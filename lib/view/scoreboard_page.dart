import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:aplicacao_aula/controller/scoreboard_controller.dart';

class ScoreboardView extends StatefulWidget {
  const ScoreboardView({super.key});

  @override
  State<ScoreboardView> createState() => _ScoreboardViewState();
}

class _ScoreboardViewState extends State<ScoreboardView> {
  final ScoreController controller = ScoreController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // 🔹 Timer & Duração
  int _matchDuration = 120; // Padrão: 2 minutos (120s)
  int _remainingSeconds = 120;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  /// 🔹 Alterna entre Iniciar e Pausar o Cronômetro
  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      if (_remainingSeconds == 0) return;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_remainingSeconds > 0) {
          setState(() => _remainingSeconds--);
        } else {
          _timer?.cancel();
          setState(() {
            _isRunning = false;
            _remainingSeconds = _matchDuration; // Reset automático para nova rodada
          });
          _playEndSound();
        }
      });
      setState(() => _isRunning = true);
    }
  }

  /// 🔹 Altera a Duração do Round (1 min ou 2 min)
  void _setMatchDuration(int seconds) {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _matchDuration = seconds;
      _remainingSeconds = seconds;
    });
  }

  /// 🔹 Reproduz o som de fim de round
  Future<void> _playEndSound() async {
    try {
      await _audioPlayer.play(AssetSource("sounds/beep.mp3"));
    } catch (_) {
      // Caso o áudio falhe em dispositivos sem o asset carregado
    }
  }

  /// 🔹 Formata tempo em MM:SS
  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fundo escuro esportivo
      appBar: AppBar(
        title: const Text("Scoreboard Taekwondo"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 SELETOR DE TEMPO DE ROUND (1 min / 2 min)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Duração do Round: ",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text("1 min"),
                    selected: _matchDuration == 60,
                    selectedColor: Colors.amber,
                    onSelected: (selected) {
                      if (selected) _setMatchDuration(60);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text("2 min"),
                    selected: _matchDuration == 120,
                    selectedColor: Colors.amber,
                    onSelected: (selected) {
                      if (selected) _setMatchDuration(120);
                    },
                  ),
                ],
              ),
            ),

            // 🔹 CRONÔMETRO CENTRAL
            GestureDetector(
              onTap: _toggleTimer,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isRunning ? Colors.green.shade900 : Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isRunning ? Colors.green : Colors.amber,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _formatTime(_remainingSeconds),
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: _remainingSeconds <= 10 && _remainingSeconds > 0
                            ? Colors.red
                            : Colors.white,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isRunning ? Icons.pause_circle : Icons.play_circle,
                          color: _isRunning ? Colors.greenAccent : Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isRunning ? "TOQUE PARA PAUSAR" : "TOQUE PARA INICIAR",
                          style: TextStyle(
                            color: _isRunning ? Colors.greenAccent : Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 ÁREA DOS ATLETAS (AZUL vs VERMELHO)
            Expanded(
              child: Row(
                children: [
                  _buildPlayerCard(
                    "Azul",
                    const Color(0xFF1E3A8A), // Azul escuro
                    const Color(0xFF2563EB), // Azul vívido
                    controller.bluePlayer.score,
                    controller.bluePlayer.fouls,
                    true,
                  ),
                  const VerticalDivider(color: Colors.white24, width: 2),
                  _buildPlayerCard(
                    "Vermelho",
                    const Color(0xFF881337), // Vermelho escuro
                    const Color(0xFFDC2626), // Vermelho vívido
                    controller.redPlayer.score,
                    controller.redPlayer.fouls,
                    false,
                  ),
                ],
              ),
            ),

            // 🔹 BOTÃO RESETAR LUTA
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.white24),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      controller.resetMatch();
                      _remainingSeconds = _matchDuration;
                      _timer?.cancel();
                      _isRunning = false;
                    });
                  },
                  icon: const Icon(Icons.restart_alt),
                  label: const Text(
                    "RESETAR LUTA",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Card de cada Lutador
  Widget _buildPlayerCard(
    String name,
    Color bgCor,
    Color btnCor,
    int score,
    int fouls,
    bool isBlue,
  ) {
    return Expanded(
      child: Container(
        color: bgCor.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            // Nome
            Text(
              name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isBlue ? Colors.blue.shade300 : Colors.red.shade300,
              ),
            ),
            
            // Placar Digital de Pontos
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: btnCor, width: 2),
              ),
              child: Text(
                "$score",
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Faltas (Gam-jeom)
            Text(
              "Faltas: $fouls",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),

            const SizedBox(height: 8),

            // Grid de Botões de Ação (+1 a +5 e Falta)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 1.6,
                children: [
                  _buildActionButton("+1", () {
                    setState(() {
                      isBlue
                          ? controller.addPointToBlue(1)
                          : controller.addPointToRed(1);
                    });
                  }, btnCor),
                  _buildActionButton("+2", () {
                    setState(() {
                      isBlue
                          ? controller.addPointToBlue(2)
                          : controller.addPointToRed(2);
                    });
                  }, btnCor),
                  _buildActionButton("+3", () {
                    setState(() {
                      isBlue
                          ? controller.addPointToBlue(3)
                          : controller.addPointToRed(3);
                    });
                  }, btnCor),
                  _buildActionButton("+4", () {
                    setState(() {
                      isBlue
                          ? controller.addPointToBlue(4)
                          : controller.addPointToRed(4);
                    });
                  }, btnCor),
                  _buildActionButton("+5", () {
                    setState(() {
                      isBlue
                          ? controller.addPointToBlue(5)
                          : controller.addPointToRed(5);
                    });
                  }, btnCor),
                  _buildActionButton("Falta", () {
                    setState(() {
                      if (isBlue) {
                        controller.addFoulToBlue();
                        controller.addPointToRed(1);
                      } else {
                        controller.addFoulToRed();
                        controller.addPointToBlue(1);
                      }
                    });
                  }, Colors.amber.shade800),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Botões Estilizados
  Widget _buildActionButton(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.zero,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}