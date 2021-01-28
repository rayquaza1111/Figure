import 'package:cloud_firestore/cloud_firestore.dart';

class CartsServices{
  Firestore _fireStore = Firestore.instance;
  String ref = "carts";

  Future<List<DocumentSnapshot>> getCarts() =>
      _fireStore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });

}