import 'package:flutter/material.dart';


class CartCalculations extends ChangeNotifier {
  int cartData = 0;
  int get getCartData => cartData;

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

  // addToCart(BuildContext context, dynamic data, String docId) async {
  //   cartData++;
  //   await Provider.of<FirebaseOperations>(context, listen: false)
  //       .submitCartData(docId, data);
  //   print(cartData);
  //   notifyListeners();
  // }

  // deleteCartItem(BuildContext context, String docId) async {
  //   await Provider.of<FirebaseOperations>(context, listen: false)
  //       .deleteCartData(context, docId);
  //   cartData--;
  //   print(cartData);
  //   notifyListeners();
  // }
}
