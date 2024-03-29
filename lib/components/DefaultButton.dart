import 'package:flutter/material.dart';
import '../constants.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
  }) : super(key: key);
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          primary: Colors.white,
          backgroundColor: Colors.white ,
        ),
        onPressed: press as void Function()?,
        child: Text(
          text!,
          style: getstyle(13, FontWeight.w500, Colors.black)
        ),
      ),
    );
  }
}