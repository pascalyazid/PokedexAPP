import 'package:flutter/material.dart';
import 'package:flutterprojectzli/middleware/DataHandler.dart';
import 'package:flutterprojectzli/pages/PokemonListPage.dart';

void main() {
  runApp(PokedexApp());
}

// ignore: must_be_immutable
class PokedexApp extends StatelessWidget {
  DataHandler dataHandler = DataHandler();
  PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PokemonListPage(),
    );
  } 
}
