import 'dart:convert';

/**
 *   {
        "id": 1,
        "nom": "Charmander",
        "descripcio": "Pokemon tipus foc",
        "foto": "link de sa foto",
        "shiny": "no",
        "regio": "kanto"
    }
 */
class Pokemon {
  Pokemon({
    this.id,
    required this.nom,
    required this.descripcio,
    required this.foto,
    required this.shiny,
    required this.regio,
  });
  String? id;
  String nom;
  String descripcio;
  String foto;
  String shiny;
  String regio;

  factory Pokemon.fromJson(String str) => Pokemon.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pokemon.fromMap(Map<String, dynamic> json) => Pokemon(
    id: json["id"]?.toString() ?? "",
    nom: json["nom"]?.toString() ?? "",
    descripcio: json["descripcio"]?.toString() ?? "",
    foto: json["foto"]?.toString() ?? "",
    shiny: json["shiny"]?.toString() ?? "",
    regio: json["regio"]?.toString() ?? "",
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nom": nom,
    "descripcio": descripcio,
    "foto": foto,
    "shiny": shiny,
    "regio": regio,
  };

  Pokemon copy() => Pokemon(
    id: id,
    nom: nom,
    descripcio: descripcio,
    foto: foto,
    shiny: shiny,
    regio: regio,
  );
}
