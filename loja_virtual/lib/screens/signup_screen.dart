import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/user_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
 
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _enderecoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("CRIAR CONTA",
        style: TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: Theme.of(context).primaryColor, // Cor de fundo do AppBar
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if (model.isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[

                //Nome
                TextFormField(
                  controller: _nameController,
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
                  controller: _emailController,
                  validator: (String? text) {
                    // Expressão regular para validar e-mail (padrão comum,
                    // garantindo que o domínio de nível superior (TLD) tenha pelo menos 2 caracteres)
                    //.*\@.*\..*
                    final emailRegex = RegExp(r"^\S+@\S+\.\S+$");
                    if (text == null || text.isEmpty || !emailRegex.hasMatch(text)) {
                      return "Insira um e-mail válido";
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
                  controller: _enderecoController,
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

                        Map<String, dynamic> userData = {
                          "name" : _nameController.text,
                          "email" : _emailController.text,
                          "endereco": _enderecoController.text
                        };
                        model.signUp(
                          userData: userData, 
                          pass: _senhaController.text, 
                          onSuccess: _onSuccess, 
                          onFail: _onFail
                        );
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

                //Botao cancelar
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
          );
        })
    ); 
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Usuário criado com sucesso"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

  void _onFail(String errorMessage){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
        ),
      );
    
  }
}