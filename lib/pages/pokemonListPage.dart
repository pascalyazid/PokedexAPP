import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectzli/middleware/dataHandler.dart';
import 'package:flutterprojectzli/model/pokemon.dart';
import 'package:flutterprojectzli/pages/pokemonDetailsPage.dart';
import 'package:shake/shake.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({Key? key}) : super(key: key);

  @override
  _PokemonListPageState createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  late int listOffset = 0;
  late ScrollController _scrollController;
  late List<Pokemon>? _pokemon = [];
  late bool bottom = false;
  late Map<String, dynamic> pokemonData;
  @override
  void initState() {
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      int index = Random().nextInt(952);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => PokemonDetailsPage(
                    url:
                        "https://pokeapi.co/api/v2/pokemon/" + index.toString(),
                  )),
          ModalRoute.withName('/'));
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    _getData();
  }

  Future<void> getPokemonData(int index) async {
    Future<Map<String, dynamic>> futureData;
    futureData = DataHandler().getPokemon(_pokemon![index].url);
    pokemonData = await futureData;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // reached bottom
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getData() async {
    _pokemon = (await DataHandler().listPokemons(listOffset, 8, _pokemon!))!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    //await Future.delayed(const Duration(seconds: 1));
    bottom = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.red,
          title: const Text("Pokemon List"),
        ),
        body: _pokemon == null || _pokemon!.isEmpty
            ? const Center(
                child: Column(
                  children: [Text("Empty")],
                ),
              )
            : pokemonList(context));
  }

  Widget pokemonList(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            !bottom) {
          bottom = true;
          listOffset += 8;
          // reached bottom
          _getData();
        }
        return true;
      },
      child: ListView.builder(
          itemCount: _pokemon!.length,
          itemBuilder: (context, index) {
            return Dismissible(
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PokemonDetailsPage(
                                    url: _pokemon![index].url,
                                  )));
                    });
                    return false;
                  }
                },
                background: Container(
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(Icons.info),
                    ),
                  ),
                ),
                key: Key(_pokemon![index].name),
                child: Card(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(_pokemon![index].name.toString()),
                        CachedNetworkImage(
                          imageUrl: _pokemon![index].spriteS.toString(),
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ],
                    )
                  ]),
                ));
          }),
    );
  }
}
