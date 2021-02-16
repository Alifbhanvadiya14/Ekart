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
      appBar: AppBar(
        title: Text(category),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 16),
          child: FutureBuilder(
            future: Provider.of<FirebaseOperations>(context, listen: false)
                .fetchCategoryProducts(category),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.height / 5,
                              height: 150,
                              child: Image.network(
                                snapshot.data[index].data()["Images"][0],
                                fit: BoxFit.cover,
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
                                  snapshot.data[index].data()["Name"],
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
                                    "Brand : ${snapshot.data[index].data()["Brand"]}",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ));
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
