import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rastrear/Pages/Agentes/AgentesView/AgentesView.dart';
import 'package:rastrear/Pages/Todos/Agente.dart';

class Agentes extends StatefulWidget {
  @override
  _AgentesState createState() => _AgentesState();
}

class _AgentesState extends State<Agentes> {
  Widget notWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 30),
        Expanded(
          flex: 0,
          child: Text(
            "Você não tem nenhum agente de saúde registrado!",
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

  Widget ListViewAgentes(List<AgentesTodos> agentes) {
    return ListView.separated(
        itemCount: agentes.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(color: Colors.grey),
        itemBuilder: (context, index) {
          return FlatButton(
            onPressed: () {
              Navigator.of(context).push(_createRoute(AgentesView(
                agentes: agentes[index],
              )));
            },
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
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
                      //Image.asset(
                      //  "assets/ic_agente.png", width: 60, height: 60),
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            agentes[index].localidade,
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AgentesTodos>>(
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
            snapshot.data
                .sort((a, b) => a.id.toString().compareTo(b.toString()));
            return ListViewAgentes(snapshot.data);
          } else {
            return notWidget();
          }
        });
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
