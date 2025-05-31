import 'package:flutter/material.dart';
import '../tabs/home_tab.dart';
import '../widgets/custom_drawer.dart';
import '../tabs/products_tab.dart';
import '../widgets/cart_button.dart';
import '../tabs/orders_tab.dart';
import '../tabs/places_tabs.dart';

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
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos")
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus pedidos"),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageController),
        )
      ],
    );
    //PageView - end
  }
}