import 'package:dio/dio.dart';

class PokeApiClient {
  final _dio = Dio(
    BaseOptions(
      baseUrl: "https://pokeapi.co/api/v2/",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  );

  Future<Map<String, dynamic>> fetchPokemonList({
    int offset = 0,
    int limit = 20,
  }) async {
    final resp = await _dio.get(
      "pokemon",
      queryParameters: {"offset": offset, "limit": limit},
    );
    return resp.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchPokemonRaw(String nameOrId) async {
    final resp = await _dio.get("pokemon/$nameOrId");
    return resp.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchSpeciesRaw(String nameOrId) async {
    final resp = await _dio.get("pokemon-species/$nameOrId");
    return resp.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchUrl(String url) async {
    final resp = await _dio.getUri(Uri.parse(url));
    return resp.data as Map<String, dynamic>;
  }
}
