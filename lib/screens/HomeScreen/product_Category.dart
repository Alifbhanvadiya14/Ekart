import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekart/services/firebase_operation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CategoryProduct extends StatelessWidget {
  final String category;

  const CategoryProduct({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<FirebaseOperations>(context, listen: true)
                  .getCategoryLength >
              0
          ? Colors.grey.shade200
          : Colors.white,
      appBar: AppBar(
        title: Text(category),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 16),
          child: StreamBuilder<QuerySnapshot>(
            stream: Provider.of<FirebaseOperations>(context, listen: false)
                .fetchCategoryProduct(context, category),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data.docs.isEmpty) {
                return Center(
                  child: Image.asset(
                    "assets/images/empty_shopping_cart_image.png",
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
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
                                snapshot.data.docs[index].data()["Images"][0],
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 6),
                                Text(
                                  snapshot.data.docs[index].data()["Name"],
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
                                        snapshot.data.docs[index]
                                            .data()["Price"]
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
                                    "Brand : ${snapshot.data.docs[index].data()["Brand"]}",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              ],
                            )
                          ],
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
}
