import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_service.dart'; // Importa el servicio

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pokemonService = Provider.of<PokemonService>(
      context,
      listen: true,
    ); // Escuchar cambios

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: pokemonService.pokemon.length,
              itemBuilder: (context, index) {
                final pokemon = pokemonService.pokemon[index];
                return ListTile(
                  title: Text(pokemon.nom),
                  subtitle: Text(pokemon.regio),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/userDetail',
                      arguments:
                          pokemon.toMap(), // Pasa el usuario como argumento
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed:
                        () => PokemonService.deletePokemon(
                          pokemon,
                        ), // Elimina el usuario
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/addUser',
          ); // Navega a la pantalla de agregar usuario
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
