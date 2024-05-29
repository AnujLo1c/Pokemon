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

  Pokemon({
    required this.name,
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
    required this.nature
   }) ;
    // : hp = calculateHpStat(base: baseHp, iv: hpIV, ev: hpEV, level: level),
  //       attack = calculateOtherStat(base: baseAttack, iv: attackIV, ev: attackEV, level: level),
  //       defense = calculateOtherStat(base: baseDefense, iv: defenseIV, ev: defenseEV, level: level),
  //       specialAttack = calculateOtherStat(base: baseSpecialAttack, iv: specialAttackIV, ev: specialAttackEV, level: level),
  //       specialDefense = calculateOtherStat(base: baseSpecialDefense, iv: specialDefenseIV, ev: specialDefenseEV, level: level),
  //       speed = calculateOtherStat(base: baseSpeed, iv: speedIV, ev: speedEV, level: level),
  // maxHp=calculateHpStat(base: baseHp, iv: hpIV, ev: hpEV, level: level);

  // static int calculateHpStat({required int base, required int iv, required int ev, required int level}) {
  //
  //   return ((((iv + 2 * base + (ev / 4)) * level) / 100) + level + 10).floor();
  // }
  //

  // static int calculateOtherStat({required int base, required int iv, required int ev, required int level}) {
  //   return ((((iv + 2 * base + (ev / 4)) * level) / 100) + 5).floor();
  // }
//done
  void receiveDamage(int damage) {
    hp -= damage;
    if (hp < 0) {
      hp = 0;
    }
  }

  bool get isFainted => hp <= 0;
}
