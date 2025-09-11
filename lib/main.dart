import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/pokedex.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(EvolutionStageAdapter());
  Hive.registerAdapter(PokemonDetailAdapter());

  await Hive.openBox<PokemonDetail>("pokemon_cache");

  runApp(const PokedexApp());
}
