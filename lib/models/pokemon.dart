//import 'package:flutter/material.dart';

class PokemonDetail {
  final int id;
  final String name;
  final List<String> types;
  final String imageUrl;
  final String species;
  final String height;
  final String weight;
  final List<String> abilities;
  final Map<String, int> baseStats;
  final double? genderRatioMale;
  final List<String> eggGroups;
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

class EvolutionStage {
  final int id;
  final String name;
  final String imageUrl;

  const EvolutionStage({
    required this.id,
    required this.name,
    required this.imageUrl,
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
