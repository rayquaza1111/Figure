import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartProduct extends StatefulWidget {
  final String name;
  final double price;
  final String brand;
  final String picture;
  int quantity;
  final String size;
  final String color;
  final String cartId;
  final double cost;

  CartProduct({this.quantity, this.price, this.brand, this.name, this.picture, this.size, this.color, this.cartId, this.cost});


  @override
  _CartProductState createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  GlobalKey<FormState> _dialogFormKey = GlobalKey();
  TextEditingController dialogController = TextEditingController();
  @override
  Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context,constraints){
      if(constraints.maxWidth < 350){
        return Container(
            child: ListTile(
              leading: Image.network(widget.picture, width: 50, height: 70,),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0,12,0,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${widget.name}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),),
                    Text("Released by: ${widget.brand} ", style: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                    Row(
                      children: <Widget>[
                        Text("\$${widget.price}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),),
                        SizedBox(width: 5,),
                        IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed: (){
                          if(widget.quantity == 1){
                            setState(() {
                              widget.quantity = 1;
                              widget.quantity = widget.quantity;
                              Firestore.instance.collection("carts").document(widget.cartId).updateData({
                                "products.productQuantity" : widget.quantity,
                                "products.productCost" : widget.quantity * widget.price
                              });
                            });
                          }else{
                            setState(() {
                              widget.quantity--;
                              Firestore.instance.collection("carts").document(widget.cartId).updateData({
                                "products.productQuantity" : widget.quantity,
                                "products.productCost" : widget.quantity * widget.price
                              });
                            });
                          }
                        }),
                        InkWell(
                          onTap: (){
                            _showDialog();
                          },
                          child: Text(widget.quantity.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: (){
                          setState(() {
                            widget.quantity++;
                            Firestore.instance.collection("carts").document(widget.cartId).updateData({
                              "products.productQuantity" : widget.quantity,
                              "products.productCost" : widget.quantity * widget.price
                            });
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              trailing: InkWell(
                  onTap: (){
                    Firestore.instance.collection("carts").document(widget.cartId).delete();
                  },
                  child: Icon(Icons.close)
              ),
            )
        );
      }else if(constraints.maxWidth > 351 && constraints.maxWidth < 410){
        return Container(
            child: ListTile(
              leading: Image.network(widget.picture, width: 50, height: 70,),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0,12,0,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${widget.name}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),),
                    Text("Released by: ${widget.brand} ", style: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                    Row(
                      children: <Widget>[
                        Text("\$${widget.price}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),),
                        SizedBox(width: 5,),
                        IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed: (){
                          if(widget.quantity == 1){
                            setState(() {
                              widget.quantity = 1;
                              widget.quantity = widget.quantity;
                              Firestore.instance.collection("carts").document(widget.cartId).updateData({
                                "products.productQuantity" : widget.quantity,
                                "products.productCost" : widget.quantity * widget.price
                              });
                            });
                          }else{
                            setState(() {
                              widget.quantity--;
                              Firestore.instance.collection("carts").document(widget.cartId).updateData({
                                "products.productQuantity" : widget.quantity,
                                "products.productCost" : widget.quantity * widget.price
                              });
                            });
                          }
                        }),
                        InkWell(
                          onTap: (){
                            _showDialog();
                          },
                          child: Text(widget.quantity.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: (){
                          setState(() {
                            widget.quantity++;
                            Firestore.instance.collection("carts").document(widget.cartId).updateData({
                              "products.productQuantity" : widget.quantity,
                              "products.productCost" : widget.quantity * widget.price
                            });
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              trailing: InkWell(
                  onTap: (){
                    Firestore.instance.collection("carts").document(widget.cartId).delete();
                  },
                  child: Icon(Icons.close)
              ),
            )
        );
      }else if(constraints.maxWidth > 411 && constraints.maxWidth < 500){
        return Container(
            child: ListTile(
              leading: Image.network(widget.picture),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0,12,0,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${widget.name}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),),
                    Text("Released by: ${widget.brand} ", style: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                    Row(
                      children: <Widget>[
                        Text("\$${widget.price}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),),
                        SizedBox(width: 20,),
                        IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed: (){
                          if(widget.quantity == 1){
                            setState(() {
                              widget.quantity = 1;
                              widget.quantity = widget.quantity;
                              Firestore.instance.collection("carts").document(widget.cartId).updateData({
                                "products.productQuantity" : widget.quantity,
                                "products.productCost" : widget.quantity * widget.price
                              });
                            });
                          }else{
                            setState(() {
                              widget.quantity--;
                              Firestore.instance.collection("carts").document(widget.cartId).updateData({
                                "products.productQuantity" : widget.quantity,
                                "products.productCost" : widget.quantity * widget.price
                              });
                            });
                          }
                        }),
                        InkWell(
                          onTap: (){
                            _showDialog();
                          },
                          child: Text(widget.quantity.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: (){
                          setState(() {
                            widget.quantity++;
                            Firestore.instance.collection("carts").document(widget.cartId).updateData({
                              "products.productQuantity" : widget.quantity,
                              "products.productCost" : widget.quantity * widget.price
                            });
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              trailing: InkWell(
                  onTap: (){
                    Firestore.instance.collection("carts").document(widget.cartId).delete();
                  },
                  child: Icon(Icons.close)
              ),
            )
        );
      }else if(constraints.maxWidth > 501){
        return Container(
            child: ListTile(
              leading: Image.network(widget.picture),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0,12,0,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${widget.name}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),),
                    Text("Released by: ${widget.brand} ", style: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                    Row(
                      children: <Widget>[
                        Text("\$${widget.price}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),),
                        SizedBox(width: 20,),
                        IconButton(icon: Icon(Icons.keyboard_arrow_left), onPressed: (){
                          if(widget.quantity == 1){
                            setState(() {
                              widget.quantity = 1;
                              widget.quantity = widget.quantity;
                              Firestore.instance.collection("carts").document(widget.cartId).updateData({
                                "products.productQuantity" : widget.quantity,
                                "products.productCost" : widget.quantity * widget.price
                              });
                            });
                          }else{
                            setState(() {
                              widget.quantity--;
                              Firestore.instance.collection("carts").document(widget.cartId).updateData({
                                "products.productQuantity" : widget.quantity,
                                "products.productCost" : widget.quantity * widget.price
                              });
                            });
                          }
                        }),
                        InkWell(
                          onTap: (){
                            _showDialog();
                          },
                          child: Text(widget.quantity.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: (){
                          setState(() {
                            widget.quantity++;
                            Firestore.instance.collection("carts").document(widget.cartId).updateData({
                              "products.productQuantity" : widget.quantity,
                              "products.productCost" : widget.quantity * widget.price
                            });
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              trailing: InkWell(
                  onTap: (){
                    Firestore.instance.collection("carts").document(widget.cartId).delete();
                  },
                  child: Icon(Icons.close)
              ),
            )
        );
      }else return null;
    },
  );
}
  void _showDialog() {
    var alert = new AlertDialog(
      content: Form(
        key: _dialogFormKey,
        child: TextFormField(
          controller: dialogController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              hintText: "Pick up your quantity"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            setState(() {
              widget.quantity = int.parse(dialogController.text);
              Firestore.instance.collection("carts").document(widget.cartId).updateData({
                "products.productQuantity" : widget.quantity,
                "products.productCost" : widget.quantity * widget.price
              });
            });
            Navigator.pop(context);
            _dialogFormKey.currentState.reset();
          },
          child: Text('OK')),
        FlatButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text('CANCEL')),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }
}




