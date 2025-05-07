import 'package:flutter/material.dart';
import '../datas/products_data.dart';

class ProductsTile extends StatelessWidget {
  
  final String type;
  final ProductsData product;

  ProductsTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: type == "grid" ? 
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.8,
              child: Image.network(
                product.images[0],
                fit: BoxFit.cover,
              ),  
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(product.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text("R\$ ${product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
        : Row(),
      ),
    );
  }
}