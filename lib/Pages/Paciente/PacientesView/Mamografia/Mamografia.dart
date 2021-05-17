import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rastrear/Pages/Paciente/PacientesView/Mamografia/LaudoEditM.dart';
import 'package:rastrear/Pages/Todos/Mamografia.dart';
import 'package:rastrear/Pages/Todos/Pacientes.dart';

class Mamografia extends StatefulWidget
{
  int idPaciente;
  PacientesTodos paciente;

  Mamografia({@required this.idPaciente, Key key}) : super(key: key);

  @override
  _MamografiaState createState() => _MamografiaState();
}

class _MamografiaState extends State<Mamografia>
{
  @override
  void initState() {
    super.initState();
    _loadPaciente();
  }

  @override
  void didUpdateWidget(Mamografia oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadPaciente();
  }

  @override
  Widget build(BuildContext context)
  {
    return FutureBuilder<PacientesTodos>(
      future: PacientesTodos.getPacientePorId(widget.idPaciente),
      builder: (context, AsyncSnapshot<PacientesTodos> snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.data != null && snapshot.data.mamografia != null){
          return listarMamografias(snapshot.data.mamografia);
        } else {
          return notWidget();
        }
      }
    );
  }

  Widget notWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 30),
        Expanded(
          flex: 0,
          child: Text(
            "Nenhum laudo foi cadastrado nesta paciente!",
            style: TextStyle(
                fontFamily: "Minha Fonte",
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 500,
            width: 500,
            child: FlareActor(
              "assets/vazio.flr",
              fit: BoxFit.contain,
              alignment: Alignment.center,
              animation: "empty",
            ),
          ),
        ),
      ],
    );
  }

  Widget listarMamografias(List<MamografiaTodos> mamografias)
  {
    return ListView.separated(
        itemCount: mamografias.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.grey),
        itemBuilder: (context, index) {
          return FlatButton(
            onPressed: () {
              Navigator.of(context).push(_createRoute(LaudoEditM(
                paciente: widget.paciente,
                id: index,
              )));
            },
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.folder, size: 56, color: Colors.black38),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            mamografias[index].detalhesRegistro,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.black87
                            ),
                          ),
                          ResultadoRegistro(mamografias, index),
                          Text(
                            mamografias[index].dataLaudo,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  Widget ResultadoRegistro(mamografia, index)
  {
    if(mamografia[index].resultadoRegistro == "Negativo") {
      return Text(
        mamografia[index].resultadoRegistro,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.green
        ),
      );
    } else {
      return Text(
        mamografia[index].resultadoRegistro,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.red
        ),
      );
    }
  }

  _loadPaciente() async {
    widget.paciente = await PacientesTodos.getPacientePorId(widget.idPaciente);
  }

  Route _createRoute(Page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
