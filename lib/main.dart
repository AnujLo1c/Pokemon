// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:poke_battle/GameLogic/create_pokemon.dart';
import 'package:poke_battle/screens/battle_screen.dart';
import 'package:poke_battle/ui/pokemon_info_card.dart';
import 'GameLogic/battle.dart';
import 'Model/pokemon.dart';
import 'Model/move.dart';

void main() {
  runApp(const PokemonBattleApp());
}

class PokemonBattleApp extends StatelessWidget {
  const PokemonBattleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: const BattleScreen().pageName, page: () => const BattleScreen(),)
      ],
      initialRoute: const BattleScreen().pageName,
      debugShowCheckedModeBanner: false,
    );
  }
}
