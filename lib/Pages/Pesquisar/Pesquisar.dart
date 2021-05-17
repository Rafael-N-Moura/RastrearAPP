import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rastrear/Pages/Agentes/AgentesView/AgentesView.dart';
import 'package:rastrear/Pages/Paciente/PacientesView/PacientesView.dart';
import 'package:rastrear/Pages/Todos/Agente.dart';
import 'package:rastrear/Pages/Todos/Pacientes.dart';

class Pesquisar extends StatefulWidget {
  @override
  _PesquisarState createState() => _PesquisarState();
}

class _PesquisarState extends State<Pesquisar> {
  var searchText = new TextEditingController();
  String filter;

  @override
  void initState() {
    super.initState();

    searchText.addListener(() {
      setState(() {
        filter = searchText.text;
      });
    });
  }

  Widget notWidget() {
    return Column(
      children: <Widget>[
        SizedBox(height: 200),
        Text(
          "Pesquisa por pacientes e relatórios. Fique sempre informado de forma rápida sobre seus pacientes.",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: "Minha Fonte",
              color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget notFound() {
      return Container(
        padding: EdgeInsets.only(left: 15),
        child: Text(
          "Nenhum resultado encontrado para sua busca aqui.",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      );
    }

    Widget ListViewPaciente(List<PacientesTodos> pacientes) {
      return Flexible(
        child: ListView.builder(
          itemCount: pacientes.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return filter == null || filter == ""
                ? FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(_createRoute(
                          PacientesView(paciente: pacientes[index])));
                    },
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            pacientes[index].hasFoto
                                ? CircleAvatar(
                                    backgroundImage: FileImage(
                                      File(pacientes[index].foto),
                                    ),
                                    radius: 30,
                                  )
                                : Image.asset("assets/ic_woman.png",
                                    width: 60, height: 60),
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
                                ),
                                Text(
                                  pacientes[index].agente,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(color: Colors.grey),
                      ],
                    ))
                : pacientes[index]
                        .nome
                        .toLowerCase()
                        .contains(filter.toLowerCase())
                    ? FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(_createRoute(
                              PacientesView(paciente: pacientes[index])));
                        },
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
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
                                //width: 60, height: 60),
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
                                              : Colors.black),
                                    ),
                                    //Text(
                                    //pacientes[index].detalhes,
                                    //style: TextStyle(
                                    //fontWeight: FontWeight.w700,
                                    //fontSize: 15,
                                    //  color: Colors.grey
                                    //),
                                    //),
                                  ],
                                )
                              ],
                            ),
                            Divider(color: Colors.grey)
                          ],
                        ),
                      )
                    : new SizedBox();
          },
        ),
      );
    }

    Widget ListViewAgentes(List<AgentesTodos> agentes) {
      return Flexible(
        child: ListView.builder(
          itemCount: agentes.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return filter == null || filter == ""
                ? FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(_createRoute(AgentesView(
                        agentes: agentes[index],
                      )));
                    },
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            agentes[index].hasFoto
                                ? CircleAvatar(
                                    backgroundImage: FileImage(
                                      File(agentes[index].foto),
                                    ),
                                    radius: 30,
                                  )
                                : Image.asset("assets/ic_agente.png",
                                    width: 60, height: 60),
                            //Image.asset("assets/ic_agente.png",
                            //  width: 60, height: 60),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  agentes[index].nome,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.black87),
                                ),
                                Text(
                                  agentes[index].localidade,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(color: Colors.grey),
                      ],
                    ))
                : agentes[index]
                        .nome
                        .toLowerCase()
                        .contains(filter.toLowerCase())
                    ? FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(_createRoute(AgentesView(
                            agentes: agentes[index],
                          )));
                        },
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                agentes[index].hasFoto
                                    ? CircleAvatar(
                                        backgroundImage: FileImage(
                                          File(agentes[index].foto),
                                        ),
                                        radius: 30,
                                      )
                                    : Image.asset("assets/ic_agente.png",
                                        width: 60, height: 60),
                                //Image.asset("assets/ic_agente.png",
                                //  width: 60, height: 60),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      agentes[index].nome,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: Colors.black87),
                                    ),
                                    Text(
                                      agentes[index].localidade,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: Colors.grey),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(color: Colors.grey)
                          ],
                        ),
                      )
                    : new SizedBox();
          },
        ),
      );
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Theme(
              data: ThemeData(
                primaryColor: Colors.red,
                primaryColorDark: Colors.red,
              ),
              child: TextField(
                controller: searchText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)),
                  hintText: "Busque por pacientes e agentes de saúde",
                  labelText: "Pesquisar",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  prefixText: " ",
                  suffixStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          Divider(color: Colors.grey),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              "Pacientes",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          FutureBuilder<List<PacientesTodos>>(
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
                  return ListViewPaciente(snapshot.data);
                } else {
                  return notFound();
                }
              }),
          Divider(color: Colors.grey),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              "Agentes de saúde",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          FutureBuilder<List<AgentesTodos>>(
              future: AgentesTodos.getAllAgentes(),
              builder: (context, AsyncSnapshot<List<AgentesTodos>> snapshot) {
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
                  return ListViewAgentes(snapshot.data);
                } else {
                  return notFound();
                }
              })
        ],
      ),
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
