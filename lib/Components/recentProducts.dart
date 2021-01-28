import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_upd/Pages/Product/ProductDetails.dart';

class RecentProductsDisplay extends StatelessWidget {
  final String id;
  final String name;
  final List colors;
  final String category;
  final String brand;
  final List images;
  final String image;
  final List sizes;
  final double price;
  final double oldPrice;
  final bool sale;
  final String description;
  RecentProductsDisplay({this.id, this.images, this.colors, this.sizes, this.name, this.price, this.image, this.oldPrice, this.sale, this.description, this.category, this.brand});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          Card(
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                    ProductDetails(id: id, name: name, sizes: sizes, colors: colors, price: price,
                      images: images, description: description, brand: brand,category: category, isFavourite: false,)));
              },
              child: ListTile(
                leading: Image.network(
                  image,
                  width: 70,
                  height: 120,
                  fit: BoxFit.fitHeight,
                ),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "$name\n", style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold)),
                      TextSpan(text: "Released by: $brand\n", style: TextStyle(color: Colors.grey, fontSize:  17.0, fontWeight: FontWeight.bold)),
                      TextSpan(text: "\$$price", style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


