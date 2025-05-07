import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/category_screen.dart';

class CategoryTile extends StatelessWidget {
  
  late final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(
          (snapshot.data()as Map<String, dynamic>)["icon"],
          ),
      ),
      title: Text(
        (snapshot.data() as Map<String, dynamic>)["title"]),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>  CategoryScreen(snapshot))
        );
      },
    );
  }
}