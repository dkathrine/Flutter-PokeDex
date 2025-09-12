import 'dart:async';
import 'package:hive/hive.dart';
import 'package:pokedex/data/poke_api_client.dart';
import 'package:pokedex/models/pokemon.dart';

class PokemonRepository {
  final api = PokeApiClient();
  final Map<int, PokemonDetail> _cache = {};

  static const String _boxName = "pokemon_cache";

  PokemonRepository() {
    if (!Hive.isBoxOpen(_boxName)) {
      throw Exception(
        "Hive box $_boxName not open. INitialize Hive before using repository.",
      );
    }
  }

  Future<List<PokemonSummary>> fetchPage({
    int offset = 0,
    int limit = 20,
  }) async {
    final listJson = await api.fetchPokemonList(offset: offset, limit: limit);
    final results = (listJson["results"] as List).cast<Map<String, dynamic>>();

    if (results.isEmpty) {
      //print("⚠️ API returned empty list at offset: $offset");
      return [];
    }

    const int concurrency = 5;
    final List<PokemonSummary> out = [];

    for (var i = 0; i < results.length; i += concurrency) {
      final batch = results.skip(i).take(concurrency).toList();
      final batchFutures = batch.map((r) async {
        final name = r["name"] as String;
        try {
          final detail = await _fetchOrGetFromCache(name);
          final summary = _mapDetailToSummary(detail);
          return summary;
        } catch (e) {
          //print("Failted to fetch $name: $e");
        }
      }).toList();

      final batchResults = await Future.wait(batchFutures);
      out.addAll(batchResults.whereType<PokemonSummary>());
      await Future.delayed(Duration(milliseconds: 200));
    }
    return out;
  }

  Future<PokemonDetail> getPokemonDetail(String nameOrId) async {
    return _fetchOrGetFromCache(nameOrId);
  }

  Future<PokemonDetail> _fetchOrGetFromCache(String nameOrId) async {
    final box = Hive.box<PokemonDetail>(_boxName);
    //print('Cached ids: ${box.keys.toList()}');
    final maybeId = int.tryParse(nameOrId);

    //check in-memory storage by Id
    if (maybeId != null && _cache.containsKey(maybeId)) {
      return _cache[maybeId]!;
    }

    //check in-memory storage by name
    for (final p in _cache.values) {
      if (p.name.toLowerCase() == nameOrId.toLowerCase()) {
        return p;
      }
    }

    //check hive cache by Id
    if (maybeId != null && box.containsKey(maybeId)) {
      final cachedPokemon = box.get(maybeId);
      if (cachedPokemon != null) {
        _cache[maybeId] = cachedPokemon;
        return cachedPokemon;
      }
    }

    //check hive cache by name
    for (final p in box.values) {
      if (p.name.toLowerCase() == nameOrId.toLowerCase()) {
        _cache[p.id] = p;
        return p;
      }
    }

    //fetch from API
    final raw = await api.fetchPokemonRaw(nameOrId);

    int extractSpeciesIdFromUrl(String url) {
      final cleanedUrl = url.endsWith('/')
          ? url.substring(0, url.length - 1)
          : url;

      final parts = cleanedUrl.split('/');
      return int.tryParse(parts.last) ?? 0;
    }

    final speciesId = extractSpeciesIdFromUrl(raw["species"]["url"]);

    final species = await api.fetchSpeciesRaw(speciesId.toString());

    final evoChainUrl = species["evolution_chain"]?["url"] as String?;
    final evoJson = evoChainUrl != null
        ? await api.fetchUrl(evoChainUrl)
        : null;

    final detail = await _maptoDetail(raw, species, evoJson);
    _cache[detail.id] = detail;
    await box.put(detail.id, detail);

    return detail;
  }

  Future<void> clearCache() async {
    _cache.clear();
    final box = Hive.box<PokemonDetail>(_boxName);
    await box.clear();
  }

  PokemonSummary _mapDetailToSummary(PokemonDetail detail) {
    final id = detail.id;
    final name = detail.name;
    final types = detail.types;
    final imageUrl = detail.imageUrl;
    return PokemonSummary(
      id: id,
      name: capitalizeWords(name),
      types: types.map((t) => capitalizeFirstLetter(t)).toList(),
      imageUrl: imageUrl,
    );
  }

  Future<PokemonDetail> _maptoDetail(
    Map<String, dynamic> raw,
    Map<String, dynamic> species,
    Map<String, dynamic>? evoJson,
  ) async {
    final id = raw["id"] as int;
    final name = raw["name"] as String;
    final types = mapTypes(raw["types"]);
    final imageUrl = officialArtwork(raw);
    final speciesText = extractEngSpecies(species);
    final height = ((raw["height"] as num?) ?? 0) / 10.0;
    final weight = ((raw["weight"] as num?) ?? 0) / 10.0;
    final abilities = mapAbilities(raw["abilities"]);
    final stats = mapStats(raw["stats"]);

    final genderRate = species["gender_rate"] as int?;
    double? maleRatio;
    if (genderRate == null || genderRate == -1) {
      maleRatio = null;
    } else {
      final femaleRatio = (genderRate / 8.0).clamp(0.0, 1.0);
      maleRatio = (1.0 - femaleRatio);
    }

    final eggGroups = (species["egg_groups"] as List? ?? [])
        .map((e) => e["name"] as String)
        .toList();

    final evoStages = <EvolutionStage>[];
    if (evoJson != null) {
      void traverse(node) {
        final sp = node["species"] as Map<String, dynamic>;
        final spName = capitalizeWords(sp["name"] as String);
        final spUrl = sp["url"] as String?;
        final spId = extractIdFromUrl(spUrl) ?? 0;
        evoStages.add(
          EvolutionStage(
            id: spId,
            name: spName,
            imageUrl: artworkUrlForId(spId),
          ),
        );
        final evolvesTo = (node["evolves_to"] as List<dynamic>? ?? []);
        for (final child in evolvesTo) {
          traverse(child as Map<String, dynamic>);
        }
      }

      final chain = evoJson["chain"] as Map<String, dynamic>?;
      if (chain != null) traverse(chain);
    }

    return PokemonDetail(
      id: id,
      name: capitalizeWords(name),
      types: types.map((t) => capitalizeFirstLetter(t)).toList(),
      imageUrl: imageUrl,
      species: capitalizeWords(speciesText),
      height: height.toString(),
      weight: weight.toString(),
      abilities: abilities.map((a) => capitalizeWords(a)).toList(),
      baseStats: stats.map(
        (key, value) => MapEntry(capitalizeWords(key), value),
      ),
      genderRatioMale: maleRatio,
      eggGroups: eggGroups.map((e) => capitalizeWords(e)).toList(),
      evolutionChain: evoStages,
    );
  }
}
