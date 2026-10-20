import 'package:aplicacao_aula/model/scoreboard.dart';

class ScoreController {
  // 🔹 Singleton
  ScoreController._privateConstructor();
  static final ScoreController _instance = ScoreController._privateConstructor();
  factory ScoreController() => _instance;

  Player bluePlayer = Player(name: "Azul");
  Player redPlayer = Player(name: "Vermelho");

  void addPointToBlue(int points) {
    bluePlayer.addPoint(points);
  }

  void addPointToRed(int points) {
    redPlayer.addPoint(points);
  }

  void addFoulToBlue() {
    bluePlayer.addFoul();
  }

  void addFoulToRed() {
    redPlayer.addFoul();
  }

  void resetMatch() {
    bluePlayer.reset();
    redPlayer.reset();
  }
}
