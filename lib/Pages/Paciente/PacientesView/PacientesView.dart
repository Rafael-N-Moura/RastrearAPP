import 'package:flutter/material.dart';
import 'package:rastrear/Pages/Home.dart';
import 'package:rastrear/Pages/Paciente/PacientesView/Actions/PacientesEdit.dart';
import 'package:rastrear/Pages/Paciente/PacientesView/Citologia/Laudo.dart';
import 'package:rastrear/Pages/Paciente/PacientesView/Mamografia/LaudoM.dart';
import 'package:rastrear/Pages/Paciente/PacientesView/Mamografia/Mamografia.dart';
import 'package:rastrear/Pages/Pesquisar/Pesquisar.dart';
import 'package:rastrear/Pages/Todos/Agente.dart';
import 'package:rastrear/Pages/Todos/Pacientes.dart';
import 'package:toast/toast.dart';

import 'Citologia/Citologia.dart';
import 'Dados/Dados.dart';

class PacientesView extends StatefulWidget {
  @override
  _PacientesViewState createState() => _PacientesViewState();

  PacientesTodos paciente;
  var agentes = new List<AgentesTodos>();

  PacientesView({@required this.paciente});
}

class _PacientesViewState extends State<PacientesView> {
  @override
  void initState() {
    super.initState();
    _loadAgente();
  }

  @override
  void didUpdateWidget(PacientesView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadAgente();
  }

  _loadAgente() async {
    widget.agentes = await AgentesTodos.getAllAgentes();
  }

  int _selectedIndex = 0;
  bool activeFlat = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 0) {
        activeFlat = true;
      } else if (_selectedIndex == 1) {
        activeFlat = true;
      } else if (_selectedIndex == 2) {
        activeFlat = false;
      }
    });
  }

  List<String> choices = <String>[
    "Remover pacientes",
  ];

  @override
  Widget build(BuildContext context) {
    Widget selectMarker() {
      if (widget.paciente.selectedMarker == 1) {
        return Icon(Icons.bookmark, color: Colors.white);
      } else {
        return Icon(Icons.bookmark_border, color: Colors.white);
      }
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xffB03060),
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      _createRoute(Home()), (route) => false),
                  //Navigator.of(context).pop(), //Navigator.of(context).push(
                  //_createRoute(Pesquisar())),
                ),
                bottom: TabBar(
                  onTap: (value) {
                    _onItemTapped(value);
                  },
                  indicatorColor: Colors.pink,
                  tabs: <Widget>[
                    Tab(icon: Container(), text: "Citologia"),
                    Tab(icon: Container(), text: "Mamografia"),
                    Tab(icon: Container(), text: "Dados")
                  ],
                ),
                title: Text(
                  widget.paciente.nome,
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
                      Navigator.of(context).push(_createRoute(
                          PacientesEdit(pacientes: widget.paciente)));
                    },
                    icon: Icon(Icons.edit, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (widget.paciente.selectedMarker == 1) {
                          widget.paciente.selectedMarker = 0;

                          Toast.show("Paciente desmarcado", context,
                              duration: 2,
                              gravity: Toast.BOTTOM,
                              textColor: Colors.white,
                              backgroundColor: Colors.grey);

                          PacientesTodos.save(widget.paciente);
                        } else {
                          widget.paciente.selectedMarker = 1;

                          Toast.show("Paciente marcado", context,
                              duration: 2,
                              gravity: Toast.BOTTOM,
                              textColor: Colors.white,
                              backgroundColor: Colors.grey);

                          PacientesTodos.save(widget.paciente);
                        }
                      });
                    },
                    icon: selectMarker(),
                  ),
                  PopupMenuButton<String>(
                    elevation: 4,
                    onSelected: (value) {
                      setState(() {
                        PacientesTodos.removerPacientes(widget.paciente.id);
                        //Navigator.pop(context);
                        Navigator.of(context).push(_createRoute(Home()));
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return choices.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text("Remover paciente"),
                        );
                      }).toList();
                    },
                  )
                ],
              ),
              floatingActionButton: activeFlat
                  ? FloatingActionButton(
                      onPressed: () async {
                        if (_selectedIndex == 0) {
                          await Navigator.of(context)
                              .push(_createRoute(Laudo(
                            paciente: widget.paciente,
                          )))
                              .then((retorno) {
                            if (retorno != null) {
                              if (retorno) {
                                setState(() {
                                  _reloadPaciente();
                                });
                              }
                            }
                          });
                        } else if (_selectedIndex == 1) {
                          await Navigator.of(context)
                              .push(_createRoute(LaudoM(
                            paciente: widget.paciente,
                          )))
                              .then((retorno) {
                            if (retorno != null) {
                              if (retorno) {
                                setState(() {
                                  _reloadPaciente();
                                });
                              }
                            }
                          });
                        }
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Colors.pinkAccent,
                    )
                  : Container(),
              body: TabBarView(
                children: <Widget>[
                  Citologia(
                    idPaciente: widget.paciente.id,
                  ),
                  Mamografia(
                    idPaciente: widget.paciente.id,
                  ),
                  Dados(
                    paciente: widget.paciente,
                  ),
                ],
              )),
        ));
  }

  void _reloadPaciente() async {
    widget.paciente = await PacientesTodos.getPacientePorId(widget.paciente.id);
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
