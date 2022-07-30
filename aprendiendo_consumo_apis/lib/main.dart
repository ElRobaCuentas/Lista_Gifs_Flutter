import 'dart:async';
import 'dart:convert';

import 'package:aprendiendo_consumo_apis/models/gif.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Future<List<Gif>> _listadoGifs;

  Future<List<Gif>> _getGifs() async {
    final response = await http.get(Uri.parse(
        "https://api.giphy.com/v1/gifs/trending?api_key=lbwBmQS6tGmvfqLGpFexs1Jp6B69RCHl&limit=10&rating=g"));

    List<Gif> gifs = [];

    if (response.statusCode == 200) {
      // utf8 para que cuando traiga datos de tipo string por ejemplo la ñ se muestre de forma normal
      // lo unico que hace es codificar todo a utf8 y asignarlo a la variable body
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var item in jsonData["data"]) {
        gifs.add(Gif(item["title"], item["images"]["downsized"]["url"]));
      }
      return gifs;
    } else {
      throw Exception('Algo saliió mal');
    }
  }

  @override
  void initState() {
    super.initState();
    _getGifs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiApp',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('Material App Bar'),
        ),
        body: FutureBuilder(
          future: _getGifs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 2,
                children: _listGifs(snapshot.data),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text('TUDU MAL');
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _listGifs(data) {
    List<Widget> gifs = [];

    for (var gif in data) {
      gifs.add(Card(
          child: Column(
        children: [
          Image.network(gif.url),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(gif.name),
          ),
        ],
      )));
    }

    return gifs;
  }
}

// falta la ultima parte de asignar todo a _listadoGifs