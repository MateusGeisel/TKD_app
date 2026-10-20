import 'package:flutter/material.dart';
import 'package:aplicacao_aula/controller/pessoas_controller.dart';
import 'package:aplicacao_aula/model/pessoa.dart';

class PessoasPage extends StatefulWidget {
  const PessoasPage({super.key});

  @override
  State<PessoasPage> createState() => _PessoasPageState();
}

class _PessoasPageState extends State<PessoasPage> {
  // Instância do controller (Singleton)
  final PessoasController controller = PessoasController();

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _academiaController = TextEditingController();
  final _faixaController = TextEditingController();

  void _abrirModalCadastro({Pessoa? pessoa, int? index}) {
    if (pessoa != null) {
      _nomeController.text = pessoa.nome;
      _idadeController.text = pessoa.idade.toString();
      _academiaController.text = pessoa.academia;
      _faixaController.text = pessoa.faixa ?? '';
    } else {
      _nomeController.clear();
      _idadeController.clear();
      _academiaController.clear();
      _faixaController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    pessoa == null ? "Cadastrar Lutador" : "Editar Lutador",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Campo Nome
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: "Nome do Lutador",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Informe o nome do lutador";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Campo Idade
                  TextFormField(
                    controller: _idadeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Idade",
                      prefixIcon: Icon(Icons.cake),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Informe a idade";
                      }
                      if (int.tryParse(value.trim()) == null) {
                        return "Informe um número válido";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Campo Academia
                  TextFormField(
                    controller: _academiaController,
                    decoration: const InputDecoration(
                      labelText: "Academia / Equipe",
                      prefixIcon: Icon(Icons.fitness_center),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Informe a academia";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Campo Faixa
                  TextFormField(
                    controller: _faixaController,
                    decoration: const InputDecoration(
                      labelText: "Faixa / Graduação (ex: Faixa Preta 1º Dan)",
                      prefixIcon: Icon(Icons.military_tech),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botão Salvar / Atualizar
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final novoLutador = Pessoa(
                          id:
                              pessoa?.id ??
                              DateTime.now().millisecondsSinceEpoch,
                          nome: _nomeController.text.trim(),
                          idade:
                              int.tryParse(_idadeController.text.trim()) ?? 0,
                          academia: _academiaController.text.trim(),
                          faixa: _faixaController.text.trim(),
                        );

                        setState(() {
                          if (pessoa != null && index != null) {
                            controller.pessoas[index] = novoLutador;
                          } else {
                            controller.pessoas.add(novoLutador);
                          }
                        });

                        Navigator.pop(ctx);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              pessoa == null
                                  ? "Lutador cadastrado com sucesso!"
                                  : "Dados atualizados!",
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Text(pessoa == null ? "Salvar" : "Atualizar"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _removerLutador(int index) {
    setState(() {
      controller.pessoas.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Lutador removido com sucesso."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lutadores = controller.pessoas;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Lutadores"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: lutadores.isEmpty
          ? const Center(
              child: Text(
                "Nenhum lutador cadastrado.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: lutadores.length,
              itemBuilder: (context, index) {
                final lutador = lutadores[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.shade800,
                      foregroundColor: Colors.white,
                      child: Text(
                        lutador.nome.isNotEmpty
                            ? lutador.nome[0].toUpperCase()
                            : "?",
                      ),
                    ),
                    title: Text(
                      lutador.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.fitness_center,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              lutador.academia.isNotEmpty
                                  ? lutador.academia
                                  : "Sem academia",
                              style: const TextStyle(fontSize: 13),
                            ),
                            if (lutador.idade > 0) ...[
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.cake,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${lutador.idade} anos",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ],
                        ),
                        if (lutador.faixa != null &&
                            lutador.faixa!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.military_tech,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                lutador.faixa!,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _abrirModalCadastro(
                            pessoa: lutador,
                            index: index,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removerLutador(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () => _abrirModalCadastro(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
