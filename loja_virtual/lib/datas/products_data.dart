import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsData {
  
  String? category;
  late String id;
  late String title;
  late String description;
  late double price;
  late List images;
  late List sizes;

  ProductsData.fromDocument(DocumentSnapshot snapshot){

    id = snapshot.id; // Use 'id' instead of 'documentID'
    final data = snapshot.data() as Map<String, dynamic>;
    //print("Dados do snapshot: $data");    
    title = data["title"] ?? " Titulo nao carregado";
    description = data["description"]?? " Description nao carregado";
    price = data["price"]?? " Preco nao carregado";
    images = data["images"]?? " Imagem nao carregada";
    sizes = data["sizes"]?? " Tamanhos nao carregado";

  }

  Map<String, dynamic> toResumeMap(){
    return {
      "title": title,
      "description": description,
      "price": price
    };
  }
}