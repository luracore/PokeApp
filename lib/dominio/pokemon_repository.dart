abstract class PokemonRepository {
  Future<List<Map<String, dynamic>>> fetchPokedex();
  Future<Map<String, dynamic>> fetchPokemon(int id);
}
