import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergym/models/user_modal.dart';
import 'package:fluttergym/screens/edit_profile_screen.dart';
import 'package:fluttergym/screens/login_register.dart';
import 'package:fluttergym/tabs/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 3000), callback);


  }
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white
//            image: DecorationImage(image: AssetImage('splash-background.png'),
//              fit: BoxFit.cover
//            )
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              child: Image.asset(
                'assets/images/image006.jpg',

              ),
            ),
          ),


        ],
      );
  }



  callback() {
    SharedPreferences.getInstance().then((prefs){
      if(prefs.getBool("login")==null){
        prefs.setBool("login", false) ;
      }
      if(!prefs.getBool("login")){
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (co) => LoginRegister()) , (context)=>false) ;
      }else{
        var modal  = Provider.of<UserModal>(context) ;
        modal.initUser() ;
     //   Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (co) =>EditProfileScreen()) , (context)=>false) ;
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (co) =>MainScreen()) , (context)=>false) ;
      }


    }) ;


  }
}
