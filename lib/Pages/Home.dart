import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rastrear/Pages/Todos/Agente.dart';
import 'package:toast/toast.dart';

import 'Agentes/Agentes.dart';
import 'Agentes/AgentesADD.dart';
import 'Config/Config.dart';
import 'Paciente/Pacientes.dart';
import 'Paciente/PacientesADD.dart';
import 'Pesquisar/Pesquisar.dart';

class Home extends StatefulWidget
{
  @override
  _HomeState createState() => _HomeState();

  var agentes = new List<AgentesTodos>();
}

class _HomeState extends State<Home> with TickerProviderStateMixin
{
  int _selectedIndex = 0;
  bool activeFlat = true;

  List title = ["Mulheres", "Pesquisar", "Agentes", "Configurações"];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      title[index] = title[_selectedIndex];

      if(_selectedIndex == 0) {
        activeFlat = true;
      } else if(_selectedIndex == 1) {
        activeFlat = false;
      } else if(_selectedIndex == 2) {
        activeFlat = true;
      } else if(_selectedIndex == 3) {
        activeFlat = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffB03060),
            title: Text(
              "Rastrear",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Minha Fonte",
                  fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.left,
            ),
            bottom: TabBar(
              onTap: (value) {
                _onItemTapped(value);
              },
              indicatorColor: Colors.pink,
              tabs: <Widget>[
                Tab(icon: ImageIcon(AssetImage("assets/ic_gender.png")), text: "Mulheres"),
                Tab(icon: Icon(Icons.search), text: "Pesquisar"),
                Tab(icon: Icon(Icons.account_circle), text: "Agentes"),
                Tab(icon: Icon(Icons.settings), text: "Configuração")
              ],
            ),
          ),
          floatingActionButton: activeFlat ? FloatingActionButton(
            onPressed: () async {
              if(_selectedIndex == 0) {
                _reloadPaciente();
              } else if(_selectedIndex == 2) {
                Navigator.of(context).push(_createRoute(AgentesADD()));
              }
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.pinkAccent,
          ) : Container(),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Pacientes(),
              Pesquisar(),
              Agentes(),
              Config(),
            ],
          )
        ),
      )
    );
  }

  void _reloadPaciente() async {
    widget.agentes = await AgentesTodos.getAllAgentes();

    if(widget.agentes == null) {
      Toast.show(
        "Você precisa ter um Agente de Sáude",
        context, duration: 3,
        gravity: Toast.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Colors.grey
      );
    } else {
      Navigator.of(context).push(_createRoute(PacientesADD()));
    }
  }

  Route _createRoute(Page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
