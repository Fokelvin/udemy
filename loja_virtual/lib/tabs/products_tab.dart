import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../tiles/category.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("products").get(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else{

          var dividedTiles  = ListTile.divideTiles(tiles: snapshot.data!.docs.map(
              (doc){
                return CategoryTile(doc);
              }
            ).toList(),
            color: Colors.grey[500]).toList();
          return ListView(
            children: dividedTiles,
          );
        }
      },
    );
  }
}