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
    required List<PokemonType> type,
    required List<PokemonAbility> ability,
    required int accuracy,
    required int evasion,
    required int level,
  }) {
    // Generate IVs and Nature
    final hpIV = generateRandomIV();
    final attackIV = generateRandomIV();
    final defenseIV = generateRandomIV();
    final specialAttackIV = generateRandomIV();
    final specialDefenseIV = generateRandomIV();
    final speedIV = generateRandomIV();
    final nature = generateRandomNature();
    // final nature = natures[0];
    // disp(nature, baseHp, baseAttack, baseDefense, baseSpecialAttack, baseSpecialDefense, baseSpeed);
    List afterNatureStates=applyNature(nature, baseHp, baseAttack, baseDefense, baseSpecialAttack, baseSpecialDefense, baseSpeed);
    baseHp=afterNatureStates[0];
    baseAttack=afterNatureStates[1];
    baseDefense=afterNatureStates[2];
    baseSpecialAttack=afterNatureStates[3];
    baseSpecialDefense=afterNatureStates[4];
    baseSpeed=afterNatureStates[5];
    // disp(nature, baseHp, baseAttack, baseDefense, baseSpecialAttack, baseSpecialDefense, baseSpeed);

    // Calculate stats
    int genhp = calculateHpStat(base: baseHp, iv: hpIV, ev: 0, level: level);
    int genattack = calculateOtherStat(base: baseAttack, iv: attackIV, ev: 0, level: level);
    int gendefense = calculateOtherStat(base: baseDefense, iv: defenseIV, ev: 0, level: level);
    int genspecialAttack = calculateOtherStat(base: baseSpecialAttack, iv: specialAttackIV, ev: 0, level: level);
    int genspecialDefense = calculateOtherStat(base: baseSpecialDefense, iv: specialDefenseIV, ev: 0, level: level);
    int genspeed = calculateOtherStat(base: baseSpeed, iv: speedIV, ev: 0, level: level);

    // Apply nature changes

    return Pokemon(
      name: name,
      hp: genhp,
      maxHp: genhp,
      attack: genattack,
      defense: gendefense,
      specialAttack: genspecialAttack,
      specialDefense: genspecialDefense,
      speed: genspeed,
      moves: moves,
      type: type,
      ability: ability,
      accuracy: accuracy,
      evasion: evasion,
      level: level,
      abilityIndex: 0,
      hpIV: hpIV,
      attackIV: attackIV,
      defenseIV: defenseIV,
      specialAttackIV: specialAttackIV,
      specialDefenseIV: specialDefenseIV,
      speedIV: speedIV,
      hpEV: 0,
      attackEV: 0,
      defenseEV: 0,
      specialAttackEV: 0,
      specialDefenseEV: 0,
      speedEV: 0,
      nature: nature,

    );
  }
  void disp(Nature nature, int genHp, int genAttack, int genDefense, int genSpecialAttack, int genSpecialDefense, int genSpeed) {
    print('Nature: ${nature.name}');
    print('HP: $genHp');
    print('Attack: $genAttack');
    print('Defense: $genDefense');
    print('Special Attack: $genSpecialAttack');
    print('Special Defense: $genSpecialDefense');
    print('Speed: $genSpeed');
    print("////////////////////////////");
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

  List<int> applyNature(Nature nature,int hp, int attack,  int defense, int specialAttack,  int specialDefense, int speed) {
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
  List<int> natureAppliedStates=[hp,attack,defense,specialAttack,specialDefense,speed];
  return natureAppliedStates;
    }
}

// List of natures
final List<Nature> natures = [
  Nature(NatureName.adament, "attack", "specialAttack"),
  Nature(NatureName.bashful, "", ""),  // Neutral
  Nature(NatureName.bold, "defense", "attack"),
  Nature(NatureName.brave, "attack", "speed"),
  Nature(NatureName.calm, "specialDefense", "attack"),
  Nature(NatureName.careful, "specialDefense", "specialAttack"),
  Nature(NatureName.docile, "", ""),  // Neutral
  Nature(NatureName.gentle, "specialDefense", "defense"),
  Nature(NatureName.hardy, "", ""),  // Neutral
  Nature(NatureName.hasty, "speed", "defense"),
  Nature(NatureName.impish, "defense", "specialAttack"),
  Nature(NatureName.jolly, "speed", "specialAttack"),
  Nature(NatureName.lax, "defense", "specialDefense"),
  Nature(NatureName.lonely, "attack", "defense"),
  Nature(NatureName.mild, "specialAttack", "defense"),
  Nature(NatureName.modest, "specialAttack", "attack"),
  Nature(NatureName.naive, "speed", "specialDefense"),
  Nature(NatureName.naughty, "attack", "specialDefense"),
  Nature(NatureName.quiet, "specialAttack", "speed"),
  Nature(NatureName.quirky, "", ""),  // Neutral
  Nature(NatureName.rash, "specialAttack", "specialDefense"),
  Nature(NatureName.relaxed, "defense", "speed"),
  Nature(NatureName.sassy, "specialDefense", "speed"),
  Nature(NatureName.serious, "", ""),  // Neutral
  Nature(NatureName.timid, "speed", "attack"),
];