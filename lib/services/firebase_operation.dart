import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekart/services/Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FirebaseOperations with ChangeNotifier {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future createUser(BuildContext context, dynamic data) async {
    return _firebaseFirestore
        .collection("users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future fetchTrendingData(String collection) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection(collection)
        .where("Trending", isEqualTo: true)
        .get();

    return querySnapshot.docs;
  }

  Future fetchProducts(String collection) async {
    QuerySnapshot querySnapshot =
        await _firebaseFirestore.collection(collection).get();

    return querySnapshot.docs;
  }

  Future fetchCategoryProducts(String category) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection("products")
        .where("Category", isEqualTo: category)
        .get();

    return querySnapshot.docs;
  }
}
