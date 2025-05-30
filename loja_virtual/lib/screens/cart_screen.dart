import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import '../models/cart_model.dart';
import '../models/user_model.dart';
import 'login_screen.dart';
import '../tiles/cart_tile.dart';
import '../widgets/discount_card.dart';
import '../widgets/ship_card.dart';
import '../widgets/cart_price.dart';

class CartScreen extends StatelessWidget {
  

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MEU CARRINHO",
          style: TextStyle(
            color: Colors.white,
        ),
      ),
        backgroundColor: Theme.of(context).primaryColor, // Cor de fundo do AppBar
        centerTitle: true,
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8.0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                int p = model.products.length;
                return Text(
                  "${p ?? 0} ${p == 1 ? "ITEM" : "ITENS"}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                  ),
                );
              }
              ),
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (contexto, child, model){
          if(model.isLoading && UserModel.of(context).isloggedIn()){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(!UserModel.of(context).isloggedIn()){
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.remove_shopping_cart,
                      size: 80.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 16.0),
                    Text("Faça o login para adicionar produtos",
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
            // ignore: unnecessary_null_comparison
            }else if(model.products == null || model.products.isEmpty ){
              return Center(
                child: Text("Nenhum produto no carrinho",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }else{
              return ListView(
                children: <Widget>[
                  Column(
                    children: model.products.map(
                      (products){
                        return CartTile(products);
                      }
                    ).toList(),
                  ),
                  DiscountCard(),
                  ShipCard(),
                  CartPrice(
                    (){}
                  ),
                ],
              );
            }
          }
        ),
    );
  }
}