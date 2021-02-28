import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekart/screens/CartScreen/cart.dart';
import 'package:ekart/screens/onboarding_screen.dart';
import 'package:ekart/services/Auth.dart';
import 'package:ekart/services/cart_calculation.dart';
import 'package:ekart/services/firebase_operation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

var uid;
String docId;

class ProductDetails extends StatelessWidget {
  final QueryDocumentSnapshot querydocumentSnapshot;

  const ProductDetails({Key key, this.querydocumentSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("Ekart",
            style: TextStyle(
                //color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0.0,
        //backgroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Cart()),
                );
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              transitionOnUserGestures: true,
              tag: querydocumentSnapshot.data()["ProductId"],
              child: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Carousel(
                    images: [
                      NetworkImage(querydocumentSnapshot.data()["Images"][0]),
                      NetworkImage(querydocumentSnapshot.data()["Images"][1]),
                      //NetworkImage(querydocumentSnapshot.data()["Images"][2]),
                    ],
                    boxFit: BoxFit.contain,
                    autoplay: false,
                    dotBgColor: Colors.transparent,
                    dotSize: 5.0,
                    dotSpacing: 15.0,
                    dotColor: Colors.black,
                    indicatorBgPadding: 5.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    querydocumentSnapshot.data()["Name"],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            // Provider.of<CartCalculations>(context,
                            //                 listen: false)
                            //             .getCartData >
                            //         1
                            //     ?
                            Provider.of<CartCalculations>(context,
                                    listen: false)
                                .decrementProductQuantity();
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            color: Colors.blueGrey.withOpacity(0.2),
                            child: Center(
                              child: Icon(FontAwesomeIcons.minus, size: 16),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            Provider.of<CartCalculations>(context, listen: true)
                                .getProductQuantity
                                .toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Provider.of<CartCalculations>(context,
                                    listen: false)
                                .incrementProductQuantity();
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            color: Colors.blueGrey.withOpacity(0.3),
                            child: Center(
                              child: Icon(FontAwesomeIcons.plus, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.rupeeSign,
                        size: 22,
                        color: Colors.red[900],
                      ),
                      Text(
                        querydocumentSnapshot.data()["Price"].toString(),
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.red[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 22,
                          color: Colors.yellow[700],
                        ),
                        Text(
                          " 4.5",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  docId = Provider.of<Authentication>(context, listen: false)
                              .getUserUid ==
                          null
                      ? userUid + querydocumentSnapshot.data()["ProductId"]
                      : Provider.of<Authentication>(context, listen: false)
                              .getUserUid +
                          querydocumentSnapshot.data()["ProductId"];
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .countCartData(context);
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .submitCartData(docId, {
                    "docId": docId,
                    "userUid": Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid ==
                            null
                        ? userUid
                        : Provider.of<Authentication>(context, listen: false)
                            .getUserUid,
                    "productId": querydocumentSnapshot.data()["ProductId"],
                    "productImage": querydocumentSnapshot.data()["Images"][0],
                    "productName": querydocumentSnapshot.data()["Name"],
                    "productPrice": querydocumentSnapshot.data()["Price"],
                    "productQuantity":
                        Provider.of<CartCalculations>(context, listen: false)
                            .getProductQuantity
                  }).whenComplete(() {
                    final snackBar = SnackBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Text(
                        "Item Added to Cart",
                        style: TextStyle(color: Colors.white),
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      Text(
                        " Add to Wishlist",
                        style: TextStyle(
                            letterSpacing: 1.5,
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Divider(
                thickness: 4,
                color: Colors.grey.shade500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                "Brand : ${querydocumentSnapshot.data()["Brand"]}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                "Category : ${querydocumentSnapshot.data()["Category"]}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Divider(
                thickness: 4,
                color: Colors.grey.shade500,
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
