class Relatorio {
  final int id;
  final String jogador1;
  final String jogador2;
  final String descricao;

  Relatorio({required this.id, required this.jogador1, required this.jogador2, required this.descricao  });

  factory Relatorio.fromJson(Map<String, dynamic> json) {
    return Relatorio(
      id: json['id'],
      jogador1: json['jogador1'],
      jogador2: json['jogador2'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'jogador1': jogador1, 'jogador2': jogador2, 'descricao': descricao};
  }
}
