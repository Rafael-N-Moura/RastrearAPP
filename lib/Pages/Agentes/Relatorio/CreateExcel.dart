import 'dart:io';

import 'package:csv/csv.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rastrear/Pages/Todos/Agente.dart';
import 'package:rastrear/Pages/Todos/Pacientes.dart';
import 'package:rastrear/Pages/Todos/Relatorio.dart';

Relatorio tempRelatorio = new Relatorio();
DateTime data;

class CreateExcel {
  static void GenerateExcel(
      AgentesTodos agente, Function retornarCaminho) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Exception("Permissão negada ao tentar gerar o excel.");
    }

    var paciente = new List<PacientesTodos>();
    paciente = await PacientesTodos.getPacientePorNome(agente.nome);

    if (paciente != null) {
      List<List<dynamic>> csvData = [
        <String>['Relatorio do Agente de Saude ${agente.nome}'],
        <String>[""],
        //Citologias
        <String>["Citologias"],
        <String>[""],

        <String>["Cadastro sem laudos"],
        <String>['Paciente', "Data de nascimento", "CPF", "Agente"],
        ...paciente.map((function) => function.citologia == null
            ? [function.nome, function.dataNasc, function.cpf, function.agente]
            : []),
        <String>[""],

        <String>["Laudos negativos"],
        <String>['Paciente', "Data de nascimento", "CPF", "Agente"],
        ...paciente.map((function) => function.citologia != null
            ? [
                ...function.citologia.map((funC) =>
                    funC.resultadoRegistro == "Negativo" ? funC.nome : ''),
                ...function.citologia.map((funC) =>
                    funC.resultadoRegistro == "Negativo" ? funC.dataNasc : ''),
                ...function.citologia.map((funC) =>
                    funC.resultadoRegistro == "Negativo" ? funC.cpf : ''),
                ...function.citologia.map((funC) =>
                    funC.resultadoRegistro == "Negativo" ? funC.agente : ''),
              ]
            : []),
        <String>[""],

        <String>["Laudos positivos"],
        <String>['Paciente', "Data de nascimento", "CPF", "Agente"],
        ...paciente.map((function) => function.citologia != null
            ? [
                ...function.citologia.map((funC) =>
                    funC.resultadoRegistro == "Positivo" ? funC.nome : ''),
                ...function.citologia.map((funC) =>
                    funC.resultadoRegistro == "Positivo" ? funC.dataNasc : ''),
                ...function.citologia.map((funC) =>
                    funC.resultadoRegistro == "Positivo" ? funC.cpf : ''),
                ...function.citologia.map((funC) =>
                    funC.resultadoRegistro == "Positivo" ? funC.agente : ''),
              ]
            : []),
        <String>[""],

        <String>["Sem laudo nos ultimos tres anos"],
        <String>['Paciente', "Data de nascimento", "CPF", "Agente"],
        ...paciente.map((function) => function.citologia == null
            ? [function.nome, function.dataNasc, function.cpf, function.agente]
            : []),
        <String>[""],

        //Mamografias
        <String>["Mamografias"],
        <String>[""],

        <String>["Cadastro sem laudos"],
        <String>['Paciente', "Data de nascimento", "CPF", "Agente"],
        ...paciente.map((function) => function.mamografia == null
            ? [function.nome, function.dataNasc, function.cpf, function.agente]
            : []),
        <String>[""],

        <String>["Laudos negativos"],
        <String>['Paciente', "Data de nascimento", "CPF", "Agente"],
        ...paciente.map((function) => function.mamografia != null
            ? [
                ...function.mamografia.map((funC) =>
                    funC.resultadoRegistro == "Negativo" ? funC.nome : ''),
                ...function.mamografia.map((funC) =>
                    funC.resultadoRegistro == "Negativo" ? funC.dataNasc : ''),
                ...function.mamografia.map((funC) =>
                    funC.resultadoRegistro == "Negativo" ? funC.cpf : ''),
                ...function.mamografia.map((funC) =>
                    funC.resultadoRegistro == "Negativo" ? funC.agente : ''),
              ]
            : []),
        <String>[""],

        <String>["Laudos positivos"],
        <String>['Paciente', "Data de nascimento", "CPF", "Agente"],
        ...paciente.map((function) => function.mamografia != null
            ? [
                ...function.mamografia.map((funC) =>
                    funC.resultadoRegistro == "Positivo" ? funC.nome : ''),
                ...function.mamografia.map((funC) =>
                    funC.resultadoRegistro == "Positivo" ? funC.dataNasc : ''),
                ...function.mamografia.map((funC) =>
                    funC.resultadoRegistro == "Positivo" ? funC.cpf : ''),
                ...function.mamografia.map((funC) =>
                    funC.resultadoRegistro == "Positivo" ? funC.agente : ''),
              ]
            : []),
        <String>[""],

        <String>["Sem laudo nos ultimos tres anos"],
        <String>['Paciente', "Data de nascimento", "CPF", "Agente"],
        ...paciente.map((function) => function.mamografia == null
            ? [function.nome, function.dataNasc, function.cpf, function.agente]
            : []),
        <String>[""],
      ];

      String csv = const ListToCsvConverter().convert(csvData);

      //Directory tempDir2 = await getExternalStorageDirectory();
      Directory tempDir2 = await DownloadsPathProvider.downloadsDirectory;
      String pathFile = tempDir2.path + "/relatorio ${agente.nome}.csv";
      var file = File(pathFile);
      file.writeAsString(csv);
      tempRelatorio.caminho = pathFile;
      tempRelatorio.nomeAgente = agente.nome;
      data = DateTime.now();
      tempRelatorio.dataRegistro =
          DateFormat("'Data:' dd/MM/yyyy").format(data);
      print(pathFile);
      retornarCaminho(tempRelatorio);
    }
  }
}
