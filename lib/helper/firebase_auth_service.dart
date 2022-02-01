import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glare_user_app/helper/profile_data.dart';
import 'package:glare_user_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:glare_user_app/screens/sign_in/sign_in_screen.dart';
import 'package:glare_user_app/screens/user/usermain.dart';
import '../constants.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: Center(
                  child: CircularProgressIndicator(
                color: c1,
              )),
            );
          }
          if (snapshot.hasData) {
            return body();
          }
          return SignInScreen();
          //return MapView();
        });
  }

  Widget body() {
    Profile profile = new Profile(
        FirebaseAuth.instance.currentUser!.email,
        FirebaseAuth.instance.currentUser!.uid,
        "null",
        "null",
        "null",
        "null",
        "null",
        "null",
        "null",
        "null",
        "null",
    "null");

    var stream = FirebaseFirestore.instance
        .collection("Userdata")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return StreamBuilder(
        stream: stream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if(snapshot.connectionState==ConnectionState.waiting){
            return Container(
              color: Colors.white,
              child: Center(
                  child: Container(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: c1,
                    ),
                  )),
            );
          }

          if(snapshot.data!.data().toString()=="null"){
           return CompleteProfileScreen(profile: profile);

          }

          if(snapshot.data!.data().toString()!="null"){
            return UserMain();

          }

          return Container(
            color: Colors.white,
            child: Center(
                child: Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: c1,
                  ),
                )),
          );

        });
  }
}
