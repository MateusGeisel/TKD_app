class Player {
  final String name;
  int score;
  int fouls;

  Player({required this.name, this.score = 0, this.fouls = 0});

  void addPoint(int points) {
    score += points;
  }

  void addFoul() {
    fouls++;
  }

  void reset() {
    score = 0;
    fouls = 0;
  }
}
