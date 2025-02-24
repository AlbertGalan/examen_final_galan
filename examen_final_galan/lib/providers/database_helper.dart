import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pokemon.dart'; // Importa la clase Pokemon

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pokemons.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pokemons(
        id TEXT PRIMARY KEY,
        nom TEXT,
        descripcio TEXT,
        foto TEXT,
        shiny TEXT,
        regio TEXT
      )
    ''');
  }

  // Insertar un usuario
  Future<void> insertPokemon(Pokemon pokemon) async {
    final db = await database;
    await db.insert(
      'pokemons',
      pokemon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Usuario insertado en la base de datos local: ${pokemon.id}');
  }

  // Obtener todos los usuarios
  Future<List<Pokemon>> getPokemons() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pokemons');
    return List.generate(maps.length, (i) {
      return Pokemon.fromMap(maps[i]);
    });
  }

  // Actualizar un usuario
  Future<void> updatePokemon(Pokemon pokemon) async {
    final db = await database;
    await db.update(
      'pokemons',
      pokemon.toMap(),
      where: 'id = ?',
      whereArgs: [pokemon.id],
    );
    print('Usuario actualizado en la base de datos local: ${pokemon.id}');
  }

  // Eliminar un usuario
  Future<void> deletePokemon(String id) async {
    final db = await database;
    await db.delete('pokemons', where: 'id = ?', whereArgs: [id]);
    print('Usuario eliminado de la base de datos local: $id');
  }

  // Sincronizar datos con Firebase
  Future<void> syncWithFirebase(List<Pokemon> firebasePokemons) async {
    final db = await database;
    await db.delete('pokemons'); // Limpiar la base de datos local
    for (final pokemon in firebasePokemons) {
      await db.insert(
        'pokemons',
        pokemon.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    print('Datos sincronizados con Firebase');
  }
}
