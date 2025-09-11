import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';

class AboutTab extends StatelessWidget {
  final PokemonDetail pokemon;
  const AboutTab({super.key, required this.pokemon});

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: const TextStyle(color: Colors.black54)),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final femaleRatio = 1.0 - pokemon.genderRatioMale!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('About'),
        _row('Species', pokemon.species),
        _row('Height', pokemon.height),
        _row('Weight', pokemon.weight),
        _row('Abilities', pokemon.abilities.join(', ')),
        const SizedBox(height: 16),

        _sectionTitle('Breeding'),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: Text('Gender', style: TextStyle(color: Colors.black54)),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: (pokemon.genderRatioMale! * 1000).round(),
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(90),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: (femaleRatio * 1000).round(),
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.pink.withAlpha(85),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(pokemon.genderRatioMale! * 100).toStringAsFixed(1)}% ♂',
                    ),
                    const SizedBox(width: 8),
                    Text('${(femaleRatio * 100).toStringAsFixed(1)}% ♀'),
                  ],
                ),
              ),
            ],
          ),
        ),
        _row('Egg Groups', pokemon.eggGroups.join(', ')),
        //_row('Egg Cycle', pokemon.eggCycle),
        const SizedBox(height: 24),
      ],
    );
  }
}
