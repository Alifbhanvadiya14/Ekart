import 'package:ekart/screens/LoginScreen/login_screen.dart';
import 'package:ekart/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../onboarding_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Provider.of<Authentication>(context, listen: false)
                    .signOut()
                    .whenComplete(
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoginScreen(),
                        ),
                      ),
                    );
              })
        ],
      ),
      body: Center(
          child:
              Provider.of<Authentication>(context, listen: false).getUserUid ==
                      null
                  ? Text(userUid)
                  : Text(Provider.of<Authentication>(context, listen: false)
                      .getUserUid)),
    );
  }
}
