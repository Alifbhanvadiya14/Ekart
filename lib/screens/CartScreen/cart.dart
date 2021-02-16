import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekart/services/firebase_operation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyCart",
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
              icon: Icon(Icons.shopping_cart_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 16),
          child: FutureBuilder(
            future: Provider.of<FirebaseOperations>(context, listen: true)
                .fetchCartData(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: Image.asset(
                    "assets/images/empty_shopping_cart.png",
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          showSheet(context, snapshot.data[index]);
                        },
                        child: Container(
                            height: 100,
                            //color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.height / 5,
                                  height: 100,
                                  child: Image.network(
                                    snapshot.data[index].data()["productImage"],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data[index]
                                          .data()["productName"],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: [
                                          Icon(FontAwesomeIcons.rupeeSign,
                                              color: Colors.red[900], size: 16),
                                          Text(" "),
                                          Text(
                                            snapshot.data[index]
                                                .data()["productPrice"]
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.red[900],
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        "Quantity : ${snapshot.data[index].data()["productQuantity"]}",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  showSheet(BuildContext context, QueryDocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Center(
            child: RaisedButton(
              onPressed: () {
                Provider.of<FirebaseOperations>(context, listen: false)
                    .deleteCartData(context, documentSnapshot.data()["docId"])
                    .whenComplete(() {
                  Navigator.pop(context);
                  final snackBar = SnackBar(
                    content: Text(
                      "Item deleted",
                      style: TextStyle(color: Colors.red),
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }).whenComplete(() {
                  Navigator.pop(context);
                });
              },
              child: Text("Delete"),
            ),
          ),
        );
      },
    );
  }
}
