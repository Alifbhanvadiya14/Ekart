import 'package:carousel_pro/carousel_pro.dart';
import 'package:ekart/screens/HomeScreen/home_screen_helper.dart';
import 'package:ekart/screens/LoginScreen/login_screen.dart';
import 'package:ekart/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            icon: Icon(
              Icons.logout,
              //color: Colors.black,
            ),
            onPressed: () {
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
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.blueGrey,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: "Search for products",
                    contentPadding: EdgeInsets.all(6),
                    hintStyle: TextStyle(color: Colors.blueGrey)),
              ),
            ),
            Container(
              height: 180.0,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Carousel(
                  images: [
                    AssetImage("assets/offers/offer_2.jpg"),
                    AssetImage("assets/offers/offer_1.jpg"),
                    AssetImage("assets/offers/offer_3.jpg"),
                  ],
                  boxFit: BoxFit.cover,
                  radius: Radius.circular(12),
                  dotSize: 4.0,
                  dotSpacing: 15.0,
                  dotColor: Colors.lightGreenAccent,
                  indicatorBgPadding: 5.0,
                  // dotBgColor: Colors.purple.withOpacity(0.5),
                  borderRadius: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              //color: Colors.red,
              child: HomeScreenHelper().cateogryList(context),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 16),
              child: Text(
                "Trending Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: HomeScreenHelper().trendingProduct(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: HomeScreenHelper().productList(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
