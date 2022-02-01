import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class Editprofile extends StatefulWidget {
  String firstname,lastname,gender,email,phoneNumber;
  Editprofile({Key? key,required this.firstname,required this.lastname,required this.gender,required this.email,required this.phoneNumber}) : super(key: key,);

  @override
  _EditprofileState createState() => _EditprofileState(firstname: firstname,lastname: lastname,gender: gender,email: email,phoneNumber: phoneNumber);
}

class _EditprofileState extends State<Editprofile> {

  String firstname,lastname,gender,email,phoneNumber;
  _EditprofileState({required this.firstname,required this.lastname,required this.gender,required this.email,required this.phoneNumber});
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstname=new TextEditingController();
  TextEditingController _lastname=new TextEditingController();
  TextEditingController _email=new TextEditingController();
  TextEditingController _phonenumber=new TextEditingController();
  bool progress=false;
  FirebaseAuth auth=FirebaseAuth.instance;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _firstname.dispose();
    _lastname.dispose();
    _email.dispose();
    _phonenumber.dispose();
    setState(() {
      progress = false;
    });
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email..text=email;
    _firstname..text=firstname;
    _lastname..text=lastname;
    if(phoneNumber!="null"){
      _phonenumber..text=phoneNumber;
    }else{
      _phonenumber..text="";
    }

  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark
    ));


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black,size: 15),
        actions: [
          TextButton(onPressed: (){


            setState(() {
              progress=true;
            });

            savedata();


          }, child: Text("Save",style: getstyle(13, FontWeight.normal, Colors.black),)) ],
      ),
      body:Stack(children: [

        SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Edit Personal Info",style: getstyle(22, FontWeight.w600,Colors.black)),
                    SizedBox(height: 10,),
                    buildFirstnameFormField(),
                    SizedBox(height: 15,),
                    buildlastnameFormField(),
                    SizedBox(height: 20,),
                    Text("Gender",style: getstyle(11, FontWeight.w600, Colors.black),),
                    buildGenderDropdown(),
                    SizedBox(height: 10,),
                    buildphonenumberFormField(),

                    SizedBox(height: 60,),
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
        Visibility(
          visible: progress,
          child: Container(color: Colors.white,child: Center(child: CircularProgressIndicator(color: c1,),),
          ),
        )],)
    );

  }

  TextFormField buildFirstnameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstname = newValue!,
      controller: _firstname,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter firstname';
        }
        return null;
      },
      style: TextStyle(color:Colors.grey,fontSize: 15),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kTextColor),
        ),
        focusColor: c1,
        hintStyle: getstyle(15, FontWeight.normal, Colors.grey),
        labelText: "First Name",
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: c1,fontWeight: FontWeight.w600),
        hintText: "Enter your First Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,

      ),
    );
  }

  TextFormField buildlastnameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastname = newValue!,
      controller: _lastname,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter lastname';
        }
        return null;
      },
      style: TextStyle(color:Colors.grey,fontSize: 15),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusColor: c1,
        hintStyle: getstyle(15, FontWeight.normal, Colors.grey),
        labelText: "Last Name",
        labelStyle: TextStyle(color: c1,fontWeight: FontWeight.w600),
        hintText: "Enter your Last Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,

      ),
    );
  }

  Container buildGenderDropdown(){

    return Container(

      alignment: Alignment.center,
      width: double.infinity,
      child: DropdownButton<String>(
        onTap: removeFocus,
        menuMaxHeight: 200,
        value: gender,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        dropdownColor: Colors.white,
        iconEnabledColor:c1,
        underline: Container(color: Colors.grey,width: MediaQuery.of(context).size.width,height: 1,),
        elevation: 16,
        borderRadius: BorderRadius.circular(10),
        iconDisabledColor: Colors.white,
        style: const TextStyle(color: c1),
        onChanged: (String? newValue) {
          setState(() {
            gender = newValue!;
          });
        },

        items: <String>['Male', 'Female', 'Other']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,style: getstyle(15, FontWeight.normal, Colors.grey),),
          );
        }).toList(),
      ),
    );

  }

  TextFormField buildphonenumberFormField() {
    return TextFormField(
      onSaved: (newValue) => phoneNumber = newValue!,
      controller: _phonenumber,

      style: TextStyle(color:kTextColor,fontSize: 14),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusColor: c1,
        hintStyle: getstyle(14, FontWeight.normal, Colors.grey),
        labelText: "Phone Number",
        labelStyle: TextStyle(color: c1,fontWeight: FontWeight.w600),
        hintText: "Enter Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,

      ),
    );
  }

  removeFocus(){
    FocusScope.of(context).unfocus();
  }

  savedata() async {


    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
     await FirebaseFirestore.instance.collection("Userdata").doc(FirebaseAuth.instance.currentUser!.uid).update({
        "firstname":firstname,
        "lastname":lastname,
        "gender":gender,
        "phone":phoneNumber,
      });


      setState(() {
        progress=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content:Row(children: [
        Icon(Icons.check_circle,color: Colors.green,),
        SizedBox(width: 10,),
        Text("Profile Updated",style: getstyle(13, FontWeight.normal, Colors.green),)
      ],) ,backgroundColor: light,));


    }}

}




