import 'package:flutter/material.dart';

class GifPage extends StatelessWidget {

  final Map gifData;

  const GifPage({Key? key, required this.gifData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gifData["title"]),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Image.network(gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
