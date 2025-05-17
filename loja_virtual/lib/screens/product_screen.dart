import 'package:flutter/material.dart';
import '../datas/products_data.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductScreen extends StatefulWidget {

final ProductsData product;

const ProductScreen(this.product, {super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductsData product;
  int _currentIndex = 0;

  String? size;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title,
        ),
        centerTitle: true,
        backgroundColor: primaryColor, // Cor de fundo do AppBar
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(aspectRatio: 1,
          child: CarouselSlider(
              items: product.images.map((url){
                return Builder(
                  builder: (BuildContext context){
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 300.0,
                autoPlay: false,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                onPageChanged: (index, reason){
                  setState(() {
                    _currentIndex = index;
                  });
                },
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(product.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor
                  ),
                ),
                SizedBox(height: 16.0,),
                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,
                    ),
                    children: product.sizes.map(
                      (s){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              size = s;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                color: s == size ? primaryColor: Colors.grey,
                                width: 4.0,
                              ),
                            ),
                            width: 50,
                            alignment: Alignment.center,
                            child: Text(s),
                          ),
                        );
                      }
                    ).toList()
                  ),
                ),
                SizedBox(height: 16.0,),
                SizedBox(
                  height: 44.0,
                  child: ElevatedButton(
                    onPressed: size != null ?(){

                    }: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      )
                    ),
                    child: Text("Adicionar ao Carrinho",
                      style: TextStyle(
                        fontSize: 18.0 
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16,),
                Text(
                  "Descrição",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}