import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GifPage extends StatelessWidget {
  
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"], style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.white, // Define a cor do botão de voltar
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.share),
              onPressed: (){
                Share.share(_gifData["images"]["fixed_height"]["url"]);
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: Image.network(_gifData["images"]["fixed_height"]["url"]),
          ),
        ),
    );
  }
}