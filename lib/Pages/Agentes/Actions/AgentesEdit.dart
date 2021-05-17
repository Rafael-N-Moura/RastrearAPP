import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rastrear/Pages/Components/ImageSourceSheet.dart';
import 'package:rastrear/Pages/Home.dart';
import 'package:rastrear/Pages/Todos/Agente.dart';
import 'package:rastrear/Pages/Todos/Pacientes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AgentesEdit extends StatefulWidget {
  @override
  _AgentesEditState createState() => _AgentesEditState();

  AgentesTodos agentes;
  var paciente = new List<PacientesTodos>();

  final nameText = TextEditingController();
  final localidadeText = TextEditingController();

  AgentesEdit({
    @required this.agentes,
  });
}

class _AgentesEditState extends State<AgentesEdit> {
  bool empetyNome = false;
  bool empetyLocal = false;
  File profile;

  @override
  void initState() {
    super.initState();

    widget.nameText.text = widget.agentes.nome;
    widget.localidadeText.text = widget.agentes.localidade;

    _loadPaciente();
  }

  @override
  void didUpdateWidget(AgentesEdit oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadPaciente();
  }

  _loadPaciente() async {
    widget.paciente =
        await PacientesTodos.getPacientePorNome(widget.agentes.nome);
  }

  @override
  Widget build(BuildContext context) {
    void onImageSelected(File file) {
      setState(() {
        profile = file;
        widget.agentes.hasFoto = true;
        widget.agentes.foto = file.path;
        Navigator.pop(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  widget.agentes.hasFoto = false;
                  widget.agentes.foto = ' ';
                });
              })
        ],
        backgroundColor: Color(0xffB03060),
        title: Text(
          "Editar agente de saúde",
          style: TextStyle(
            fontFamily: "Minha Fonte",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (_) => ImageSourceSheet(
                                onImageSelected: onImageSelected,
                              ));
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: widget.agentes.hasFoto
                          ? CircleAvatar(
                              backgroundImage: FileImage(
                                File(widget.agentes.foto),
                              ),
                              radius: 200,
                            )
                          : SizedBox(
                              child: Image.asset("assets/ic_agente.png",
                                  height: 200, width: 200),
                            ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Theme(
                    data: ThemeData(
                      primaryColor: Colors.red,
                      primaryColorDark: Colors.red,
                    ),
                    child: TextField(
                      controller: widget.nameText,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                        hintText: "Digite seu nome completo",
                        labelText: "Nome completo",
                        errorText:
                            empetyNome ? "Não deixe o campo vazio" : null,
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: Colors.grey,
                        ),
                        prefixText: " ",
                        suffixStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  flex: 0,
                  child: Theme(
                    data: ThemeData(
                      primaryColor: Colors.red,
                      primaryColorDark: Colors.red,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: widget.localidadeText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                        hintText: "Digite sua localidade",
                        labelText: "Localidade",
                        errorText:
                            empetyLocal ? "Não deixe o campo vazio" : null,
                        prefixIcon: Icon(
                          Icons.gps_not_fixed,
                          color: Colors.grey,
                        ),
                        prefixText: " ",
                        suffixStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                    flex: 0,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.centerRight,
                              stops: [0.3, 1],
                              colors: [Color(0xffB03060), Color(0xffD02090)],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: SizedBox.expand(
                          child: FlatButton(
                            child: Text(
                              "Registrar edição",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 19),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              if (widget.nameText.text.isEmpty) {
                                setState(() {
                                  empetyNome = true;
                                  empetyLocal = false;
                                });
                                return;
                              }

                              if (widget.localidadeText.text.isEmpty) {
                                setState(() {
                                  empetyNome = false;
                                  empetyLocal = true;
                                });
                                return;
                              }

                              setState(() {
                                widget.agentes.nome = widget.nameText.text;
                                widget.agentes.localidade =
                                    widget.localidadeText.text;

                                if (widget.paciente.length != null) {
                                  if (widget.paciente.length > 0) {
                                    for (int i = 0;
                                        i < widget.paciente.length;
                                        i++) {
                                      widget.paciente[i].agente =
                                          widget.nameText.text;
                                    }
                                  }
                                }
                              });

                              AgentesTodos.save(widget.agentes);
                              if (widget.paciente.length != null &&
                                  widget.paciente.length > 0) {
                                save();
                              }

                              //Navigator.pop(context);
                              Navigator.of(context).push(_createRoute(Home()));

                              Toast.show("Editado com sucesso", context,
                                  duration: 2,
                                  gravity: Toast.BOTTOM,
                                  textColor: Colors.white,
                                  backgroundColor: Colors.grey);
                            },
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("pacientesData", jsonEncode(widget.paciente));
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
