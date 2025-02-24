import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_service.dart'; // Importa el servicio
import '../models/pokemon.dart'; // Importa la clase User

class _AddPokemonScreen extends StatefulWidget {
  @override
  _AddPokemonScreenState createState() => _AddPokemonScreenState();
}

class _AddPokemonScreenState extends State<_AddPokemonScreen> {
  final _idController = TextEditingController();
  final _nomController = TextEditingController();
  final _descripcioController = TextEditingController();
  final _fotoController = TextEditingController();
  final _shinyController = TextEditingController();
  final _regioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final PokemonService = Provider.of<PokemonService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Add User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'Id'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcioController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fotoController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _shinyController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _regioController,
                decoration: InputDecoration(labelText: 'Photo URL'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a photo URL';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newPokemon = Pokemon(
                      id: _idController.text,
                      nom: _nomController.text,
                      descripcio: _descripcioController.text,
                      foto: _fotoController.text,
                      shiny: _shinyController.text,
                      regio: _regioController.text,
                    );
                    pokemonService.tempPokemon = newPokemon;
                    await pokemonService
                        .saveOrCreatePokemon(); // Guardar el usuario
                    Navigator.pop(context); // Regresar a la pantalla anterior
                  }
                },
                child: Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
