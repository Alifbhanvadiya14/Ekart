import 'package:flutter/material.dart';

class CartCalculations extends ChangeNotifier {
  int productQuantity = 1;
  int get getProductQuantity => productQuantity;

  incrementProductQuantity() {
    productQuantity++;
    notifyListeners();
  }

  decrementProductQuantity() {
    productQuantity--;
    notifyListeners();
  }

  // Future countTotalAmount(BuildContext context) async {
  //   await _firebaseFirestore
  //       .collection("CartData")
  //       .where("userUid",
  //           isEqualTo: Provider.of<Authentication>(context, listen: false)
  //                       .getUserUid ==
  //                   null
  //               ? userUid
  //               : Provider.of<Authentication>(context, listen: false)
  //                   .getUserUid)
  //       .snapshots()
  //       .listen((snapshot) {
  //     snapshot.docs.forEach((doc) {
  //       totalAmount +=
  //           (doc.data()["productQuantity"] * doc.data()["productPrice"]);
  //     });
  //   });

  //   print(totalAmount);
  //   return totalAmount;
  // }
}
