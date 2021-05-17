import 'dart:convert';

import 'package:rastrear/Pages/Todos/Mamografia.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Citologia.dart';

class PacientesTodos {
  int id;
  String nome;
  //String detalhes;
  String nomeMae;
  String cpf;
  //String cartaoSUS;
  String dataNasc;
  int selectedMarker;
  int selectedIndexAgente;
  String agente;
  String foto;
  bool hasFoto;
  bool posResult;

  List<CitologiaTodos> citologia;
  List<MamografiaTodos> mamografia;

  PacientesTodos(
      {this.id,
      this.nome,
      this.foto,
      //this.detalhes,
      //this.cartaoSUS,
      this.nomeMae,
      this.cpf,
      this.dataNasc,
      this.agente,
      this.selectedMarker,
      this.selectedIndexAgente,
      this.hasFoto,
      this.posResult,
      this.citologia,
      this.mamografia});

  PacientesTodos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    //detalhes = json['detalhes'];
    //cartaoSUS = json['cartaoSUS'];
    nomeMae = json['nomeMae'];
    cpf = json['cpf'];
    dataNasc = json['dataNasc'];
    selectedMarker = json['selectedMarker'];
    selectedIndexAgente = json['selectedIndexAgente'];
    agente = json['agente'];
    foto = json['foto'];
    hasFoto = json['hasFoto'];
    posResult = json['posResult'];

    if (json['citologia'] != null) {
      List<dynamic> citologias = json['citologia'];
      citologia = citologias.map((x) => CitologiaTodos.fromJson(x)).toList();
    }

    if (json['mamografia'] != null) {
      List<dynamic> mamografias = json['mamografia'];
      mamografia = mamografias.map((x) => MamografiaTodos.fromJson(x)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    //data['detalhes'] = this.detalhes;
    //data['cartaoSUS'] = this.cartaoSUS;
    data['nomeMae'] = this.nomeMae;
    data['cpf'] = this.cpf;
    data['dataNasc'] = this.dataNasc;
    data['agente'] = this.agente;
    data['selectedMarker'] = this.selectedMarker;
    data['selectedIndexAgente'] = this.selectedIndexAgente;
    data['citologia'] = this.citologia;
    data['mamografia'] = this.mamografia;
    data['foto'] = this.foto;
    data['hasFoto'] = this.hasFoto;
    data['posResult'] = this.posResult;

    return data;
  }

  static Future<List<PacientesTodos>> getAll(SharedPreferences prefs) async {
    var data = prefs.getString("pacientesData");

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<PacientesTodos> result =
          decoded.map((x) => PacientesTodos.fromJson(x)).toList();

      return result;
    }
    return null;
  }

  static Future<List<PacientesTodos>> getAllPacientes() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("pacientesData");

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<PacientesTodos> result =
          decoded.map((x) => PacientesTodos.fromJson(x)).toList();

      return result;
    }
    return null;
  }

  static Future<List<PacientesTodos>> getPacientePorNome(String nome) async {
    var prefs = await SharedPreferences.getInstance();
    List<PacientesTodos> pacientes = await getAll(prefs);
    if (pacientes != null) {
      return pacientes.where((paciente) => paciente.agente == nome).toList();
    }
  }

  static Future<PacientesTodos> getPacientePorId(int id) async {
    var prefs = await SharedPreferences.getInstance();
    List<PacientesTodos> pacientes = await getAll(prefs);
    if (pacientes != null) {
      return pacientes.firstWhere((paciente) => paciente.id == id);
    }
  }

  static Future<List<PacientesTodos>> getCitologiaPorNome(String nome) async {
    var prefs = await SharedPreferences.getInstance();
    List<PacientesTodos> pacientes = await getAll(prefs);
    return pacientes.where((paciente) => paciente.agente == nome).toList();
  }

  static void removerPacientes(int id) async {
    var prefs = await SharedPreferences.getInstance();
    List<PacientesTodos> pacientes = await getAll(prefs);
    pacientes.removeWhere((item) => item.id == id);
    if (pacientes.length < 1) {
      await prefs.remove("pacientesData");
    } else {
      await prefs.setString("pacientesData", jsonEncode(pacientes));
    }
  }

  static void removerPacientesPorNome(String nome) async {
    var prefs = await SharedPreferences.getInstance();
    List<PacientesTodos> pacientes = await getAll(prefs);
    if (pacientes != null) {
      pacientes.removeWhere((item) => item.agente == nome);

      if (pacientes.length < 1) {
        await prefs.remove("pacientesData");
      } else {
        await prefs.setString("pacientesData", jsonEncode(pacientes));
      }
    }
  }

  static void save(PacientesTodos paciente) async {
    var prefs = await SharedPreferences.getInstance();
    List<PacientesTodos> pacientes = await PacientesTodos.getAll(prefs);
    pacientes = pacientes.map((item) {
      if (item.id == paciente.id) {
        item = paciente;
      }
      return item;
    }).toList();
    await prefs.setString("pacientesData", jsonEncode(pacientes));
  }

  static void removerTodasCitologias(int id) async {
    PacientesTodos paciente = await getPacientePorId(id);
    if (paciente.citologia != null) {
      paciente.citologia.clear();
      await save(paciente);
    }
  }
}
