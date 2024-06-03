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
  List<PokemonAbility> ability;
  Nature nature;
  int abilityIndex;

  // statStages
  int attackStage=7;
  int defenceStage=7;
  int specialAttackStage=7;
  int specialDefenceStage=7;
  int speedStage=7;
  late int oAttack;
  late int oDefense;
  late  int oSpecialAttack;
  late  int oSpecialDefense;
  late  int oSpeed;



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
      required this.nature}){
    oAttack=attack;
    oDefense=defense;
    oSpecialAttack=specialAttack;
    oSpecialDefense=specialDefense;
    oSpeed=speed;

    _initStatusEffects();
    _initSetStatusEffects();

  }


  //statusCondition
  PokemonStatus statusCondition = PokemonStatus.none;
  bool flinched = false;
  bool behindSubstitute = false;
  int confusionTurns = 0;
  int turnsPoisoned = 0;
  late final Map<PokemonStatus, Function> setStatusEffects;
  late final Map<PokemonStatus, Function> statusEffects;
  // String setStatusCondition(PokemonStatus status) {
  //   switch (status) {
  //     case PokemonStatus.burn:
  //       if (type[0] != PokemonType.fire &&
  //           (type.length == 2 ? type[1] != PokemonType.fire : true) &&
  //           !ability.contains(PokemonAbility.waterVeil) &&
  //           !behindSubstitute) {
  //         statusCondition = status;
  //         attack = (attack / 2).round();
  //         return "${name} is affected by burn.";
  //       }
  //       return "${name} is immune to Burn";
  //       break;
  //
  //     case PokemonStatus.paralyzed:
  //       if (type[0] != PokemonType.electric &&
  //           (type.length == 2 ? type[1] != PokemonType.electric : true) &&
  //           !ability.contains(PokemonAbility.limber) &&
  //           !behindSubstitute) {
  //         statusCondition = status;
  //         speed = (speed / 2).round();
  //         return "$name is affected by paralysis.";
  //       }
  //       return "$name is immune to Paralysis";
  //       break;
  //
  //     case PokemonStatus.poisoned:
  //       if (type[0] != PokemonType.poison &&
  //           type[0] != PokemonType.steel &&
  //           (type.length == 2
  //               ? (type[1] != PokemonType.poison && type[1] != PokemonType.steel)
  //               : true) &&
  //           !ability.contains(PokemonAbility.immunity) &&
  //           !behindSubstitute) {
  //         statusCondition = status;
  //         return "${name} is poisoned.";
  //       }
  //       return "${name} is immune to Poisoning";
  //       break;
  //
  //     case PokemonStatus.badlyPoisoned:
  //       if (type[0] != PokemonType.poison &&
  //           type[0] != PokemonType.steel &&
  //           (type.length == 2
  //               ? (type[1] != PokemonType.poison && type[1] != PokemonType.steel)
  //               : true) &&
  //           !ability.contains(PokemonAbility.immunity) &&
  //           !behindSubstitute) {
  //         statusCondition = status;
  //         turnsPoisoned = 0;
  //         return "${name} is badly poisoned.";
  //       }
  //       return "${name} is immune to Badly Poisoning";
  //       break;
  //
  //     case PokemonStatus.frozen:
  //       if (type[0] != PokemonType.ice &&
  //           (type.length == 2 ? type[1] != PokemonType.ice : true) &&
  //           !ability.contains(PokemonAbility.magmaArmor)) {
  //         statusCondition = status;
  //         return "${name} is frozen solid.";
  //       }
  //       return "${name} is immune to Freezing";
  //       break;
  //
  //     case PokemonStatus.flinch:
  //       if (!ability.contains(PokemonAbility.innerFocus)) {
  //         flinched = true;
  //         return "${name} flinched and couldn't move!";
  //       }
  //       return "${name} is immune to Flinching";
  //       break;
  //
  //     case PokemonStatus.confused:
  //       if (!ability.contains(PokemonAbility.ownTempo)) {
  //         statusCondition = status;
  //         confusionTurns =
  //             (1 + Random().nextInt(4)); // Random turns between 1 to 4
  //         return "${name} is confused!";
  //       }
  //       return "${name} is immune to Confusion";
  //
  //     // case 'Infatuation':
  //     //   if(!ability.contains('Oblivious') && opponentGender != null && gender != opponentGender) {
  //     //     statusCondition = status;
  //     //     return "${name} is infatuated with the opponent!";
  //     //   }
  //     //   return "${name} is immune to Infatuation";
  //
  //     case PokemonStatus.leechSeed:
  //       if (!(type.contains(PokemonType.grass))) {
  //         statusCondition = status;
  //         return "${name} is seeded!";
  //       }
  //       return "${name} is immune to Leech Seed";
  //
  //     default:
  //       return "No effect.";
  //   }
  // }

  void _initSetStatusEffects() {

    setStatusEffects = {
      PokemonStatus.burn: () {
        if (type[0] != PokemonType.fire &&
            (type.length == 2 ? type[1] != PokemonType.fire : true) &&
            !ability.contains(PokemonAbility.waterVeil) &&
            !behindSubstitute) {
          statusCondition = PokemonStatus.burn;
          attack = (attack / 2).round();
          return "$name is affected by burn.\n";
        }
        return "$name is immune to Burn\n";
      },
      PokemonStatus.paralyzed: () {
        if (type[0] != PokemonType.electric &&
            (type.length == 2 ? type[1] != PokemonType.electric : true) &&
            !ability.contains(PokemonAbility.limber) &&
            !behindSubstitute) {
          statusCondition = PokemonStatus.paralyzed;
          speed = (speed / 2).round();
          return "$name is affected by paralysis.\n";
        }
        return "$name is immune to Paralysis\n";
      },
      PokemonStatus.poisoned: () {
        if (type[0] != PokemonType.poison &&
            type[0] != PokemonType.steel &&
            (type.length == 2 ? (type[1] != PokemonType.poison && type[1] != PokemonType.steel) : true) &&
            !ability.contains(PokemonAbility.immunity) &&
            !behindSubstitute) {
          statusCondition = PokemonStatus.poisoned;
          return "$name is poisoned.\n";
        }
        return "$name is immune to Poisoning\n";
      },
      PokemonStatus.badlyPoisoned: () {
        if (type[0] != PokemonType.poison &&
            type[0] != PokemonType.steel &&
            (type.length == 2 ? (type[1] != PokemonType.poison && type[1] != PokemonType.steel) : true) &&
            !ability.contains(PokemonAbility.immunity) &&
            !behindSubstitute) {
          statusCondition = PokemonStatus.badlyPoisoned;
          turnsPoisoned = 0;
          return "$name is badly poisoned.\n";
        }
        return "$name is immune to Badly Poisoning\n";
      },
      PokemonStatus.frozen: () {
        if (type[0] != PokemonType.ice &&
            (type.length == 2 ? type[1] != PokemonType.ice : true) &&
            !ability.contains(PokemonAbility.magmaArmor)) {
          statusCondition = PokemonStatus.frozen;
          return "$name is frozen solid.\n";
        }
        return "$name is immune to Freezing\n";
      },
      PokemonStatus.flinch: () {
        if (!ability.contains(PokemonAbility.innerFocus)) {
          flinched = true;
          return "$name flinched and couldn't move!\n";
        }
        return "$name is immune to Flinching\n";
      },
      PokemonStatus.confused: () {
        if (!ability.contains(PokemonAbility.ownTempo)) {
          statusCondition = PokemonStatus.confused;
          confusionTurns = 1 + Random().nextInt(4); // Random turns between 1 to 4
          return "$name is confused!\n";
        }
        return "$name is immune to Confusion\n";
      },
      PokemonStatus.leechSeed: () {
        if (!type.contains(PokemonType.grass)) {
          statusCondition = PokemonStatus.leechSeed;
          return "$name is seeded!\n";
        }
        return "$name is immune to Leech Seed\n";
      },
    };
  }
  void _initStatusEffects() {
    statusEffects = {
      PokemonStatus.none: () {
        return "";
      },
      PokemonStatus.burn: () {
        if(hp<0) {
        int burnDamage = (0.125 * maxHp).round();
          hp -= burnDamage;
        return "${name} delt Burn status damage $burnDamage\n";
        }
      },
      PokemonStatus.paralyzed: () {
        bool willMove = Random().nextInt(100) > 75;
        return willMove ? '' : '$name is paralyzed, cannot move.\n';
      },
      PokemonStatus.leechSeed: () {
        if(hp<0) {
        int leechSeedDamage = (0.0625 * maxHp).round();
          hp -= leechSeedDamage;
        return "$name is hurt by Leech Seed! Damage $leechSeedDamage\n";
        }
        // Assuming opponent gains HP
        // opponent.hp += leechSeedDamage;
        // "$opponent.name gained $leechSeedDamage HP";
      },
      PokemonStatus.poisoned: () {
        if(hp<0) {
        int poisonDamage = (0.0625 * maxHp).round();
          hp -= poisonDamage;
        return "Poison status damage $poisonDamage\n";
        }
      },
      PokemonStatus.badlyPoisoned: () {
        turnsPoisoned++;
        if(hp<0) {
          int badlyPoisonDamage = (turnsPoisoned * 0.0625 * maxHp).round();
          hp -= badlyPoisonDamage;
          return "Badly Poison status damage $badlyPoisonDamage\n";
        }
        },
      PokemonStatus.frozen: () {
        bool thawed = Random().nextInt(100) < 20;
        if (thawed) {
          statusCondition = PokemonStatus.none;
          return "$name thawed out!\n";
        } else {
          return "$name is frozen solid and cannot move.\n";
        }
      },
      PokemonStatus.confused: () {
        confusionTurns--;
        if (confusionTurns > 0) {
          bool willHurtSelf = Random().nextInt(100) < 50;
          if (willHurtSelf) {
            if(hp<0) {
              int confusionDamage = (0.25 * maxHp).round();
              hp -= confusionDamage;
              return "$name is confused and hurt itself in its confusion! Damage $confusionDamage\n";
            }
          } else {
            return "$name is confused but managed to attack.\n";
          }
        } else {
          statusCondition = PokemonStatus.none;
          return "$name snapped out of its confusion!\n";
        }
      }
    };
  }

  String statusBattleEachTurnEffect(){
    // var str=statusEffects[statusCondition]!();
    print("status affect${statusEffects[statusCondition]!()}$statusCondition");
    return statusEffects[statusCondition]!();
  }
  setPokemonStatus(PokemonStatus s){
    if(s==statusCondition){
      return 'Pokemon is already ${statusCondition}\n';
    }
    String str=setStatusEffects[s]!();
    statusCondition=s;
    print("status changed${statusCondition}\n");
    return str;
  }


List<double> stages=[-3,-2.5,-2,-1.5,-1,-0.5,0,0.5,1,1.5,2,2.5,3];
  statStageChange(String state,int level){
    switch(state){
      case 'a':
        attackStage+=level.clamp(-6, 6);
        attack=level>0?(oAttack*stages[attackStage]).round():(oAttack/stages[attackStage]).round();

        break;
        case 'd':
          defenceStage+=level.clamp(-6, 6);
          defense=level>0?(oDefense*stages[defenceStage]).round():(oDefense/stages[defenceStage]).round();
        break;
        case 'sa':
          specialAttackStage+=level.clamp(-6, 6);
          specialAttack=level>0?(stages[specialAttackStage]*oSpecialAttack).round():(stages[specialAttackStage]/oSpecialAttack).round();
        break;
        case 'sd':
          specialDefenceStage+=level.clamp(-6, 6);
          specialDefense=level>0?(stages[specialDefenceStage]*oSpecialDefense).round():(stages[specialDefenceStage]/oSpecialDefense).round();
        break;
        case 's':
          speedStage+=level.clamp(-6, 6);
          speed=level>0?(stages[speedStage]*oSpeed).round():(stages[speedStage]/oSpeed).round();
        break;
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
enum PokemonType{
  normal,fire,water,electric,grass,ice,fighting,poison,ground,flying,psychic,bug,rock,ghost,dragon,dark,steel,fairy
}
enum PokemonStatus{
  none,burn,poisoned,badlyPoisoned,paralyzed,frozen,confused,leechSeed,flinch
}
enum PokemonAbility{
  adaptability, aerilate, aftermath, airLock, analytic, angerPoint, angerShell, anticipation, arenaTrap, armorTail, aromaVeil, asOne,
  auraBreak, badDreams, ballFetch, battery, battleArmor, battleBond, beadsOfRuin, beastBoost, berserk, bigPecks, blaze, bulletproof,
  cheekPouch, chillingNeigh, chlorophyll, clearBody, cloudNine, colorChange, comatose, commander, competitive, compoundEyes, contrary,
  corrosion, costar, cottonDown, cudChew, curiousMedicine, cursedBody, cuteCharm, damp, dancer, darkAura, dauntlessShield, dazzling,
  defeatist, defiant, deltaStream, desolateLand, disguise, download, dragonsMaw, drizzle, drought, drySkin, earlyBird, earthEater,
  effectSpore, electricSurge, electromorphosis, embodyAspect, emergencyExit, fairyAura, filter, flameBody, flareBoost, flashFire,
  flowerGift, flowerVeil, fluffy, forecast, forewarn, friendGuard, frisk, fullMetalBody, furCoat, galeWings, galvanize, gluttony,
  goodAsGold, gooey, gorillaTactics, grassPelt, grassySurge, grimNeigh, guardDog, gulpMissile, guts, hadronEngine, harvest, healer,
  heatproof, heavyMetal, honeyGather, hospitality, hugePower, hungerSwitch, hustle, hydration, hyperCutter, iceBody, iceFace,
  iceScales, illuminate, illusion, immunity, imposter, infiltrator, innardsOut, innerFocus, insomnia, intimidate, intrepidSword,
  ironBarbs, ironFist, justified, keenEye, klutz, leafGuard, levitate, libero, lightMetal, lightningRod, limber, lingeringAroma,
  liquidOoze, liquidVoice, longReach, magicBounce, magicGuard, magician, magmaArmor, magnetPull, marvelScale, megaLauncher, merciless,
  mimicry, mindsEye, minus, mirrorArmor, mistySurge, moldBreaker, moody, motorDrive, moxie, multiscale, multitype, mummy,
  myceliumMight, naturalCure, neuroforce, neutralizingGas, noGuard, normalize, oblivious, opportunist, orichalcumPulse,
  overcoat, overgrow, ownTempo, parentalBond, pastelVeil, perishBody, pickpocket, pickup, pixilate, plus, poisonHeal,
  poisonPoint, poisonPuppeteer, poisonTouch, powerConstruct, powerOfAlchemy, powerSpot, prankster, pressure, primordialSea,
  prismArmor, propellerTail, protean, protosynthesis, psychicSurge, punkRock, purePower, purifyingSalt, quarkDrive,
  queenlyMajesty, quickDraw, quickFeet, rainDish, rattled, receiver, reckless, refrigerate, regenerator, ripen, rivalry, rksSystem,
  rockHead, rockyPayload, roughSkin, runAway, sandForce, sandRush, sandSpit, sandStream, sandVeil, sapSipper, schooling, scrappy,
  screenCleaner, seedSower, sereneGrace, shadowShield, shadowTag, sharpness, shedSkin, sheerForce, shellArmor, shieldDust,
  shieldsDown, simple, skillLink, slowStart, slushRush, sniper, snowCloak, snowWarning, solarPower, solidRock, soulHeart,
  soundproof, speedBoost, stakeout, stall, stalwart, stamina, stanceChange, static, steadfast, steamEngine, steelworker,
  steelySpirit, stench, stickyHold, stormDrain, strongJaw, sturdy, suctionCups, superLuck, supersweetSyrup, supremeOverlord,
  surgeSurfer, swarm, sweetVeil, swiftSwim, swordOfRuin, symbiosis, synchronize, tabletsOfRuin, tangledFeet, tanglingHair,
  technician, telepathy, teraShell, teraShift, teraformZero, teravolt, thermalExchange, thickFat, tintedLens, torrent,
  toughClaws, toxicBoost, toxicChain, toxicDebris, trace, transistor, triage, truant, turboblaze, unaware, unburden, unnerve,
  unseenFist, vesselOfRuin, victoryStar, vitalSpirit, voltAbsorb, wanderingSpirit, waterAbsorb, waterBubble, waterCompaction,
  waterVeil, weakArmor, wellBakedBody, whiteSmoke, wimpOut, windPower, windRider, wonderGuard, wonderSkin, zenMode, zeroToHero
}