import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/data/pokemon_repository.dart';
import 'package:pokedex/common/widgets/pokemon_card.dart';
import 'package:pokedex/common/widgets/type_filter_button.dart';
import 'package:pokedex/features/detail_screen/detail_screen.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final PokemonRepository _repo = PokemonRepository();
  late Future<List<PokemonSummary>> _futurePokemon;
  List<PokemonSummary> _items = [];
  late List<PokemonSummary> filtered = [];
  final TextEditingController _txtctrl = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  String? _selectedType;
  bool _loadingMore = false;
  int _offset = 20;
  final int _limit = 20;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _futurePokemon = _repo.fetchPage();
    _txtctrl.addListener(_onSearchOrFilterChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _txtctrl.removeListener(_onSearchOrFilterChanged);
    _txtctrl.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;

    setState(() => _loadingMore = true);

    try {
      final page = await _repo.fetchPage(offset: _offset, limit: _limit);

      if (page.isEmpty) {
        setState(() => _hasMore = false);
      } else {
        setState(() {
          _offset += _limit;
          _items.addAll(page);
          filtered = List.from(_items);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load more Pokémon: $e")),
      );
    } finally {
      setState(() => _loadingMore = false);
    }
  }

  void _onScroll() {
    final isFiltering = _txtctrl.text.isNotEmpty || _selectedType != null;
    if (isFiltering) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      _loadMore();
    }
  }

  void _onSearchOrFilterChanged() {
    final q = _txtctrl.text.trim().toLowerCase();
    setState(() {
      filtered = _items.where((p) {
        final matchesName = q.isEmpty || p.name.toLowerCase().contains(q);
        final matchesType =
            _selectedType == null ||
            p.types.any((t) => t.toLowerCase() == _selectedType!.toLowerCase());
        return matchesName && matchesType;
      }).toList();
    });
  }

  void _onTypeSelected(String? type) {
    setState(() {
      _selectedType = type;
    });
    _onSearchOrFilterChanged();
    _searchFocusNode.unfocus();
  }

  void _clearSearch() {
    _txtctrl.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 700 ? 3 : 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'Pokedex',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: TextField(
                          focusNode: _searchFocusNode,
                          controller: _txtctrl,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: 'Search Pokemon',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _txtctrl.text.isEmpty
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: _clearSearch,
                                  ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        ),
                      ),
                    ),

                    SizedBox(width: 12),

                    TypeFilterButton(
                      selectedType: _selectedType,
                      onSelected: _onTypeSelected,
                    ),
                  ],
                ),
              ),

              // Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: FutureBuilder(
                    future: _futurePokemon,
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (asyncSnapshot.hasError) {
                        return Center(
                          child: Text(
                            'Failed to load Pokémon: ${asyncSnapshot.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (!asyncSnapshot.hasData ||
                          asyncSnapshot.data!.isEmpty) {
                        return const Center(child: Text('No Pokémon found'));
                      }

                      // Once data is ready, cache it and apply filters
                      _items = asyncSnapshot.data!;
                      filtered = filtered.isEmpty ? _items : filtered;

                      return filtered.isEmpty
                          ? const Center(child: Text('No Pokémon found'))
                          : GridView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.only(
                                top: 6,
                                bottom: 18,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 1.40,
                                  ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final pokemon = filtered[index];
                                return PokemonCard(
                                  pokemon: pokemon,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            DetailScreen(pokemon: pokemon),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
