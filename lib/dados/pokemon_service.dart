import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:pokeapp/dominio/pokemon_repository.dart';

class PokemonService implements PokemonRepository {

  @override
  Future<List<Map<String, dynamic>>> fetchPokedex() async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar Pokémon: ${response.statusCode}');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    final List<dynamic> results = data['results'] as List<dynamic>;

    return results.map((pokemon) => pokemon as Map<String, dynamic>).toList();
  }

  @override
  Future<Map<String, dynamic>> fetchPokemon(int id) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$id/');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Não foi possível carregar o Pokémon.');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
