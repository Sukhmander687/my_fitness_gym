import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttergym/utils/const.dart';
import 'package:fluttergym/utils/size_config.dart';

import 'package:toast/toast.dart';

import 'login_register.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var email;
  bool v = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Forgot Password', style: titleText),
        actions: <Widget>[],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 5 * SizeConfig.heightMultiplier,
          ),
          Text(
            'Enter the email address \nassociated with your account',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 2.5 * SizeConfig.textMultiplier, color: Colors.grey),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 30.0, horizontal: 8 * SizeConfig.widthMultiplier),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: fieldBorder,
                  boxShadow: [boxShadow]),
              width: double.infinity,
              child: TextFormField(
                style: fieldText,
                enabled: !v,
                onChanged: (e) {
                  email = e;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: accentColor, borderRadius: fieldBorder),
                        height: 15,
                        width: 30,
                        child: Center(
                          child: Icon(
                            Icons.mail,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    hintText: 'Email',
                    hintStyle: hintText),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:150.0),
            child: Visibility(
              visible: !v,
              child: RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  if(email.toString().isEmpty ||!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email))
                  {
                    Toast.show("Enter a valid email", context,gravity: Toast.CENTER);
                    return;
                  }


                  showDialog(
                      context: context,
                      builder: (BuildContext) => Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.cyan,
                              strokeWidth: 5,
                            ),
                          ));

                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email)
                      .then((r) {
                    Navigator.pop(context);
                   showDialog(context: context,
                     builder: (c) => AlertDialog(
                       title: Text('send you an email.',style: TextStyle(fontWeight: FontWeight.bold),),
                       actions: <Widget>[
                         Center(
                           child: RaisedButton( color: accentColor,
                             textColor: Colors.white,
                             shape: new RoundedRectangleBorder(
                               borderRadius: new BorderRadius.circular(18.0),
                             ),
                             onPressed: () {
                               Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context) => LoginRegister()));
                             },
                             child: Text('ok'.toUpperCase(),
                                 style: TextStyle(
                                     fontSize: 14, fontWeight: FontWeight.bold)),


                           ),
                         )
                       ],

                     ),
                   );
                  }).catchError((e) {Navigator.pop(context);
                      if(e is PlatformException)
                        {
                          var content=e.message;
                          showDialog(context: context,
                            builder: (c) => AlertDialog(
                              content: Text(content,style: TextStyle(fontWeight: FontWeight.bold),),
                              actions: <Widget>[
                                Center(
                                  child: RaisedButton( color: accentColor,
                                    textColor: Colors.white,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(18.0),
                                    ),
                                    onPressed: () {
                                    Navigator.pop(context);
                                    },
                                    child: Text('ok'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.bold)),


                                  ),
                                )
                              ],

                            ),
                          );

                        }
                  print(e.toString());
                  });
                },
                color: accentColor,
                textColor: Colors.white,
                child: Text("Send".toUpperCase(),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
          ),




//          Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: [
//              Visibility(
//                visible: v,
//                child: Column(
//                  children: <Widget>[
//                    Text(
//                      'visit you email',
//                      style:
//                          TextStyle(fontSize: 2.4 * SizeConfig.textMultiplier),
//                    ),
//                    RaisedButton(
//                      color: accentColor,
//                      textColor: Colors.white,
//                      shape: new RoundedRectangleBorder(
//                        borderRadius: new BorderRadius.circular(18.0),
//                      ),
//                      onPressed: () {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => LoginRegister()));
//                      },
//                      child: Text('back'.toUpperCase(),
//                          style: TextStyle(
//                              fontSize: 14, fontWeight: FontWeight.bold)),
//                    )
//                  ],
//                ),
//              ),
//            ],
//          ),
        ],
      ),
    );
  }
}
