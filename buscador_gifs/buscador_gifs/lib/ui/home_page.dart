// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'dart:convert';

import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  
  @override
  // ignore: library_private_types_in_public_api
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  late String _search = "";
  int _offset = 0;

  Future<Map> _getGifs() async {
    print('teste');
    http.Response response;
    if(_search.isEmpty){
      response = await http.get(Uri.parse('https://api.giphy.com/v1/gifs/trending?api_key=51fdeyu7zwSU3YM6to2XUy9MZrfnQhar&limit=25&offset=$_offset&rating=g&bundle=messaging_non_clips'));
    }else{    
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=51fdeyu7zwSU3YM6to2XUy9MZrfnQhar&q=$_search&limit=19&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips"));
    }

    if (response.statusCode == 200) {
      print('Resposta recebida com sucesso');
      return json.decode(response.body);
    } else {
      print('Falha ao carregar GIFs: ${response.statusCode}');
      return {};
    }

    }

  @override
  void initState(){
    super.initState();
    _getGifs().then((map){
      print(map);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: GestureDetector(
          onTap: () {
            setState(() {
              _search = "";
              _offset = 0;
            });
            _getGifs().then((map) {
            });
          },
          child: Image.network('https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif')),
        centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget> [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui!",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder()
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0
              ),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                _search = text;
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor : AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0
                      ),
                    );
                  default:
                    if(snapshot.hasError){
                      return Container();
                    }else{
                      return _createGifTable(context, snapshot);
                    }
                }
              }
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data){
    if(_search == null){
      return data.length;
    }else{
      return data.length + 1;
    }
  }
  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0
      ),
      itemCount: _getCount(snapshot.data["data"]), 
      itemBuilder: (context, index){
        if(_search == null || index < snapshot.data["data"].length){
          return GestureDetector(
            key: ValueKey(snapshot.data["data"][index]["id"]),
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GifPage(snapshot.data["data"][index]))
              );
            },
          onLongPress: (){
            Share.share(snapshot.data["data"][index]["images"]["original"]["url"]);
          },
          );
        }else{
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70.0),
                  Text("Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  )
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 19;
                });
              },
            )
          );
        }
      }
    );
  }
}