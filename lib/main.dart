import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glare_user_app/theme.dart';

import 'constants.dart';
import 'helper/firebase_auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,

        builder: (context, snapshot) {
          // Check for Errors
          if (snapshot.hasError) {
            print("Something Went Wrong>>"+snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: Center(
                  child: CircularProgressIndicator(color: c1,)),
            );
          }

          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,

          ));

          return MaterialApp(


            title: 'Glare',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(

              scaffoldBackgroundColor: Colors.white,
              textTheme: textTheme(),

              textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Colors.grey
              ),
            ),
            home:AuthService().handleAuth(),
          );
        });
  }


}

