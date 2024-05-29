import 'dart:math';
import 'package:poke_battle/Model/pokemon.dart';
import '../Model/move.dart';
import '../Model/nature.dart';

class CreatePokemon {
  Pokemon createPokemon({
    required String name,
    required int baseHp,
    required int baseAttack,
    required int baseDefense,
    required int baseSpecialAttack,
    required int baseSpecialDefense,
    required int baseSpeed,
    required List<Move> moves,
    required List<String> type,
    required String ability,
    required int accuracy,
    required int evasion,
    required int level,
    int hpEV = 0,
    int attackEV = 0,
    int defenseEV = 0,
    int specialAttackEV = 0,
    int specialDefenseEV = 0,
    int speedEV = 0,
  }) {
    // Generate IVs and Nature
    final hpIV = generateRandomIV();
    final attackIV = generateRandomIV();
    final defenseIV = generateRandomIV();
    final specialAttackIV = generateRandomIV();
    final specialDefenseIV = generateRandomIV();
    final speedIV = generateRandomIV();
    final nature = generateRandomNature();

    // Calculate stats
    int genhp = calculateHpStat(base: baseHp, iv: hpIV, ev: hpEV, level: level);
    int genattack = calculateOtherStat(base: baseAttack, iv: attackIV, ev: attackEV, level: level);
    int gendefense = calculateOtherStat(base: baseDefense, iv: defenseIV, ev: defenseEV, level: level);
    int genspecialAttack = calculateOtherStat(base: baseSpecialAttack, iv: specialAttackIV, ev: specialAttackEV, level: level);
    int genspecialDefense = calculateOtherStat(base: baseSpecialDefense, iv: specialDefenseIV, ev: specialDefenseEV, level: level);
    int genspeed = calculateOtherStat(base: baseSpeed, iv: speedIV, ev: speedEV, level: level);

    // Apply nature changes
    applyNature(nature, genhp, genattack, gendefense, genspecialAttack, genspecialDefense, genspeed);

    return Pokemon(
      name: name,
      hp: baseHp,
      maxHp: baseHp,
      attack: baseAttack,
      defense: baseDefense,
      specialAttack: baseSpecialAttack,
      specialDefense: baseSpecialDefense,
      speed: baseSpeed,
      moves: moves,
      type: type,
      ability: ability,
      accuracy: accuracy,
      evasion: evasion,
      level: level,
      hpIV: hpIV,
      attackIV: attackIV,
      defenseIV: defenseIV,
      specialAttackIV: specialAttackIV,
      specialDefenseIV: specialDefenseIV,
      speedIV: speedIV,
      hpEV: hpEV,
      attackEV: attackEV,
      defenseEV: defenseEV,
      specialAttackEV: specialAttackEV,
      specialDefenseEV: specialDefenseEV,
      speedEV: speedEV,
      nature: nature,
      // hp: hp,
      // attack: attack,
      // defense: defense,
      // specialAttack: specialAttack,
      // specialDefense: specialDefense,
      // speed: speed,
    );
  }

  int generateRandomIV() {
    final random = Random();
    return random.nextInt(32);
  }

  Nature generateRandomNature() {
    final random = Random();
    return natures[random.nextInt(natures.length)];
  }

  int calculateHpStat({required int base, required int iv, required int ev, required int level}) {
    return ((((iv + 2 * base + (ev / 4)) * level) / 100) + level + 10).floor();
  }

  int calculateOtherStat({required int base, required int iv, required int ev, required int level}) {
    return ((((iv + 2 * base + (ev / 4)) * level) / 100) + 5).floor();
  }

  void applyNature(Nature nature,int hp, int attack,  int defense, int specialAttack,  int specialDefense, int speed) {
  if (nature.increases.isNotEmpty) {
  switch (nature.increases) {
  case 'attack':
  attack = (attack * 1.1).round();
  break;
  case 'defense':
  defense = (defense * 1.1).round();
  break;
  case 'specialAttack':
  specialAttack = (specialAttack * 1.1).round();
  break;
  case 'specialDefense':
  specialDefense = (specialDefense * 1.1).round();
  break;
  case 'speed':
  speed = (speed * 1.1).round();
  break;
  }
  }

  if (nature.decreases.isNotEmpty) {
  switch (nature.decreases) {
  case 'attack':
  attack = (attack * 0.9).round();
  break;
  case 'defense':
  defense = (defense * 0.9).round();
  break;
  case 'specialAttack':
  specialAttack = (specialAttack * 0.9).round();
  break;
  case 'specialDefense':
  specialDefense = (specialDefense * 0.9).round();
  break;
  case 'speed':
  speed = (speed * 0.9).round();
  break;
  }
  }
  }
}

// List of natures
final List<Nature> natures = [
  Nature("Adamant", "attack", "specialAttack"),
  Nature("Bashful", "", ""),  // Neutral
  Nature("Bold", "defense", "attack"),
  Nature("Brave", "attack", "speed"),
  Nature("Calm", "specialDefense", "attack"),
  Nature("Careful", "specialDefense", "specialAttack"),
  Nature("Docile", "", ""),  // Neutral
  Nature("Gentle", "specialDefense", "defense"),
  Nature("Hardy", "", ""),  // Neutral
  Nature("Hasty", "speed", "defense"),
  Nature("Impish", "defense", "specialAttack"),
  Nature("Jolly", "speed", "specialAttack"),
  Nature("Lax", "defense", "specialDefense"),
  Nature("Lonely", "attack", "defense"),
  Nature("Mild", "specialAttack", "defense"),
  Nature("Modest", "specialAttack", "attack"),
  Nature("Naive", "speed", "specialDefense"),
  Nature("Naughty", "attack", "specialDefense"),
  Nature("Quiet", "specialAttack", "speed"),
  Nature("Quirky", "", ""),  // Neutral
  Nature("Rash", "specialAttack", "specialDefense"),
  Nature("Relaxed", "defense", "speed"),
  Nature("Sassy", "specialDefense", "speed"),
  Nature("Serious", "", ""),  // Neutral
  Nature("Timid", "speed", "attack"),
];