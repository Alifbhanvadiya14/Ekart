import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekart/screens/CartScreen/cart.dart';
import 'package:ekart/screens/HomeScreen/home_Screen.dart';
import 'package:ekart/screens/HomeScreen/product_Category.dart';
import 'package:ekart/screens/LoginScreen/login_screen.dart';
import 'package:ekart/screens/ProductDetails/product_details.dart';
import 'package:ekart/services/Auth.dart';
import 'package:ekart/services/firebase_operation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              color: Color(0xFFFFFDD0),
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
              child: Hero(
                tag: snapshot.data[index].data()["ProductId"],
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFD0),
                    //color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2,
                          color: Colors.grey.shade100,
                          spreadRadius: 0),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetails(
                            querydocumentSnapshot: snapshot.data[index],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: 200,
                          child: Image.network(
                            snapshot.data[index].data()["Images"][0],
                            fit: BoxFit.contain,
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
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget productList(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("products").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView(
              //scrollDirection: Axis.vertical,
              physics: PageScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children:
                  snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetails(
                            querydocumentSnapshot: documentSnapshot,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      //color: Colors.red,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFD0),
                        //color: Colors.red,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              color: Colors.grey.shade100,
                              spreadRadius: 0),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                  ),
                );
              }).toList());
        },
      ),
    );
  }

  Widget drawerBody(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            arrowColor: Colors.red,
            accountName: Text(
              Provider.of<FirebaseOperations>(context, listen: false)
                  .getUsername,
              style: TextStyle(fontSize: 16),
            ),
            accountEmail: Text(
              Provider.of<FirebaseOperations>(context, listen: false)
                  .getUserEmail,
              style: TextStyle(fontSize: 16),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(),
                ),
              );
            },
            child: ListTile(
              leading: Icon(CupertinoIcons.home, size: 24),
              title: Text("Home", style: TextStyle(fontSize: 18)),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Cart(),
                ),
              );
            },
            child: ListTile(
              leading: Icon(CupertinoIcons.cart, size: 24),
              title: Text("My Cart", style: TextStyle(fontSize: 18)),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(FontAwesomeIcons.cartArrowDown, size: 24),
              title: Text("My Orders", style: TextStyle(fontSize: 18)),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(CupertinoIcons.person_add, size: 24),
              title: Text("Update Profile", style: TextStyle(fontSize: 18)),
            ),
          ),
          InkWell(
            onTap: () {
              Provider.of<Authentication>(context, listen: false)
                  .signOut()
                  .whenComplete(() async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();

                sharedPreferences.remove("uid");

                sharedPreferences.remove("userEmail");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                );
              });
            },
            child: ListTile(
              leading: Icon(Icons.logout, size: 24),
              title: Text("Logout", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
