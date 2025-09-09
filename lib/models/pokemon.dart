import 'package:flutter/material.dart';

class Pokemon {
  final int id;
  final String name;
  final List<String> types;
  final String imageUrl;
  final String species;
  final String height;
  final String weight;
  final List<String> abilities;
  final Map<String, int> baseStats;
  final double genderRatioMale;
  final List<String> eggGroups;
  final String eggCycle;
  final List<EvolutionStage> evolutionChain;

  const Pokemon({
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
    required this.eggCycle,
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
