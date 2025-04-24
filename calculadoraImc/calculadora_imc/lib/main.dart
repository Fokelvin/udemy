// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  String textInfo = "INFO";

  void _resetField(){
    setState(() {
      textInfo = "Infore seus dados";
      _formKey = GlobalKey<FormState>();
    });
    weightController.text = "";
    heightController.text = "";
  }

  void cacular(){
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height*height);
      if (imc < 18.6){
        textInfo = "Abaixo do peso: ${imc.toStringAsPrecision(4)}";
      }else if( imc >18.6 && imc < 24.9){
        textInfo = "Dentro do peso ideal: ${imc.toStringAsPrecision(4)}";
      }else{
        textInfo = "Acima do peso: ${imc.toStringAsPrecision(4)}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Caculadora de IMC'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetField,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Icon(Icons.person_outlined, size: 120, color: Colors.green),
                TextFormField(
                  controller: weightController,
                  validator: (value){
                    if(value!.isEmpty){
                      return "insira seu peso";
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Peso em KG',
                      labelStyle: TextStyle(
                        color: Colors.green,
                      )),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25.0),
                ),
                TextFormField(
                  controller: heightController,
                  validator: (value){
                    if(value!.isEmpty){
                      return "insira sua altura";
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Altura em cm',
                      labelStyle: TextStyle(
                        color: Colors.green,
                      )),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          cacular();
                        }
                      },
                      child: const Text(
                        'Calcular',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  textInfo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
