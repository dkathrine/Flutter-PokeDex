// lib/screens/overview_screen.dart
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
  List<PokemonSummary> _items = [];
  late List<PokemonSummary> filtered = [];
  bool _loading = false;
  String? _error;
  final TextEditingController _txtctrl = TextEditingController();
  String? _selectedType;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadPage();
    _txtctrl.addListener(_onSearchOrFilterChanged);
  }

  Future<void> _loadPage() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await _repo.fetchPage();
      setState(() {
        _items = page;
        filtered = _items;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load Pokemon: $_error")),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _txtctrl.removeListener(_onSearchOrFilterChanged);
    _txtctrl.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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
                  child: filtered.isEmpty
                      ? const Center(child: Text('No Pokémon found'))
                      : GridView.builder(
                          padding: const EdgeInsets.only(top: 6, bottom: 18),
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
