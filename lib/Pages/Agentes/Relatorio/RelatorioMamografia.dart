import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rastrear/Pages/Todos/Agente.dart';
import 'package:rastrear/Pages/Todos/Mamografia.dart';
import 'package:rastrear/Pages/Todos/Pacientes.dart';

class RelatorioMamografia extends StatefulWidget
{
  @override
  _RelatorioMamografiaState createState() => _RelatorioMamografiaState();

  AgentesTodos agente;
  int idPaciente;

  RelatorioMamografia({
    this.agente,
    this.idPaciente,
  });
}

class _RelatorioMamografiaState extends State<RelatorioMamografia>
{
  String result = "ordem";
  bool btnResultOrdem = true;
  bool btnResultNeg = false;
  bool btnResultPos = false;
  bool btnDate = false;

  @override
  Widget build(BuildContext context)
  {
    return FutureBuilder<List<PacientesTodos>>(
        future: PacientesTodos.getCitologiaPorNome(widget.agente.nome),
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
          }
          else if(snapshot.data != null) {
            if(snapshot.data[widget.idPaciente].mamografia != null) {

              if(btnDate == true) {
                snapshot.data[widget.idPaciente].mamografia.sort((a,b) => a.dataLaudo.substring(6, 10).compareTo(b.dataLaudo.substring(6, 10)));
              }

              return listarMamografias(snapshot.data[widget.idPaciente].mamografia);
            } else {
              return notWidgetMaterial();
            }
          }
          else {return notWidgetMaterial();}
        }
    );
  }

  Widget listarMamografias(List<MamografiaTodos> mamografias) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Relatório",
          style: TextStyle(
            fontFamily: "Minha Fonte",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FlatButton(
              onPressed: () {
                _settingModalBottomSheet(context);
              },
              child: Row(
                children: <Widget>[
                  Text(
                    "Classificar por: $result",
                  ),
                  Icon(Icons.arrow_upward, color: Colors.grey, size: 20),
                ],
              )
          ),
          Flexible(
            child: ListView.builder(
                itemCount: mamografias.length,
                itemBuilder: (context, index) {
                  if(result == "negativos") {
                    if (mamografias[index].resultadoRegistro == "Negativo") {
                      return FlatButton(
                        onPressed: () {},
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.library_books, size: 56,
                                      color: Colors.black38),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        mamografias[index].nome,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Colors.black87
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        mamografias[index].detalhesRegistro,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Colors.black87
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                            Divider(color: Colors.grey),
                          ],
                        ),
                      );
                    } else {return Container();}
                  } else if(result == "positivos") {
                    if (mamografias[index].resultadoRegistro == "Positivo") {
                      return FlatButton(
                        onPressed: () {},
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.library_books, size: 56,
                                      color: Colors.black38),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        mamografias[index].nome,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Colors.black87
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        mamografias[index].detalhesRegistro,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Colors.black87
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                            Divider(color: Colors.grey),
                          ],
                        ),
                      );
                    } else {return Container();}
                  } else if(result == "ordem") {
                    return FlatButton(
                      onPressed: () {},
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.library_books, size: 56,
                                    color: Colors.black38),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      mamografias[index].nome,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: Colors.black87
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      mamografias[index].detalhesRegistro,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: Colors.black87
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                          Divider(color: Colors.grey),
                        ],
                      ),
                    );
                  } else {
                    return FlatButton(
                      onPressed: () {},
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.library_books, size: 56,
                                    color: Colors.black38),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      mamografias[index].nome,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: Colors.black87
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      mamografias[index].detalhesRegistro,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: Colors.black87
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                          Divider(color: Colors.grey),
                        ],
                      ),
                    );
                  }
                }
            ),
          )
        ],
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Color(0xff737373),
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)
                    )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 70, top: 20, right: 70, bottom: 20),
                      child: Text(
                        "Classificar por",
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "Minha Fonte",
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    ButtonOrdem(btnResultOrdem),
                    ButtonNegative(btnResultNeg),
                    ButtonPositive(btnResultPos),
                    ButtonDate(btnDate),
                  ],
                )
            ),
          );
        }
    );
  }

  Widget ButtonOrdem(active) {
    return FlatButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            btnResultOrdem = true;
            btnResultPos = false;
            btnResultNeg = false;
            btnDate = false;
            result = "ordem";

            Navigator.pop(context);
          });
        },
        child: Container(
          padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
          width: MediaQuery.of(context).size.width,
          decoration: active ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                stops: [0.3, 1],
                colors: [Colors.pink.withOpacity(0.1), Colors.pink.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.only(topRight: Radius.circular(40), bottomRight: Radius.circular(40))
          ) : BoxDecoration(),
          child: Row(
            children: <Widget>[
              active ? Icon(Icons.arrow_upward, color: Colors.pink.withOpacity(0.5)) : Icon(null),
              SizedBox(width: 20),
              Text(
                "Ordem",
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "Minha Fonte",
                    fontWeight: FontWeight.w700
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget ButtonNegative(active) {
    return FlatButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            btnResultOrdem = false;
            btnResultPos = false;
            btnResultNeg = true;
            btnDate = false;
            result = "negativos";

            Navigator.pop(context);
          });
        },
        child: Container(
          padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
          width: MediaQuery.of(context).size.width,
          decoration: active ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                stops: [0.3, 1],
                colors: [Colors.pink.withOpacity(0.1), Colors.pink.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.only(topRight: Radius.circular(40), bottomRight: Radius.circular(40))
          ) : BoxDecoration(),
          child: Row(
            children: <Widget>[
              active ? Icon(Icons.arrow_upward, color: Colors.pink.withOpacity(0.5)) : Icon(null),
              SizedBox(width: 20),
              Text(
                "Negativos",
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "Minha Fonte",
                    fontWeight: FontWeight.w700
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget ButtonPositive(active) {
    return FlatButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            btnResultOrdem = false;
            btnResultPos = true;
            btnResultNeg = false;
            btnDate = false;
            result = "positivos";

            Navigator.pop(context);
          });
        },
        child: Container(
          padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
          width: MediaQuery.of(context).size.width,
          decoration: active ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                stops: [0.3, 1],
                colors: [Colors.pink.withOpacity(0.1), Colors.pink.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.only(topRight: Radius.circular(40), bottomRight: Radius.circular(40))
          ) : BoxDecoration(),
          child: Row(
            children: <Widget>[
              active ? Icon(Icons.arrow_upward, color: Colors.pink.withOpacity(0.5)) : Icon(null),
              SizedBox(width: 20),
              Text(
                "Positivos",
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "Minha Fonte",
                    fontWeight: FontWeight.w700
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget ButtonDate(active) {
    return FlatButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            btnResultOrdem = false;
            btnResultPos = false;
            btnResultNeg = false;
            btnDate = true;
            result = "data";

            Navigator.pop(context);
          });
        },
        child: Container(
          padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
          width: MediaQuery.of(context).size.width,
          decoration: active ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                stops: [0.3, 1],
                colors: [Colors.pink.withOpacity(0.1), Colors.pink.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.only(topRight: Radius.circular(40), bottomRight: Radius.circular(40))
          ) : BoxDecoration(),
          child: Row(
            children: <Widget>[
              active ? Icon(Icons.arrow_upward, color: Colors.pink.withOpacity(0.5)) : Icon(null),
              SizedBox(width: 20),
              Text(
                "Data",
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "Minha Fonte",
                    fontWeight: FontWeight.w700
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget ResultadoRegistro(mamografias, index) {
    if(mamografias[index].resultadoRegistro == "Negativo") {
      return Text(
        mamografias[index].resultadoRegistro,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.green
        ),
      );
    } else {
      return Text(
        mamografias[index].resultadoRegistro,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.red
        ),
      );
    }
  }

  Widget notWidgetMaterial() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 50),
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
}