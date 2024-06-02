// ignore_for_file: dead_code, unnecessary_brace_in_string_interps

import 'dart:math';

import 'package:flutter/gestures.dart';

import 'move.dart';
import 'nature.dart';

class Pokemon {
  String name;
  int hp;
  int maxHp;
  int attack;
  int defense;
  int specialAttack;
  int specialDefense;
  int speed;
  List<Move> moves;
  List<PokemonType> type;
  int accuracy;
  int evasion;
  int level;
  String ability;
  Nature nature;
  int abilityIndex;

  // IVs
  int hpIV;
  int attackIV;
  int defenseIV;
  int specialAttackIV;
  int specialDefenseIV;
  int speedIV;

  // EVs
  int hpEV;
  int attackEV;
  int defenseEV;
  int specialAttackEV;
  int specialDefenseEV;
  int speedEV;

  Pokemon(
      {required this.name,
      required this.hp,
      required this.maxHp,
      required this.attack,
      required this.defense,
      required this.specialAttack,
      required this.specialDefense,
      required this.speed,
      required this.moves,
      required this.ability,
      required this.type,
      required this.accuracy,
      required this.evasion,
      required this.level,
        required this.abilityIndex,
      required this.hpIV,
      required this.attackIV,
      required this.defenseIV,
      required this.specialAttackIV,
      required this.specialDefenseIV,
      required this.speedIV,
      required this.hpEV,
      required this.attackEV,
      required this.defenseEV,
      required this.specialAttackEV,
      required this.specialDefenseEV,
      required this.speedEV,
      required this.nature});

  //statusCondition
  PokemonStatus statusCondition = PokemonStatus.none;
  bool flinched = false;
  bool behindSubstitute = false;
  int confusionTurns = 0;
  int turnsPoisoned = 0;

  String setStatusCondition(PokemonStatus status) {
    switch (status) {
      case PokemonStatus.burn:
        if (type[0] != PokemonType.fire &&
            (type.length == 2 ? type[1] != PokemonType.fire : true) &&
            !ability.contains('Water Veil') &&
            !behindSubstitute) {
          statusCondition = status;
          attack = (attack / 2).round();
          return "${name} is affected by burn.";
        }
        return "${name} is immune to Burn";
        break;

      case PokemonStatus.paralyzed:
        if (type[0] != PokemonType.electric &&
            (type.length == 2 ? type[1] != PokemonType.electric : true) &&
            !ability.contains('Limber') &&
            !behindSubstitute) {
          statusCondition = status;
          speed = (speed / 2).round();
          return "$name is affected by paralysis.";
        }
        return "$name is immune to Paralysis";
        break;

      case PokemonStatus.poisoned:
        if (type[0] != PokemonType.poison &&
            type[0] != PokemonType.steel &&
            (type.length == 2
                ? (type[1] != PokemonType.poison && type[1] != PokemonType.steel)
                : true) &&
            !ability.contains('Immunity') &&
            !behindSubstitute) {
          statusCondition = status;
          return "${name} is poisoned.";
        }
        return "${name} is immune to Poisoning";
        break;

      case PokemonStatus.badlyPoisoned:
        if (type[0] != PokemonType.poison &&
            type[0] != PokemonType.steel &&
            (type.length == 2
                ? (type[1] != PokemonType.poison && type[1] != PokemonType.steel)
                : true) &&
            !ability.contains('Immunity') &&
            !behindSubstitute) {
          statusCondition = status;
          turnsPoisoned = 0;
          return "${name} is badly poisoned.";
        }
        return "${name} is immune to Badly Poisoning";
        break;

      case PokemonStatus.frozen:
        if (type[0] != PokemonType.ice &&
            (type.length == 2 ? type[1] != PokemonType.ice : true) &&
            !ability.contains('Magma Armor')) {
          statusCondition = status;
          return "${name} is frozen solid.";
        }
        return "${name} is immune to Freezing";
        break;

      case PokemonStatus.flinch:
        if (!ability.contains('Inner Focus')) {
          flinched = true;
          return "${name} flinched and couldn't move!";
        }
        return "${name} is immune to Flinching";
        break;

      case PokemonStatus.confused:
        if (!ability.contains('Own Tempo')) {
          statusCondition = status;
          confusionTurns =
              (1 + Random().nextInt(4)); // Random turns between 1 to 4
          return "${name} is confused!";
        }
        return "${name} is immune to Confusion";

      // case 'Infatuation':
      //   if(!ability.contains('Oblivious') && opponentGender != null && gender != opponentGender) {
      //     statusCondition = status;
      //     return "${name} is infatuated with the opponent!";
      //   }
      //   return "${name} is immune to Infatuation";

      case PokemonStatus.leechSeed:
        if (!(type.contains(PokemonType.grass))) {
          statusCondition = status;
          return "${name} is seeded!";
        }
        return "${name} is immune to Leech Seed";

      default:
        return "No effect.";
    }
  }

  String statusBattleEachTurnEffect() {
    Map<PokemonStatus, Function> statusEffects = {
      PokemonStatus.none: () {
        return "";
      },
      PokemonStatus.burn: () {
        int burnDamage = (0.125 * maxHp).round();
        hp -= burnDamage;
        return "Burn status damage $burnDamage";
      },
      PokemonStatus.paralyzed: () {
        bool willMove = Random().nextInt(100) > 75;
        return willMove ? '' : '$name is paralyzed, cannot move.';
      },
      PokemonStatus.leechSeed: () {
        int leechSeedDamage = (0.0625 * maxHp).round();
        hp -= leechSeedDamage;
        // Assuming opponent gains HP
        // opponent.hp += leechSeedDamage;
        return "$name is hurt by Leech Seed! Damage $leechSeedDamage";
        // "$opponent.name gained $leechSeedDamage HP";
      },
      PokemonStatus.poisoned: () {
        int poisonDamage = (0.0625 * maxHp).round();
        hp -= poisonDamage;
        return "Poison status damage $poisonDamage";
      },
      PokemonStatus.badlyPoisoned: () {
        turnsPoisoned++;
        int badlyPoisonDamage = (turnsPoisoned * 0.0625 * maxHp).round();
        hp -= badlyPoisonDamage;
        return "Badly Poison status damage $badlyPoisonDamage";
      },
      PokemonStatus.frozen: () {
        bool thawed = Random().nextInt(100) < 20;
        if (thawed) {
          statusCondition = PokemonStatus.none;
          return "$name thawed out!";
        } else {
          return "$name is frozen solid and cannot move.";
        }
      },
      PokemonStatus.confused: () {
        confusionTurns--;
        if (confusionTurns > 0) {
          bool willHurtSelf = Random().nextInt(100) < 50;
          if (willHurtSelf) {
            int confusionDamage = (0.25 * maxHp).round();
            hp -= confusionDamage;
            return "$name is confused and hurt itself in its confusion! Damage $confusionDamage";
          } else {
            return "$name is confused but managed to attack.";
          }
        } else {
          statusCondition = PokemonStatus.none;
          return "$name snapped out of its confusion!";
        }
      }
    };
    return statusEffects[statusCondition]!();
  }

  void receiveDamage(int damage) {
    hp -= damage;
    if (hp < 0) {
      hp = 0;
    }
  }

  bool get isFainted => hp <= 0;
}
enum PokemonType{
  normal,fire,water,electric,grass,ice,fighting,poison,ground,flying,psychic,bug,rock,ghost,dragon,dark,steel,fairy
}
enum PokemonStatus{
  none,burn,poisoned,badlyPoisoned,paralyzed,frozen,confused,leechSeed,flinch
}