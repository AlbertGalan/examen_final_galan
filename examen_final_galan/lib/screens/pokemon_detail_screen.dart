import 'package:flutter/material.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Map<String, dynamic> pokemon;

  PokemonDetailScreen({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokemon Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('id: ${pokemon['id']}'),
            Text('nom: ${pokemon['nom']}'),
            Text('descripcio: ${pokemon['descripcio']}'),
            Text('shiny: ${pokemon['shiny']}'),
            Text('regio: ${pokemon['regio']}'),
            SizedBox(height: 20),
            Image.network(pokemon['foto']),
          ],
        ),
      ),
    );
  }
}
