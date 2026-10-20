class Pessoa {
  final int? id;
  final String nome;
  final int idade;
  final String academia;
  final String? faixa;

  Pessoa({
    this.id,
    required this.nome,
    required this.idade,
    required this.academia,
    this.faixa,
  });

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      id: json['id'],
      nome: json['nome'] ?? '',
      idade: json['idade'] ?? 0,
      academia: json['academia'] ?? '',
      faixa: json['faixa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'idade': idade,
      'academia': academia,
      'faixa': faixa,
    };
  }
}