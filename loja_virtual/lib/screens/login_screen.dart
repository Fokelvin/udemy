import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/user_model.dart';

import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final _formKey = GlobalKey<FormState>();

  final _senhaController = TextEditingController();
  final _emailController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ENTRAR",
        style: TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: Theme.of(context).primaryColor, // Cor de fundo do AppBar
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context)=> SignupScreen())
              );
            },
            style: TextButton.styleFrom(
              maximumSize: const Size(120, 40),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text("CRIAR CONTA"),
            )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if(model.isLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
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
                TextFormField(
                  controller: _senhaController,
                  validator: (text){
                    if(text!.isEmpty || text.length < 6) {
                      return "Insira uma senha valida";
                    }
                  },              
                  decoration: InputDecoration(
                    hintText: "Senha",
                  ),
                  obscureText: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: (){
                      if(_emailController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Insira seu e-mail"),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 3),
                          ),
                        ); 
                      }else{
                        model.recoverPass(_emailController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Confira seu e-mail"),
                          backgroundColor: Theme.of(context).primaryColor,
                          duration: Duration(seconds: 3),
                          ),
                        ); 
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Text("Esqueci minha senha",
                      textAlign: TextAlign.right,
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
                      if(_formKey.currentState!.validate()){

                      }
                      model.signIn(
                        email: _emailController.text,
                        pass: _senhaController.text,
                        onSuccess: _onSuccess,
                        onFail: _onFail
                      );
                    }, 
                    child: Text("Entrar",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      )
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail(){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao tentar entrar"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
        ),
      );

  }
}
