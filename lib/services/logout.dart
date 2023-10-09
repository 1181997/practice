import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:practice/login_page.dart';

class logout extends StatelessWidget {
  const logout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: TextButton(onPressed: (){
                FacebookAuth.i.logOut().then((value) {

                });
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
              },
                  child: Text("Log out")),
            )
          ],
        ),
      ),
    );
  }
}
