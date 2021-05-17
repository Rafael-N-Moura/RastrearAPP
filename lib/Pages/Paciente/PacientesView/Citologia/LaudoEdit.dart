import 'package:flutter/material.dart';
import 'package:rastrear/Libs/date_formatted.dart';
import 'package:rastrear/Pages/Paciente/PacientesView/PacientesView.dart';
import 'package:rastrear/Pages/Todos/Pacientes.dart';

class LaudoEdit extends StatefulWidget {
  @override
  _LaudoEditState createState() => _LaudoEditState();

  var DataCtrl = new TextEditingController();
  var DetalhesCtrl = new TextEditingController();
  var ControleCtrl = new TextEditingController();
  bool ResultPositivoCtrl = false;
  bool ResultNegativoCtrl = true;

  int id;
  PacientesTodos paciente;

  LaudoEdit({
    @required this.paciente,
    @required this.id,
  });
}

class _LaudoEditState extends State<LaudoEdit> {
  String result;
  bool resultComplement = false;

  bool empetyData = false;
  bool empetyDetalhes = false;
  bool emptyControle = false;

  @override
  void initState() {
    super.initState();

    widget.DataCtrl.text = widget.paciente.citologia[widget.id].dataLaudo;
    widget.DetalhesCtrl.text =
        widget.paciente.citologia[widget.id].detalhesRegistro;
    widget.ControleCtrl.text = widget.paciente.citologia[widget.id].controle;

    if (widget.paciente.citologia[widget.id].resultadoRegistro == "Positivo") {
      widget.ResultPositivoCtrl = true;
      widget.ResultNegativoCtrl = false;
      result = "Positivo";
      resultComplement = true;
    } else {
      widget.ResultNegativoCtrl = true;
      widget.ResultPositivoCtrl = false;
      result = "Negativo";
      resultComplement = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffB03060),
          centerTitle: true,
          title: Text(
            "Editar laudo",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Minha Fonte",
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.left,
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 0,
                child: Theme(
                  data: ThemeData(
                    primaryColor: Colors.red,
                    primaryColorDark: Colors.red,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      DateInputFormatter(),
                    ],
                    controller: widget.DataCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                      hintText: "Ex.: 31/03/1964",
                      labelText: "Data do laudo",
                      errorText: empetyData ? "Não deixe o campo vazio" : null,
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
              Row(
                children: <Widget>[
                  Checkbox(
                    activeColor: Colors.pinkAccent,
                    value: widget.ResultNegativoCtrl,
                    onChanged: (bool value) {
                      setState(() {
                        widget.ResultNegativoCtrl = value;
                        widget.ResultPositivoCtrl = false;
                        result = "Negativo";
                        resultComplement = false;
                      });
                    },
                  ),
                  Text("Negativo para câncer"),
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: widget.ResultPositivoCtrl,
                    activeColor: Colors.pinkAccent,
                    onChanged: (bool value) {
                      setState(() {
                        widget.ResultPositivoCtrl = value;
                        widget.ResultNegativoCtrl = false;
                        result = "Positivo";
                        resultComplement = true;
                      });
                    },
                  ),
                  Text("Positivo para câncer"),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                flex: resultComplement ? 0 : 1,
                child: Theme(
                  data: ThemeData(
                    primaryColor: Colors.red,
                    primaryColorDark: Colors.red,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: widget.DetalhesCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                      hintText: "Digite os detalhes do registro",
                      labelText: "Detalhes do registro",
                      errorText:
                          empetyDetalhes ? "Não deixe o campo vazio" : null,
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
              SizedBox(height: 20),
              resultComplement
                  ? Expanded(
                      flex: 1,
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Colors.red,
                          primaryColorDark: Colors.red,
                        ),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          controller: widget.ControleCtrl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal)),
                            hintText:
                                "Digite os dados de controle com o especialista",
                            labelText: "Controle com o Especialista",
                            errorText: emptyControle
                                ? "Não deixe o campo vazio"
                                : null,
                            prefixIcon: Icon(
                              Icons.textsms,
                              color: Colors.grey,
                            ),
                            prefixText: " ",
                            suffixStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  : Container(),
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
                            "Salvar edição",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 19),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            if (!RegExp(r'[!@#<>?":_`~;|=+)(*&^%0-9]')
                                .hasMatch(widget.DataCtrl.text)) {
                              setState(() {
                                empetyData = true;
                                empetyDetalhes = false;
                              });
                              return;
                            }
                            if (resultComplement == true) {
                              if (widget.ControleCtrl.text.isEmpty) {
                                setState(() {
                                  emptyControle = true;
                                });
                              }
                            }
                            if (widget.DetalhesCtrl.text.isEmpty) {
                              setState(() {
                                empetyData = false;
                                empetyDetalhes = true;
                              });
                              return;
                            }

                            if (result == "Positivo") {
                              setState(() {
                                widget.paciente.posResult = true;
                              });
                            }
                            if (result == "Negativo") {
                              setState(() {
                                widget.paciente.posResult = false;
                              });
                            }

                            setState(() {
                              widget.paciente.citologia[widget.id].citologiaID =
                                  widget.id;
                              widget.paciente.citologia[widget.id].dataLaudo =
                                  widget.DataCtrl.text;
                              widget.paciente.citologia[widget.id]
                                  .resultadoRegistro = result.toString();
                              widget.paciente.citologia[widget.id]
                                  .detalhesRegistro = widget.DetalhesCtrl.text;
                              widget.paciente.citologia[widget.id].controle =
                                  widget.ControleCtrl.text;
                            });

                            PacientesTodos.save(widget.paciente);

                            //Navigator.pop(context, true);
                            Navigator.of(context).push(_createRoute(
                                PacientesView(paciente: widget.paciente)));
                          },
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ));
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
