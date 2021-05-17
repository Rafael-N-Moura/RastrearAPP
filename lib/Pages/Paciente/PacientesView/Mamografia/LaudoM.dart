import 'package:flutter/material.dart';
import 'package:rastrear/Libs/date_formatted.dart';
import 'package:rastrear/Pages/Todos/Mamografia.dart';
import 'package:rastrear/Pages/Todos/Pacientes.dart';

class LaudoM extends StatefulWidget {
  @override
  _LaudoMState createState() => _LaudoMState();

  var DataCtrl = new TextEditingController();
  var DetalhesCtrl = new TextEditingController();
  var ControleCtrl = new TextEditingController();
  bool ResultPositivoCtrl = false;
  bool ResultNegativoCtrl = true;

  PacientesTodos paciente;

  LaudoM({@required this.paciente});
}

class _LaudoMState extends State<LaudoM> {
  bool empetyData = false;
  bool empetyDetalhes = false;
  bool emptyControle = false;

  String result = "Negativo";
  bool resultComplement = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffB03060),
          centerTitle: true,
          title: Text(
            "Novo laudo",
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
                  child: TextField(
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
                        //widget.paciente.posResult = true;
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
                            "Salvar registro",
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
                                emptyControle = false;
                              });
                              return;
                            }

                            if (resultComplement) {
                              if (widget.ControleCtrl.text.isEmpty) {
                                setState(() {
                                  emptyControle = true;
                                  empetyData = false;
                                  empetyDetalhes = false;
                                });
                              }
                            }

                            if (widget.DetalhesCtrl.text.isEmpty) {
                              setState(() {
                                empetyData = false;
                                empetyDetalhes = true;
                                emptyControle = false;
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

                            if (widget.paciente.mamografia == null)
                              widget.paciente.mamografia =
                                  List<MamografiaTodos>();
                            widget.paciente.mamografia.add(MamografiaTodos(
                              mamografiaID: widget.paciente.id,
                              dataLaudo: widget.DataCtrl.text,
                              resultadoRegistro: result.toString(),
                              detalhesRegistro: widget.DetalhesCtrl.text,
                              controle: widget.paciente.posResult
                                  ? widget.ControleCtrl.text
                                  : " ",

                              nome: widget.paciente.nome,
                              //cartaoSUS: widget.paciente.cartaoSUS,
                              cpf: widget.paciente.cpf,
                              dataNasc: widget.paciente.dataNasc,
                              //detalhes: widget.paciente.detalhes,
                              nomeMae: widget.paciente.nomeMae,
                              agente: widget.paciente.agente,
                            ));

                            PacientesTodos.save(widget.paciente);

                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}
