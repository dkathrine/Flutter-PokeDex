import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';

class BaseStatsTab extends StatelessWidget {
  final PokemonDetail pokemon;
  const BaseStatsTab({super.key, required this.pokemon});

  static const int _statMax = 255;

  Widget _statRow(String label, int value) {
    final normalized = (value / _statMax).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(label)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: normalized,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(height: 6),
                Text(
                  '$value',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              const SizedBox(width: 90, child: Text('Total')),
              Text(
                pokemon.baseStats.values.reduce((a, b) => a + b).toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ...pokemon.baseStats.entries.map((e) => _statRow(e.key, e.value)),
        const SizedBox(height: 24),
      ],
    );
  }
}
