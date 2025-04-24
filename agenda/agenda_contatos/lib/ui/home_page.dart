import 'dart:io';

import 'package:flutter/material.dart';
import '../helpers/contact_helper.dart';
import 'contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions{
  orderaz,
  orderaza
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{

  ContactHelper helper = ContactHelper();

  List<Contact> contacts = [];

  @override
  void initState(){
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordernar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordernar de Z-A"),
                value: OrderOptions.orderaza,
              ),
            ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index){
            return _contacCard(context, index);
          },

        ),
    );
  }

  Widget _contacCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null ? FileImage(File(contacts[index].img!)) : AssetImage("images/person.jpeg"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Text(contacts[index].name ?? "",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold
                        ),
                    ),
                    Text(contacts[index].email ?? "",
                      style: TextStyle(
                        fontSize: 18.0,
                        ),
                    ),
                    Text(contacts[index].phone ?? "",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                  )
                )
            ],
          ),
        ),
      ),
      onTap: (){
        _showOptions(context, index);
        //_showContactPage(contact: contacts[index]);
      },
    );
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
      context: context, 
      builder: (context){
        return BottomSheet(
          onClosing: (){},
          builder: (context){
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: (){
                         launchUrl(
                          Uri(
                            scheme:'tel', 
                            path: contacts[index].phone,
                            ),
                        );
                      }, 
                      child: Text("Ligar",
                        style: TextStyle(color: Colors.red,
                        fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                        _showContactPage(contact: contacts[index]);
                      },
                      child: Text("Editar",
                        style: TextStyle(color: Colors.red,
                        fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed:(){
                        (contacts[index].id) != null ? helper.deleteContact(contacts[index].id!) : null;
                        setState(() {
                          contacts.removeAt(index);
                          Navigator.pop(context);                          
                        });
                      },
                      child: Text("Excluir",
                        style: TextStyle(color: Colors.red,
                        fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
      }
    );
  }

  void _showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(contact: contact,
        )),
      );
    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);
        _getAllContacts();
      }else{
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts(){
    helper.getAllContacts().then((list){
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        contacts.sort((a, b){
          return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
        });
        break;
      case OrderOptions.orderaza:
        contacts.sort((a, b){
          return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
        });
        break;
    }
    setState(() {
      
    });
  }

}