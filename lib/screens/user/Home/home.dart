import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glare_user_app/screens/user/PhotographerDetails/photographer_details.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:http/http.dart' as http;

import '../usermain.dart';
class Dashboard extends StatefulWidget {



  @override
  _DashboardState createState() =>
      _DashboardState();
}

class _DashboardState extends State<Dashboard> {
 //final gsignin = GoogleSignIn();
  Map<String, int> dot_indexs = new Map<String, int>();
  FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> wishlist = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark));

    return Scaffold(
      appBar: AppBar(
        elevation: 7,
        backgroundColor: Colors.white,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.camera,color: Colors.black,),
                //Image.asset("assets/icons/Bookfillicon.png",width: 30,fit: BoxFit.cover,color: Colors.black,),

              SizedBox(width: 5,),

              Text(
                "Glare",
                style: GoogleFonts.poppins(
                    color: Colors.black, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body:StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Photographerdata")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.black,),
            ) );
          }

          if (snapshot.hasData) {

            return SafeArea(

                  child: Container(
                              color: Colors.white,
                              child:  RefreshIndicator(
                                color: Colors.black,
                                onRefresh: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserMain())),
                                child: ListView(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  //controller: controller,
                                  children: snapshot.data!.docs.map((document) {

                                    dot_indexs.putIfAbsent(document["uid"], () => 0);

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PhotgrapherDetails(
                                                  uid: document["uid"],
                                                )));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        margin: EdgeInsets.only(top: 10),
                                        child: Column(
                                          children: [

                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 15,
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          document["firstname"] +
                                                              " " +
                                                              document["lastname"],
                                                          style: GoogleFonts.poppins(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Container(
                                                          width: 1,
                                                          height: 15,
                                                          color: Colors.black,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          document["city"],
                                                          style: getstyle(13,
                                                              FontWeight.normal, Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                  ),),
                                                Expanded(
                                                  flex: 5,
                                                  child: Container(
                                                    margin: EdgeInsets.only(right: 15),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: kTextColor,
                                                          size: 14,
                                                        ),
                                                        Text(
                                                          "4.55 |",
                                                          style: GoogleFonts.montserrat(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          " 56",
                                                          style: GoogleFonts.montserrat(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),),
                                              ],
                                            ),


                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal: 7),
                                              child: getimages(document["uid"]),
                                            ),
                                            SizedBox(
                                              height: 14,
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [

                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(20),
                                                      border: Border.all(
                                                          width: 0.5, color: bodytextcolor),
                                                    ),
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 15, vertical: 5),
                                                    child: Text(
                                                      "Rs. 1500/ day",
                                                      style: GoogleFonts.poppins(
                                                        color: bodytextcolor,
                                                        fontWeight: FontWeight.normal,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),

                                                  GestureDetector(
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 15, vertical: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(20),
                                                        border: Border.all(
                                                            width: 0.5, color: bodytextcolor),
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Icon(Icons.share,size: 20,color: bodytextcolor,),
                                                          SizedBox(width: 5,),
                                                          Text("Share",style: getstyle(13, FontWeight.normal, bodytextcolor))
                                                        ],
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      //final url=document["profilepic"];

                                                      // final response=await http.get(url);
                                                      // final bytes=response.bodyBytes;
                                                      // final temp=await getTemporaryDirectory();
                                                      // final path="${temp.path}/image.jpeg";
                                                      // File(path).writeAsBytesSync(bytes);


                                                      Share.share("Shared String data");
                                                    },
                                                  ),
                                                  getbookmarks(document["uid"])


                                                ],
                                              ),
                                            ),

                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(width: double.infinity,height: 0.2,color: Colors.grey,margin: EdgeInsets.symmetric(horizontal: 50),),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )

            );
          }

          return Container(
              color: Colors.white,
              child: Center(child: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.black,),
              ) )
          );
        },
      ),
    );
  }

  //Images In Carousel
  getimages(String key) {
    var stream = FirebaseFirestore.instance
        .collection("Posts")
        .where("uid", isEqualTo: key);

    return StreamBuilder(
        stream: stream.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (!snapshot.hasData) {
            return Container(
              height: 290,
              child: Center(child: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.black,),
              ) ),
            );
          }

          return Column(
            children: [
              Container(
                height: 270,
                width: MediaQuery.of(context).size.width,
                child: snapshot.data!.docs.length > 0
                    ? CarouselSlider.builder(
                        carouselController: new CarouselController(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index, realIndex) {
                          final image = snapshot.data!.docs[index]["url"];

                          return buildImage(
                              image, index, snapshot.data!.docs.length);
                        },
                        options: CarouselOptions(
                          height: 400,
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              dot_indexs[key] = index;
                            });
                          },
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(image: AssetImage("assets/images/dummy.jpeg"),fit: BoxFit.cover)
                        ),
                      ),
              ),
              snapshot.data!.docs.length > 1
                  ? Column(
                      children: [
                        SizedBox(
                          height: 7,
                        ),
                        AnimatedSmoothIndicator(
                          activeIndex: dot_indexs[key]!,
                          count: snapshot.data!.docs.length,
                          effect: JumpingDotEffect(
                            dotWidth: 6,
                            dotHeight: 6,
                            spacing: 4,
                            dotColor: Colors.grey,
                            activeDotColor: Colors.black,
                          ),
                        )
                      ],
                    )
                  : Container(),
            ],
          );
        });
  }

  //Carousel item
  Widget buildImage(String image, int index, int length) {
    return Column(
      children: [
        Container(
          height: 270,

          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                  image: NetworkImage(image), fit: BoxFit.cover)),
        ),
      ],
    );
  }

  // getheart
  Widget getbookmarks(String key) {
    var stream = FirebaseFirestore.instance
        .collection("Wishlist")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    return StreamBuilder(
        stream: stream.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              wishlist.clear();
          if(!snapshot.hasData){
            return Center(child: Container(
              height: 20,
              width: 20,
              child:  CircularProgressIndicator(color: Colors.black,),));
          }else if(snapshot.data!.exists){


            wishlist.addAll(snapshot.data!["list"]);

            return Stack(
                    children: [
                      wishlist.contains(key)?GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(20),
                            border: Border.all(
                                width: 0.5, color: bodytextcolor),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.bookmark,size: 20,color: bodytextcolor,),
                              SizedBox(width: 5,),
                              Text("Save",style: getstyle(13, FontWeight.normal, bodytextcolor),)
                            ],
                          ),
                        ),
                        onTap: (){
                          removewishlist(key);
                        },
                      ):
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(20),
                            border: Border.all(
                                width: 0.5, color: bodytextcolor),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.bookmark_border,size: 20,color: bodytextcolor,),
                              SizedBox(width: 5,),
                              Text("Save",style: getstyle(13, FontWeight.normal, bodytextcolor),)
                            ],
                          ),
                        ),
                        onTap: (){
                          Addtowishlist(key);
                        },
                      )

                    ],
                  );



          }

          return  GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(20),
                border: Border.all(
                    width: 0.5, color: bodytextcolor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border,size: 20,color: bodytextcolor,),
                  SizedBox(width: 5,),
                  Text("Save",style: getstyle(13, FontWeight.normal, bodytextcolor),)
                ],
              ),
            ),
            onTap: (){
              Addtowishlist(key);
            },
          );


        });
  }

  //add to wishlist
  Addtowishlist(String key) async {
    wishlist.add(key);
    await FirebaseFirestore.instance
        .collection("Wishlist")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({"list":wishlist});

    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Saved",style: getstyle(14, FontWeight.normal, Colors.green),),backgroundColor: light,elevation: 10,));

  }

  //removewishlist
  removewishlist(String key) async {
    wishlist.remove(key);
    await FirebaseFirestore.instance
        .collection("Wishlist")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({"list":wishlist});
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Unsaved",style: getstyle(14, FontWeight.normal, Colors.red),),backgroundColor: light));

  }

}


