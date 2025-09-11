import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/common/widgets/type_chip.dart';

class PokemonCard extends StatelessWidget {
  final PokemonSummary pokemon;
  final VoidCallback? onTap;

  const PokemonCard({super.key, required this.pokemon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final base = const Color.fromARGB(255, 163, 64, 255);
    final darker = const Color.fromARGB(255, 87, 14, 155);

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth;
          final imageSize = cardWidth * 0.4;

          return Container(
            width: MediaQuery.of(context).size.width,
            //height: 150,
            //margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [base.withAlpha(95), darker.withAlpha(95)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: base.withAlpha(18),
                  blurRadius: 8,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                //height: 120,
                child: Stack(
                  children: [
                    // Right side: image
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 86,
                        alignment: Alignment.center,
                        child: Image.network(
                          pokemon.imageUrl,
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return SizedBox(
                              width: imageSize,
                              height: imageSize,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stack) => const Icon(
                            Icons.broken_image,
                            size: 56,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),

                    // Left side: info
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  pokemon.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '#${pokemon.id.toString().padLeft(3, '0')}',
                                style: const TextStyle(
                                  color: Colors.black26,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var t in pokemon.types)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 6.0,
                                    bottom: 6,
                                  ),
                                  child: TypeChip(type: t),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
