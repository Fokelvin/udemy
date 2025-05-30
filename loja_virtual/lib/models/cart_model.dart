import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import '../datas/cart_product.dart';
import 'user_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CartModel extends Model{

  UserModel user;
  List<CartProduct> products = [];
  bool isLoading = false;

  String? cupomCode;
  int discountPercenter = 0;

  CartModel(this.user){
    if(user.isloggedIn()){
      _loadcartItens();
    }
  }


  static CartModel of(BuildContext context) =>
    ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){

    products.add(cartProduct);

    FirebaseFirestore.instance.collection("users")
    .doc(user.firebaseUser!.uid)
    .collection("cart")
    .add(cartProduct.toMap()).then((doc){
      cartProduct.cid = doc.id;
    });
    notifyListeners();
  }

  void removedCartItem(CartProduct cartProduct){

    FirebaseFirestore.instance.collection("users")
    .doc(user.firebaseUser!.uid)
    .collection("cart")
    .doc(cartProduct.cid).delete();

    products.remove(cartProduct);
    
    notifyListeners();
  }

    void incProduct(CartProduct){
      CartProduct.quantity++;
      FirebaseFirestore.instance.collection("users").doc(user.firebaseUser?.uid).
      collection("cart").doc(CartProduct.cid).update(CartProduct.toMap());
      print("Atualizei firebase adicionando");
      notifyListeners();
  }

  void decProduct(CartProduct){
    CartProduct.quantity--;
    FirebaseFirestore.instance.collection("users").doc(user.firebaseUser?.uid).
    collection("cart").doc(CartProduct.cid).update(CartProduct.toMap());

    print("Atualizei firebase removendo");
    notifyListeners();
  }

  void _loadcartItens() async {

    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(user.firebaseUser?.uid).collection("cart").get();

    products = query.docs.map(
      (doc) => CartProduct.fromDocument(doc)
    ).toList();

    notifyListeners();
  }

  void setCupom(String coupomCode, int discountPercenter){
    this.cupomCode = cupomCode;
    this.discountPercenter = discountPercenter;
  }

  double getProductPrice(){

    double price = 0.0;

    for(CartProduct c in products){
      if(c.productData != null){
        price += (c.quantity! * c.productData!.price);
      }
    }
    return price;

  }

  double getDiscount(){
    return getProductPrice() * discountPercenter /100;
  }

  double getShipPrice(){
    return 9.99;
  }

  void updatePrices(){
    notifyListeners();
  }

  Future<String?> finishOrder()async{

    if (user.firebaseUser?.uid == null) {
      print('Usuário não autenticado');
      return null;
    }
    
    if(products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double prodcutsPrice = getProductPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await FirebaseFirestore.instance.collection("orders").add(
      {
        "clientId": user.firebaseUser!.uid,
        "products": products.map(
          (cartProduct) => cartProduct.toMap()).toList(),
        "price": shipPrice,
        "productsPrice": prodcutsPrice,
        "discount": discount,
        "totalPrice" : prodcutsPrice - discount + shipPrice,
        "status": 1
      }
    );

    await FirebaseFirestore.instance.collection("users").doc(user.firebaseUser!.uid)
    .collection("orders").doc(refOrder.id).set(
      {
        "orderId": refOrder.id
      }
    );

    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(user.firebaseUser!.uid)
    .collection("cart").get();

    for(DocumentSnapshot doc in query.docs){
      doc.reference.delete();
    }

    products.clear();

    cupomCode = null;
    discountPercenter = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.id;

  }

}