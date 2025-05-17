import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildBodyBack() => Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 211, 118, 130),
            Color.fromARGB(255, 253, 181, 168),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        )
      ),
    );
    
    return Stack(
      children: <Widget>[
        buildBodyBack(),
        CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Novidades",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection("home").orderBy("pos").get(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,  
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                } else {
                  final docs = snapshot.data!.docs;
                  
                  return SliverToBoxAdapter(
                    child: StaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: List.generate(docs.length, (index) {
                        // Obter valores x e y do Firestore, com valores padrão de 1 se não existirem
                        int x = docs[index]['x'] != null ? (docs[index]['x'] as num).toInt() : 1;
                        int y = docs[index]['y'] != null ? (docs[index]['y'] as num).toInt() : 1;
                        
                        // Garantir que x e y sejam pelo menos 1
                        x = x < 1 ? 1 : x;
                        y = y < 1 ? 1 : y;
                        
                        return StaggeredGridTile.count(
                          crossAxisCellCount: x,
                          mainAxisCellCount: y,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: docs[index]['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }
              },
            ),
          ],
        )
      ],
    );
  }
}