import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../datas/cart_product.dart';
import '../datas/products_data.dart';
import "../models/cart_model.dart";

class CartTile extends StatelessWidget {

  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  Widget _buildContent(BuildContext context){

    CartModel.of(context).updatePrices();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          width: 120.0,
          child: Image.network(
            cartProduct.productData?.images[0],
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  cartProduct.productData!.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17.0
                  ),
                ),
                Text(
                  "Tamanho ${cartProduct.size}",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text("R\$ ${cartProduct.productData!.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      color: Theme.of(context).primaryColor,
                      onPressed:cartProduct.quantity! > 1 ? (){
                        CartModel.of(context).decProduct(cartProduct);
                      }
                      : null,
                    ),
                    Text(cartProduct.quantity.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      color: Theme.of(context).primaryColor,
                      onPressed:(){
                        CartModel.of(context).incProduct(cartProduct);
                      },
                    ),
                    ElevatedButton(
                      onPressed: (){
                        CartModel.of(context).removedCartItem(cartProduct);
                      }, 
                      child: Text("Remover"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.zero,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProduct.productData == null ?
        FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection("products").doc(cartProduct.category).
          collection("itens").doc(cartProduct.pid).get(),
          builder: (context, snapshot){
            if(snapshot.hasData && snapshot.data !=null ){
              cartProduct.productData = ProductsData.fromDocument(snapshot.data!);
              return _buildContent(context);
            }else{
              return Container(
                height: 70.0,
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              );
            }
          },
        ) : _buildContent(context)
    );
  }
}