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
}
