import 'package:flutter/material.dart';
import 'package:shop_app_upd/Components/FeaturedCard.dart';
import 'package:shop_app_upd/db/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FeaturedProducts extends StatefulWidget {
  @override
  _FeaturedProductsState createState() => _FeaturedProductsState();
}

class _FeaturedProductsState extends State<FeaturedProducts> {
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
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: getProductFeatured().map((DocumentSnapshot document){
            return FeaturedCard(
              id: document["id"],
              name: document["name"],
              price: document["price"],
              images: document["images"],
              colors: document["colors"],
              brand: document["brand"],
              category: document["category"],
              sizes: document["sizes"],
              image: document["images"][0],
              sale: document["onSale"],
              oldPrice: document["oldPrice"],
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
  List<DocumentSnapshot> getProductFeatured(){
    List<DocumentSnapshot> items = new List();
    _products.map((DocumentSnapshot document){
      if(document["featured"] == true){
        setState(() {
          items.add(document);
        });
      }
    }).toList();
    return items;
  }
}

