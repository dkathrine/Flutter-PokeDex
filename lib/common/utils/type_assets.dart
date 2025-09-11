import 'package:flutter/material.dart';

const List<String> kPokemonTypes = [
  'Normal',
  'Fire',
  'Water',
  'Electric',
  'Grass',
  'Ice',
  'Fighting',
  'Poison',
  'Ground',
  'Flying',
  'Psychic',
  'Bug',
  'Rock',
  'Ghost',
  'Dragon',
  'Dark',
  'Steel',
  'Fairy',
];

String assetPathForType(String type) =>
    'assets/types/${type.toLowerCase()}.png';

class TypeAssets {
  /// Gradient colors for each Pokémon type
  static const Map<String, List<Color>> gradients = {
    "normal": [Color(0xFFA8A77A), Color(0xFFC6C6A7)],
    "fire": [Color(0xFFEE8130), Color(0xFFF5AC78)],
    "water": [Color(0xFF6390F0), Color(0xFF9DB7F5)],
    "electric": [Color(0xFFF7D02C), Color(0xFFF9E078)],
    "grass": [
      Color(0xFF7AC74C),
      Color(0xFF9BCC50),
    ], //Color(0xFF2DD4BF), Color(0xFF34D399)
    "ice": [Color(0xFF96D9D6), Color(0xFFBCE6E6)],
    "fighting": [Color(0xFFC22E28), Color(0xFFD67873)],
    "poison": [Color(0xFFA33EA1), Color(0xFFB97FC9)],
    "ground": [Color(0xFFE2BF65), Color(0xFFF7DE3F)],
    "flying": [Color(0xFFA98FF3), Color(0xFFC6B7F5)],
    "psychic": [Color(0xFFF95587), Color(0xFFFAB7B7)],
    "bug": [Color(0xFFA6B91A), Color(0xFFC6D16E)],
    "rock": [Color(0xFFB6A136), Color(0xFFD1C17D)],
    "ghost": [Color(0xFF735797), Color(0xFF9F7AC6)],
    "dragon": [Color(0xFF6F35FC), Color(0xFF97B3FD)],
    "dark": [Color(0xFF705746), Color(0xFFA29288)],
    "steel": [Color(0xFFB7B7CE), Color(0xFFD1D1E0)],
    "fairy": [Color(0xFFD685AD), Color(0xFFF4BDC9)],
  };

  /// Get gradient colors for a type; fallback to grey if unknown
  static List<Color> gradientForType(String type) {
    return gradients[type.toLowerCase()] ?? [Colors.grey, Colors.grey.shade300];
  }
}
