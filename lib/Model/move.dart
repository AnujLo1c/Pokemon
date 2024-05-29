class Move {
  String name;
  String style;
  String type;
  int power;
  bool alwaysGoFirst;
  String effect;
  int accuracy;
  int pp;

  Move({
    required this.name,
    required this.style,
    required this.type,
    required this.power,
    required this.alwaysGoFirst,
    required this.effect,
    required this.accuracy,
    required this.pp,
  });
}
