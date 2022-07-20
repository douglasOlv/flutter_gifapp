import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class GifPage extends StatelessWidget {
  const GifPage(this._gifData, {Key? key}) : super(key: key);
  final Map _gifData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final url = Uri.parse(_gifData["images"]["fixed_height"]["url"]);
              final response = await http.get(url);
              final temp = await getTemporaryDirectory();
              final path = "${temp.path}/${_gifData["slug"]}.${_gifData["type"]}";
              await File(path).writeAsBytes(response.bodyBytes);
              await Share.shareFiles([path]);
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
