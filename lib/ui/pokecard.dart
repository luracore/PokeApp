import 'package:flutter/material.dart';

class PokeCard extends StatelessWidget {
  final Map<String, dynamic> pokemon;
  final int id;
  final VoidCallback onTap;

  const PokeCard({
    super.key,
    required this.pokemon,
    required this.id,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        leading: Image.network(
          'https://raw.githubusercontent.com/'
          'PokeAPI/sprites/master/sprites/pokemon/$id.png',
          width: 50,
          height: 50,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.catching_pokemon,
              color: Colors.red,
            );
          },
        ),
        title: Text(
          pokemon['name'].toString().toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'ID: #${id.toString().padLeft(3, '0')}',
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
