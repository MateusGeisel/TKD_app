import 'package:aplicacao_aula/model/relatorio.dart';

class RelatoriosController {
  // 🔹 Singleton
  RelatoriosController._privateConstructor();
  static final RelatoriosController _instance = RelatoriosController._privateConstructor();
  factory RelatoriosController() => _instance;

  final List<Relatorio> _relatorios = [];

  List<Relatorio> get relatorios => List.unmodifiable(_relatorios);

  void adicionarRelatorio(Relatorio relatorio) {
    _relatorios.add(relatorio);
  }

  void removerRelatorio(int id) {
    _relatorios.removeWhere((r) => r.id == id);
  }

  void atualizarRelatorio(Relatorio relatorioAtualizado) {
    final index = _relatorios.indexWhere((r) => r.id == relatorioAtualizado.id);
    if (index != -1) {
      _relatorios[index] = relatorioAtualizado;
    }
  }
}
