import 'package:cloud_firestore/cloud_firestore.dart';

class BrandServices{
  Firestore _fireStore = Firestore.instance;
  String ref = "brands";

  Future<List<DocumentSnapshot>> getBrands() =>
      _fireStore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });

}