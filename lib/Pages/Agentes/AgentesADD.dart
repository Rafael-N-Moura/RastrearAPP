import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rastrear/Pages/Components/ImageSourceSheet.dart';
import 'package:rastrear/Pages/Todos/Agente.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AgentesADD extends StatefulWidget {
  @override
  _AgentesADDState createState() => _AgentesADDState();

  var agentes = new List<AgentesTodos>();
  var comeco = new List<String>();

  final nameText = TextEditingController();
  final localidadeText = TextEditingController();
}

class _AgentesADDState extends State<AgentesADD> {
  bool empetyNome = false;
  bool empetyLocal = false;
  bool imagem = false;
  File profile;

  void onImageSelected(File file) {
    setState(() {
      imagem = true;
      profile = file;
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    _loadAgente();
  }

  _loadAgente() async {
    widget.agentes = await AgentesTodos.getAllAgentes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              setState(() {
                imagem = false;
              });
            },
          ),
        ],
        backgroundColor: Color(0xffB03060),
        title: Text(
          "Novo agente de saúde",
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
                  child: imagem
                      ? CircleAvatar(
                          backgroundImage: FileImage(profile),
                          radius: 200,
                        )
                      : Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Material(
                            borderRadius: BorderRadiusDirectional.circular(60),
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(Icons.add_a_photo),
                              iconSize: 70,
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (_) => ImageSourceSheet(
                                          onImageSelected: onImageSelected,
                                        ));
                              },
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                ),
                Expanded(
                  flex: 0,
                  child: TextField(
                    controller: widget.nameText,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                      hintText: "Digite seu nome completo",
                      labelText: "Nome completo",
                      errorText: empetyNome ? "Não deixe o campo vazio" : null,
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                      ),
                      prefixText: " ",
                      suffixStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  flex: 0,
                  child: TextField(
                    controller: widget.localidadeText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                      hintText: "Digite sua localidade",
                      labelText: "Localidade",
                      errorText: empetyLocal ? "Não deixe o campo vazio" : null,
                      prefixIcon: Icon(
                        Icons.gps_not_fixed,
                        color: Colors.grey,
                      ),
                      prefixText: " ",
                      suffixStyle: TextStyle(color: Colors.grey),
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
                              "Registrar agente de saúde",
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
                                widget.comeco.add("bolo");
                                if (widget.agentes == null)
                                  widget.agentes = List<AgentesTodos>();
                                widget.agentes.add(AgentesTodos(
                                  id: widget.agentes.length,
                                  nome: widget.nameText.text,
                                  localidade: widget.localidadeText.text,
                                  hasFoto: imagem ? true : false,
                                  foto: imagem ? profile.path : " ",
                                ));
                              });

                              save();

                              Navigator.pop(context);

                              Toast.show("Registrado com sucesso", context,
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
    await prefs.setString("agentesData", jsonEncode(widget.agentes));
  }
}
