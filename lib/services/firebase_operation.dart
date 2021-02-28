import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekart/screens/onboarding_screen.dart';
import 'package:ekart/services/Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FirebaseOperations with ChangeNotifier {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  int count = 0;
  int get getCount => count;

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

  Future submitCartData(String docId, dynamic data) async {
    return _firebaseFirestore.collection("CartData").doc(docId).set(data);
  }

  Stream<QuerySnapshot> fetchCartData(BuildContext context) {
    Stream<QuerySnapshot> _querySnapshot = _firebaseFirestore
        .collection("CartData")
        .where("userUid",
            isEqualTo: Provider.of<Authentication>(context, listen: false)
                        .getUserUid ==
                    null
                ? userUid
                : Provider.of<Authentication>(context, listen: false)
                    .getUserUid)
        .snapshots();

    return _querySnapshot;
  }

  Future deleteCartData(BuildContext context, String docId) async {
    return _firebaseFirestore.collection("CartData").doc(docId).delete();
  }

  void countCartData(BuildContext context) async {
    QuerySnapshot _querySnapshot = await _firebaseFirestore
        .collection("CartData")
        .where("userUid",
            isEqualTo: Provider.of<Authentication>(context, listen: false)
                        .getUserUid ==
                    null
                ? userUid
                : Provider.of<Authentication>(context, listen: false)
                    .getUserUid)
        .get();
    print(_querySnapshot.size);
    count = _querySnapshot.size;
    notifyListeners();
  }
}
