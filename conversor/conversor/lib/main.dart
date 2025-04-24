// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  double dolar = 0;
  double euro = 0;
void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
}
  void _realChange(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChange(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar*this.dolar).toStringAsFixed(2);
    euroController.text = (dolar*this.dolar / euro).toStringAsFixed(2);
  }
  void _euroChange(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro*this.euro).toStringAsFixed(2);
    dolarController.text = (euro*this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(" \$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text("Retornando dados",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erro ao consultar dados",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center),
                  );
                } else {
                  dolar = snapshot.data?["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data?["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: Colors.amber,
                        ),
                        buildTextField("Reais", "R\$", realController, _realChange),
                        Divider(),
                        buildTextField("Dolar", "US\$",dolarController, _dolarChange),
                        Divider(),
                        buildTextField("Euros", "EUR\$", euroController, _euroChange),
                      ]),
                  );
                }
            }
          }),
    );
  }

  Widget buildTextField(String label, String prefix, TextEditingController c, void Function(String) f){
    return TextField(
            controller: c,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.amber),
              border: OutlineInputBorder(),
              prefixText: prefix,
              prefixStyle: TextStyle(
                color: Colors.amber,
                fontSize: 25,
              )
            ),
            style: TextStyle(
              color: Colors.amber,
              fontSize: 25,
            ),
            onChanged: f,
            keyboardType: TextInputType.number,
          );
  }
}
