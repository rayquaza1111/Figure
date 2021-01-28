import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_upd/Components/paymentMethod.dart';
import 'package:uuid/uuid.dart';
import 'package:shop_app_upd/Pages/Order/myorder.dart';

class CheckOutPage extends StatefulWidget {
  final String email;
  CheckOutPage({Key key, @required this.email}) : super(key:key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Step> steps;
  List<Payment> payments;
  List<DocumentSnapshot> order = new List();
  Payment selectedPayment = Payment();
  double total = 0;
  bool choseMethod = false;
  Uuid orderId = Uuid();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    payments = Payment.getPaymentMethod();
  }

  setSelectedMethod(Payment payment) {
    setState(() {
      choseMethod = true;
      selectedPayment = payment;
    });
  }

  Widget confirmOrder() {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Card(
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Your address", style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),),
                Text(_nameController.text, style: TextStyle(fontSize: 18.0)),
                Text(_phoneController.text, style: TextStyle(fontSize: 18.0)),
                Text(_addressController.text, style: TextStyle(fontSize: 18.0)),
                SizedBox(height: 10,),
                Text("Your payment method", style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0)),
                choseMethod
                    ? Text(
                    selectedPayment.name, style: TextStyle(fontSize: 18.0))
                    : Text(""),
                SizedBox(height: 10,),
                Text("Your cart", style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0)),
                StreamBuilder(
                    stream: Firestore.instance.collection("carts").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("No products in cart yet!");
                      } else {
                        return Container(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: _showItemInCart(snapshot),
                          ),
                        );
                      }
                    }
                ),
                SizedBox(height: 10,),
                Text("Total cost", style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0)),
                StreamBuilder(
                    stream: Firestore.instance.collection("carts").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("0");
                      } else {
                        return Container(
                          height: 40,
                          width: 100,
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
        ),
      ],
    );
  }

  List<Widget> createRadioListPayments() {
    List<Widget> widgets = [];
    for (Payment payment in payments) {
      widgets.add(
          RadioListTile(
            value: payment,
            groupValue: selectedPayment,
            title: Text(payment.name),
            onChanged: (Payment currentPayment) {
              setSelectedMethod(currentPayment);
            },
            selected: selectedPayment == payment,
          ));
    }
    return widgets;
  }

  Widget getNameController() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Your name",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Please fill up your name";
              } else {
                return null;
              }
            },
          ),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: "Your address",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Please fill up your address";
              } else {
                return null;
              }
            },
          ),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: "Your phone",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Please fill up your phone";
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  int currentStep = 0;
  bool complete = false;

  next() {
    currentStep + 1 != steps.length ? goTo(currentStep + 1) : setState(() =>
    complete = true);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() {
      currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text("Check your order", style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 20.0,
            fontWeight: FontWeight.w800),),
        leading: Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.deepOrange,),
                onPressed: () {
                  Navigator.pop(context);
                })
        ),
      ),
      body: Column(
        children: <Widget>[
          complete ? Expanded(
            child: Center(
              child: AlertDialog(
                content: Text("Are you sure to buy these goods?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      setState(() {
                        complete = false;
                        addOrder();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyOrder(email: widget.email)));
                      });
                    },
                  ),
                  FlatButton(
                    child: Text("No"),
                    onPressed: () {
                      setState(() {
                        complete = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          )
              : Expanded(
            child: Stepper(
              steps: steps = [
                Step(
                  title: Text("Your information"),
                  isActive: true,
                  state: StepState.complete,
                  content: getNameController(),
                ),
                Step(
                    title: Text("Payment method"),
                    isActive: false,
                    state: StepState.complete,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: createRadioListPayments(),
                    )
                ),
                Step(
                  title: Text("Confirm your cart"),
                  isActive: false,
                  state: StepState.complete,
                  content: confirmOrder(),
                )
              ],
              currentStep: currentStep,
              onStepContinue: next,
              onStepCancel: cancel,
              onStepTapped: (step) => goTo(step),
            ),
          )
        ],
      ),
    );
  }

  _showItemInCart(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<DocumentSnapshot> data = new List();
    for (DocumentSnapshot document in snapshot.data.documents) {
      if (document["userEmail"] == widget.email) {
        data.add(document);
        order = data;
      } else {
        _noProducts();
      }
    }
    return data.map((DocumentSnapshot document) {
      return Container(
        height: 70,
        child: ListTile(
          leading: Image.network(document["products"]["productImage"]),
          title: Text(document["products"]["productName"],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(document["products"]["productBrand"],
                  style: TextStyle(fontSize: 18.0)),
              Row(
                children: <Widget>[
                  Text(document["products"]["productPrice"].toString(),
                      style: TextStyle(fontSize: 20.0)),
                  SizedBox(width: 5,),
                  Text("x", style: TextStyle(fontSize: 18.0)),
                  SizedBox(width: 5,),
                  Text(document["products"]["productQuantity"].toString(),
                      style: TextStyle(fontSize: 20.0))
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _noProducts() {
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
    snapshot.data.documents.forEach((cost) {
      if (cost["userEmail"] == widget.email) {
        total = cost["products"]["productCost"];
        temp = temp + total;
      }
    });
    dataCost.add(temp);
    return dataCost.map((cost) => _test(cost)).toList();
  }

  Widget _test(double cost) {
    return Container(
      height: 40,
      width: 40,
      child: ListTile(
        title: Text(
          "\$$cost", style: TextStyle(color: Colors.black, fontSize: 18.0),),
      ),
    );
  }

  addOrder() {
    var time = DateTime.now();
    Firestore.instance.collection("orders").document(orderId.v1()).setData({
      "orderId": orderId.v1(),
      "informationPersonal":
      {
        "email": widget.email,
        "name": _nameController.text,
        "phone": _phoneController.text,
        "address": _addressController.text,
        "paymentMethod": selectedPayment.name
      },
      "products": order.map((DocumentSnapshot document) =>
      {
        "name": document["products"]["productName"],
        "price": document["products"]["productPrice"],
        "quantity": document["products"]["productQuantity"],
        "size": document["products"]["productSize"],
        "cost": document["products"]["productCost"],
        "color": document["products"]["productColor"],
        "image": document["products"]["productImage"],
        "brand": document["products"]["productBrand"]
      }
      ).toList(),
      "status": false,
      "time": time
    });
  }
}