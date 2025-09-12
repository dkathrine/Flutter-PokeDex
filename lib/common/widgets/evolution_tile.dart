import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/common/utils/name_utils.dart';

class EvolutionTile extends StatelessWidget {
  final EvolutionStage stage;
  const EvolutionTile({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Image.network(
              stage.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 48),
            ),
            const SizedBox(height: 8),
            Text(
              capitalizeWords(stage.name),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '#${stage.id.toString().padLeft(3, '0')}',
              style: const TextStyle(color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
