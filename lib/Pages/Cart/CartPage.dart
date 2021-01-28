import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_upd/Components/CartProduct.dart';
import 'package:shop_app_upd/Pages/Cart/checkOutPage.dart';

 class CartPage extends StatefulWidget {
   final String email;
   CartPage({Key key, @required this.email}) : super(key:key);

   @override
   _CartPageState createState() => _CartPageState();
 }

 class _CartPageState extends State<CartPage> {

   double total = 0;

   @override
   Widget build(BuildContext context){
     return Scaffold(
       appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: Text("My Cart", style: TextStyle(color: Colors.deepOrange, fontSize: 20.0, fontWeight: FontWeight.w800),),
          leading: Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.deepOrange,), onPressed: (){
                Navigator.pop(context);
              })
          ),
       ),

       body: SingleChildScrollView(
         child: StreamBuilder(
           stream: Firestore.instance.collection("carts").snapshots(),
           builder: (context,snapshot){
             if(!snapshot.hasData){
               return Text("No products in cart yet!");
             }else{
               return Container(
                 height: 500,
                 child: ListView(
                   scrollDirection: Axis.vertical,
                   shrinkWrap: true,
                   children: _showItemInCart(snapshot),
                 ),
               );
             }
           }
         ),
       ),
       bottomNavigationBar: new Container(
         color: Colors.white,
         child: Row(
           children: <Widget>[
             StreamBuilder(
               stream: Firestore.instance.collection("carts").snapshots(),
               builder: (context, snapshot){
                 if(!snapshot.hasData){
                   return Row(
                     children: <Widget>[
                       Expanded(
                          child: Card(
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text("Total cost", style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(4.0),
                                  child: Text("\$$total", style: TextStyle(color: Colors.black, fontSize: 18.0),),
                              ),
                            ),
                              elevation: 10.0,
                          ),
                        ),
                       Expanded(
                         child: Card(
                           child: new ListTile(
                             onTap: (){
                               Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckOutPage(email: widget.email)));
                             },
                             title: Padding(
                               padding: const EdgeInsets.fromLTRB(39,20,8,0),
                               child: new Text("Check out", style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                             ),
                             subtitle: Text(""),
                           ),
                           elevation: 10.0,
                           color: Colors.red,
                         ),
                       ),
                     ],
                   );
                 }else{
                   return Container(
                     height: 70,
                     width: 400,
                     child: ListView(
                       shrinkWrap: true,
                       children: _showTotalCost(snapshot),
                     ),
                   );
                 }
               }
             ),
           ],
         ),
       ),
     );
   }

   _showItemInCart(AsyncSnapshot<QuerySnapshot> snapshot){
     List<DocumentSnapshot> data = new List();
     for(DocumentSnapshot document in snapshot.data.documents){
       if(document["userEmail"] == widget.email){
         data.add(document);
       }else{
         _noProducts();
       }
     }
     return data.map((DocumentSnapshot document){
       return Container(
         height: 130,
         child: CartProduct(
           name: document["products"]["productName"],
           brand: document["products"]["productBrand"],
           picture: document["products"]["productImage"],
           price: document["products"]["productPrice"],
           color: document["products"]["productColor"],
           quantity: document["products"]["productQuantity"],
           size: document["products"]["productSize"],
           cartId: document["cartsId"],
           cost: document["products"]["productCost"],
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

  _showTotalCost(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<double> dataCost = new List();
    double temp = 0;
    snapshot.data.documents.forEach((cost){
      if(cost["userEmail"] == widget.email){
        total = cost["products"]["productCost"];
        temp = temp + total;
      }
    });
    dataCost.add(temp);
    return dataCost.map((cost)=>_test(cost)).toList();
  }

  Widget _test(double cost){
    return LayoutBuilder(
      builder: (context,constraints){
        if(constraints.maxWidth < 350){
          return Container(
            width: 10,
            height: 70,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Total cost", style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("\$$cost", style: TextStyle(color: Colors.black, fontSize: 18.0),),
                      ),
                    ),
                    elevation: 10.0,
                  ),
                ),
                Expanded(
                  child: Card(
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckOutPage(email: widget.email,)));
                      },
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(20,15,8,0),
                        child: Text("Check out", style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                      ),
                      subtitle: Text(""),
                    ),
                    elevation: 10.0,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        }else if(constraints.maxWidth > 351 && constraints.maxWidth < 410){
          return Container(
            width: 10,
            height: 70,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Total cost", style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("\$$cost", style: TextStyle(color: Colors.black, fontSize: 18.0),),
                      ),
                    ),
                    elevation: 10.0,
                  ),
                ),
                Expanded(
                  child: Card(
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckOutPage(email: widget.email,)));
                      },
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(20,15,8,0),
                        child: Text("Check out", style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                      ),
                      subtitle: Text(""),
                    ),
                    elevation: 10.0,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        }else if(constraints.maxWidth > 411 && constraints.maxWidth < 500){
          return Container(
            width: 10,
            height: 70,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Total cost", style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("\$$cost", style: TextStyle(color: Colors.black, fontSize: 18.0),),
                      ),
                    ),
                    elevation: 10.0,
                  ),
                ),
                Expanded(
                  child: Card(
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckOutPage(email: widget.email,)));
                      },
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(30,15,8,0),
                        child: Text("Check out", style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                      ),
                      subtitle: Text(""),
                    ),
                    elevation: 10.0,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        }else if(constraints.maxWidth > 501){
          return Container(
            width: 10,
            height: 70,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Total cost", style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("\$$cost", style: TextStyle(color: Colors.black, fontSize: 18.0),),
                      ),
                    ),
                    elevation: 10.0,
                  ),
                ),
                Expanded(
                  child: Card(
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckOutPage(email: widget.email,)));
                      },
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(20,15,8,0),
                        child: Text("Check out", style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                      ),
                      subtitle: Text(""),
                    ),
                    elevation: 10.0,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        }else return null;
      },
    );
  }
}



