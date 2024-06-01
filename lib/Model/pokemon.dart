// ignore_for_file: dead_code, unnecessary_brace_in_string_interps

import 'dart:math';

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
  List<String> type;
  int accuracy;
  int evasion;
  int level;
  String ability;
  Nature nature;

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
  String statusCondition = "None";
  bool flinched = false;
  bool behindSubstitute = false;
  int confusionTurns = 0;
  int turnsPoisoned = 0;

  String setStatusCondition(String status) {
    switch (status) {
      case 'Burn':
        if (type[0] != 'Fire' &&
            (type.length == 2 ? type[1] != 'Fire' : true) &&
            !ability.contains('Water Veil') &&
            !behindSubstitute) {
          statusCondition = status;
          attack = (attack / 2).round();
          return "${name} is affected by burn.";
        }
        return "${name} is immune to Burn";
        break;

      case 'Paralyzed':
        if (type[0] != 'Electric' &&
            (type.length == 2 ? type[1] != 'Electric' : true) &&
            !ability.contains('Limber') &&
            !behindSubstitute) {
          statusCondition = status;
          speed = (speed / 2).round();
          return "$name is affected by paralysis.";
        }
        return "$name is immune to Paralysis";
        break;

      case 'Poisoned':
        if (type[0] != 'Poison' &&
            type[0] != 'Steel' &&
            (type.length == 2
                ? (type[1] != 'Poison' && type[1] != 'Steel')
                : true) &&
            !ability.contains('Immunity') &&
            !behindSubstitute) {
          statusCondition = status;
          return "${name} is poisoned.";
        }
        return "${name} is immune to Poisoning";
        break;

      case 'Badly Poisoned':
        if (type[0] != 'Poison' &&
            type[0] != 'Steel' &&
            (type.length == 2
                ? (type[1] != 'Poison' && type[1] != 'Steel')
                : true) &&
            !ability.contains('Immunity') &&
            !behindSubstitute) {
          statusCondition = status;
          turnsPoisoned = 0;
          return "${name} is badly poisoned.";
        }
        return "${name} is immune to Badly Poisoning";
        break;

      case 'Frozen':
        if (type[0] != 'Ice' &&
            (type.length == 2 ? type[1] != 'Ice' : true) &&
            !ability.contains('Magma Armor')) {
          statusCondition = status;
          return "${name} is frozen solid.";
        }
        return "${name} is immune to Freezing";
        break;

      case 'Flinch':
        if (!ability.contains('Inner Focus')) {
          flinched = true;
          return "${name} flinched and couldn't move!";
        }
        return "${name} is immune to Flinching";
        break;

      case 'Confused':
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

      case 'Leech Seed':
        if (!(type.contains('Grass'))) {
          statusCondition = status;
          return "${name} is seeded!";
        }
        return "${name} is immune to Leech Seed";

      default:
        return "No effect.";
    }
  }

  String statusBattleEachTurnEffect() {
    switch (statusCondition) {
      case "None":
        return "";

      case "Burn":
        int burnDamage = ((0.125) * maxHp).round();
        hp -= burnDamage;
        return "Burn status damage $burnDamage";

      case 'Paralyzed':
        bool willMove = Random().nextInt(100) > 75 ? true : false;
        if (willMove) {
          return '';
        } else {
          return '$name is paralyzed, cannot move.';
        }

      case 'Poisoned':
        int poisonDamage =
            ((0.0625) * maxHp).round();
        hp -= poisonDamage;
        return "Poison status damage $poisonDamage";

      case 'Badly Poisoned':
        turnsPoisoned++;

        int badlyPoisonDamage = ((turnsPoisoned * 0.0625) * maxHp).round();
        hp -= badlyPoisonDamage;
        return "Badly Poison status damage $badlyPoisonDamage";

      case 'Frozen':
        bool thawed = Random().nextInt(100) < 20;
        if (thawed) {
          statusCondition = "None";
          return "$name thawed out!";
        } else {
          return "$name is frozen solid and cannot move.";
        }

      case 'Confused':
        confusionTurns--;
        if (confusionTurns > 0) {
          bool willHurtSelf =
              Random().nextInt(100) < 50;
          if (willHurtSelf) {
            int confusionDamage =
                ((0.25) * maxHp).round();
            hp -= confusionDamage;
            return "$name is confused and hurt itself in its confusion! Damage $confusionDamage";
          } else {
            return "$name is confused but managed to attack.";
          }
        } else {
          statusCondition = "None";
          return "$name snapped out of its confusion!";
        }

      case 'Infatuation':
        bool infatuated =
            Random().nextInt(100) < 50; // 50% chance to be immobilized by love
        if (infatuated) {
          return "$name is immobilized by love!";
        } else {
          return "$name shook off its infatuation and attacked.";
        }

      case 'Leech Seed':
        int leechSeedDamage =
            ((0.0625) * maxHp).round(); // Leech Seed damage is 1/16 of max HP
        hp -= leechSeedDamage;
        // Assuming opponent gains HP
        // opponent.hp += leechSeedDamage;
        return "$name is hurt by Leech Seed! Damage $leechSeedDamage,"
            // " $opponent.name gained $leechSeedDamage HP"
            ;

      default:
        return "";
    }
  }

  void receiveDamage(int damage) {
    hp -= damage;
    if (hp < 0) {
      hp = 0;
    }
  }

  bool get isFainted => hp <= 0;
}
