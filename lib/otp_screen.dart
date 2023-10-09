import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:practice/api/product.dart';
import 'package:practice/login_page.dart';

class OTPScreen extends StatelessWidget {
  AuthMethod _authMethod = AuthMethod.none;
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                autoFocus: true,
                autoDisposeControllers: true,
                cursorColor: Colors.black,
                enablePinAutofill: true,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                ),
                animationDuration: Duration(milliseconds: 300),
                controller: otpController,
                keyboardType: TextInputType.number,
                onCompleted: (v) {
                  print("Completed");
                },
                onChanged: (value) {
                  print(value);
                },
              ),
            ),

          ),
          ElevatedButton(
            onPressed: () async {
// Verify OTP
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: LoginPage.verify,
                smsCode: otpController.text,
              );

              UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

// If sign-in was successful, navigate to the Product page
              if (userCredential.user != null) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProductList(authMethod: _authMethod)));
              }
            },
            child: Text('Verify'),
          ),
        ],
      ),
    );
  }
}

