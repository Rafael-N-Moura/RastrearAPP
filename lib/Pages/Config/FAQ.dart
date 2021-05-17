import 'package:flutter/material.dart';

class FAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffB03060),
        centerTitle: true,
        title: Text(
          "FAQ",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: "Minha Fonte",
              fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Rastrear",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Minha Fonte"
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "O que é?",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Minha Fonte"
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Text(
                  "É um aplicativo destinado a criar um banco de dados sobre informações relacionadas ao histórico de rastreamento"
                      " do câncer de colo de útero e mama de mulheres da estratégia de saúde da família.",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Minha Fonte"
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 10),
                Text(
                  "Para que o aplicativo foi criado?",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Minha Fonte"
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Text(
                  "O rastrear foi criado com o objetivo de contribuir para a organização do rastreamento do câncer de colo de útero"
                      " e mama em mulheres em idade de risco através do acompanhamento da execução dos exames e sua periodicidade.",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Minha Fonte"
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 10),
                Text(
                  "Como funciona o Rastrear?",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Minha Fonte"
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Text(
                  "O rastrear permite a criação de um banco de dados com o registro de innformações sobre a citologia oncótica cervical e mamografia"
                      " obtendo-se assim um banco de dados de fácil acesso, disponível aos profissionais permitindo o controle de regularidade das mulheres em relação aos exames.",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Minha Fonte"
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 10),
                Text(
                  "Cadastrar Mulheres",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Minha Fonte"
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Text(
                  "Permite inserir dados das mulheres existentes nas área na faixa e´taria de 25 a 69 anos e realizar através da data de nascimento"
                      " e agente comunitário de saúde responsável pelo seu acompanhamento.",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Minha Fonte"
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 10),
                Text(
                  "Cadastrar Citologia",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Minha Fonte"
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Text(
                  "Permite registrar o seu laudo por mulher cadastrada, criando assim uma série de histórico dos exames registrados e,"
                      " visualizando as mulheres cadastradas sem exames e as mulheres que realizaram os exames com os intervalos regulares e irregulares.",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Minha Fonte"
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 10),
                Text(
                  "Cadastrar Mamografia",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Minha Fonte"
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Text(
                  "Permite registrar o seu laudo por mulher cadastrada, criando assim uma série histórico dos exames registrados e, visualizando as mulheres cadastradas sem exames e as mulheres que realizaram os exames com os intervalos regulares e irregulares.",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Minha Fonte"
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
