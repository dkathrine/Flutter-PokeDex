// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EvolutionStageAdapter extends TypeAdapter<EvolutionStage> {
  @override
  final int typeId = 0;

  @override
  EvolutionStage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EvolutionStage(
      id: fields[0] as int,
      name: fields[1] as String,
      imageUrl: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EvolutionStage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvolutionStageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PokemonDetailAdapter extends TypeAdapter<PokemonDetail> {
  @override
  final int typeId = 1;

  @override
  PokemonDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonDetail(
      id: fields[0] as int,
      name: fields[1] as String,
      types: (fields[2] as List).cast<String>(),
      imageUrl: fields[3] as String,
      species: fields[4] as String,
      height: fields[5] as String,
      weight: fields[6] as String,
      abilities: (fields[7] as List).cast<String>(),
      baseStats: (fields[8] as Map).cast<String, int>(),
      genderRatioMale: fields[9] as double?,
      eggGroups: (fields[10] as List).cast<String>(),
      evolutionChain: (fields[11] as List).cast<EvolutionStage>(),
    );
  }

  @override
  void write(BinaryWriter writer, PokemonDetail obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.types)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.species)
      ..writeByte(5)
      ..write(obj.height)
      ..writeByte(6)
      ..write(obj.weight)
      ..writeByte(7)
      ..write(obj.abilities)
      ..writeByte(8)
      ..write(obj.baseStats)
      ..writeByte(9)
      ..write(obj.genderRatioMale)
      ..writeByte(10)
      ..write(obj.eggGroups)
      ..writeByte(11)
      ..write(obj.evolutionChain);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
