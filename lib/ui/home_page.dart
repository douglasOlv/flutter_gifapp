import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gifapp/ui/gif_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = "";
  int _offset = 0;

  Future<Map> _getGif() async {
    http.Response respose;

    if (_search.isEmpty) {
      respose = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=eqljFoQ4B5ZHmZARyt6IrIKaiR5jZmB2&limit=24&rating=g"));
    } else {
      respose = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=eqljFoQ4B5ZHmZARyt6IrIKaiR5jZmB2&q=${_search}&limit=21&offset=${_offset}&rating=g&lang=pt"));
    }
    return json.decode(respose.body);
  }

  int _getDataLength(List list) {
    if (_search.isEmpty) return list.length;
    return list.length + 1;
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _getDataLength(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (index < snapshot.data["data"].length) {
            return GestureDetector(
              child: Image.network(
                snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300,
                fit: BoxFit.cover,
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> GifPage(snapshot.data["data"][index])));
              },
            );
          }
          return GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
               Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 70,
                ),
                Text("Carregar mais",
                    style: TextStyle(color: Colors.white, fontSize: 22)),
              ],
            ),
            onTap: (){
              setState(() {
                _offset += 21;
              });
            },
          );
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
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise aqui",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: _getGif(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                    height: 200,
                    width: 200,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5),
                  );
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Container();
                  } else {
                    return _createGifTable(context, snapshot);
                  }
              }
            },
          ))
        ],
      ),
    );
  }
}

class ImgGif {}
