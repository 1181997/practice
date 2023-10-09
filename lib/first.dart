import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice/login_page.dart';
import 'package:practice/services/firebase_services.dart';

class first extends StatefulWidget {
  const first({super.key});

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(FirebaseAuth.instance.currentUser!.photoURL!),
              SizedBox(height: 5,),
              Text("${FirebaseAuth.instance.currentUser!.displayName}"),
              Text("${FirebaseAuth.instance.currentUser!.email}"),
              SizedBox(height: 15,),
              Center(
                child: ElevatedButton(onPressed: () async{
                  await FirebaseServices().signOut();
                 // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginPage()));
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
                },
                    child: Text("Sign Out")),
              )
            ],
          ),
        ),
    );
  }
}
