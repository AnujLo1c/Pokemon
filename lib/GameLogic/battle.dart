import 'dart:math';


import '../Model/pokemon.dart';
import '../Model/move.dart';
import '../Model/weather.dart';
const typeEffectiveness = {
  MoveType.normal: {PokemonType.rock: 0.5, PokemonType.ghost: 0, PokemonType.steel: 0.5},
  MoveType.fire: {PokemonType.fire: 0.5, PokemonType.water: 0.5, PokemonType.grass: 2, PokemonType.ice: 2, PokemonType.bug: 2, PokemonType.rock: 0.5, PokemonType.dragon: 0.5, PokemonType.steel: 2},
  MoveType.water: {PokemonType.fire: 2, PokemonType.water: 0.5, PokemonType.grass: 0.5, PokemonType.ground: 2, PokemonType.rock: 2, PokemonType.dragon: 0.5},
  MoveType.electric: {PokemonType.water: 2, PokemonType.electric: 0.5, PokemonType.grass: 0.5, PokemonType.ground: 0, PokemonType.flying: 2, PokemonType.dragon: 0.5},
  MoveType.grass: {PokemonType.fire: 0.5, PokemonType.water: 2, PokemonType.grass: 0.5, PokemonType.poison: 0.5, PokemonType.ground: 2, PokemonType.flying: 0.5, PokemonType.bug: 0.5, PokemonType.rock: 2, PokemonType.dragon: 0.5, PokemonType.steel: 0.5},
  MoveType.ice: {PokemonType.fire: 0.5, PokemonType.water: 0.5, PokemonType.grass: 2, PokemonType.ice: 0.5, PokemonType.ground: 2, PokemonType.flying: 2, PokemonType.dragon: 2, PokemonType.steel: 0.5},
  MoveType.fighting: {PokemonType.normal: 2, PokemonType.ice: 2, PokemonType.poison: 0.5, PokemonType.flying: 0.5, PokemonType.psychic: 0.5, PokemonType.bug: 0.5, PokemonType.rock: 2, PokemonType.ghost: 0, PokemonType.dark: 2, PokemonType.steel: 2, PokemonType.fairy: 0.5},
  MoveType.poison: {PokemonType.grass: 2, PokemonType.poison: 0.5, PokemonType.ground: 0.5, PokemonType.rock: 0.5, PokemonType.ghost: 0.5, PokemonType.steel: 0, PokemonType.fairy: 2},
  MoveType.ground: {PokemonType.fire: 2, PokemonType.electric: 2, PokemonType.grass: 0.5, PokemonType.poison: 2, PokemonType.flying: 0, PokemonType.bug: 0.5, PokemonType.rock: 2, PokemonType.steel: 2},
  MoveType.flying: {PokemonType.electric: 0.5, PokemonType.grass: 2, PokemonType.fighting: 2, PokemonType.bug: 2, PokemonType.rock: 0.5, PokemonType.steel: 0.5},
  MoveType.psychic: {PokemonType.fighting: 2, PokemonType.poison: 2, PokemonType.psychic: 0.5, PokemonType.dark: 0, PokemonType.steel: 0.5},
  MoveType.bug: {PokemonType.fire: 0.5, PokemonType.grass: 2, PokemonType.fighting: 0.5, PokemonType.poison: 0.5, PokemonType.flying: 0.5, PokemonType.psychic: 2, PokemonType.ghost: 0.5, PokemonType.dark: 2, PokemonType.steel: 0.5, PokemonType.fairy: 0.5},
  MoveType.rock: {PokemonType.fire: 2, PokemonType.ice: 2, PokemonType.fighting: 0.5, PokemonType.ground: 0.5, PokemonType.flying: 2, PokemonType.bug: 2, PokemonType.steel: 0.5},
  MoveType.ghost: {PokemonType.normal: 0, PokemonType.psychic: 2, PokemonType.ghost: 2, PokemonType.dark: 0.5},
  MoveType.dragon: {PokemonType.dragon: 2, PokemonType.steel: 0.5, PokemonType.fairy: 0},
  MoveType.dark: {PokemonType.fighting: 0.5, PokemonType.psychic: 2, PokemonType.ghost: 2, PokemonType.dark: 0.5, PokemonType.fairy: 0.5},
  MoveType.steel: {PokemonType.fire: 0.5, PokemonType.water: 0.5, PokemonType.electric: 0.5, PokemonType.ice: 2, PokemonType.rock: 2, PokemonType.steel: 0.5, PokemonType.fairy: 2},
  MoveType.fairy: {PokemonType.fire: 0.5, PokemonType.fighting: 2, PokemonType.poison: 0.5, PokemonType.dragon: 2, PokemonType.dark: 2, PokemonType.steel: 0.5},
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

  double getTypeEffectiveness(MoveType attackType, List<PokemonType> defenderTypes) {
    double effectiveness = 1.0;
    // String attackTypeStr = attackType.toString().split('.').last;
    for (var defenderType in defenderTypes) {
      if (typeEffectiveness[attackType] != null &&
          typeEffectiveness[attackType]![defenderType] != null) {
        effectiveness *= typeEffectiveness[attackType]![defenderType]!;
      }
    }
    print("typeEffectiveness working $effectiveness");
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
          if (move.type == MoveType.fire) {
            pow = move.power;
            move.power = (move.power * 2).round();
          } else if (move.type == MoveType.water) {
            pow = move.power;
            move.power = (move.power * 0.5).round();
            // } else if (move.name == 'Solar Beam' || move.name == 'Solar Blade') {
            // move.chargingRequired = false;
          } else if (move.name == MoveName.thunder || move.name == MoveName.hurricane) {
            acc = move.accuracy;
            move.accuracy = (move.accuracy * 0.5).round();
          }
          // if (move.name == 'Synthesis' || move.name == 'Morning Sun' || move.name == 'Moonlight') {
          // move.healingPower = (move.healingPower * 2).round(); // Strengthened healing moves
          // }
          weatherEffect = "The sun is shining intensely!\n";

        case Weather.rain:
          if (move.type == MoveType.water) {
            pow = move.power;
            move.power = (move.power * 2).round();
          } else if (move.type ==MoveType.fire) {
            pow = move.power;
            move.power = (move.power * 0.5).round();
          } else if (move.name == MoveName.thunder || move.name == MoveName.hurricane) {
            acc = move.accuracy;
            move.accuracy = 100;
          }

          // if (move.name == 'Synthesis' || move.name == 'Morning Sun' || move.name == 'Moonlight') {
          // move.healingPower = (move.healingPower * 0.5).round(); // Weakened healing moves
          // }
          weatherEffect = "It's raining heavily!\n";

        case Weather.hail:
          if (!attacker.type.contains(PokemonType.ice)) {
            int hailDamage = ((0.0625) * attacker.maxHp)
                .round(); // Hail damage is 1/16 of max HP
            attacker.hp -= hailDamage;
            weatherEffect =
            "${attacker.name} is buffeted by the hail! Damage $hailDamage\n";
          }
          if (!defender.type.contains(PokemonType.ice)) {
            int hailDamage = ((0.0625) * defender.maxHp)
                .round(); // Hail damage is 1/16 of max HP
            defender.hp -= hailDamage;
            weatherEffect =
            "${defender.name} is buffeted by the hail! Damage $hailDamage\n";
          }
          if (move.name == MoveName.blizzard) {
            acc = move.accuracy;
            move.accuracy = 100; // Blizzard guaranteed hit in hail
          }

          // if (move.name == 'Synthesis' || move.name == 'Morning Sun' || move.name == 'Moonlight') {
          //   move.healingPower = (move.healingPower * 0.5).round(); // Weakened healing moves
          // }
          weatherEffect = "Hail is pelting down!\n";

        case Weather.sandstorm:
          if (!attacker.type.contains(PokemonType.rock) &&
              !attacker.type.contains(PokemonType.ground) &&
              !attacker.type.contains(PokemonType.steel)) {
            int sandstormDamage = ((0.0625) * attacker.maxHp)
                .round(); // Sandstorm damage is 1/16 of max HP
            attacker.hp -= sandstormDamage;
            weatherEffect = "${attacker
                .name} is buffeted by the sandstorm! Damage $sandstormDamage\n";
          }
          if (!defender.type.contains(PokemonType.rock) &&
              !defender.type.contains(PokemonType.ground) &&
              !defender.type.contains(PokemonType.steel)) {
            int sandstormDamage = ((0.0625) * defender.maxHp)
                .round(); // Sandstorm damage is 1/16 of max HP
            defender.hp -= sandstormDamage;
            weatherEffect = "${defender
                .name} is buffeted by the sandstorm! Damage $sandstormDamage\n";
            if (defender.type.contains(PokemonType.rock)) {
              defSD = defender.specialDefense;
              defender.specialDefense = (defender.specialDefense * 1.5)
                  .round(); // Rock-types get 50% extra special defense
            }
          }

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

      // updateWeather(Weather.rain);
      /////////////////weather call

    int damage;
    if (move.style == MoveStyle.special) {
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
