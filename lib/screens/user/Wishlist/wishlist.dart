import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glare_user_app/screens/user/PhotographerDetails/photographer_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  Map<String, int> dot_indexs = new Map<String, int>();
  FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> wishlist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getwishlist();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark));

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kTextColor),
        elevation: 1,
        backgroundColor: Colors.white,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.favorite),
              SizedBox(
                width: 5,
              ),
              Text(
                "Wishlist",
                style: GoogleFonts.poppins(
                    color: Colors.black, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: getwishlist(),
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
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Column(
            children: [
              Container(
                height: 270,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
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
                    : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                      Text(
                        "No Post Yet",
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 14),
                      )
                    ],
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
                      dotWidth: 7,
                      dotHeight: 7,
                      dotColor: Colors.grey,
                      activeDotColor: c2,
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
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                  image: NetworkImage(image), fit: BoxFit.cover)),
        ),
      ],
    );
  }

  //getwishlist
  Widget getwishlist() {
    var stream = FirebaseFirestore.instance
        .collection("Wishlist")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    return StreamBuilder(
        stream: stream.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          wishlist.clear();
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(),);
          } else if (snapshot.data!.exists) {
            wishlist.addAll(snapshot.data!["list"]);

            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Photographerdata")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData) {
                  return SafeArea(
                    //Listview
                    child: ListView(
                      children: snapshot.data!.docs.map((document) {
                        dot_indexs.putIfAbsent(document["uid"], () => 0);

                        print(wishlist.length);
                        return wishlist.contains(document["uid"])
                            ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PhotgrapherDetails(
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
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: getimages(document["uid"]),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                    SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Row(
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
                                                "56 Reviews",
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
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
                                                  FontWeight.normal,
                                                  Colors.grey),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 1, color: Colors.black),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 7),
                                          child: Text(
                                            "Rs. 1500/ day",
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  Expanded(
                                    flex: 4,

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(onPressed: () {
                                          removewishlist(document["uid"]);
                                        },
                                            icon: Icon(Icons.delete,
                                              color: Colors.red,)),
                                      ],
                                    ),


                                  ),
                                  ]
                                ),
                                ),
                            ]
                            ),

                          ),
                        )
                            : Container();
                      }).toList(),
                    ),
                  );
                }

                return Container(
                  color: Colors.white,
                  child: Center(
                    child: Container(
                      height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.black,)),
                  ),
                );
              },
            );
          }

          return  Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.black,));
        });
  }

  //removefromwishlist
  removewishlist(String key) async {
    wishlist.remove(key);
    await FirebaseFirestore.instance
        .collection("Wishlist")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({"list": wishlist});
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(
      "Removed from Wishlist",
      style: getstyle(14, FontWeight.normal, Colors.red),),
        backgroundColor: light));
  }

}
