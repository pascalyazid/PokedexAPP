import 'dart:convert';

List<Pokemon> pokemonFromJson(String str) =>
    List<Pokemon>.from(json.decode(str).map((x) => Pokemon.fromJson(x)));

String pokemonToJson(List<Pokemon> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pokemon {
  String name;
  String url;
  late String spriteS = '';
  late String spriteM = '';

  Pokemon({
    required this.name,
    required this.url,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      Pokemon(name: json["name"], url: json["url"]);

  Map<String, dynamic> toJson() => {"name": name, "url": url};

  void setSpriteS(String url) {
    spriteS = url;
  }

  void setSpriteM(String url) {
    spriteM = url;
  }
}
