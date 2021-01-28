import 'package:cloud_firestore/cloud_firestore.dart';

class ProductServices{
  Firestore _fireStore = Firestore.instance;
  String ref = "products";

  Future<List<DocumentSnapshot>> getProducts() =>
      _fireStore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });

}