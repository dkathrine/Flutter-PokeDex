import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/features/overview_screen/overview_screen.dart';

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      home: OverviewScreen(allPokemon: _dummyPokemon),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Dummy Pokémon
final List<PokemonDetail> _dummyPokemon = [
  PokemonDetail(
    id: 1,
    name: 'Bulbasaur',
    types: ['Grass', 'Poison'],
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/245.png',
    species: 'Seed',
    height: '2\'3" (0.70 m)',
    weight: '15.2 lbs (6.9 kg)',
    abilities: ['Overgrow', 'Chlorophyll'],
    baseStats: {
      'HP': 45,
      'Attack': 49,
      'Defense': 49,
      'Sp. Atk': 65,
      'Sp. Def': 65,
      'Speed': 45,
    },
    genderRatioMale: 0.875,
    eggGroups: ['Monster', 'Grass'],
    evolutionChain: [
      EvolutionStage(
        id: 1,
        name: 'Bulbasaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
      ),
      EvolutionStage(
        id: 2,
        name: 'Ivysaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
      ),
      EvolutionStage(
        id: 3,
        name: 'Venusaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png',
      ),
    ],
  ),
  PokemonDetail(
    id: 1,
    name: 'Bulbasaur',
    types: ['Grass', 'Poison'],
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
    species: 'Seed',
    height: '2\'3" (0.70 m)',
    weight: '15.2 lbs (6.9 kg)',
    abilities: ['Overgrow', 'Chlorophyll'],
    baseStats: {
      'HP': 45,
      'Attack': 49,
      'Defense': 49,
      'Sp. Atk': 65,
      'Sp. Def': 65,
      'Speed': 45,
    },
    genderRatioMale: 0.875,
    eggGroups: ['Monster', 'Grass'],
    evolutionChain: [
      EvolutionStage(
        id: 1,
        name: 'Bulbasaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
      ),
      EvolutionStage(
        id: 2,
        name: 'Ivysaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
      ),
      EvolutionStage(
        id: 3,
        name: 'Venusaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png',
      ),
    ],
  ),
  PokemonDetail(
    id: 1,
    name: 'Bulbasaur',
    types: ['Grass', 'Poison'],
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
    species: 'Seed',
    height: '2\'3" (0.70 m)',
    weight: '15.2 lbs (6.9 kg)',
    abilities: ['Overgrow', 'Chlorophyll'],
    baseStats: {
      'HP': 45,
      'Attack': 49,
      'Defense': 49,
      'Sp. Atk': 65,
      'Sp. Def': 65,
      'Speed': 45,
    },
    genderRatioMale: 0.875,
    eggGroups: ['Monster', 'Grass'],
    evolutionChain: [
      EvolutionStage(
        id: 1,
        name: 'Bulbasaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
      ),
      EvolutionStage(
        id: 2,
        name: 'Ivysaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
      ),
      EvolutionStage(
        id: 3,
        name: 'Venusaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png',
      ),
    ],
  ),
  PokemonDetail(
    id: 1,
    name: 'Bulbasaur',
    types: ['Grass', 'Poison'],
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
    species: 'Seed',
    height: '2\'3" (0.70 m)',
    weight: '15.2 lbs (6.9 kg)',
    abilities: ['Overgrow', 'Chlorophyll'],
    baseStats: {
      'HP': 45,
      'Attack': 49,
      'Defense': 49,
      'Sp. Atk': 65,
      'Sp. Def': 65,
      'Speed': 45,
    },
    genderRatioMale: 0.875,
    eggGroups: ['Monster', 'Grass'],
    evolutionChain: [
      EvolutionStage(
        id: 1,
        name: 'Bulbasaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
      ),
      EvolutionStage(
        id: 2,
        name: 'Ivysaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
      ),
      EvolutionStage(
        id: 3,
        name: 'Venusaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png',
      ),
    ],
  ),
  PokemonDetail(
    id: 1,
    name: 'Bulbasaur',
    types: ['Grass', 'Poison'],
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
    species: 'Seed',
    height: '2\'3" (0.70 m)',
    weight: '15.2 lbs (6.9 kg)',
    abilities: ['Overgrow', 'Chlorophyll'],
    baseStats: {
      'HP': 45,
      'Attack': 49,
      'Defense': 49,
      'Sp. Atk': 65,
      'Sp. Def': 65,
      'Speed': 45,
    },
    genderRatioMale: 0.875,
    eggGroups: ['Monster', 'Grass'],
    evolutionChain: [
      EvolutionStage(
        id: 1,
        name: 'Bulbasaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
      ),
      EvolutionStage(
        id: 2,
        name: 'Ivysaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
      ),
      EvolutionStage(
        id: 3,
        name: 'Venusaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png',
      ),
    ],
  ),
  PokemonDetail(
    id: 1,
    name: 'Bulbasaur',
    types: ['Grass', 'Poison'],
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
    species: 'Seed',
    height: '2\'3" (0.70 m)',
    weight: '15.2 lbs (6.9 kg)',
    abilities: ['Overgrow', 'Chlorophyll'],
    baseStats: {
      'HP': 45,
      'Attack': 49,
      'Defense': 49,
      'Sp. Atk': 65,
      'Sp. Def': 65,
      'Speed': 45,
    },
    genderRatioMale: 0.875,
    eggGroups: ['Monster', 'Grass'],
    evolutionChain: [
      EvolutionStage(
        id: 1,
        name: 'Bulbasaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
      ),
      EvolutionStage(
        id: 2,
        name: 'Ivysaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
      ),
      EvolutionStage(
        id: 3,
        name: 'Venusaur',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png',
      ),
    ],
  ),

  // Add more dummy Pokémon here...
];
