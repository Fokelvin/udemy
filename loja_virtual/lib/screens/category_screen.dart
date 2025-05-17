import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../datas/products_data.dart';
import '../tiles/products_tile.dart';

class CategoryScreen extends StatelessWidget {
  
  final DocumentSnapshot snapshot;

  const CategoryScreen(this.snapshot, {super.key});

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data() as Map<String, dynamic>; // Explicitly cast data to Map<String, dynamic>
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(data["title"]),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(icon:Icon(Icons.grid_on),),
              Tab(icon:Icon(Icons.list),),
            ]
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection("products").doc(snapshot.id).collection("itens").get(),
          builder: (context, snapshot){

            print("Snapshot Connection State: ${snapshot.connectionState}");
            print("Snapshot Has Data: ${snapshot.hasData}");
            print("Snapshot Data: ${snapshot.data?.docs}");
            if(!snapshot.hasData){
              return Center(
                child: Container(
                  height: 200.0,  
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            }else{
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  GridView.builder(
                    padding: EdgeInsets.all(4.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 0.65
                    ),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index){
                      print("Grid Item $index: ${snapshot.data!.docs[index].data()}");
                      return ProductsTile("grid", ProductsData.fromDocument(snapshot.data!.docs[index]));
                    }
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(4.0),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index){
                      print("List Item $index: ${snapshot.data!.docs[index].data()}");
                      return ProductsTile("list", ProductsData.fromDocument(snapshot.data!.docs[index]));
                      //return Text("Item $index");
                    }
                  )
                ],
              );
            }
          }
        ),
      ),
    );
  }
}