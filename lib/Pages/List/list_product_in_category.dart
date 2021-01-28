import 'package:flutter/material.dart';
import 'package:shop_app_upd/Components/FeaturedCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListProductsInCategory extends StatefulWidget {
  final String category;
  ListProductsInCategory({Key key, @required this.category}) : super(key:key);
  @override
  _ListProductsInCategoryState createState() => _ListProductsInCategoryState();
}

class _ListProductsInCategoryState extends State<ListProductsInCategory> {
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
              child: Text("No products exist in this category"),
            );
          }else{
            return GridView.count(
              crossAxisCount: 2,
              children: _showProductsInCategory(snapshot),
            );
          }
        }
      ),
    );
  }

  _showProductsInCategory(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<DocumentSnapshot> data = new List();
    snapshot.data.documents.map((DocumentSnapshot document){
      if(document["category"] == widget.category){
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
