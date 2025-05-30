import 'package:cloud_firestore/cloud_firestore.dart';
import 'products_data.dart';


class CartProduct {

  String? cid;
  String? category;
  String? pid;
  int? quantity;
  String? size;

  ProductsData? productData;

  CartProduct();
  
  CartProduct.fromDocument(DocumentSnapshot document){

    cid = document.id;
    final data = document.data() as Map<String, dynamic>;
    category = data["category"];
    pid = data["pid"];
    quantity = data["quantity"];
    size = data["size"];


  }

  Map<String, dynamic> toMap(){
    return {
      "category" : category,
      "pid" : pid,
      "quantity" : quantity,
      "size": size,
      //"product" : productData?.toResumeMap()
    };
  }

}