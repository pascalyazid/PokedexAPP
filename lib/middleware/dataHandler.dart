import 'dart:async';
import 'dart:developer';
import 'dart:convert';
import 'package:flutterprojectzli/model/pokemon.dart';
import 'package:http/http.dart' as http;

class DataHandler {
  Future<List<Pokemon>?> listPokemons(
      int offset, int limit, List<Pokemon> old) async {
    try {
      var url = Uri.parse(
          'https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$limit');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body.toString());

        List<Map<String, dynamic>> results = (data['results'] as List)
            .map((result) => {
                  'name': result['name'],
                  'url': result['url'],
                })
            .toList();

        List<Pokemon> _pokemon = pokemonFromJson(json.encode(results));
        setSprites(_pokemon);
        return old + _pokemon;
      } else {
        log("Couldn't retrieve data");
      }
    } catch (e) {
      log("Error retrieving data");
      log(e.toString());
      return null;
    }
    return null;
  }

  Future<List<Pokemon>?> setSprites(List<Pokemon> pokemons) async {
    try {
      for (final p in pokemons) {
        if (p.spriteS == '') {
          var url = Uri.parse(p.url);
          var response = await http.get(url);
          if (response.statusCode == 200) {
            Map<String, dynamic> data = jsonDecode(response.body.toString());
            p.spriteS = data['sprites']['front_default'];
          }
        }
      }
      return pokemons;
    } catch (e) {
      log(e.toString());
      return pokemons;
    }
  }

  Future<Map<String, dynamic>> getPokemon(String uri) async {
    Map<String, dynamic> data = Map();
    try {
      var completer = new Completer();
      var url = Uri.parse(uri);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        log("Data retrieved");
        data = jsonDecode(response.body.toString());
        completer.complete();
        return data;
      }
      return data;
    } catch (e) {
      log(e.toString());
      return data;
    }
  }
}
