import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  
  late final IconData icon;
  late final String title; 
  final PageController controller;
  late final int page;
  DrawerTile(this.icon, this.title, this.controller, this.page);


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size:32.0,
                color: controller.page == page.round() ? Theme.of(context).primaryColor : Colors.grey[700],
              ),
              SizedBox(width: 32.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  color: controller.page == page.round() ? Theme.of(context).primaryColor : Colors.grey[700],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}