import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rastrear/Pages/Todos/Agente.dart';
import 'package:rastrear/Pages/Todos/Pacientes.dart';
import 'package:rastrear/Pages/Todos/Relatorio.dart';
import 'package:intl/intl.dart';

Relatorio tempRelatorio = new Relatorio();
DateTime data;

class CreatePDF {
  static void GeneratePDF(AgentesTodos agente, Function retornarCaminho) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Exception("Permissão negada ao tentar gerar o pdf.");
    }

    var paciente = new List<PacientesTodos>();
    paciente = await PacientesTodos.getPacientePorNome(agente.nome);

    final pdf = Document(deflate: zlib.encode);

    //var data = await rootBundle.load("assets/minhafonte.ttf");
    //var myFont = Font.ttf(data);
    //var myStyle = TextStyle(font: myFont);

    pdf.addPage(MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: CrossAxisAlignment.start,
        header: (Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: BoxDecoration(
                  border: BoxBorder(
                      bottom: true, width: 0.5, color: PdfColors.grey)),
              child: Text('Relatório gerado pelo aplicativo Rastrear',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text(
                  'Página ${context.pageNumber} de ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (Context context) => <Widget>[
              Header(
                  level: 0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Relatório do Agente de Saúde ${agente.nome}',
                            textScaleFactor: 2),
                        PdfLogo()
                      ])),
              Header(level: 1, text: 'Citologias'),
              Header(level: 3, text: 'Cadastro sem laudos'),
              TableNotLaudoC(context, paciente),
              Header(level: 3, text: 'Laudos negativos'),
              TableLaudoNegativoC(context, paciente),
              Header(level: 3, text: 'Laudos positivos'),
              TableLaudoPositivoC(context, paciente),
              Header(level: 3, text: 'Sem laudo nos últimos três anos'),
              TableNotLaudoYearC(context, paciente),
              Header(level: 1, text: 'Mamografias'),
              Header(level: 3, text: 'Cadastro sem laudos'),
              TableNotLaudoM(context, paciente),
              Header(level: 3, text: 'Laudos negativos'),
              TableLaudoNegativoM(context, paciente),
              Header(level: 3, text: 'Laudos positivos'),
              TableLaudoPositivoM(context, paciente),
              Header(level: 3, text: 'Sem laudo nos últimos três anos'),
              TableNotLaudoYearM(context, paciente),
              Padding(padding: const EdgeInsets.all(10)),
            ]));

    //Directory tempDir2 = await getExternalStorageDirectory();
    Directory tempDir2 = await DownloadsPathProvider.downloadsDirectory;
    String pathFile = tempDir2.path + "/relatorio ${agente.nome}.pdf";
    var file = File(pathFile);
    file.writeAsBytesSync(pdf.save());
    //if (agente.relatorios.length <= 1) {
    //agente.relatorios.first = pathFile;
    //} else {
    //  agente.relatorios.add(pathFile);
    //}
    tempRelatorio.caminho = pathFile;
    tempRelatorio.nomeAgente = agente.nome;
    data = DateTime.now();
    tempRelatorio.dataRegistro = DateFormat("'Data:' dd/MM/yyyy").format(data);
    //tempRelatorio.dataRegistro = "Bom dia";
    print(pathFile);
    retornarCaminho(tempRelatorio);
  }

  static Widget TableNotLaudoC(context, List<PacientesTodos> pacientes) {
    if (pacientes != null) {
      return Table.fromTextArray(context: context, data: <List<String>>[
        //<String>['Paciente', 'Data de nascimento', 'Cartão SUS', "Agente"],
        <String>['Paciente', 'Data de nascimento', 'CPF', "Agente"],
        ...pacientes.map((function) => function.citologia == null
            ? [
                function.nome ?? 'Sem resgistro',
                function.dataNasc ?? 'Sem resgistro',
                //function.cartaoSUS,
                function.cpf ?? 'Sem resgistro',
                function.agente ?? 'Sem resgistro',
              ]
            : [])
      ]);
    }
  }

  static Widget TableLaudoNegativoC(context, List<PacientesTodos> pacientes) {
    if (pacientes != null) {
      return Table.fromTextArray(context: context, data: <List<String>>[
        //<String>['Paciente', 'Data de nascimento', 'Cartão SUS', "Agente"],
        <String>['Paciente', 'Data de nascimento', 'CPF', "Agente"],
        ...pacientes.map((function) => function.citologia != null
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
            : [])
      ]);
    }
  }

  static Widget TableLaudoPositivoC(context, List<PacientesTodos> pacientes) {
    if (pacientes != null) {
      return Table.fromTextArray(context: context, data: <List<String>>[
        <String>['Paciente', 'Data de nascimento', 'CPF', "Agente"],
        ...pacientes.map((function) => function.citologia != null
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
            : [])
      ]);
    }
  }

  static Widget TableNotLaudoYearC(context, List<PacientesTodos> pacientes) {
    if (pacientes != null) {
      return Table.fromTextArray(context: context, data: <List<String>>[
        <String>['Paciente', 'Data de nascimento', 'CPF', "Agente"],
        ...pacientes.map((function) => function.citologia == null
            ? [
                function.nome ?? 'Sem resgistro',
                function.dataNasc ?? 'Sem resgistro',
                function.cpf ?? 'Sem resgistro',
                function.agente ?? 'Sem resgistro'
              ]
            : [])
      ]);
    }
  }

  static Widget TableNotLaudoM(context, List<PacientesTodos> pacientes) {
    if (pacientes != null) {
      return Table.fromTextArray(context: context, data: <List<String>>[
        <String>['Paciente', 'Data de nascimento', 'CPF', "Agente"],
        ...pacientes.map((function) => function.mamografia == null
            ? [
                function.nome ?? 'Sem resgistro',
                function.dataNasc ?? 'Sem resgistro',
                function.cpf ?? 'Sem resgistro',
                function.agente ?? 'Sem resgistro'
              ]
            : [])
      ]);
    }
  }

  static Widget TableLaudoNegativoM(context, List<PacientesTodos> pacientes) {
    if (pacientes != null) {
      return Table.fromTextArray(context: context, data: <List<String>>[
        <String>['Paciente', 'Data de nascimento', 'CPF', "Agente"],
        ...pacientes.map((function) => function.mamografia != null
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
            : [])
      ]);
    }
  }

  static Widget TableLaudoPositivoM(context, List<PacientesTodos> pacientes) {
    if (pacientes != null) {
      return Table.fromTextArray(context: context, data: <List<String>>[
        <String>['Paciente', 'Data de nascimento', 'CPF', "Agente"],
        ...pacientes.map((function) => function.mamografia != null
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
            : [])
      ]);
    }
  }

  static Widget TableNotLaudoYearM(context, List<PacientesTodos> pacientes) {
    if (pacientes != null) {
      return Table.fromTextArray(context: context, data: <List<String>>[
        <String>['Paciente', 'Data de nascimento', 'CPF', "Agente"],
        ...pacientes.map((function) => function.mamografia == null
            ? [
                function.nome ?? 'Sem resgistro',
                function.dataNasc ?? 'Sem resgistro',
                function.cpf ?? 'Sem resgistro',
                function.agente ?? 'Sem resgistro'
              ]
            : [])
      ]);
    }
  }
}
