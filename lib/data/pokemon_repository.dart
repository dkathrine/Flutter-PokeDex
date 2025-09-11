import 'dart:async';
import 'package:pokedex/data/poke_api_client.dart';
import 'package:pokedex/models/pokemon.dart';

class PokemonRepository {
  final api = PokeApiClient();
  final Map<int, PokemonDetail> _detailCache = {};
  final Map<int, PokemonSummary> _summaryCache = {};

  Future<List<PokemonSummary>> fetchPage({
    int offset = 0,
    int limit = 20,
  }) async {
    final listJson = await api.fetchPokemonList(offset: offset, limit: limit);
    final results = (listJson["results"] as List).cast<Map<String, dynamic>>();

    final futures = results.map((r) async {
      final name = r["name"] as String;
      final raw = await api.fetchPokemonRaw(name);
      final summary = _mapRawToSummary(raw);
      _summaryCache[summary.id] = summary;
      return summary;
    });
    return await Future.wait(futures);
  }

  Future<PokemonDetail> getPokemonDetail(String nameOrId) async {
    final maybeId = int.tryParse(nameOrId);
    if (maybeId != null && _detailCache.containsKey(maybeId)) {
      return _detailCache[maybeId]!;
    }

    final raw = await api.fetchPokemonRaw(nameOrId);
    final species = await api.fetchSpeciesRaw(nameOrId);

    final evoChainUrl = species["evolution_chain"]?["url"] as String?;
    final evoJson = evoChainUrl != null
        ? await api.fetchUrl(evoChainUrl)
        : null;

    final detail = await _maptoDetail(raw, species, evoJson);
    _detailCache[detail.id] = detail;
    return detail;
  }

  PokemonSummary _mapRawToSummary(Map<String, dynamic> raw) {
    final id = raw["id"] as int;
    final name = raw["name"] as String;
    final types = mapTypes(raw["types"]);
    final imageUrl = officialArtwork(raw);
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
