import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekart/services/firebase_operation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          Provider.of<FirebaseOperations>(context, listen: true).getCount > 0
              ? cartButton(context)
              : SizedBox(),
      appBar: AppBar(
        title: Text(
          "MyCart",
          style: TextStyle(
              //color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0.0,
        //backgroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          Container(
            child: Center(
              child: Stack(
                children: [
                  IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
                  Positioned(
                    right: 5,
                    top: 3,
                    child: Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.red),
                      child: Center(
                        child: Text(
                          Provider.of<FirebaseOperations>(context, listen: true)
                              .getCount
                              .toString(),
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      backgroundColor:
          Provider.of<FirebaseOperations>(context, listen: true).getCount > 0
              ? Colors.grey.shade200
              : Colors.white,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 16),
          child: StreamBuilder<QuerySnapshot>(
            stream: Provider.of<FirebaseOperations>(context, listen: true)
                .fetchCartData(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data.docs.isEmpty) {
                return Center(
                  child: Image.asset(
                    "assets/images/empty_shopping_cart.png",
                  ),
                );
              } else {
                return ListView.builder(
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          showSheet(context, snapshot.data.docs[index]);
                        },
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                            //color: Colors.red,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 2,
                                  color: Colors.white,
                                  spreadRadius: 0),
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.height / 5,
                                height: 100,
                                child: Image.network(
                                  snapshot.data.docs[index]
                                      .data()["productImage"],
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      snapshot.data.docs[index]
                                          .data()["productName"],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      children: [
                                        Icon(FontAwesomeIcons.rupeeSign,
                                            color: Colors.red[900], size: 16),
                                        Text(" "),
                                        Text(
                                          snapshot.data.docs[index]
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
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      "Quantity : ${snapshot.data.docs[index].data()["productQuantity"]}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
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

  showSheet(BuildContext context, DocumentSnapshot documentSnapshot) {
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
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .countCartData(context);
                  Navigator.pop(context);
                  final snackBar = SnackBar(
                    elevation: 3.0,
                    duration: Duration(milliseconds: 50),
                    backgroundColor: Theme.of(context).primaryColor,
                    content: Text(
                      "Item deleted",
                      style: TextStyle(color: Colors.white),
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

cartButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: StreamBuilder<QuerySnapshot>(
            stream: Provider.of<FirebaseOperations>(context, listen: true)
                .fetchCartData(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 20,
                  child: CircularProgressIndicator(),
                );
              }
              return Text(
                "Total: \n Rs.${snapshot.data.docs.length > 0 ? snapshot.data.docs.map((e) => e.data()["productQuantity"] * e.data()["productPrice"]).reduce((value, element) => value + element).toString() : "0"}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              );
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.blue,
            ),
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                "Proceed To CheckOut",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
