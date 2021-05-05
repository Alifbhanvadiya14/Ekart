import 'package:ekart/services/firebase_operation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

final pincode = TextEditingController();
final address = TextEditingController();
final city = TextEditingController();
final state = TextEditingController();

class AddressDetail extends StatefulWidget {
  @override
  _AddressDetailState createState() => _AddressDetailState();
}

class _AddressDetailState extends State<AddressDetail> {
  Razorpay razorpay;

  @override
  void initState() {
    super.initState();
    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void makePayment() {
    var options = {
      "key": "rzp_test_bJja0AhqBIQ3X5",
      "amount": Provider.of<FirebaseOperations>(context, listen: false)
              .getTotalAmount *
          100,
      "name": "Ecom",
      "description": "Payment for products",
      "prefill": {
        "contact": "+918888888888",
        "email":
            Provider.of<FirebaseOperations>(context, listen: false).getUserEmail
      },
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlePaymentSuccess() {
    print("Payment Success");

    VxToast.show(context, msg: "Payment Success");
  }

  void handlePaymentError() {
    print("Payment Failed");
    VxToast.show(context, msg: "Payment Failed");
  }

  void handleExternalWallet() {
    print("External Wallet");
    VxToast.show(context, msg: "Payment from External Wallet");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: VxAppBar(title: "Address".text.make()),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "Where your Items to be Shipped"
                  .text
                  .xl4
                  .center
                  .color(Colors.grey)
                  .make()
                  .p12(),
              "Pincode".text.xl.make(),
              VxTextField(
                controller: pincode,
                keyboardType: TextInputType.number,
                maxLength: 6,
                borderType: VxTextFieldBorderType.roundLine,
                borderRadius: 14,
                clear: false,
              ).py8(),
              "Locality".text.xl.make(),
              VxTextField(
                controller: address,
                borderType: VxTextFieldBorderType.roundLine,
                borderRadius: 14,
                maxLine: 2,
                clear: false,
              ).py8(),
              "City".text.xl.make(),
              VxTextField(
                controller: city,
                borderType: VxTextFieldBorderType.roundLine,
                borderRadius: 14,
                clear: false,
              ).py8(),
              "State".text.xl.make(),
              VxTextField(
                controller: state,
                borderType: VxTextFieldBorderType.roundLine,
                borderRadius: 14,
                clear: false,
              ).py8(),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    makePayment();
                  },
                  child:
                      "Pay Rs. ${Provider.of<FirebaseOperations>(context, listen: true).getTotalAmount}"
                          .text
                          .xl
                          .make(),
                ),
              ).py8()
            ],
          ).p16(),
        ),
      ),
    );
  }
}
