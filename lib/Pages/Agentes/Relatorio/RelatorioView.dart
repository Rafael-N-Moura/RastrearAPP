import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:rastrear/Pages/Agentes/Relatorio/RelatorioHome.dart';
import 'package:rastrear/Pages/Todos/Agente.dart';
import 'package:rastrear/Pages/Todos/Pacientes.dart';
import 'package:rastrear/Pages/Todos/Relatorio.dart';
import 'package:toast/toast.dart';

import 'CreateExcel.dart';
import 'CreatePDF.dart';

//Relatorio tempRelatorio;

class RelatorioView extends StatefulWidget {
  AgentesTodos agente;

  RelatorioView({@required this.agente, Key key}) : super(key: key);

  @override
  _RelatorioViewState createState() => _RelatorioViewState();
}

class _RelatorioViewState extends State<RelatorioView> {
  void retornarCaminho(Relatorio tempRelatorio) {
    setState(() {
      //widget.agente.relatorios.add(caminho);
      if (widget.agente.relatorios == null) {
        widget.agente.relatorios = List<Relatorio>();
      }

      widget.agente.relatorios.add(Relatorio(
        nomeAgente: tempRelatorio.nomeAgente,
        caminho: tempRelatorio.caminho,
        dataRegistro: tempRelatorio.dataRegistro,
      ));

      AgentesTodos.save(widget.agente);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PacientesTodos>>(
        future: PacientesTodos.getPacientePorNome(widget.agente.nome),
        builder: (context, AsyncSnapshot<List<PacientesTodos>> snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.data != null &&
              snapshot.data.length > 0 &&
              widget.agente.relatorios != null &&
              widget.agente.relatorios.length > 0) {
            return ListPacientesWPacientesWRelatorios(
                snapshot.data, widget.agente.relatorios);
            //return Container(
            //child: Text("Cara, eu tenho pacientes e relatorios"),
            // );
          } else if (widget.agente.relatorios != null &&
              widget.agente.relatorios.length > 0) {
            return ListRelatorioWOPacientes(widget.agente.relatorios);
            //return Container(
            //child: Text("Cara, eu só tenho relatorios"),
            //);
          } else if (snapshot.data != null && snapshot.data.length > 0) {
            return ListRelatorioWORelatorios(snapshot.data);
            //return Container(
            //child: Text("Cara, eu só tenho pacientes"),
            //);
          } else {
            return notWidget();
          }
        });
  }

  //Se não tem paciente nem relatorio retorna notWidget --
  //Se n tem paciente mas tem relatorio, retorna só a lista de relatorios sem a possibilidade de criar um novo --
  //Se não tem relatório mas tem paciente, retornar a possibildade de criar um relatorio e uma mensagem que n tem relatorio
  //Se tem paciente e tem relatorio retorna a lista de relatorios com a possibilidade de criar um novo

  Widget marketPaciente(PacientesTodos pacientes) {
    if (pacientes.selectedMarker == 1) {
      return Icon(Icons.arrow_right, size: 20, color: Colors.pinkAccent);
    } else {
      return Container();
    }
  }

  Widget ListPacientesWPacientesWRelatorios(
      List<PacientesTodos> pacientes, List<Relatorio> relatorios) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _settingModalCreateFile(context, pacientes);
        },
        child: Icon(Icons.folder_shared),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
          child: ListView.separated(
              itemCount: relatorios.length ?? 0,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(color: Colors.grey),
              itemBuilder: (context, index) {
                return FlatButton(
                  onPressed: () async {
                    //final _result = await OpenFile.open(
                    // widget.agente.relatorios.first.caminho);
                    final _result = await OpenFile.open(
                        widget.agente.relatorios[index].caminho);
                    print(_result.message);
                    // Navigator.of(context).push(_createRoute(RelatorioHome(
                    //  agente: widget.agente,
                    //  idPaciente: index,
                    // )));
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: <Widget>[
                            //marketPaciente(pacientes[index]),
                            //Image.asset("assets/ic_woman.png",
                            //  width: 60, height: 60),
                            //Image.asset("assets/ic_relatorio.png",
                            //  width: 60, height: 60),
                            Icon(
                              Icons.file_copy_rounded,
                              size: 60,
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  relatorios[index].nomeAgente,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.black87),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  relatorios[index].dataRegistro,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // Text(
                                //   getAge(
                                //           pacientes[index]
                                //               .dataNasc
                                //               .substring(6, 10),
                                //           pacientes[index]
                                //               .dataNasc
                                //               .substring(3, 5),
                                //           pacientes[index]
                                //               .dataNasc
                                //               .substring(0, 2)
                                //           //) + " Anos • " + pacientes[index].detalhes,
                                //           ) +
                                //       " Anos • ",
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.w700,
                                //       fontSize: 15,
                                //       color: Colors.grey),
                                //   maxLines: 1,
                                //   overflow: TextOverflow.ellipsis,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }

  Widget ListRelatorioWOPacientes(List<Relatorio> relatorios) {
    return Scaffold(
      //floatingActionButton: FloatingActionButton(
      //onPressed: () {
      //_settingModalCreateFile(context, pacientes);
      //},
      //child: Icon(Icons.folder_shared),
      //backgroundColor: Colors.blueAccent,
      //),
      body: Container(
          child: ListView.separated(
              itemCount: relatorios.length ?? 0,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(color: Colors.grey),
              itemBuilder: (context, index) {
                return FlatButton(
                  onPressed: () async {
                    //final _result = await OpenFile.open(
                    // widget.agente.relatorios.first.caminho);
                    final _result = await OpenFile.open(
                        widget.agente.relatorios[index].caminho);
                    print(_result.message);
                    // Navigator.of(context).push(_createRoute(RelatorioHome(
                    //  agente: widget.agente,
                    //  idPaciente: index,
                    // )));
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: <Widget>[
                            //marketPaciente(pacientes[index]),
                            //Image.asset("assets/ic_woman.png",
                            //  width: 60, height: 60),
                            //Image.asset("assets/ic_relatorio.png",
                            //  width: 60, height: 60),
                            Icon(
                              Icons.file_copy_rounded,
                              size: 60,
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  relatorios[index].nomeAgente,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.black87),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  relatorios[index].dataRegistro,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                //Text(
                                // getAge(
                                //        pacientes[index]
                                //          .dataNasc
                                //        .substring(6, 10),
                                //    pacientes[index]
                                //          .dataNasc
                                //        .substring(3, 5),
                                //    pacientes[index]
                                //        .dataNasc
                                //       .substring(0, 2)
                                //) + " Anos • " + pacientes[index].detalhes,
                                //   ) +
                                // " Anos • ",
                                // style: TextStyle(
                                //     fontWeight: FontWeight.w700,
                                //     fontSize: 15,
                                //     color: Colors.grey),
                                // maxLines: 1,
                                // overflow: TextOverflow.ellipsis,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }

  Widget ListRelatorioWORelatorios(List<PacientesTodos> pacientes) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _settingModalCreateFile(context, pacientes);
        },
        child: Icon(Icons.folder_shared),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 30),
            Expanded(
              flex: 0,
              child: Text(
                "Você não tem relatorios registrados neste agente de saúde!",
                style: TextStyle(
                    fontFamily: "Minha Fonte",
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 500,
                width: 500,
                child: FlareActor(
                  "assets/vazioblue.flr",
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  animation: "empty",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String nome) async {
    AlertDialog alert = AlertDialog(
        title: Text("Gerando $nome"),
        content: Container(
          height: 40,
          child: Center(
            child: Column(
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          ),
        ));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );

    Navigator.pop(context);

    await new Future.delayed(const Duration(seconds: 4));

    Navigator.of(context, rootNavigator: true).pop('dialog');

    Toast.show("${nome} gerado com sucesso", context,
        duration: 2,
        gravity: Toast.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Colors.grey);
  }

  void _settingModalCreateFile(context, citologias) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 150,
            color: Color(0xff737373),
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, top: 20, right: 20, bottom: 20),
                      child: Text(
                        "Gerar relatório",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "Minha Fonte",
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showAlertDialog(context, "PDF");
                              CreatePDF.GeneratePDF(
                                  widget.agente, retornarCaminho);
                            },
                            child: Row(
                              children: <Widget>[
                                Image.asset("assets/ic_pdf.png",
                                    width: 56, height: 56),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey),
                          FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showAlertDialog(context, "Excel");
                              CreateExcel.GenerateExcel(
                                  widget.agente, retornarCaminho);
                            },
                            child: Row(
                              children: <Widget>[
                                Image.asset("assets/ic_excel.png",
                                    width: 56, height: 56),
                                SizedBox(width: 10),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          );
        });
  }

  Widget notWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 30),
        Expanded(
          flex: 0,
          child: Text(
            "Você não tem nenhuma paciente e nem relatorios registrados neste agente de saúde!",
            style: TextStyle(
                fontFamily: "Minha Fonte",
                fontSize: 16,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 500,
            width: 500,
            child: FlareActor(
              "assets/vazioblue.flr",
              fit: BoxFit.contain,
              alignment: Alignment.center,
              animation: "empty",
            ),
          ),
        ),
      ],
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

  getAge(String year, String month, String day) {
    final birthday =
        DateTime(int.parse(year), int.parse(month), int.parse(day));

    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthday.year;
    int month1 = currentDate.month;
    int month2 = birthday.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthday.day;
      if (day2 > day1) {
        age--;
      }
    }

    return age.toString();
  }
}
