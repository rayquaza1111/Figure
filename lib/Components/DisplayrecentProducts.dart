import 'package:flutter/material.dart';
import 'package:shop_app_upd/db/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app_upd/Components/recentProducts.dart';

class RecentProducts extends StatefulWidget {
  @override
  _RecentProductsState createState() => _RecentProductsState();
}

class _RecentProductsState extends State<RecentProducts> {
  List<DocumentSnapshot> _products = <DocumentSnapshot>[];
  ProductServices _productServices = ProductServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProducts();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: getProductRecent().map((DocumentSnapshot document){
            return RecentProductsDisplay(
              id: document["id"],
              name: document["name"],
              price: document["price"],
              category: document["category"],
              brand: document["brand"],
              images: document["images"],
              colors: document["colors"],
              sizes: document["sizes"],
              image: document["images"][0],
              oldPrice: document["oldPrice"],
              sale: document["onSale"],
              description: document["description"],
            );
          }).toList()
      ),
    );
  }

  void _getProducts() async{
    List<DocumentSnapshot> data2 = await _productServices.getProducts();
    setState(() {
      _products = data2;
    });
  }
  List<DocumentSnapshot> getProductRecent(){
    List<DocumentSnapshot> items = new List();
    _products.map((DocumentSnapshot document){
      if(document["onSale"] == false && document["featured"] == false){
        setState(() {
          items.add(document);
        });
      }
    }).toList();
    return items;
  }
}
