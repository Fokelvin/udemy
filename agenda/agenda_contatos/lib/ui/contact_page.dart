import 'dart:io';

import 'package:flutter/material.dart';
import '../helpers/contact_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact? contact;

  ContactPage({this.contact});

  @override
  State<ContactPage> createState() => __ContactPageState();
}

class __ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _nameFocus = FocusNode();
  bool _userEdited = false;
  late Contact _edditContact;

  @override
  void initState(){
    super.initState();

    if(widget.contact == null){
      _edditContact = Contact();
    }else{
      _edditContact = Contact.fromMap(widget.contact?.toMap() ?? {});
    }

    _nameController.text = _edditContact.name ?? "";
    _phoneController.text = _edditContact.phone ?? "";
    _emailController.text = _edditContact.email ?? "";
    
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_edditContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
          onPressed: (){
            if(_edditContact.name != null && _edditContact.name!.isNotEmpty){
              Navigator.pop(context, _edditContact);
            }else{
              FocusScope.of(context).requestFocus(_nameFocus);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Campo Nome obrigatório"),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _edditContact.img != null ? FileImage(File(_edditContact.img!)) : AssetImage("images/person.jpeg"),
                    ),
                  ),
                ),
                onTap: () async{
                  final file = await ImagePicker().pickImage(source: ImageSource.camera);
                    if(file == null){
                      return;
                    }
                    setState(() {
                      _edditContact.img = file.path;
                    });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(
                  labelText: "Nome",
                ),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _edditContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "E-mail",
                ),
                onChanged: (text){
                  _userEdited = true;
                  _edditContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Telefone",
                ),
                onChanged: (text){
                  _userEdited = true;
                  _edditContact.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],),
        ),
      ),
    );
  }

  Future<bool> _requestPop() async {
    if (_userEdited) {
      final shouldLeave = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Descartar Alterações?"),
            content: Text("Se sair, as alterações serão perdidas!"),
            actions: <Widget>[
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context, false); // Return false
                },
              ),
              TextButton(
                child: Text("Sair"),
                onPressed: () {
                  Navigator.pop(context, true); // Return true
                },
              ),
            ],
          );
        },
      );
      return shouldLeave ?? false; // Default to false if null
    }
    return true; // Allow navigation if no edits were made
  }
}