import 'package:flutter/material.dart';
import 'package:aplicacao_aula/controller/relatorios_controller.dart';
import 'package:aplicacao_aula/model/relatorio.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  final RelatoriosController _controller = RelatoriosController();
  final TextEditingController _jogador1Controller = TextEditingController();
  final TextEditingController _jogador2Controller = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  @override
  void dispose() {
    _jogador1Controller.dispose();
    _jogador2Controller.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  // ------------------------
  // Adicionar Relatório
  // ------------------------
  void _adicionarRelatorio() {
    if (_jogador1Controller.text.isEmpty ||
        _jogador2Controller.text.isEmpty ||
        _descricaoController.text.isEmpty) {
      return;
    }

    final novoRelatorio = Relatorio(
      id: DateTime.now().millisecondsSinceEpoch,
      jogador1: _jogador1Controller.text,
      jogador2: _jogador2Controller.text,
      descricao: _descricaoController.text,
    );

    setState(() {
      _controller.adicionarRelatorio(novoRelatorio);
    });

    _jogador1Controller.clear();
    _jogador2Controller.clear();
    _descricaoController.clear();
    Navigator.pop(context);
  }

  void _abrirDialogoAdicionar() {
    _jogador1Controller.clear();
    _jogador2Controller.clear();
    _descricaoController.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Novo Relatório"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _jogador1Controller,
              decoration: const InputDecoration(labelText: "Jogador 1"),
            ),
            TextField(
              controller: _jogador2Controller,
              decoration: const InputDecoration(labelText: "Jogador 2"),
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: _adicionarRelatorio,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  // ------------------------
  // Editar Relatório
  // ------------------------
  void _editarRelatorio(Relatorio relatorio) {
    if (_jogador1Controller.text.isEmpty ||
        _jogador2Controller.text.isEmpty ||
        _descricaoController.text.isEmpty) {
      return;
    }

    final relatorioAtualizado = Relatorio(
      id: relatorio.id,
      jogador1: _jogador1Controller.text,
      jogador2: _jogador2Controller.text,
      descricao: _descricaoController.text,
    );

    setState(() {
      _controller.atualizarRelatorio(relatorioAtualizado);
    });

    _jogador1Controller.clear();
    _jogador2Controller.clear();
    _descricaoController.clear();
    Navigator.pop(context);
  }

  void _abrirDialogoEditar(Relatorio relatorio) {
    _jogador1Controller.text = relatorio.jogador1;
    _jogador2Controller.text = relatorio.jogador2;
    _descricaoController.text = relatorio.descricao;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Relatório"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _jogador1Controller,
              decoration: const InputDecoration(labelText: "Jogador 1"),
            ),
            TextField(
              controller: _jogador2Controller,
              decoration: const InputDecoration(labelText: "Jogador 2"),
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => _editarRelatorio(relatorio),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text("Salvar Alterações"),
          ),
        ],
      ),
    );
  }

  // ------------------------
  // Excluir Relatório
  // ------------------------
  void _confirmarExclusao(Relatorio relatorio) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar exclusão"),
        content: Text("Deseja realmente excluir o relatório de "
            "${relatorio.jogador1} vs ${relatorio.jogador2}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _controller.removerRelatorio(relatorio.id);
              });
              Navigator.pop(context);
            },
            child: const Text("Excluir"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final relatorios = _controller.relatorios;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Relatórios"),
      ),
      body: relatorios.isEmpty
          ? const Center(child: Text("Nenhum relatório criado."))
          : ListView.builder(
              itemCount: relatorios.length,
              itemBuilder: (context, index) {
                final relatorio = relatorios[index];
                return ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: Text("${relatorio.jogador1} vs ${relatorio.jogador2}"),
                  subtitle: Text(relatorio.descricao),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _abrirDialogoEditar(relatorio),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmarExclusao(relatorio),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirDialogoAdicionar,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
