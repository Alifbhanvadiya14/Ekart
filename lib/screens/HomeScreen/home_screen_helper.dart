import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekart/screens/HomeScreen/product_Category.dart';
import 'package:ekart/services/firebase_operation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreenHelper {
  List texts = [
    "Electronics",
    "Mobile",
    "Appliances",
    "Fashion",
    "Home",
    "Beauty"
  ];

  List images = [
    "assets/category/electronic.png",
    "assets/category/mobiles.png",
    "assets/category/appliances.png",
    "assets/category/fashion.png",
    "assets/category/home.png",
    "assets/category/beauty.png",
  ];

  Widget cateogryList(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryProduct(
                    category: texts[index],
                  ),
                ),
              );
            },
            child: Container(
              //color: Colors.red,
              height: 110,
              width: 80,
              child: Image.asset(
                images[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget trendingProduct(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<FirebaseOperations>(context, listen: false)
          .fetchTrendingData("products"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                //color: Colors.red,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: 220,
                      child: Image.network(
                        snapshot.data[index].data()["Images"][0],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        snapshot.data[index].data()["Name"],
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, top: 4),
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.rupeeSign, size: 16),
                          Text(
                            snapshot.data[index].data()["Price"].toString(),
                            style: TextStyle(
                                color: Colors.red[900],
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget productList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("products").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return GridView(
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            children:
                snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  //color: Colors.red,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Image.network(
                          documentSnapshot.data()["Images"][0],
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          documentSnapshot.data()["Name"],
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, top: 4),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.rupeeSign, size: 16),
                            Text(
                              documentSnapshot.data()["Price"].toString(),
                              style: TextStyle(
                                  color: Colors.red[900],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList());
      },
    );
  }
}

// ListView.builder(
//           //scrollDirection: Axis.horizontal,
//           itemCount: snapshot.data.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: Container(
//                 //color: Colors.red,
//                 height: MediaQuery.of(context).size.height * 0.2,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: MediaQuery.of(context).size.height * 0.1,
//                       child: Image.network(
//                         snapshot.data[index].data()["Images"][0],
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 4.0),
//                       child: Text(
//                         snapshot.data[index].data()["Name"],
//                         style: TextStyle(color: Colors.black, fontSize: 18),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 4.0, top: 4),
//                       child: Row(
//                         children: [
//                           Icon(FontAwesomeIcons.rupeeSign, size: 16),
//                           Text(
//                             snapshot.data[index].data()["Price"].toString(),
//                             style: TextStyle(color: Colors.black, fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
