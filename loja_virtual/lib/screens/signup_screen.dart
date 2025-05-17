import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../screens/login_screen.dart';

class SignupScreen extends StatelessWidget {

  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRIAR CONTA",
        style: TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: Theme.of(context).primaryColor, // Cor de fundo do AppBar
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            //Nome
            TextFormField(
              validator: (text){
                if(text!.isEmpty ) {
                  return "Insira nome valido";
                }
              },
              decoration: InputDecoration(
                hintText: "Nome completo",
              ),
            ),
            SizedBox(height: 16.0,),
            //Email
            TextFormField(
              validator: (text){
                if(text!.isEmpty || !text.contains("@")) {
                  return "Insira um e-mail valido";
                }
              },
              decoration: InputDecoration(
                hintText: "E-mail",
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0,),
            //Endereço
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator: (text){
                if(text!.isEmpty) {
                  return "Insira um endereço valido";
                }
              },
              decoration: InputDecoration(
                hintText: "Endereço",
              ),
            ),
            SizedBox(height: 16.0,),

            //Senha1
            TextFormField(
              controller: _senhaController,
              validator: (text){
                if(text!.isEmpty || text.length < 6) {
                  return "Insira uma senha valida";
                }
                return null;
              },              
              decoration: InputDecoration(
                hintText: "Senha",
              ),
              obscureText: true,
            ),
            
            //Senha2
            TextFormField(
              controller: _confirmarSenhaController,
              validator: (text){
                if(text!.isEmpty || text.length < 6) {
                  return "Insira uma senha válida";
                }
                if(text != _senhaController.text){
                  return "As senhas não são iguais";
                }
                return null;
              },              
              decoration: InputDecoration(
                hintText: "Confirme sua senha",
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            
            //Botao cadastrar
            SizedBox(
              height: 44.00,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: (){
                  if(_formKey.currentState!.validate()){

                  }
                }, 
                child: Text("Cadastrar",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              height: 44.00,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                }, 
                child: Text("Cancelar",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}