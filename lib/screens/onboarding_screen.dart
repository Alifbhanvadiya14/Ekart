import 'package:ekart/screens/LoginScreen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IntroductionScreen(
          done: Text(
            "Sign Up",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 18),
          ),
          curve: Curves.easeInCirc,
          dotsDecorator: DotsDecorator(
              size: Size(10, 10),
              activeSize: Size(16, 10),
              spacing: EdgeInsets.all(4),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onDone: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginScreen()));
          },
          onSkip: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginScreen()));
          },
          skip: Text("Skip"),
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,
          next: Text(
            "Next",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
          showNextButton: true,
          pages: [
            pageViewModel(context, "shopping2", "Buy At Your FingerTips"),
            pageViewModel(context, "payment1", "Secure Payment Gateways"),
            pageViewModel(
                context, "delivery3", "Quick Delivery At Your Doorstep"),
          ],
          isProgressTap: false,
        ),
      ),
    );
  }

  pageViewModel(BuildContext context, String image, String title) {
    return PageViewModel(
      image: Image.asset(
        "assets/images/$image.jpg",
        width: MediaQuery.of(context).size.width,
      ),
      title: title,
      body: "Find the best products from popular shops",
      decoration: PageDecoration(
        pageColor: Colors.white,
        imageFlex: 2,
        titleTextStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 24),
        bodyTextStyle: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}