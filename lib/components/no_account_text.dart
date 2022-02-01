import 'package:flutter/material.dart';
import 'package:glare_user_app/screens/sign_up/sign_up_screen.dart';


import '../constants.dart';
import '../size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don’t have an account? ",
          style: getstyle(12, FontWeight.normal, Colors.white),
        ),
        GestureDetector(
          onTap: () =>  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpScreen())),
          child: Text(
            "Sign Up",
            style:getstyle(12, FontWeight.w500, Colors.white),
          ),
        ),
      ],
    );
  }
}