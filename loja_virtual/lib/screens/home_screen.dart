import 'package:flutter/material.dart';
import '../tabs/home_tab.dart';
import '../widgets/custom_drawer.dart';
import '../tabs/products_tab.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    //PageView - start
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos")
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
        ),
        Container(color: Colors.yellow,),
        Container(color: Colors.green,),
      ],
    );
    //PageView - end
  }
}