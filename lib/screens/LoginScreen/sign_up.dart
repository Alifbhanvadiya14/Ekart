import 'package:ekart/screens/HomeScreen/home_Screen.dart';
import 'package:ekart/services/Auth.dart';
import 'package:ekart/services/firebase_operation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.2,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: usernameController,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    prefixIcon: Icon(Icons.person),
                    hintText: "Enter Username",
                    enabled: true,
                    hintStyle: TextStyle(fontSize: 16),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    prefixIcon: Icon(Icons.email_sharp),
                    hintText: "Enter Email",
                    enabled: true,
                    hintStyle: TextStyle(fontSize: 16),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: obscureText,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    prefixIcon: Icon(Icons.vpn_key),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() => obscureText = !obscureText);
                        }),
                    hintText: "Enter Password",
                    enabled: true,
                    hintStyle: TextStyle(fontSize: 16),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Provider.of<Authentication>(context, listen: false)
                        .createAccount(
                            emailController.text, passwordController.text)
                        .whenComplete(() {
                      if (Provider.of<Authentication>(context, listen: false)
                              .getErrorMessage ==
                          "") {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .createUser(context, {
                          "username": usernameController.text,
                          "useremail": emailController.text,
                          "useruid": Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid,
                        }).whenComplete(() {
                          print(
                              "${Provider.of<Authentication>(context, listen: false).getUser}");
                          emailController.text = "";
                          passwordController.text = "";
                          usernameController.text = "";
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(),
                            ),
                          );
                        });
                      } else if (Provider.of<Authentication>(context,
                                  listen: false)
                              .getErrorMessage !=
                          "") {
                        final snackBar = SnackBar(
                          content: Text(
                            Provider.of<Authentication>(context, listen: false)
                                .getErrorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Provider.of<Authentication>(context, listen: false)
                            .errorMessage = "";
                      }
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            letterSpacing: 1.5,
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Or",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.blueGrey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Provider.of<Authentication>(context, listen: false)
                        .signInWithGoogle()
                        .whenComplete(() {
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .createUser(context, {
                        "username":
                            Provider.of<Authentication>(context, listen: false)
                                .getUser
                                .displayName,
                        "useremail":
                            Provider.of<Authentication>(context, listen: false)
                                .getUser
                                .email,
                        "useruid":
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid,
                      });
                    }).whenComplete(() {
                      print(
                          "${Provider.of<Authentication>(context, listen: false).getUser}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(),
                        ),
                      );
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/google_icon.png",
                          height: 20,
                          width: 50,
                        ),
                        Text(
                          "Sign In With Google",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an Account? ",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                        fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
