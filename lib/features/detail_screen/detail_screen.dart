import 'package:flutter/material.dart';
import 'package:pokedex/data/pokemon_repository.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/features/detail_screen/about_tab.dart';
import 'package:pokedex/features/detail_screen/base_stats_tab.dart';
import 'package:pokedex/features/detail_screen/evolution_tab.dart';
import 'package:pokedex/common/widgets/type_chip.dart';
import 'package:pokedex/common/utils/type_assets.dart';

class DetailScreen extends StatefulWidget {
  final PokemonSummary pokemon;
  const DetailScreen({super.key, required this.pokemon});

  static const double _topHeight = 340;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final PokemonRepository _repo = PokemonRepository();
  late Future<PokemonDetail> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = _repo.getPokemonDetail(widget.pokemon.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final statusBar = media.padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F9),
      body: FutureBuilder(
        future: _futureDetail,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (asyncSnapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load Pokémon: ${asyncSnapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!asyncSnapshot.hasData) {
            return const Center(child: Text('No Pokémon found'));
          }

          final pokemon = asyncSnapshot.data!;

          final gradientColor = TypeAssets.gradientForType(pokemon.types.first);

          return SizedBox.expand(
            child: Stack(
              children: [
                // Top header
                Container(
                  height: DetailScreen._topHeight + 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColor,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),

                // Back
                Positioned(
                  top: statusBar + 12,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white24,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),

                // Name, Types, and ID
                Positioned(
                  top: statusBar + 72,
                  left: 24,
                  right: 24,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.pokemon.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: widget.pokemon.types
                                  .map(
                                    (t) => Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: TypeChip(type: t),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '#${widget.pokemon.id.toString().padLeft(3, '0')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tabs & Bottom card
                Positioned(
                  top: DetailScreen._topHeight,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          const TabBar(
                            labelColor: Colors.black87,
                            unselectedLabelColor: Colors.black45,
                            indicatorColor: Colors.black87,
                            indicatorWeight: 3,
                            tabs: [
                              Tab(text: 'About'),
                              Tab(text: 'Base Stats'),
                              Tab(text: 'Evolution'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: TabBarView(
                              children: [
                                SingleChildScrollView(
                                  child: AboutTab(pokemon: pokemon),
                                ),
                                SingleChildScrollView(
                                  child: BaseStatsTab(pokemon: pokemon),
                                ),
                                SingleChildScrollView(
                                  child: EvolutionTab(pokemon: pokemon),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Pokemon artwork
                Positioned(
                  top: DetailScreen._topHeight - 140,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.network(
                      widget.pokemon.imageUrl,
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
