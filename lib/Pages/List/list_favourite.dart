import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app_upd/Pages/Product/ProductDetails.dart';


class ListProductsFavourite extends StatefulWidget {
  final String email;
  ListProductsFavourite({Key key, @required this.email}) : super(key:key);
  @override
  ListProductsFavouriteState createState() => ListProductsFavouriteState();
}

class ListProductsFavouriteState extends State<ListProductsFavourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepOrange),
        elevation: 0.0,
        title: Text("List your favourite products", style: TextStyle(color:Colors.deepOrange, fontSize: 18.0),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Press icon to unlike ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
              ],
            ),
          ),
          StreamBuilder(
            stream: Firestore.instance.collection("favourite").snapshots(),
            builder: (context,snapshot){
              if(!snapshot.hasData){
                return Text("No products exist");
              }else{
                return ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: showListCategories(snapshot),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  showListCategories(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<DocumentSnapshot> data = new List();
    for(DocumentSnapshot document in snapshot.data.documents){
      if(document["userEmail"] == widget.email){
        data.add(document);
      }else{
        _noProducts();
      }
    }
    return data.map((DocumentSnapshot document){
      return Padding(
              padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10.0,
            child: ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(
                  id: document["product"]["productId"], category: document["product"]["productCategory"], brand: document["product"]["productBrand"],
                  description: document["product"]["productDescription"], images: document["product"]["productImages"], price: document["product"]["productPrice"],
                  colors: document["product"]["productColors"],sizes: document["product"]["productSizes"],
                  name: document["product"]["productName"],isFavourite: document["isFavourite"],
                )));
              },
              leading: Image.network(document["product"]["productImages"][0]),
              title: Text(document["product"]["productName"], style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w800),),
              trailing:
                  IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: (){
                        Firestore.instance.collection("favourite").document(document["favouriteID"]).delete();
                      }
                  ),
              ),
            ),
        );
    }).toList();
  }

  Widget _noProducts(){
    return Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: Container(
            alignment: Alignment.center,
            child: Center(
              child: Text("You haven't favourite products yet"),
            ),
        ),
    );
  }
}


