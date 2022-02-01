import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glare_user_app/screens/sign_in/sign_in_screen.dart';
import 'package:glare_user_app/screens/user/Edit_profile_info/Editprofileinfo.dart';
import 'package:glare_user_app/screens/user/Wishlist/wishlist.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  // final uid = FirebaseAuth.instance.currentUser!.uid;
  // final email = FirebaseAuth.instance.currentUser!.email;
  // final creationTime = FirebaseAuth.instance.currentUser!.metadata.creationTime;
  // User? user = FirebaseAuth.instance.currentUser;
  //
  // verifyEmail() async {
  //   if (user != null && !user!.emailVerified) {
  //     await user!.sendEmailVerification();
  //     print('Verification Email has benn sent');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.orangeAccent,
  //         content: Text(
  //           'Verification Email has benn sent',
  //           style: TextStyle(fontSize: 18.0, color: Colors.black),
  //         ),
  //       ),
  //     );
  //   }
  // }
  String? firstname,lastname,gender,email,phoneNumber;
  //final gsignin=GoogleSignIn();
  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark
    ));


    FirebaseAuth auth=FirebaseAuth.instance;
    var stream=FirebaseFirestore.instance.collection("Userdata").doc(auth.currentUser!.uid);


    return StreamBuilder(
      stream: stream.snapshots(), //changed
      builder: (BuildContext context,  AsyncSnapshot<DocumentSnapshot> snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          Container(
            color: Colors.white,
            child: Center(
                child: CircularProgressIndicator(
                  color: c1,
                )),
          );
        }
        if(snapshot.hasData){
          firstname=snapshot.data!["firstname"];
          lastname=snapshot.data!["lastname"];
          email=snapshot.data!["email"];
          if(snapshot.data!["phone"]!="null"){
            phoneNumber=snapshot.data!["phone"];
          }else{
            phoneNumber="";
          }

          gender=snapshot.data!["gender"];

          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,

              body: Container(

                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
                    child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            //Upper Bar
                            Row(
                              children: [

                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(image:AssetImage("assets/images/c1.png"),fit: BoxFit.cover),
                                      shape: BoxShape.circle
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text("$firstname $lastname",style: getstyle(20, FontWeight.w600,Colors.black)),
                                    Text("$email",style: getstyle(12, FontWeight.normal,Colors.grey)),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 20,),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey,
                            ),



                            //  Account settings
                            SizedBox(height: 20,),
                            Text("ACCOUNT SETTINGS",style: getstyle(12, FontWeight.normal, Colors.grey),),

                            ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Editprofile(firstname: firstname!,lastname: lastname!,email: email!,gender: gender!,phoneNumber: phoneNumber!,)));
                              },
                              contentPadding: EdgeInsets.all(0),
                              title: Text("Personal Information",style: getstyle(12, FontWeight.w500, Colors.black),),
                              trailing: ImageIcon(AssetImage("assets/icons/Profileoutlines.png"),color: Colors.black,size: 20,),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: light,
                            ),

                            ListTile(
                              onTap: (){

                              },
                              contentPadding: EdgeInsets.all(0),
                              title: Text("Payments",style: getstyle(12,  FontWeight.w500, Colors.black),),
                              trailing: ImageIcon(AssetImage("assets/icons/creditfill.png"),color: Colors.black,size: 20,),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: light,
                            ),
                            ListTile(
                              onTap: (){

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Wishlist()));

                              },
                              contentPadding: EdgeInsets.all(0),
                              title: Text("Wishlist",style: getstyle(12,  FontWeight.w500, Colors.black),),
                              trailing: Icon(Icons.favorite_border_outlined,color: Colors.black,size: 20,),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: light,
                            ),


                            //  Support
                            SizedBox(height: 20,),
                            Text("SUPPORT",style: getstyle(12, FontWeight.normal, Colors.grey),),

                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("Get Help",style: getstyle(12,  FontWeight.w500, Colors.black),),
                              trailing: ImageIcon(AssetImage("assets/icons/support.png"),color: Colors.black,size: 20,),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: light,
                            ),

                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("Get us Feedback",style: getstyle(12, FontWeight.w500, Colors.black),),
                              trailing: ImageIcon(AssetImage("assets/icons/Notificationsoutlines.png"),color: Colors.black,size: 20,),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: light,
                            ),

                            //  Legal
                            SizedBox(height: 20,),
                            Text("LEGAL",style: getstyle(12, FontWeight.normal, Colors.grey),),
                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("Terms and Service",style: getstyle(12,  FontWeight.w500, Colors.black),),
                              trailing: ImageIcon(AssetImage("assets/icons/terms.png"),color: Colors.black,size: 20,),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: light,
                            ),

                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text("Privacy Policy",style: getstyle(12,  FontWeight.w500, Colors.black),),
                              trailing: ImageIcon(AssetImage("assets/icons/terms.png"),color: Colors.black,size: 20,),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: light,
                            ),

                            ListTile(
                              onTap: () async {
                                await FirebaseAuth.instance.signOut();
                               // await gsignin.signOut();
                                Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                                ),
                                (route) => false);
                              },
                              contentPadding: EdgeInsets.all(0),
                              title: Text("Logout",style: getstyle(12,  FontWeight.w500, Colors.black),),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: light,
                            ),


                            SizedBox(height: 40,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Version 1.00",style: getstyle(13, FontWeight.normal, Colors.grey),)
                              ],
                            )





                          ],
                        ),



                  ),
                ),
               ),
            ),
          );
        }
        if(snapshot.hasError){
          return SafeArea(
            child: Container(
              child: Text("has error"),
            ),
          );
        }

        return Container(
          color: Colors.white,
          child: Center(
              child: CircularProgressIndicator(
                color: c1,
              )),
        );

      },
    );



  }
}