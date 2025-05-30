import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiscountCard extends StatelessWidget {
  DiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text("Cupom desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700]
          ),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom"
              ),
              initialValue: CartModel.of(context).cupomCode ?? "",
              onFieldSubmitted: (text){
                FirebaseFirestore.instance.collection("coupons").doc(text).get().then(
                  (docSnap){
                    if(docSnap.data() != null){
                      CartModel.of(context).setCupom(text, docSnap.data()?["percent"]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Desconto de ${docSnap.data()?["percent"]} % aplicado",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        backgroundColor: Theme.of(context).primaryColor, // Cor de fundo do AppBar
                        duration: Duration(seconds: 3),
                        ),
                      ); 
                    }else{
                      CartModel.of(context).setCupom("", 0);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Cupom não existente",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        backgroundColor: Colors.red, // Cor de fundo do AppBar
                        duration: Duration(seconds: 3),
                        ),
                      ); 
                    }
                  }
                );
              },
            )
          )
        ],
      ),
    );
  }
}