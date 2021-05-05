import 'package:carousel_pro/carousel_pro.dart';
import 'package:ekart/screens/CartScreen/cart.dart';
import 'package:ekart/screens/HomeScreen/home_screen_helper.dart';
import 'package:ekart/services/firebase_operation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<FirebaseOperations>(context, listen: false)
        .fetchUserDetails(context);
    Provider.of<FirebaseOperations>(context, listen: false)
        .countCartData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      drawer: HomeScreenHelper().drawerBody(context),
      appBar: AppBar(
        title: Text(
          "Ekart",
          style: TextStyle(
              //color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0.0,
        //backgroundColor: Colors.white,
        actions: [
          Container(
            child: Center(
              child: Stack(
                children: [
                  IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Cart()),
                        );
                      }),
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
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
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
                      AssetImage("assets/images/promotion__one_1.png"),
                      AssetImage("assets/offers/offer_1.jpg"),
                      AssetImage("assets/images/promotion_one.png"),
                      AssetImage("assets/images/promotion_three.png"),
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
              Divider(
                height: 10,
                color: Colors.grey.shade700,
                thickness: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10),
                child: Text(
                  "Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  //color: Colors.red,
                  child: HomeScreenHelper().cateogryList(context),
                ),
              ),
              Divider(
                height: 10,
                color: Colors.grey.shade700,
                thickness: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 16, bottom: 4),
                child: Text(
                  "Trending Products",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: HomeScreenHelper().trendingProduct(context),
                ),
              ),
              Divider(
                height: 10,
                color: Colors.grey.shade700,
                thickness: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 4, top: 8),
                child: Text(
                  "Products",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
      ),
    );
  }
}
