import 'package:flutter/material.dart';
import 'package:shop_app_upd/Components/FeaturedCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListProductsInBrand extends StatefulWidget {
  final String brand;
  ListProductsInBrand({Key key, @required this.brand}) : super(key:key);
  @override
  _ListProductsInBrandState createState() => _ListProductsInBrandState();
}

class _ListProductsInBrandState extends State<ListProductsInBrand> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepOrange),
        elevation: 0.0,
        title: Text("List of Products", style: TextStyle(color:Colors.deepOrange, fontSize: 18.0),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("products").snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Center(
                child: Text("No products exist in this brand"),
              );
            }else{
              return GridView.count(
                crossAxisCount: 2,
                children: _showProductsInBrand(snapshot),
              );
            }
          }
      ),
    );
  }

  _showProductsInBrand(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<DocumentSnapshot> data = new List();
    snapshot.data.documents.map((DocumentSnapshot document){
      if(document["brand"] == widget.brand){
        data.add(document);
      }
    }).toList();
    return data.map((DocumentSnapshot document){
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
    }).toList();

  }
}
