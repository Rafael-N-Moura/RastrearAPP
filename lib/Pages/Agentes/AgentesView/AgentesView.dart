import 'package:flutter/material.dart';
import 'package:rastrear/Pages/Agentes/Actions/AgentesEdit.dart';
import 'package:rastrear/Pages/Agentes/Dados/DadosAgentes.dart';
import 'package:rastrear/Pages/Agentes/Pacientes/PacientesAgentes.dart';
import 'package:rastrear/Pages/Agentes/Relatorio/RelatorioView.dart';
import 'package:rastrear/Pages/Home.dart';
import 'package:rastrear/Pages/Todos/Agente.dart';
import 'package:rastrear/Pages/Todos/Pacientes.dart';

class AgentesView extends StatefulWidget {
  @override
  _AgentesViewState createState() => _AgentesViewState();

  AgentesTodos agentes;

  AgentesView({@required this.agentes});
}

class _AgentesViewState extends State<AgentesView> {
  List<String> choices = <String>[
    "Remover agente",
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueAccent,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      _createRoute(Home()),
                      (route) => false), //Navigator.of(context).pop(),
                ),
                bottom: TabBar(
                  indicatorColor: Colors.blueGrey,
                  tabs: <Widget>[
                    Tab(icon: Container(), text: "Pacientes"),
                    Tab(icon: Container(), text: "Relatório"),
                    Tab(icon: Container(), text: "Dados"),
                  ],
                ),
                title: Text(
                  widget.agentes.nome,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Minha Fonte",
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          _createRoute(AgentesEdit(agentes: widget.agentes)));
                    },
                    icon: Icon(Icons.edit, color: Colors.white),
                  ),
                  PopupMenuButton<String>(
                    elevation: 4,
                    onSelected: (value) {
                      setState(() {
                        showAlertDialog(context);
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return choices.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text("Remover agente"),
                        );
                      }).toList();
                    },
                  )
                ],
              ),
              body: TabBarView(
                children: <Widget>[
                  PacientesAgentes(
                    agente: widget.agentes,
                  ),
                  RelatorioView(
                    agente: widget.agentes,
                  ),
                  DadosAgentes(
                    agente: widget.agentes,
                  ),
                ],
              )),
        ));
  }

  showAlertDialog(BuildContext context) {
    Widget cancelaButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget continuaButton = FlatButton(
      child: Text("Continuar"),
      onPressed: () {
        AgentesTodos.removerAgentes(widget.agentes.id);
        PacientesTodos.removerPacientesPorNome(widget.agentes.nome);

        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).push(_createRoute(Home()));
        //Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Remover Agente de Saúde"),
      content: Text(
          "Se remover, todos os pacientes relacionados ao agente, será removido também!"),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Route _createRoute(Page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
