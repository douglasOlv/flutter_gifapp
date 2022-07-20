import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _search;
  int _offset = 0;

  Future<Map> _getGif() async {
    http.Response respose;

    if (_search == null) {
      respose = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=eqljFoQ4B5ZHmZARyt6IrIKaiR5jZmB2&limit=25&rating=g"));
    } else {
      respose = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=eqljFoQ4B5ZHmZARyt6IrIKaiR5jZmB2&q=${_search}&limit=20&offset=${_offset}&rating=g&lang=pt"));
    }
    return json.decode(respose.body);
  }

  @override
  void initState() {
    super.initState();
    print("hello");
    _getGif().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise aqui",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
