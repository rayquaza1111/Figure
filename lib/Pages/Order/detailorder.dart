import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Product{
  List products;
  Product.fromMap(Map<String,dynamic> data){
    products = data['products'];
  }
}

class ProductR{
  List products = new List();
  ProductR.fromSnapshot(DocumentSnapshot snapshot)
      : products = List.from(snapshot["products"]);
}

class DetailOrder extends StatefulWidget {
  final String orderId;
  DetailOrder({Key key, @required this.orderId}) : super(key:key);
  @override
  _DetailOrderState createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  double totalCost = 0;
  double temp = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text("Detail Order", style: TextStyle(color: Colors.deepOrange, fontSize: 20.0, fontWeight: FontWeight.w800),),
        leading: Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.deepOrange,), onPressed: (){
              Navigator.pop(context);
            })
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: StreamBuilder(
          stream: Firestore.instance.collection("orders").snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Text("No");
            }else{
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: _showDetail(snapshot),
              );
            }
          }
        ),
      )
    );
  }

  _showDetail(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<DocumentSnapshot> data = new List();
    for(DocumentSnapshot document in snapshot.data.documents){
      if(document["orderId"] == widget.orderId){
        data.add(document);
      }else{
        _noProducts();
      }
    }
    return data.map((DocumentSnapshot document){
      return Column(
        children: <Widget>[
          Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Information Personal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                  Text(document["informationPersonal"]["name"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                  SizedBox(height: 10,),
                  Text("Your payment method",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  Text(document["informationPersonal"]["paymentMethod"], style: TextStyle(fontSize: 18.0)),
                  SizedBox(height: 10,),
                  Text("Your products",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  Column(
                    children: ProductR.fromSnapshot(document).products.map((product)=>
                        ListTile(
                          leading: Image.network(product["image"]),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Name: ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                                  Text(product["name"],style: TextStyle(fontSize: 18.0)),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text("Released by: ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                                  Text(product["brand"],style: TextStyle(fontSize: 18.0)),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Text(product["price"].toString(),style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                              SizedBox(width: 5,),
                              Text("X",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                              SizedBox(width: 5,),
                              Text(product["quantity"].toString(),style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
                            ],
                          ),
                        )
                    ).toList(),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Text("Total cost: ",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  Container(
                    height: 20,
                    width: 70,
                    child: ListView(
                      children: <Widget>[
                        _totalCost(document)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  _totalCost(DocumentSnapshot document) {
    ProductR.fromSnapshot(document).products.map((product){
      temp = product["cost"];
      totalCost = totalCost + temp;
    }).toList();
    return Text(totalCost.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),);
  }
}
