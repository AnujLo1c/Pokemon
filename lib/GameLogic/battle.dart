import 'dart:math';

import 'package:poke_battle/screens/battle_screen.dart';

import '../Model/pokemon.dart';
import '../Model/move.dart';
import '../Model/weather.dart';
import '../main.dart';
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
WeatherState weatherobj;
  Battle({required this.pokemon1, required this.pokemon2, required this.weatherobj});

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
  void updateWeather(Weather newWeather) {
    // print(newWeather);
    weatherobj.updateWeather(newWeather);
// print(WeatherState().w);
  }
  String executeMove(Pokemon attacker, Pokemon defender, Move move, weatherIndex) {
    if (move.pp <= 0) {
      return '${move.name} has no PP left!\n';
    }
    move.pp -= 1;

    //////////////weather effect
      String weatherEffect='';
      int? pow, acc, defSD;
    if(weatherIndex) {
      switch (weatherobj.getWeather()) {
        case Weather.none:
          break;
        case Weather.intenseSun:
          if (move.type == 'FIRE') {
            pow = move.power;
            move.power = (move.power * 2).round();
          } else if (move.type == 'WATER') {
            pow = move.power;
            move.power = (move.power * 0.5).round();
            // } else if (move.name == 'Solar Beam' || move.name == 'Solar Blade') {
            // move.chargingRequired = false;
          } else if (move.name == 'Thunder' || move.name == 'Hurricane') {
            acc = move.accuracy;
            move.accuracy = (move.accuracy * 0.5).round();
          }
          // if (move.name == 'Synthesis' || move.name == 'Morning Sun' || move.name == 'Moonlight') {
          // move.healingPower = (move.healingPower * 2).round(); // Strengthened healing moves
          // }
          weatherEffect = "The sun is shining intensely!\n";

        case Weather.rain:
          if (move.type == 'WATER') {
            pow = move.power;
            move.power = (move.power * 2).round();
          } else if (move.type == 'FIRE') {
            pow = move.power;
            move.power = (move.power * 0.5).round();
          } else if (move.name == 'Thunder' || move.name == 'Hurricane') {
            acc = move.accuracy;
            move.accuracy = 100;
          }

          // if (move.name == 'Synthesis' || move.name == 'Morning Sun' || move.name == 'Moonlight') {
          // move.healingPower = (move.healingPower * 0.5).round(); // Weakened healing moves
          // }
          weatherEffect = "It's raining heavily!\n";

        case Weather.hail:
          if (!attacker.type.contains('ICE')) {
            int hailDamage = ((0.0625) * attacker.maxHp)
                .round(); // Hail damage is 1/16 of max HP
            attacker.hp -= hailDamage;
            weatherEffect =
            "${attacker.name} is buffeted by the hail! Damage $hailDamage\n";
          }
          if (!defender.type.contains('ICE')) {
            int hailDamage = ((0.0625) * defender.maxHp)
                .round(); // Hail damage is 1/16 of max HP
            defender.hp -= hailDamage;
            weatherEffect =
            "${defender.name} is buffeted by the hail! Damage $hailDamage\n";
          }
          if (move.name == 'Blizzard') {
            acc = move.accuracy;
            move.accuracy = 100; // Blizzard guaranteed hit in hail
          }

          // if (move.name == 'Synthesis' || move.name == 'Morning Sun' || move.name == 'Moonlight') {
          //   move.healingPower = (move.healingPower * 0.5).round(); // Weakened healing moves
          // }
          weatherEffect = "Hail is pelting down!\n";

        case Weather.sandstorm:
          if (!attacker.type.contains('ROCK') &&
              !attacker.type.contains('GROUND') &&
              !attacker.type.contains('STEEL')) {
            int sandstormDamage = ((0.0625) * attacker.maxHp)
                .round(); // Sandstorm damage is 1/16 of max HP
            attacker.hp -= sandstormDamage;
            weatherEffect = "${attacker
                .name} is buffeted by the sandstorm! Damage $sandstormDamage\n";
          }
          if (!defender.type.contains('ROCK') &&
              !defender.type.contains('GROUND') &&
              !defender.type.contains('STEEL')) {
            int sandstormDamage = ((0.0625) * defender.maxHp)
                .round(); // Sandstorm damage is 1/16 of max HP
            defender.hp -= sandstormDamage;
            weatherEffect = "${defender
                .name} is buffeted by the sandstorm! Damage $sandstormDamage\n";
            if (defender.type.contains('ROCK')) {
              defSD = defender.specialDefense;
              defender.specialDefense = (defender.specialDefense * 1.5)
                  .round(); // Rock-types get 50% extra special defense
            }
          }

          // if (move.name == 'Synthesis' || move.name == 'Morning Sun' || move.name == 'Moonlight') {
          //   move.healingPower = (move.healingPower * 0.5).round(); // Weakened healing moves
          // }

          weatherEffect = "A sandstorm is raging!\n";

        default:
          weatherEffect = '';
      }
    }
    //////////////weather effect

    if (willHit(attacker,defender,move)) {
    double typeEffectiveness = getTypeEffectiveness(move.type, defender.type);
    double abilityEffectiveness = 1.0;
    // getAbilityEffectiveness(attacker, move);
// print(abilityEffectiveness);
      /////////////////weather call
      // if(weather!=)
      updateWeather(Weather.rain);
      print("data");
      /////////////////weather call

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
    (pow!=null)?move.power=pow:null;
    (acc!=null)?move.accuracy=acc:null;
    (defSD!=null)?defender.specialDefense=defSD:null;

    return '${attacker.name} uses ${move.name} on ${defender
        .name} for $damage damage! (Type Effectiveness: ${typeEffectiveness}x)\n$weatherEffect';
  }
    else{
      return "${attacker.name}'s ${move.name} doesn't hit!\n$weatherEffect";
    }

  }

  String battleTurn() {
    if (move1 == null || move2 == null) {
      return 'Both Pokémon must select a move before the battle can proceed.';
    }

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

    result += executeMove(first, second, firstMove,false);
    if (!second.isFainted) {
      result += executeMove(second, first, secondMove,true);
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
