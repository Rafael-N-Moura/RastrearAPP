import 'package:flutter/material.dart';
import 'package:rastrear/Pages/Agentes/Relatorio/RelatorioCitologia.dart';
import 'package:rastrear/Pages/Agentes/Relatorio/RelatorioMamografia.dart';
import 'package:rastrear/Pages/Todos/Agente.dart';

class RelatorioHome extends StatefulWidget
{
  @override
  _RelatorioHomeState createState() => _RelatorioHomeState();

  AgentesTodos agente;
  int idPaciente;

  RelatorioHome({
    this.agente,
    this.idPaciente,
  });
}

class _RelatorioHomeState extends State<RelatorioHome>
{
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    List<Widget> _widgetOptions = <Widget>[
      RelatorioCitologia(
        agente: widget.agente,
        idPaciente: widget.idPaciente,
      ),
      RelatorioMamografia(
        agente: widget.agente,
        idPaciente: widget.idPaciente,
      )
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            title: Text('Citologia'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            title: Text('Mamografia'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
