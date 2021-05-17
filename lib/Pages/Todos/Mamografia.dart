class MamografiaTodos {
  int mamografiaID;
  String dataLaudo;
  String resultadoRegistro;
  String detalhesRegistro;
  String controle;
  String nome;
  //String detalhes;
  //String cartaoSUS;
  String nomeMae;
  String cpf;
  String dataNasc;
  String agente;

  MamografiaTodos({
    this.mamografiaID,
    this.dataLaudo,
    this.resultadoRegistro,
    this.detalhesRegistro,
    this.nome,
    this.controle,
    //this.detalhes,
    //this.cartaoSUS,
    this.nomeMae,
    this.cpf,
    this.dataNasc,
    this.agente,
  });

  MamografiaTodos.fromJson(Map<String, dynamic> json) {
    mamografiaID = json['mamografiaID'];
    dataLaudo = json['dataLaudo'];
    resultadoRegistro = json['resultadoRegistro'];
    detalhesRegistro = json['detalhesRegistro'];
    controle = json['controle'];
    nome = json['nome'];
    //detalhes = json['detalhes'];
    //cartaoSUS = json['cartaoSUS'];
    nomeMae = json['nomeMae'];
    cpf = json['cpf'];
    dataNasc = json['dataNasc'];
    agente = json['agente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mamografiaID'] = this.mamografiaID;
    data['dataLaudo'] = this.dataLaudo;
    data['resultadoRegistro'] = this.resultadoRegistro;
    data['detalhesRegistro'] = this.detalhesRegistro;
    data['controle'] = this.controle;
    data['nome'] = this.nome;
    //data['detalhes'] = this.detalhes;
    //data['cartaoSUS'] = this.cartaoSUS;
    data['nomeMae'] = this.nomeMae;
    data['cpf'] = this.cpf;
    data['dataNasc'] = this.dataNasc;
    data['agente'] = this.agente;

    return data;
  }
}
