import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Relatorio {
  int id;
  String nomeAgente;
  String caminho;
  String dataRegistro;

  Relatorio({this.caminho, this.dataRegistro, this.nomeAgente});

  Relatorio.fromJson(Map<String, dynamic> json) {
    nomeAgente = json['nomeAgente'];
    caminho = json['caminho'];
    dataRegistro = json['dataRegistro'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nomeAgente'] = this.nomeAgente;
    data['caminho'] = this.caminho;
    data['dataRegistro'] = this.dataRegistro;
    data['id'] = this.id;
    return data;
  }

  static Future<List<Relatorio>> getAll(SharedPreferences prefs) async {
    var data = prefs.getString("relatorioData");

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Relatorio> result =
          decoded.map((x) => Relatorio.fromJson(x)).toList();

      return result;
    }
    return null;
  }

  static Future<List<Relatorio>> getAllPacientes() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("relatorioData");

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Relatorio> result =
          decoded.map((x) => Relatorio.fromJson(x)).toList();

      return result;
    }
    return null;
  }

  static Future<List<Relatorio>> getRelatorioPorNome(String nome) async {
    var prefs = await SharedPreferences.getInstance();
    List<Relatorio> relatorio = await getAll(prefs);
    if (relatorio != null) {
      return relatorio
          .where((relatorio) => relatorio.nomeAgente == nome)
          .toList();
    }
  }

  static void save(Relatorio relatorio) async {
    var prefs = await SharedPreferences.getInstance();
    List<Relatorio> relatorios = await Relatorio.getAll(prefs);
    relatorios = relatorios.map((item) {
      if (item.id == relatorio.id) {
        item = relatorio;
      }
      return item;
    }).toList();
    await prefs.setString("relatorioData", jsonEncode(relatorios));
  }
}
