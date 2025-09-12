import 'package:hive/hive.dart';

part 'pokemon.g.dart';

@HiveType(typeId: 0)
class EvolutionStage {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  const EvolutionStage({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

@HiveType(typeId: 1)
class PokemonDetail {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> types;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final String species;

  @HiveField(5)
  final String height;

  @HiveField(6)
  final String weight;

  @HiveField(7)
  final List<String> abilities;

  @HiveField(8)
  final Map<String, int> baseStats;

  @HiveField(9)
  final double? genderRatioMale;

  @HiveField(10)
  final List<String> eggGroups;

  @HiveField(11)
  final List<EvolutionStage> evolutionChain;

  const PokemonDetail({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.species,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.baseStats,
    required this.genderRatioMale,
    required this.eggGroups,
    required this.evolutionChain,
  });
}

class PokemonSummary {
  final int id;
  final String name;
  final List<String> types;
  final String imageUrl;

  PokemonSummary({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
  });
}

String officialArtwork(Map<String, dynamic> raw) {
  try {
    final other = raw["sprites"]?["other"];
    final art = other?["official-artwork"]?["front_default"] as String?;
    if (art != null && art.isNotEmpty) return art;
  } catch (_) {}
  return raw["sprites"]?["front_default"] as String? ?? "";
}

List<String> mapTypes(dynamic raw) {
  if (raw == null) return [];
  return (raw as List)
      .map((e) => (e["type"]?["name"] as String?) ?? "")
      .where((s) => s.isNotEmpty)
      .toList();
}

Map<String, int> mapStats(dynamic raw) {
  final Map<String, int> out = {};
  if (raw == null) return out;
  for (final s in raw as List) {
    final statName = (s["stat"]?["name"] as String?) ?? "unknown";
    final base = s["base_stat"] as int? ?? 0;
    out[statName] = base;
  }
  return out;
}

List<String> mapAbilities(dynamic raw) {
  if (raw == null) return [];
  return (raw as List)
      .map((e) => (e["ability"]?["name"] as String?) ?? "")
      .where((s) => s.isNotEmpty)
      .toList();
}

String extractEngSpecies(dynamic speciesRaw) {
  final species = speciesRaw["genera"] as List<dynamic>?;
  if (species != null) {
    for (final s in species) {
      if ((s["language"]?["name"] as String?) == "en") {
        return (s["genus"] as String?) ?? "";
      }
    }
  }
  return (speciesRaw["name"] as String?) ?? "";
}

int? extractIdFromUrl(String? url) {
  if (url == null) return null;
  final parts = url.split("/");
  for (var i = parts.length - 1; i >= 0; i--) {
    if (parts[i].isNotEmpty) return int.tryParse(parts[i]);
  }
  return null;
}

String artworkUrlForId(int id) =>
    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png";
