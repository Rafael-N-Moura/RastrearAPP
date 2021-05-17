import 'dart:convert';

import 'package:rastrear/Pages/Todos/Relatorio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgentesTodos {
  int id;
  String nome;
  String localidade;
  String foto;
  bool hasFoto;
  List<Relatorio> relatorios;

  AgentesTodos({
    this.id,
    this.nome,
    this.localidade,
    this.relatorios,
    this.foto,
    this.hasFoto,
  });

  AgentesTodos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    localidade = json['localidade'];
    hasFoto = json['hasFoto'];
    foto = json['foto'];
    if (json['relatorios'] != null) {
      List<dynamic> temp = json['relatorios'];
      if (temp != null) {
        relatorios = temp.map((x) => Relatorio.fromJson(x)).toList();
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['localidade'] = this.localidade;
    data['hasFoto'] = this.hasFoto;
    data['foto'] = this.foto;
    data['relatorios'] = this.relatorios;

    return data;
  }

  static Future<List<AgentesTodos>> getAllAgentes() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("agentesData");

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<AgentesTodos> result =
          decoded.map((x) => AgentesTodos.fromJson(x)).toList();

      return result;
    }
    return null;
  }

  static Future<AgentesTodos> getPacientePorNome(String nome) async {
    var prefs = await SharedPreferences.getInstance();
    List<AgentesTodos> agentes = await getAll(prefs);
    return agentes.firstWhere((agentes) => agentes.nome == nome);
  }

  static void removerAgentes(int id) async {
    var prefs = await SharedPreferences.getInstance();
    List<AgentesTodos> agentes = await getAll(prefs);
    agentes.removeWhere((item) => item.id == id);
    if (agentes.length < 1) {
      await prefs.remove("agentesData");
    } else {
      await prefs.setString("agentesData", jsonEncode(agentes));
    }
  }

  static Future<List<AgentesTodos>> getAll(SharedPreferences prefs) async {
    var data = prefs.getString("agentesData");

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<AgentesTodos> result =
          decoded.map((x) => AgentesTodos.fromJson(x)).toList();

      return result;
    }
    return null;
  }

  static void save(AgentesTodos agente) async {
    var prefs = await SharedPreferences.getInstance();
    List<AgentesTodos> agentes = await AgentesTodos.getAll(prefs);
    agentes = agentes.map((item) {
      if (item.id == agente.id) {
        item = agente;
      }
      return item;
    }).toList();
    await prefs.setString("agentesData", jsonEncode(agentes));
  }
}
