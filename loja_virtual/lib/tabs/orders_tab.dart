import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../screens/login_screen.dart';
import 'dart:async';
import '../tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    if(UserModel.of(context).isloggedIn()){
      String uid = UserModel.of(context).firebaseUser!.uid;

      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("orders")
          .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print("Pedidos encontrados 1: ${snapshot.data?.docs.length}");
            return Center(
              child: CircularProgressIndicator(),
            );
    
          } else {
            print("Pedidos encontrados 2: ${snapshot.data!.docs.length}");
            if (snapshot.data!.docs.isEmpty) {
              return Center(child: Text("Nenhum pedido encontrado."));
            }
            return ListView(
              children: snapshot.data!.docs.map((doc) => OrderTile(doc.id)).toList().reversed.toList(),
            );
          }
        },
      );
    }else{
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.view_list,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 16.0),
            Text("Faça o login para acompanhar seus pedidos",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),                    
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text("Entrar",
                style: TextStyle(fontSize: 18.0,),
              ),
            )
          ],
        ),
      );
    }
  }
}