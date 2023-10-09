import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice/api/product.dart';
import 'package:practice/otp_screen.dart';
import 'package:practice/services/firebase_services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

enum AuthMethod { none, google, facebook }

class LoginPage extends StatefulWidget {
  static String verify = "";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthMethod _authMethod = AuthMethod.none;

  TextEditingController countrycode = TextEditingController();
  var phone = "";

  @override
  void initState() {
    // TODO: implement initState
    countrycode.text = "+91";
    super.initState();
    FacebookAudienceNetwork.init(
      testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
      //iOSAdvertiserTrackingEnabled: true //default false
    );
  }

  facebookLogin() async {
    try {
      final result =
          await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        setState(() {
          _authMethod = AuthMethod.facebook;
        });
        final userData = await FacebookAuth.i.getUserData();
        print(userData);
        print(userData['name']);
        print(userData['email']);
        print(userData['url']);
        //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>logout()));
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background_image.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: 40,
                          child: TextField(
                            controller: countrycode,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          )),
                      Text(
                        "|",
                        style: TextStyle(fontSize: 33, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                        onChanged: (value) {
                          phone = value;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone Number",
                        ),
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Implement Google sign-in
                    await FirebaseServices().signInWithGoogle();
                    setState(() {
                      _authMethod = AuthMethod.google;
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProductList(authMethod: _authMethod)));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    primary: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: Image.asset(
                    'assets/google_logo.png',
                    height: 30, // Adjust the height as needed
                  ),
                  label: Text(
                    'Sign In with Google',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement Facebook sign-in
                    facebookLogin();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProductList(authMethod: _authMethod)));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    primary: Color(0xFF1877F2), // Facebook blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: Image.asset(
                    'assets/facebook_logo.png',
                    height: 30, // Adjust the height as needed
                  ),
                  label: Text(
                    'Sign In with Facebook',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '${countrycode.text + phone}',
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          LoginPage.verify = verificationId;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OTPScreen()));
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Proceed',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    )))));
  }
}
