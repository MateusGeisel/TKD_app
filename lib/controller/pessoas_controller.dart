import 'package:aplicacao_aula/model/pessoa.dart';

class PessoasController {
  // Construtor privado para o padrão Singleton
  PessoasController._internal();

  // Instância única em memória
  static final PessoasController _instance = PessoasController._internal();

  factory PessoasController() {
    return _instance;
  }

  // Lista temporária em memória com alguns dados iniciais para teste
  final List<Pessoa> pessoas = [
    Pessoa(
      id: 1,
      nome: "Mateus Geisel",
      idade: 26,
      academia: "TKD Central",
      faixa: "Amarelo 7º Gup",
    ),
  ];
}