import 'package:flutter/material.dart';
import '../Model/pokemon.dart';

class PokemonInfoCard extends StatelessWidget {
  final Pokemon pokemon;

  PokemonInfoCard({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pokemon.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('HP: ${pokemon.hp}'),
            Text('Attack: ${pokemon.attack}'),
            Text('Defense: ${pokemon.defense}'),
            Text('Special Attack: ${pokemon.specialAttack}'),
            Text('Special Defense: ${pokemon.specialDefense}'),
            Text('Speed: ${pokemon.speed}'),
            Text('Ability: ${pokemon.ability}'),
            Text('Type: ${pokemon.type.join(", ")}'),
            Text('Level: ${pokemon.level}'),

            SizedBox(height: 8),
            Text('Moves:'),
            for (var move in pokemon.moves)
              Text('${move.name} (${move.type}) - ${move.power} Power, ${move.pp} PP'),
          ],
        ),
      ),
    );
  }
}
