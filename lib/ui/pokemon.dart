import 'package:flutter/material.dart';

import 'package:pokeapp/dados/pokemon_service.dart';
import 'package:pokeapp/dominio/pokemon_repository.dart';

class PokemonInfo extends StatefulWidget {
  final int id;

  const PokemonInfo({super.key, required this.id});

  @override
  State<PokemonInfo> createState() => _PokemonInfoState();
}

class _PokemonInfoState extends State<PokemonInfo> {
  late Future<Map<String, dynamic>> pokemonDetails;
  final PokemonRepository repository = PokemonService();

  @override
  void initState() {
    super.initState();
    pokemonDetails = repository.fetchPokemon(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Pokédex'),
        backgroundColor: const Color(0xFFDC3545),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: pokemonDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFDC3545)),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Erro ao carregar os detalhes.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pokemonDetails = repository.fetchPokemon(widget.id);
                      });
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!;
          final name = data['name'].toString();
          final id = data['id'] as int;
          final sprites = data['sprites'] as Map<String, dynamic>;
          final artwork =
              sprites['other']['official-artwork']['front_default'] as String?;
          final imageUrl =
              artwork ??
              'https://raw.githubusercontent.com/'
                  'PokeAPI/sprites/master/sprites/pokemon/$id.png';

          final types = (data['types'] as List)
              .map((item) => item['type']['name'].toString())
              .toList();

          final abilities = (data['abilities'] as List)
              .map((item) => item['ability']['name'].toString())
              .toList();

          final stats = data['stats'] as List;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '#${id.toString().padLeft(3, '0')}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.network(
                        imageUrl,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.catching_pokemon,
                          size: 120,
                          color: Color(0xFFDC3545),
                        ),
                      ),
                      Text(
                        name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: types.map((type) {
                          return Chip(
                            label: Text(
                              type.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: const Color(0xFFDC3545),
                            side: BorderSide.none,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _sectionTitle('Características'),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _infoItem(
                            'Altura',
                            '${(data['height'] as int) / 10} m',
                          ),
                        ),
                        Expanded(
                          child: _infoItem(
                            'Peso',
                            '${(data['weight'] as int) / 10} kg',
                          ),
                        ),
                        Expanded(
                          child: _infoItem(
                            'Experiência base',
                            '${data['base_experience'] ?? '-'}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _sectionTitle('Habilidades'),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 8,
                      children: abilities.map((ability) {
                        return Chip(label: Text(ability));
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _sectionTitle('Estatísticas base'),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: stats.map<Widget>((item) {
                        final statName = item['stat']['name'].toString();
                        final value = item['base_stat'] as int;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    statName.toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text('$value'),
                                ],
                              ),
                              const SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: (value / 255).clamp(0.0, 1.0),
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFFDC3545),
                                backgroundColor: Colors.grey.shade200,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
