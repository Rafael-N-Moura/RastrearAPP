import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rastrear/Libs/pattern_formatter.dart';
import 'package:rastrear/Pages/Components/ImageSourceSheet.dart';
import 'package:rastrear/Pages/Home.dart';
import 'package:rastrear/Pages/Paciente/PacientesView/PacientesView.dart';
import 'package:rastrear/Pages/Todos/Agente.dart';
import 'package:rastrear/Pages/Todos/Pacientes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class PacientesEdit extends StatefulWidget {
  @override
  _PacientesEditState createState() => _PacientesEditState();

  int _selectedAgente = 0;

  PacientesTodos pacientes;
  var agentes = new List<AgentesTodos>();

  final nameText = TextEditingController();
  final dataNascText = TextEditingController();
  //final carteiraSUS = TextEditingController();
  //final detalhesText = TextEditingController();
  final cpf = TextEditingController();
  final nomeMae = TextEditingController();

  PacientesEdit({
    @required this.pacientes,
  });
}

class _PacientesEditState extends State<PacientesEdit> {
  //Não foi eu que escrevi "empety" lol
  bool empetyNome = false;
  bool empetyData = false;
  //bool empetySUS = false;
  //bool empetyDetais = false;
  bool emptyCpf = false;
  bool emptyNomeMae = false;
  File profile;

  @override
  void initState() {
    super.initState();

    widget.nameText.text = widget.pacientes.nome;
    widget.dataNascText.text = widget.pacientes.dataNasc;
    //widget.carteiraSUS.text = widget.pacientes.cartaoSUS;
    //widget.detalhesText.text = widget.pacientes.detalhes;
    widget.cpf.text = widget.pacientes.cpf;
    widget.nomeMae.text = widget.pacientes.nomeMae;
    widget._selectedAgente = widget.pacientes.selectedIndexAgente;

    _load();
  }

  _load() async {
    widget.agentes = await AgentesTodos.getAllAgentes();
  }

  @override
  Widget build(BuildContext context) {
    void onImageSelected(File file) {
      setState(() {
        profile = file;
        widget.pacientes.hasFoto = true;
        widget.pacientes.foto = file.path;
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
                  widget.pacientes.hasFoto = false;
                  widget.pacientes.foto = ' ';
                });
              })
        ],
        backgroundColor: Color(0xffB03060),
        title: Text(
          "Editar paciente",
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
                      child: widget.pacientes.hasFoto
                          ? CircleAvatar(
                              backgroundImage: FileImage(
                                File(widget.pacientes.foto),
                              ),
                              radius: 70,
                            )
                          : SizedBox(
                              child: Image.asset("assets/ic_woman.png",
                                  height: 200, width: 200),
                            ), //SizedBox(
                      //child: Image.asset("assets/ic_woman.png",
                      //    height: 200, width: 200),
                      //),
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
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        DateInputFormatter(),
                      ],
                      controller: widget.dataNascText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                        hintText: "Ex.: 31/03/1964",
                        labelText: "Data de nascimento",
                        errorText:
                            empetyData ? "Não deixe o campo vazio" : null,
                        prefixIcon: Icon(
                          Icons.calendar_today,
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
                      //controller: widget.carteiraSUS,
                      controller: widget.cpf,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                        //hintText: "Digite o cartão SUS da paciente",
                        //labelText: "Cartão SUS",
                        hintText: "Digite o CPF da paciente",
                        labelText: "CPF",
                        //errorText: empetySUS ? "Não deixe o campo vazio" : null,
                        errorText: emptyCpf ? "Não deixe o campo vazio" : null,
                        prefixIcon: Icon(
                          Icons.info,
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
                      //controller: widget.detalhesText,
                      controller: widget.nomeMae,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                        hintText: "Digite o nome da mãe da paciente",
                        labelText: "Nome da Mãe",
                        errorText:
                            emptyNomeMae ? "Não deixe o campo vazio" : null,
                        prefixIcon: Icon(
                          Icons.textsms,
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: Colors.grey)),
                        padding: EdgeInsets.all(5),
                        child: FlatButton(
                          onPressed: () {
                            _settingModalBottomSheet(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Agente de Saúde Responsável",
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 10),
                              FutureBuilder<List<AgentesTodos>>(
                                  future: AgentesTodos.getAllAgentes(),
                                  builder: (context,
                                      AsyncSnapshot<List<AgentesTodos>>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.none ||
                                        snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                      return Center(
                                        child: SizedBox(
                                          width: 64,
                                          height: 64,
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else if (snapshot.data != null) {
                                      return Row(
                                        children: <Widget>[
                                          //Expanded(
                                          //flex: 0,
                                          //child: Image.asset(
                                          //  "assets/ic_agente.png",
                                          // width: 56,
                                          // height: 56),
                                          //),
                                          snapshot.data[widget._selectedAgente]
                                                  .hasFoto
                                              ? CircleAvatar(
                                                  backgroundImage: FileImage(
                                                    File(snapshot
                                                        .data[widget
                                                            ._selectedAgente]
                                                        .foto),
                                                  ),
                                                  radius: 30,
                                                )
                                              : Image.asset(
                                                  "assets/ic_agente.png",
                                                  height: 56,
                                                  width: 56),
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  snapshot
                                                      .data[widget
                                                          ._selectedAgente]
                                                      .nome,
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Text(
                                                  snapshot
                                                      .data[widget
                                                          ._selectedAgente]
                                                      .localidade,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                            ],
                          ),
                        ))),
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
                                  empetyData = false;
                                  //empetySUS = false;
                                  //empetyDetais = false;
                                  emptyCpf = false;
                                  emptyNomeMae = false;
                                });
                                return;
                              }

                              if (!RegExp(r'[!@#<>?":_`~;|=+)(*&^%0-9]')
                                  .hasMatch(widget.dataNascText.text)) {
                                setState(() {
                                  empetyNome = false;
                                  empetyData = true;
                                  //empetySUS = false;
                                  //empetyDetais = false;
                                  emptyCpf = false;
                                  emptyNomeMae = false;
                                });
                                return;
                              }

                              if (widget.cpf.text.isEmpty) {
                                setState(() {
                                  empetyNome = false;
                                  empetyData = false;
                                  //empetySUS = true;
                                  //empetyDetais = false;
                                  emptyCpf = true;
                                  emptyNomeMae = false;
                                });
                                return;
                              }

                              if (widget.nomeMae.text.isEmpty) {
                                setState(() {
                                  empetyNome = false;
                                  empetyData = false;
                                  //empetySUS = false;
                                  //empetyDetais = true;
                                  emptyCpf = false;
                                  emptyNomeMae = true;
                                });
                                return;
                              }

                              setState(() {
                                widget.pacientes.nome = widget.nameText.text;
                                //widget.pacientes.foto = widget.pacientes.hasFoto
                                //  ? profile.path
                                // : " ";
                                widget.pacientes.dataNasc =
                                    widget.dataNascText.text;
                                //widget.pacientes.cartaoSUS = widget.carteiraSUS.text;
                                //widget.pacientes.detalhes = widget.detalhesText.text;
                                widget.pacientes.cpf = widget.cpf.text;
                                widget.pacientes.nomeMae = widget.nomeMae.text;
                                widget.pacientes.agente =
                                    widget.agentes[widget._selectedAgente].nome;

                                //widget.pacientes.citologia[widget.pacientes.id]
                                //  .nome = widget.nameText.text;
                                //widget.pacientes.citologia[widget.pacientes.id]
                                //  .dataNasc = widget.dataNascText.text;
                                //widget.pacientes.citologia[widget.pacientes.id].cartaoSUS = widget.carteiraSUS.text;
                                //widget.pacientes.citologia[widget.pacientes.id].detalhes = widget.detalhesText.text;
                                //widget.pacientes.citologia[widget.pacientes.id]
                                //  .cpf = widget.cpf.text;
                                //widget.pacientes.citologia[widget.pacientes.id]
                                //  .nomeMae = widget.nomeMae.text;
                                // widget.pacientes.citologia[widget.pacientes.id]
                                //       .agente =
                                //  widget
                                //    .agentes[widget
                                //      .pacientes.selectedIndexAgente]
                                //.nome;
                              });

                              PacientesTodos.save(widget.pacientes);
                              //save();

                              //Navigator.of(context).pop();
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
                        topRight: Radius.circular(10))),
                child: ListView.builder(
                  itemCount: widget.agentes.length,
                  itemBuilder: (context, index) {
                    return FlatButton(
                      onPressed: () {
                        setState(() {
                          widget._selectedAgente = index;
                          // widget.pacientes.selectedIndexAgente = index;

                          Navigator.of(context).pop();
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 20, top: 20),
                            child: Row(
                              children: <Widget>[
                                //SizedBox(width: 20),
                                widget.agentes[index].hasFoto
                                    ? CircleAvatar(
                                        backgroundImage: FileImage(
                                          File(widget.agentes[index].foto),
                                        ),
                                        radius: 30,
                                      )
                                    : Image.asset("assets/ic_agente.png",
                                        height: 60,
                                        width:
                                            60), //Image.asset("assets/ic_agente.png",
                                //   height: 60, width: 60),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(widget.agentes[index].nome),
                                    Text(
                                      widget.agentes[index].localidade,
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Divider(height: 5, color: Colors.grey),
                        ],
                      ),
                    );
                  },
                )),
          );
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
