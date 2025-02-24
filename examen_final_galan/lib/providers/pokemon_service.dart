import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart'; // Importa la clase User

class PokemonService extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // URL de Firebase Realtime Database
  final String _baseUrl = "ca5247c8e44c6b37e961.free.beeceptor.com/api/pokemon";

  List<Pokemon> pokemon = [];
  late Pokemon tempPokemon;

  PokemonService() {
    loadPokemon();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // Cambiar el modo offline
  void toggleOfflineMode(bool value) {
    isOffline = value;
    loadPokemon(); // Recargar los usuarios en el modo correspondiente
    notifyListeners();
  }

  // Cargar usuarios desde Firebase o la base de datos local
  loadPokemon() async {
    pokemon.clear();
    if (isOffline) {
      // Cargar desde la base de datos local
      pokemon = await _databaseHelper.getPokemons();
      print(
        'Usuarios cargados desde la base de datos local: ${pokemon.length}',
      );
    } else {
      // Cargar desde Firebase
      final url = Uri.https(_baseUrl, 'pokemon.json');
      final response = await http.get(url);

      if (response.body == "null") return;

      final Map<String, dynamic> usersMap = json.decode(response.body);

      usersMap.forEach((key, value) {
        final auxPokemon = Pokemon.fromMap(value);
        auxPokemon.id = key; // Asignamos el ID del usuario
        pokemon.add(auxPokemon);
      });

      // Sincronizar con la base de datos local
      await _databaseHelper.syncWithFirebase(pokemon);
      print('Usuarios cargados desde Firebase: ${pokemon.length}');
    }

    notifyListeners(); // Notificar a los listeners que los datos han cambiado
  }

  // Guardar o crear un usuario
  Future saveOrCreatePokemon() async {
    if (tempPokemon.id == null) {
      await createPokemon();
    } else {
      await updatePokemon();
    }
    await loadPokemon(); // Recargar la lista de usuarios después de guardar
  }

  // Crear un nuevo usuario
  Future<void> createPokemon() async {
    if (isOffline) {
      // Guardar en la base de datos local
      tempUser.id =
          DateTime.now().millisecondsSinceEpoch.toString(); // ID temporal
      await _databaseHelper.insertUser(tempPokemon);
      print('Usuario creado en modo offline: ${tempPokemon.id}');
    } else {
      // Guardar en Firebase
      final url = Uri.https(_baseUrl, 'pokemon.json');
      final response = await http.post(
        url,
        body: json.encode({
          "id": tempPokemon.id,
          "nom": tempPokemon.nom,
          "descripcio": tempPokemon.descripcio,
          "foto": tempPokemon.foto,
          "shiny": tempPokemon.shiny,
          "regio": tempPokemon.regio,
        }),
        headers: {"Content-Type": "application/json"},
      );

      final decodedData = json.decode(response.body);
      tempPokemon.id = decodedData['nom']; // Firebase retorna un ID único
      print('Usuario creado en Firebase: ${tempPokemon.id}');
    }
    notifyListeners(); // Notificar a los listeners que los datos han cambiado
  }

  // Actualizar un usuario
  Future<void> updatePokemon() async {
    if (isOffline) {
      // Actualizar en la base de datos local
      await _databaseHelper.updateUser(tempPokemon);
      print('Usuario actualizado en modo offline: ${tempPokemon.id}');
    } else {
      // Actualizar en Firebase
      final url = Uri.https(_baseUrl, 'users/${tempPokemon.id}.json');
      final response = await http.put(
        url,
        body: json.encode({
          "id": tempPokemon.id,
          "nom": tempPokemon.nom,
          "descripcio": tempPokemon.descripcio,
          "foto": tempPokemon.foto,
          "shiny": tempPokemon.shiny,
          "regio": tempPokemon.regio,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception("Error al actualizar el usuario");
      }
      print('Usuario actualizado en Firebase: ${tempPokemon.id}');
    }
    notifyListeners(); // Notificar a los listeners que los datos han cambiado
  }

  // Eliminar un usuario
  Future<void> deletePokemon(Pokemon pokemon) async {
    if (isOffline) {
      // Eliminar de la base de datos local
      await _databaseHelper.deleteUser(pokemon.id!);
      print('Usuario eliminado en modo offline: ${pokemon.id}');
    } else {
      // Eliminar de Firebase
      final url = Uri.https(_baseUrl, 'users/${pokemon.id}.json');
      await http.delete(url);
      print('Usuario eliminado en Firebase: ${pokemon.id}');
    }
    pokemon.removeWhere(
      (p) => p.id == pokemon.id,
    ); // Eliminar el usuario de la lista local
    notifyListeners(); // Notificar a los listeners que los datos han cambiado
  }
}
