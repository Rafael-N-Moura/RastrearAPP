import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rastrear/Pages/Paciente/PacientesView/PacientesView.dart';
import 'package:rastrear/Pages/Todos/Pacientes.dart';

class Pacientes extends StatefulWidget {
  @override
  _PacientesState createState() => _PacientesState();
}

class _PacientesState extends State<Pacientes> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PacientesTodos>>(
        future: PacientesTodos.getAllPacientes(),
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
          } else if (snapshot.data != null) {
            snapshot.data
                .sort((a, b) => a.id.toString().compareTo(b.toString()));
            return ListPacientes(snapshot.data);
          } else {
            return notWidget();
          }
        });
  }

  Widget marketPaciente(PacientesTodos pacientes) {
    if (pacientes.selectedMarker == 1) {
      return Icon(Icons.arrow_right, size: 20, color: Colors.pinkAccent);
    } else {
      return Container();
    }
  }

  Widget ListPacientes(List<PacientesTodos> pacientes) {
    return Container(
        child: ListView.separated(
            itemCount: pacientes.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              return FlatButton(
                onPressed: () {
                  Navigator.of(context).push(
                      _createRoute(PacientesView(paciente: pacientes[index])));
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          marketPaciente(pacientes[index]),
                          pacientes[index].hasFoto
                              ? CircleAvatar(
                                  backgroundImage: FileImage(
                                    File(pacientes[index].foto),
                                  ),
                                  radius: 30,
                                )
                              : Image.asset("assets/ic_woman.png",
                                  width: 60, height: 60),
                          //Image.asset("assets/ic_woman.png",
                          //  width: 60, height: 60),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                pacientes[index].nome,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: pacientes[index].posResult
                                        ? Colors.redAccent
                                        : Colors.black87),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Agente: " + pacientes[index].agente,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                getAge(
                                        pacientes[index]
                                            .dataNasc
                                            .substring(6, 10),
                                        pacientes[index]
                                            .dataNasc
                                            .substring(3, 5),
                                        pacientes[index]
                                            .dataNasc
                                            .substring(0, 2)
                                        //) + " Anos • " + pacientes[index].detalhes,
                                        ) +
                                    " Anos • ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }

  Widget notWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 30),
        Expanded(
          flex: 0,
          child: Text(
            "Você não tem nenhuma paciente registrada!",
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
              "assets/vazio.flr",
              fit: BoxFit.contain,
              alignment: Alignment.center,
              animation: "empty",
            ),
          ),
        ),
        Expanded(
            flex: 0,
            child: Container(
              padding: EdgeInsets.only(left: 15, bottom: 30),
              child: Text(
                "Clique no botão para adicionar",
                style: TextStyle(
                    fontFamily: "Minha Fonte",
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            )),
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
