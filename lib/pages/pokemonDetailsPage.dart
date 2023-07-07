import 'package:flutter/material.dart';

import '../middleware/DataHandler.dart';

class PokemonDetailsPage extends StatefulWidget {
  const PokemonDetailsPage({super.key, required this.url});
  final String url;

  @override
  _PokemonDetailsPageState createState() => _PokemonDetailsPageState(url: url);
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  final String url;
  bool loaded = false;
  bool loadingError = true;
  Map<String, dynamic> _data = {};
  _PokemonDetailsPageState({
    required this.url,
  });

  @override
  void initState() {
    super.initState();

    _getData().then((value) {
      loaded = true;
      if (value != null) {
        _data = value;
        loadingError = false;
      } else {
        loadingError = true;
      }
      setState(() {});
    });
  }

  Future<Map<String, dynamic>> _getData() async {
    Map<String, dynamic>? data = (await DataHandler().getPokemon(url));
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.red,
          title: Text(_data['name']),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          // Update your View after loading data

          if (loadingError) {
            return const Text('Connection Error');
          } else if (loaded) {
            return Center(
              child: pokemonCard(context),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }));
  }

  Widget pokemonCard(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Colors.red,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: (SizedBox(
          width: 350,
          height: 600,
          child: Center(
            child: Column(
              children: [
                Center(
                  child: Image.network(
                    _data['sprites']['other']['official-artwork']
                        ['front_default'],
                    height: 160,
                    width: 300,
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      const Text("Name:"),
                      const SizedBox(width: 10),
                      Text(_data['name']),
                    ],
                  ),
                ),
                const Row(
                  children: [
                    Text("Types:"),
                    Spacer(),
                  ],
                ),
                typeList(context, _data['types'].length),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      const Text("HP:"),
                      const Spacer(),
                      Text(_data['stats'][0]['base_stat'].toString())
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      const Text("Attack:"),
                      const Spacer(),
                      Text(_data['stats'][1]['base_stat'].toString())
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      const Text("Defense:"),
                      const Spacer(),
                      Text(_data['stats'][2]['base_stat'].toString())
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      const Text("Special-Attack:"),
                      const Spacer(),
                      Text(_data['stats'][3]['base_stat'].toString())
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      const Text("Special-Defense:"),
                      const Spacer(),
                      Text(_data['stats'][4]['base_stat'].toString())
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      const Text("Speed:"),
                      const Spacer(),
                      Text(_data['stats'][5]['base_stat'].toString())
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget typeList(BuildContext context, int index) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: _data['types'].length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Text(_data['types'][index]['type']['name']);
        },
      ),
    );
  }
}
