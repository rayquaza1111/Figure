import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:shop_app_upd/Components/FeaturedCard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:shop_app_upd/db/carts.dart';
import 'package:shop_app_upd/Pages/Cart/CartPage.dart';
import 'package:shop_app_upd/Pages/Product/rating_comments.dart';
import 'package:badges/badges.dart';

class ProductDetails extends StatefulWidget {

  final String id;
  final String name;
  final List colors;
  final String category;
  final String brand;
  final List images;
  final List sizes;
  final double price;
  final String description;
  String email;
  bool isFavourite;
  int quantity;

  ProductDetails({Key key,this.email,this.id, this.images, this.colors, this.sizes, this.name, this.price, this.description, this.category, this.brand, this.isFavourite, this.quantity}) :super(key : key);

  @override
  _ProductDetails createState() => _ProductDetails();
}

class _ProductDetails extends State<ProductDetails> {

  String _currentColors;
  String _currentSizes;
  String tempId = "";

  int total = 0;

  bool isFavourite = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CartsServices _cartsServices = CartsServices();
  List<DropdownMenuItem<String>> colorsDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> sizesDropDown = <DropdownMenuItem<String>>[];

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getImages();
    getTempId();
    getCurrentUser();
    // getColors();
    // getSizes();
  }

  getCurrentUser() async{
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    setState(() {
      widget.email = _user.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            color: Colors.white.withOpacity(0.9),
            child: Column(
              children: <Widget>[
                //Carousel
                Stack(
                  children: <Widget>[
                    Container(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        child: Carousel(
                            autoplay: false,
                            animationCurve: Curves.fastOutSlowIn,
                            animationDuration: Duration(milliseconds: 1000),
                            dotSize: 3.0,
                            dotBgColor: Colors.grey.withOpacity(0.7),
                            indicatorBgPadding: 20.0,
                            images: getImages()
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(icon: Icon(
                              Icons.arrow_back_ios, color: Colors.black,),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(4),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: InkWell(
                                    onTap: ()async{

                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage(email: widget.email,)));
                                    },
                                    child: StreamBuilder(
                                      stream: Firestore.instance.collection("carts").snapshots(),
                                      builder: (context, snapshot){
                                        if(!snapshot.hasData){
                                          return Text("0");
                                        }else{
                                          return Badge(
                                            badgeContent: _showQuantity(snapshot),
                                            child: Icon(Icons.shopping_cart),
                                            position: BadgePosition.topStart(top:5,start: 15),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isFavourite = !isFavourite;
                                      widget.isFavourite = isFavourite;
                                      _listedFavourite();
                                    });
                                  },
                                  child: widget.isFavourite ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.favorite),
                                  ) : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.favorite_border),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('${widget.name}', style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '\$${widget.price}', textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),),
                      boxShadow: [
                        BoxShadow(color: Colors.white, offset: Offset(2, 5), blurRadius: 10)
                      ]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.all(4.0),
                      //   child: Row(
                      //     children: <Widget>[
                      //       //Select Colors
                      //       Padding(
                      //         padding: const EdgeInsets.all(4.0),
                      //         child: Text('Select Color: ', style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 18.0,
                      //             letterSpacing: 0.5,
                      //             fontWeight: FontWeight.bold),),
                      //       ),
                      //       DropdownButton(
                      //         items: colorsDropDown,
                      //         onChanged: changeSelectedColor,
                      //         value: _currentColors,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(4.0),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: <Widget>[
                      //       Padding(
                      //         padding: const EdgeInsets.all(4.0),
                      //         child: Text('Select Size: ', style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 18.0,
                      //             fontWeight: FontWeight.bold),),
                      //       ),
                      //       DropdownButton(
                      //         items: sizesDropDown,
                      //         onChanged: changeSelectedSize,
                      //         value: _currentSizes,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      //Select Sizes
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: 'Category: ',
                                  style: TextStyle(color: Colors.black,
                                      fontSize: 18.0,
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(text: "${widget
                                  .category} \n\n",
                                style: TextStyle(color: Colors.black,
                                    fontSize: 16.0,
                                    letterSpacing: 1.0),),
                              TextSpan(text: 'Brand: ',
                                  style: TextStyle(color: Colors.black,
                                      fontSize: 18.0,
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(text: "${widget.brand}",
                                style: TextStyle(color: Colors.black,
                                    fontSize: 16.0,
                                    letterSpacing: 1.0),)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 15, 4, 4),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: 'Description: ',
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 18.0,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(text: "${widget.description}",
                                  style: TextStyle(color: Colors.black,
                                      fontSize: 16.0,
                                      letterSpacing: 1.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 20, 4, 4),
                        child: Text("Other Products: ", style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        height: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 15, 4, 4),
                              child: Text("Same Category", style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),),
                            ),
                            Container(
                              height: 200,
                              child: StreamBuilder(
                                stream: Firestore.instance.collection(
                                    "products").snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text("No products exist");
                                  } else {
                                    return GridView.count(
                                        crossAxisCount: 2,
                                        children: getProductsSameCategory(
                                            snapshot)
                                    );
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 15, 4, 4),
                              child: Text("Same Brand", style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),),
                            ),
                            Container(
                              height: 200,
                              child: StreamBuilder(
                                stream: Firestore.instance.collection(
                                    "products").snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text("No products exist");
                                  } else {
                                    return GridView.count(
                                        crossAxisCount: 2,
                                        children: getProductsSameBrand(snapshot)
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(4),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                color: Colors.black,
                child: InkWell(
                    onTap: (){
                      _addProductToCart();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.add_shopping_cart, color: Colors.white,),
                    )
                ),
              )
          ),
          SizedBox(width: 5,),
          Padding(
              padding: const EdgeInsets.all(4),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                color: Colors.black,
                child: InkWell(
                    onTap: () async{
                      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CommentPage(id: widget.id, email: _user.email,name: widget.name,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.comment, color: Colors.white,),
                    )
                ),
              )
          ),
        ],
      ),
    );
  }

  List<Image> getImages() {
    List<Image> items = new List();
    for (int i = 0; i < widget.images.length; i++) {
      setState(() {
        items.add(Image.network(widget.images[i]));
      });
    }
    return items;
  }

  // List<DropdownMenuItem<String>> getColorsDropdown() {
  //   // List<DropdownMenuItem<String>> items1 = new List();
  //   List<DropdownMenuItem<String>> items1 = [];
  //   for (int i = 0; i < widget.colors.length; i++) {
  //     setState(() {
  //       items1.add(
  //           DropdownMenuItem(
  //             child: Text(widget.colors[i]),
  //             value: widget.colors[i],
  //           )
  //       );
  //     });
  //   }
  //   return items1;
  // }
  //
  // List<DropdownMenuItem<String>> getSizesDropdown() {
  //   // List<DropdownMenuItem<String>> items2 = new List();
  //   List<DropdownMenuItem<String>> items2 = [];
  //   for (int i = 0; i < widget.sizes.length; i++) {
  //     setState(() {
  //       _currentSizes = widget.sizes[0];
  //       items2.add(
  //           DropdownMenuItem(
  //             child: Text(widget.sizes[i]),
  //             value: widget.sizes[i],
  //           )
  //       );
  //     });
  //   }
  //   return items2;
  // }

  changeSelectedColor(String selectedColor) {
    setState(() => _currentColors = selectedColor);
  }

  changeSelectedSize(String selectedSize) {
    setState(() => _currentSizes = selectedSize);
  }

  // getColors() {
  //   setState(() {
  //     colorsDropDown = getColorsDropdown();
  //     _currentColors = widget.colors[0];
  //   });
  // }
  //
  // getSizes(){
  //   setState(() {
  //     // sizesDropDown = getSizesDropdown();
  //     _currentSizes = widget.sizes[0];
  //   });
  // }

  getProductsSameCategory(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<DocumentSnapshot> data = new List();
    snapshot.data.documents.map((DocumentSnapshot document) {
      if (document["category"] == widget.category &&
          widget.name != document["name"]) {
        data.add(document);
      }
    }).toList();
      return data.map((DocumentSnapshot item) {
        return FeaturedCard(
            id: item["id"],
            name: item["name"],
            price: item["price"],
            images: item["images"],
            colors: item["colors"],
            brand: item["brand"],
            category: item["category"],
            sizes: item["sizes"],
            image: item["images"][0],
            sale: item["onSale"],
            oldPrice: item["oldPrice"],
            description: item["description"]
        );
      }).toList();
  }

  getProductsSameBrand(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<DocumentSnapshot> data = new List();
    snapshot.data.documents.map((DocumentSnapshot document) {
      if (document["brand"] == widget.brand &&
          widget.name != document["name"]) {
        data.add(document);
      }
    }).toList();
    return data.map((DocumentSnapshot item) {
      return FeaturedCard(
          id: item["id"],
          name: item["name"],
          price: item["price"],
          images: item["images"],
          colors: item["colors"],
          brand: item["brand"],
          category: item["category"],
          sizes: item["sizes"],
          image: item["images"][0],
          sale: item["onSale"],
          oldPrice: item["oldPrice"],
          description: item["description"]
      );
    }).toList();
  }

  _listedFavourite() async {
    var uuid = Uuid();
    String favouriteId = uuid.v1();
    if (isFavourite) {
      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      Firestore.instance.collection("favourite").document(favouriteId).setData({
        "favouriteID": favouriteId,
        "userEmail": _user.email,
        "product": {
          "productId": widget.id,
          "productName": widget.name,
          "productBrand": widget.brand,
          "productCategory": widget.category,
          "productDescription": widget.description,
          "productPrice": widget.price,
          "productColors": widget.colors,
          "productSizes": widget.sizes,
          "productImages": widget.images,
        },
        "isFavourite": isFavourite
      });
    } else {
      Firestore.instance.collection("favourite").document(widget.id).delete();
    }
  }

  _addProductToCart() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    if (widget.id != tempId) {
      setState(() {
        tempId = widget.id;
        widget.quantity = 1;
        Firestore.instance.collection("carts").document(widget.id).setData({
          "cartsId": widget.id,
          "userEmail": _user.email,
          "products": {
            "productId": widget.id,
            "productName": widget.name,
            "productBrand": widget.brand,
            "productColor": _currentColors,
            "productSize": _currentSizes,
            "productPrice": widget.price,
            "productQuantity": widget.quantity,
            "productCost": (widget.quantity * widget.price),
            "productImage": widget.images[0]
          }
        });
      });
      Fluttertoast.showToast(
        msg: "Add to cart successfully",
        fontSize: 16.0,
        textColor: Colors.white,
        webBgColor: Colors.red,
      );
    } else {
      setState(() {
        widget.quantity++;
        Firestore.instance.collection("carts").document(widget.id).updateData({
          "products.productQuantity": widget.quantity,
          "products.productCost": (widget.quantity * widget.price),
        });
      });
      Fluttertoast.showToast(
        msg: "Add to cart successfully",
        fontSize: 16.0,
        textColor: Colors.white,
        webBgColor: Colors.red,
      );
    }
  }

  Widget _showQuantity(AsyncSnapshot<QuerySnapshot> snapshot) {

    List<int> dataCost = new List();
    int temp = 0;
    snapshot.data.documents.forEach((cost){
      if(cost["userEmail"] == widget.email){
        total = cost["products"]["productQuantity"];
        temp = temp + total;
      }
    });
    dataCost.add(temp);
    return Text(dataCost.last.toString());
  }

  getTempId() async {
    List<DocumentSnapshot> data = await _cartsServices.getCarts();
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    data.map((DocumentSnapshot document){
      if(document["userEmail"] == _user.email && document["cartsId"] == widget.id){
        setState(() {
          tempId = widget.id;
          widget.quantity = document["products"]["productQuantity"];
        });
      }
    }).toList();
  }
}




