import 'dart:math';

import '../Model/pokemon.dart';
import '../Model/move.dart';
const typeEffectiveness = {
  'NORMAL': {'ROCK': 0.5, 'GHOST': 0, 'STEEL': 0.5},
  'FIRE': {'FIRE': 0.5, 'WATER': 0.5, 'GRASS': 2, 'ICE': 2, 'BUG': 2, 'ROCK': 0.5, 'DRAGON': 0.5, 'STEEL': 2},
  'WATER': {'FIRE': 2, 'WATER': 0.5, 'GRASS': 0.5, 'GROUND': 2, 'ROCK': 2, 'DRAGON': 0.5},
  'ELECTRIC': {'WATER': 2, 'ELECTRIC': 0.5, 'GRASS': 0.5, 'GROUND': 0, 'FLYING': 2, 'DRAGON': 0.5},
  'GRASS': {'FIRE': 0.5, 'WATER': 2, 'GRASS': 0.5, 'POISON': 0.5, 'GROUND': 2, 'FLYING': 0.5, 'BUG': 0.5, 'ROCK': 2, 'DRAGON': 0.5, 'STEEL': 0.5},
  'ICE': {'FIRE': 0.5, 'WATER': 0.5, 'GRASS': 2, 'ICE': 0.5, 'GROUND': 2, 'FLYING': 2, 'DRAGON': 2, 'STEEL': 0.5},
  'FIGHTING': {'NORMAL': 2, 'ICE': 2, 'POISON': 0.5, 'FLYING': 0.5, 'PSYCHIC': 0.5, 'BUG': 0.5, 'ROCK': 2, 'GHOST': 0, 'DARK': 2, 'STEEL': 2, 'FAIRY': 0.5},
  'POISON': {'GRASS': 2, 'POISON': 0.5, 'GROUND': 0.5, 'ROCK': 0.5, 'GHOST': 0.5, 'STEEL': 0, 'FAIRY': 2},
  'GROUND': {'FIRE': 2, 'ELECTRIC': 2, 'GRASS': 0.5, 'POISON': 2, 'FLYING': 0, 'BUG': 0.5, 'ROCK': 2, 'STEEL': 2},
  'FLYING': {'ELECTRIC': 0.5, 'GRASS': 2, 'FIGHTING': 2, 'BUG': 2, 'ROCK': 0.5, 'STEEL': 0.5},
  'PSYCHIC': {'FIGHTING': 2, 'POISON': 2, 'PSYCHIC': 0.5, 'DARK': 0, 'STEEL': 0.5},
  'BUG': {'FIRE': 0.5, 'GRASS': 2, 'FIGHTING': 0.5, 'POISON': 0.5, 'FLYING': 0.5, 'PSYCHIC': 2, 'GHOST': 0.5, 'DARK': 2, 'STEEL': 0.5, 'FAIRY': 0.5},
  'ROCK': {'FIRE': 2, 'ICE': 2, 'FIGHTING': 0.5, 'GROUND': 0.5, 'FLYING': 2, 'BUG': 2, 'STEEL': 0.5},
  'GHOST': {'NORMAL': 0, 'PSYCHIC': 2, 'GHOST': 2, 'DARK': 0.5},
  'DRAGON': {'DRAGON': 2, 'STEEL': 0.5, 'FAIRY': 0},
  'DARK': {'FIGHTING': 0.5, 'PSYCHIC': 2, 'GHOST': 2, 'DARK': 0.5, 'FAIRY': 0.5},
  'STEEL': {'FIRE': 0.5, 'WATER': 0.5, 'ELECTRIC': 0.5, 'ICE': 2, 'ROCK': 2, 'STEEL': 0.5, 'FAIRY': 2},
  'FAIRY': {'FIRE': 0.5, 'FIGHTING': 2, 'POISON': 0.5, 'DRAGON': 2, 'DARK': 2, 'STEEL': 0.5},
};

class Battle {
  Pokemon pokemon1;
  Pokemon pokemon2;
  Move? move1;
  Move? move2;
//String Environment
  Battle({required this.pokemon1, required this.pokemon2});

  void selectMove(Move move, bool isPokemon1) {
    if (isPokemon1) {
      move1 = move;
    } else {
      move2 = move;
    }
  }

  double getTypeEffectiveness(String attackType, List<String> defenderTypes) {
    double effectiveness = 1.0;
    for (var defenderType in defenderTypes) {
      if (typeEffectiveness[attackType] != null &&
          typeEffectiveness[attackType]![defenderType] != null) {
        effectiveness *= typeEffectiveness[attackType]![defenderType]!;
      }
    }
    return effectiveness;
  }

  double getStageModifier(int stage) {
    if (stage < -6) stage = -6;
    if (stage > 6) stage = 6;

    List<double> stageModifiers = [
      0.33, 0.375, 0.43, 0.5, 0.6, 0.75, 1.0, 1.33, 1.67, 2.0, 2.33, 2.67, 3.0
    ];
    return stageModifiers[stage];
  }

  bool willHit(Pokemon attacker, Pokemon defender, Move move) {
    Random random = Random();
    int randomValue = random.nextInt(100) + 1;
    int effectiveStage=((attacker.accuracy + defender.evasion)/2).round();
    double accuracyMultiplier = getStageModifier(effectiveStage);
    double finalAccuracy = move.accuracy * accuracyMultiplier;
    double hitChance = (finalAccuracy).clamp(0, 100);
// print(accuracyMultiplier);
//     print(hitChance);
//     print(randomValue);
    return randomValue <= hitChance;
  }

//   double getAbilityEffectiveness(Pokemon attacker, Move move) {
// print(attacker);
// print(move);
//     if (attacker.Ability == 'Blaze' && attacker.hp <= attacker.hp * 0.33) {
//       if (move.type == 'FIRE') return 1.5;
//     }
//     if (attacker.Ability == 'Lightning Rod' && move.type == 'ELECTRIC') {
//       // Assuming ability effect for Lightning Rod is applied in some other logic
//       return 0.0;
//     }
//     // Add other abilities logic here
//     return 1.0;
//   }

  String executeMove(Pokemon attacker, Pokemon defender, Move move) {
    if (move.pp <= 0) {
      return '${move.name} has no PP left!\n';
    }
    move.pp -= 1;
    if (willHit(attacker,defender,move)) {
    double typeEffectiveness = getTypeEffectiveness(move.type, defender.type);
    double abilityEffectiveness = 1.0;
    // getAbilityEffectiveness(attacker, move);
// print(abilityEffectiveness);
    int damage;
    if (move.style == "special") {
      damage = ((0.5 * move.power *
          (attacker.specialAttack / defender.specialDefense) *
          typeEffectiveness * abilityEffectiveness)).round();
    } else {
      damage = ((0.5 * move.power * (attacker.attack / defender.defense) *
          typeEffectiveness * abilityEffectiveness)).round();
    }

    defender.receiveDamage(damage);
    return '${attacker.name} uses ${move.name} on ${defender
        .name} for $damage damage! (Type Effectiveness: ${typeEffectiveness}x)\n';
  }
    else{
      return "${attacker.name}'s ${move.name} doesn't hit!\n";
    }

  }

  String battleTurn() {
    if (move1 == null || move2 == null) {
      return 'Both Pokémon must select a move before the battle can proceed.';
    }

    // Determine attack order based on move priority and speed
    if (move1!.alwaysGoFirst != move2!.alwaysGoFirst) {
      if (move1!.alwaysGoFirst) {
        return _processMoveOrder(pokemon1, pokemon2, move1!, move2!);
      } else {
        return _processMoveOrder(pokemon2, pokemon1, move2!, move1!);
      }
    } else if (pokemon1.speed != pokemon2.speed) {
      if (pokemon1.speed > pokemon2.speed) {
        return _processMoveOrder(pokemon1, pokemon2, move1!, move2!);
      } else {
        return _processMoveOrder(pokemon2, pokemon1, move2!, move1!);
      }
    } else {
      return _processMoveOrder(pokemon1, pokemon2, move1!, move2!);
    }
  }

  String _processMoveOrder(Pokemon first, Pokemon second, Move firstMove, Move secondMove) {
    String result = '';

    result += executeMove(first, second, firstMove);
    if (!second.isFainted) {
      result += executeMove(second, first, secondMove);
    }

    if (pokemon1.isFainted) {
      result += '${pokemon1.name} fainted!\n';
    }
    if (pokemon2.isFainted) {
      result += '${pokemon2.name} fainted!\n';
    }

    move1 = null;
    move2 = null;

    return result;
  }
}
