import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poke_battle/GameLogic/create_pokemon.dart';
import 'package:poke_battle/ui/pokemon_info_card.dart';
import 'GameLogic/battle.dart';
import 'Model/pokemon.dart';
import 'Model/move.dart';

void main() {
  runApp(PokemonBattleApp());
}

class PokemonBattleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BattleScreen(),
    );
  }
}

class BattleScreen extends StatefulWidget {
  @override
  _BattleScreenState createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late Pokemon pokemon1;
  late Pokemon pokemon2;
  late Battle battle;
  String battleLog = '';
  bool _battleStarted = false;
  List<double> scaledData = [
    0.094,
    0.10323232323232324,
    0.11246464646464648,
    0.12169696969696971,
    0.13092929292929295,
    0.14016161616161617,
    0.1493939393939394,
    0.15862626262626263,
    0.16785858585858587,
    0.1770909090909091,
    0.18632323232323233,
    0.19555555555555557,
    0.2047878787878788,
    0.21402020202020204,
    0.22325252525252527,
    0.2324848484848485,
    0.24171717171717174,
    0.25094949494949497,
    0.2601818181818182,
    0.26941414141414144,
    0.27864646464646467,
    0.2878787878787879,
    0.29711111111111114,
    0.30634343434343437,
    0.3155757575757576,
    0.32480808080808084,
    0.33404040404040407,
    0.3432727272727273,
    0.35250505050505054,
    0.36173737373737377,
    0.370969696969697,
    0.38020202020202024,
    0.38943434343434347,
    0.3986666666666667,
    0.40789898989898993,
    0.41713131313131316,
    0.4263636363636364,
    0.4355959595959596,
    0.44482828282828286,
    0.4540606060606061,
    0.46329292929292934,
    0.47252525252525257,
    0.4817575757575758,
    0.49098989898989905,
    0.5002222222222223,
    0.5094545454545455,
    0.5186868686868688,
    0.527919191919192,
    0.5371515151515153,
    0.5463838383838386,
    0.5556161616161618,
    0.564848484848485,
    0.5740808080808083,
    0.5833131313131315,
    0.5925454545454548,
    0.601777777777778,
    0.6110101010101013,
    0.6202424242424245,
    0.6294747474747477,
    0.638707070707071,
    0.6479393939393942,
    0.6571717171717175,
    0.6664040404040407,
    0.675636363636364,
    0.6848686868686872,
    0.6941010101010105,
    0.7033333333333337,
    0.712565656565657,
    0.7217979797979802,
    0.7310303030303035,
    0.7402626262626268,
    0.74949494949495,
    0.7587272727272733,
    0.7679595959595965,
    0.7771919191919198,
    0.786424242424243,
    0.7956565656565663,
    0.8048888888888895,
    0.8141212121212128,
    0.823353535353536,
    0.8325858585858593,
    0.8418181818181825,
    0.8510505050505058,
    0.8602828282828291,
    0.8695151515151523,
    0.8787474747474756,
    0.8879797979797988,
    0.8972121212121221,
    0.9064444444444454,
    0.9156767676767686,
    0.9249090909090919,
    0.9341414141414151,
    0.9433737373737384,
    0.9526060606060616,
    0.9618383838383849,
    0.9710707070707082,
    0.9803030303030314,
    0.9895353535353547,
    0.998767676767678,
    1.0
  ];
  @override
  void initState() {
    super.initState();
    _resetBattle();
  }

  void _selectMove(Move move, bool isPokemon1) {
    if (!_battleStarted) return;
    setState(() {
      battle.selectMove(move, isPokemon1);
      if (battle.move1 != null && battle.move2 != null) {
        battleLog = battle.battleTurn();
      }
    });
  }

  void _startBattle() {
    setState(() {
      _battleStarted = true;
      battleLog = '';
pokemon1.level;

        double scaleFactor = scaledData[pokemon1.level-1];

        // Scale the attributes of pokemon1
        pokemon1.maxHp = (pokemon1.maxHp * scaleFactor).round();
        pokemon1.hp = pokemon1.maxHp;
        pokemon1.attack = (pokemon1.attack * scaleFactor).round();
        pokemon1.defense = (pokemon1.defense * scaleFactor).round();
        pokemon1.specialAttack = (pokemon1.specialAttack * scaleFactor).round();
        pokemon1.specialDefense = (pokemon1.specialDefense * scaleFactor).round();
        pokemon1.speed = (pokemon1.speed * scaleFactor).round();


        // Scale the attributes of pokemon2
      scaleFactor=scaledData[pokemon2.level-1];
        pokemon2.maxHp = (pokemon2.maxHp * scaleFactor).round();
        pokemon2.hp = pokemon2.maxHp;
        pokemon2.attack = (pokemon2.attack * scaleFactor).round();
        pokemon2.defense = (pokemon2.defense * scaleFactor).round();
        pokemon2.specialAttack = (pokemon2.specialAttack * scaleFactor).round();
        pokemon2.specialDefense = (pokemon2.specialDefense * scaleFactor).round();
        pokemon2.speed = (pokemon2.speed * scaleFactor).round();



    });
  }
  int generateRandomIV() {
    final random = Random();
    return random.nextInt(32);
  }
  void _resetBattle() {
    setState(() {
      pokemon1 = CreatePokemon().createPokemon(
        name: 'Pikachu',
        baseHp: 145,
        // baseHp: 145,
        baseAttack: 30,
        baseDefense: 10,
        baseSpecialAttack: 40,
        baseSpecialDefense: 20,
        baseSpeed: 90,
        moves: [
          Move(
              name: 'Thunder Bolt',
              style: 'special',
              type: 'ELECTRIC',
              power: 90,
              alwaysGoFirst: false,
              effect: '',
              accuracy: 80,
              pp: 15),
          Move(
              name: 'Quick Attack',
              style: 'physical',
              type: 'NORMAL',
              power: 40,
              alwaysGoFirst: true,
              effect: '',
              accuracy: 100,
              pp: 30),
          Move(
              name: 'Tackle',
              style: 'physical',
              type: 'NORMAL',
              power: 40,
              alwaysGoFirst: false,
              effect: '',
              accuracy: 100,
              pp: 35),
          Move(
              name: 'Iron Tail',
              style: 'physical',
              type: 'STEEL',
              power: 100,
              alwaysGoFirst: false,
              effect: '',
              accuracy: 75,
              pp: 15),
        ],

        type: ['ELECTRIC'],
        accuracy: 6,
        evasion: 6,
        level: 90, ability: 'Lightning rod',

      );
      pokemon2 = CreatePokemon().createPokemon(
        name: 'Charmander',
        baseHp: 139,
        baseAttack: 25,
        baseDefense: 15,
        baseSpecialAttack: 35,
        baseSpecialDefense: 25,
        baseSpeed: 65,
        moves: [
          Move(
              name: 'Flamethrower',
              type: 'FIRE',
              style: 'special',
              power: 90,
              alwaysGoFirst: false,
              effect: '',
              accuracy: 100,
              pp: 15),
          Move(
              name: 'Slash',
              type: 'NORMAL',
              style: 'physical',
              power: 70,
              alwaysGoFirst: false,
              effect: '',
              accuracy: 100,
              pp: 20),
          Move(
              name: 'Scratch',
              type: 'NORMAL',
              style: 'physical',
              power: 40,
              alwaysGoFirst: false,
              effect: '',
              accuracy: 100,
              pp: 35),
          Move(
              name: 'Ember',
              type: 'FIRE',
              style: 'special',
              power: 40,
              alwaysGoFirst: false,
              effect: '',
              accuracy: 100,
              pp: 25),
        ],
        ability: 'Blaze',
        type: ['FIRE'],
        accuracy: 6,
        evasion: 6,
        level: 80,
        hpEV: 0,
        attackEV: 0,
        defenseEV: 0,
        specialAttackEV: 0, specialDefenseEV: 0, speedEV: 0,
      );
      battle = Battle(pokemon1: pokemon1, pokemon2: pokemon2);
      battleLog = '';
      _battleStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon Battle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Pokémon Battle!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: PokemonInfoCard(pokemon: pokemon1)),
                Expanded(child: PokemonInfoCard(pokemon: pokemon2)),
              ],
            ),
            SizedBox(height: 20),
            if (!_battleStarted) ...[
              ElevatedButton(
                onPressed: _startBattle,
                child: Text('Start Battle'),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('Choose ${pokemon1.name}\'s move:'),
                      for (var move in pokemon1.moves)
                        ElevatedButton(
                          onPressed: () => _selectMove(move, true),
                          child: Text(move.name),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Choose ${pokemon2.name}\'s move:'),
                      for (var move in pokemon2.moves)
                        ElevatedButton(
                          onPressed: () => _selectMove(move, false),
                          child: Text(move.name),
                        ),
                    ],
                  ),
                ],
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetBattle,
              child: Text('Reset Battle'),
            ),
            SizedBox(height: 20),
            Text(
              battleLog,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
