class Payment{
  int id;
  String name;

  Payment({this.id, this.name});

  static List<Payment> getPaymentMethod(){
    return <Payment>[
      Payment(id: 1, name: "Payment when receive goods"),
      Payment(id: 2, name: "Payment by using master card"),
      Payment(id: 3, name: "Payment by using internet banking"),
    ];
  }
}