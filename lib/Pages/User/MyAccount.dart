import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  final String email;
  MyAccount({Key key, @required this.email}) : super(key:key);
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Account"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: (){
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage(user: widget.email,)));
            }
          ),
        ],
      ),
    );
  }
}
