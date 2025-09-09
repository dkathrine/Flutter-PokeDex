// lib/screens/detail_screen/evolution_tab.dart
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/common/widgets/evolution_tile.dart';

class EvolutionTab extends StatelessWidget {
  final Pokemon pokemon;
  const EvolutionTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final chain = pokemon.evolutionChain;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        const Text(
          'Evolution Chain',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(chain.length * 2 - 1, (i) {
              if (i.isEven) {
                final stage = chain[i ~/ 2];
                return EvolutionTile(stage: stage);
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black45,
                  ),
                );
              }
            }),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
