import 'package:flutter/material.dart';
import 'package:rastrear/Pages/Todos/Agente.dart';

class DadosAgentes extends StatelessWidget
{
  AgentesTodos agente;

  DadosAgentes({
    @required this.agente,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Nome completo",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              fontSize: 17
            ),
          ),
          Text(
            agente.nome,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Localidade do Agente",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 17
            ),
          ),
          Text(
            agente.localidade,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 15
            ),
          ),
        ],
      ),
    );
  }

  getAge(String year, String month, String day)
  {
    final birthday = DateTime(int.parse(year), int.parse(month), int.parse(day));

    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthday.year;
    int month1 = currentDate.month;
    int month2 = birthday.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthday.day;
      if (day2 > day1) {
        age--;
      }
    }

    return age.toString();
  }
}
