import 'package:ekart/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        fontFamily: "Poppins",
        primaryColor: Color(0xFF364FD4),
      ),
      title: 'Ekart',
      home: OnBoardingScreen(),
    );
  }
}
