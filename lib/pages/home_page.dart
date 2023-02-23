import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/trending?api_key=9q7GmbucfSz9Ywaim1fMPEStARF4bnR2&limit=20&rating=g'));
    } else {
      response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key=9q7GmbucfSz9Ywaim1fMPEStARF4bnR2&q=$_search&limit=19&offset=$_offset&rating=g&lang=en'));
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: SizedBox(
          width: 200,
          child: Image.network(
              "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 17.0, right: 8.0, left: 8.0, bottom: 10),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Pesquise por Giphys",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                fillColor: Color(0xFFE4E4E4),
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: FutureBuilder(
                  future: _getGifs(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        if (snapshot.hasError)
                          return Container();
                        else
                          return _createGifTable(context, snapshot);
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  int _getCount(List data){
    if (_search == null){
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index){
        if (_search == null || index < snapshot.data["data"].length){
          return GestureDetector(
            child: Image.network(
              snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return Container(
            color: Color(0xFFE4E4E4),
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.black, size: 70,),
                  Text("Carregar mais...")
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 19;
                });
              },
            ),
          );
        }
      },
      itemCount: _getCount(snapshot.data["data"]),
    );
  }
}
