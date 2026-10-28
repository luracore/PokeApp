import 'package:flutter/material.dart';

import 'package:pokeapp/dados/pokemon_service.dart';

import 'pokecard.dart';
import 'pokemon.dart';

class Pokedex extends StatefulWidget {
  const Pokedex({super.key});

  @override
  State<Pokedex> createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  final PokemonService _pokemonService = PokemonService();

  List<Map<String, dynamic>> _pokemons = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
  }

  Future<void> _fetchPokemons() async {
    try {
      final pokemons = await _pokemonService.fetchPokedex();

      if (!mounted) return;

      setState(() {
        _pokemons = pokemons;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Não foi possível carregar os Pokémon.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.red));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _fetchPokemons();
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _pokemons.length,
      itemBuilder: (context, index) {
        final pokemon = _pokemons[index];
        final id = index + 1;

        return PokeCard(
          pokemon: pokemon,
          id: id,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PokemonInfo(id: index + 1),
              ),
            );
          },
        );
      },
    );
  }
}
