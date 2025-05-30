import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        shape: CircleBorder(),
      ),
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CartScreen()));
      }, 
      child: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
    );
  }
}