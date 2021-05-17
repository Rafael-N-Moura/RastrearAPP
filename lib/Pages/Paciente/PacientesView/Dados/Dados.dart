import 'package:flutter/material.dart';
import 'package:rastrear/Pages/Todos/Pacientes.dart';

class Dados extends StatelessWidget {
  PacientesTodos paciente;

  Dados({
    @required this.paciente,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Nome do paciente",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 17),
          ),
          Text(
            paciente.nome,
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          SizedBox(height: 20),
          Text(
            //"Cartão SUS",
            "CPF",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 17),
          ),
          Text(
            //paciente.cartaoSUS,
            paciente.cpf ?? "Sem registro",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          SizedBox(height: 20),
          Text(
            //"Detalhes do paciente",
            "Nome da Mãe",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 17),
          ),
          Text(
            //paciente.detalhes,
            paciente.nomeMae ?? "Sem registro",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          SizedBox(height: 20),
          Text(
            "Idade Atual",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 17),
          ),
          Text(
            getAge(
                    paciente.dataNasc.substring(6, 10),
                    paciente.dataNasc.substring(3, 5),
                    paciente.dataNasc.substring(0, 2)) +
                " Anos",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          SizedBox(height: 20),
          Text(
            "Data de Nascimento",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 17),
          ),
          Text(
            paciente.dataNasc,
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ],
      ),
    );
  }

  getAge(String year, String month, String day) {
    final birthday =
        DateTime(int.parse(year), int.parse(month), int.parse(day));

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
