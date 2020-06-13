import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttergym/models/user_modal.dart';
import 'package:fluttergym/screens/forgot_pass.dart';
import 'package:fluttergym/tabs/main_screen.dart';
import 'package:fluttergym/utils/const.dart';
import 'package:fluttergym/utils/size_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';


class LoginRegister extends StatefulWidget {
  bool login;

  LoginRegister([this.login = true]);

  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

bool selectType = true;

class _LoginRegisterState extends State<LoginRegister> {
  var boxShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)));
  final facebookLogin = FacebookLogin();
  var token;

  bool selectType = true;

  bool animate = false;

  bool showPass = false;

  bool rememberMe = false;
  var name, email, password;

  @override
  void initState() {
    selectType = widget.login;
    super.initState();
  }

  var smallAccent =
      TextStyle(color: accentColor, fontSize: 1.8 * SizeConfig.textMultiplier);

  var smallGrey =
      TextStyle(color: lightGrey, fontSize: 1.8 * SizeConfig.textMultiplier);

  Size media;

  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context).size;

    return Material(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/image001.jpg'), fit: BoxFit.cover)),
          ),
          ListView(
            children: <Widget>[
              SizedBox(
                height: 0.5 * SizeConfig.heightMultiplier,
              ),
              AspectRatio(
                  aspectRatio: 36 / 7, child: Image.asset('logo-white.png')),
              SizedBox(
                height: 1.5 * SizeConfig.heightMultiplier,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        selectType = true;
                        animate = true;
                      });
                    },
                    elevation: 0,
                    color: selectType
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                    shape: boxShape,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.8 * SizeConfig.widthMultiplier),
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(
                            color: selectType ? primaryColor : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 1.9 * SizeConfig.textMultiplier),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3 * SizeConfig.widthMultiplier,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        selectType = false;
                      });
                    },
                    elevation: 0,
                    color: selectType
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white,
                    shape: boxShape,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.8 * SizeConfig.heightMultiplier),
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                            color: selectType ? Colors.white : primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 1.9 * SizeConfig.textMultiplier),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.5 * SizeConfig.heightMultiplier,
              ),
              Stack(
                children: <Widget>[
                  Visibility(visible: selectType, child: loginWidget()),
                  Visibility(visible: !selectType, child: registerWidget()),
                ],
              ),
              SizedBox(
                height: 1 * SizeConfig.heightMultiplier,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 2,
                    width: 20 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                          lightGrey,
                          Colors.white.withOpacity(0.5)
                        ])),
                  ),
                  Text(
                    'Social Login',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: lightGrey,
                        fontSize: 2.5 * SizeConfig.textMultiplier),
                  ),
                  Container(
                    height: 2,
                    width: 20 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                          Colors.white.withOpacity(0.5),
                          lightGrey
                        ])),
                  ),
                ],
              ),
              SizedBox(
                height: 0.5 * SizeConfig.heightMultiplier,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    child: Image.asset(
                      'assets/images/facebook.png',
                      height: 17 * SizeConfig.imageSizeMultiplier,
                    ),
                    onTap: () {
                      loginFacebook();
                    },
                  ),
                  InkWell(
                    child: Image.asset(
                      'assets/images/google.png',
                      height: 17 * SizeConfig.imageSizeMultiplier,
                    ),
                    onTap: () {
                      _handleSignIn().then((FirebaseUser user) {
                        print("google login sucess  ${user.email}");
                        navigate(user);
                      }).catchError((e) {
                        if (e is PlatformException) {
                          showErrorDialog(e);
                        }
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 80,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(' By clicking Sign Up, you agree to RePlastic',
                        style: smallGrey)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () { },
                      child: Text(
                        ' Terms of Service ',
                        style: smallAccent,
                      ),
                    ),
                    Text(
                      ' and ',
                      style: smallGrey,
                    ),
                    GestureDetector(
                      onTap: () {  },
                      child: Text(
                        'Privacy Policy',
                        style: smallAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget loginWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5 * SizeConfig.widthMultiplier),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 3 * SizeConfig.heightMultiplier),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                boxShadow: [boxShadow]),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 0.7 * SizeConfig.heightMultiplier,
                ),
                Text(
                  'Sign In',
                  style: fieldText,
                ),
                SizedBox(
                  height: 0.7 * SizeConfig.heightMultiplier,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.widthMultiplier),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: fieldBorder,
                        boxShadow: [boxShadow]),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2 * SizeConfig.widthMultiplier),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5 * SizeConfig.heightMultiplier),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: fieldText,
                          onChanged: (e) {
                            email = e;
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,

                              prefixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: accentColor,
                                      borderRadius: fieldBorder),
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
                  ),
                ),
                SizedBox(
                  height: 1.5 * SizeConfig.heightMultiplier,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.widthMultiplier),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: fieldBorder,
                        boxShadow: [boxShadow]),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2 * SizeConfig.widthMultiplier),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5 * SizeConfig.heightMultiplier),
                        child: TextFormField(
                          style: fieldText,
                          onChanged: (e) {
                            password = e;
                          },
                          obscureText: showPass ? false : true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: accentColor,
                                      borderRadius: fieldBorder),
                                  height: 15,
                                  width: 30,
                                  child: Center(
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showPass = !showPass;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color:
                                        showPass ? accentColor : fieldHintColor,
                                  )),
                              hintText: 'Password',
                              hintStyle: hintText),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0 * SizeConfig.heightMultiplier,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            rememberMe = !rememberMe;
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 3 * SizeConfig.widthMultiplier,
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: checkBoxBorder,
                                      border: Border.all(
                                          width: 1,
                                          color: rememberMe
                                              ? accentColor
                                              : Colors.grey)),
                                ),
                                Center(
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.fastOutSlowIn,
                                    height: rememberMe ? 20 : 0,
                                    width: rememberMe ? 20 : 0,
                                    decoration: BoxDecoration(
                                      color: accentColor,
                                      borderRadius: checkBoxBorder,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '  Remember Me',
                              style: TextStyle(
                                  fontSize: 1.7 * SizeConfig.textMultiplier),
                            )
                          ],
                        )),
                    FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => ForgotPassword()));
                        },
                        child: Text(
                          'Forgot Password?  ',
                          style: TextStyle(
                              color: accentColor,
                              fontSize: 1.7 * SizeConfig.textMultiplier),
                        ))
                  ],
                ),
                SizedBox(
                  height: 4 * SizeConfig.heightMultiplier,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 5 * SizeConfig.widthMultiplier),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      if (email == null || password == null) {
                        Toast.show("Please enter all fields", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (buildContext) => Center(
                                child: loaderDialog(),
                              ));
                      print("Login Email $email     passwordd $password");
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email, password: password)
                          .then((loginUser) {
                        print("Login Success");
                        // Toast.show('Login Success', context);

                        var user = Provider.of<UserModal>(context,listen: false);
                        user.getUserFirebase(loginUser, context);

//                        Firestore.instance
//                            .collection('user')
//                            .document(loginUser.user.uid)
//                            .get()
//                            .then((DocumentSnapshot ds) {
//
//                        });
//
//
//                        SharedPreferences.getInstance().then((prefs) {
//                          prefs.setBool("login", true);
//
//
//                          Navigator.push(context,
//                              MaterialPageRoute(builder: (co) => Dashboard()));
//                        });
                      }).catchError((e) {
                        Navigator.pop(context);
                        if (e is PlatformException) {
                          showErrorDialog(e);
                        }
                      });

//                    Navigator.push(context, MaterialPageRoute(
//                        builder: (c) => PlasticProblem()
//                    ));
//
                    },
                    color: accentColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.5 * SizeConfig.heightMultiplier),
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget registerWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5 * SizeConfig.widthMultiplier),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 3 * SizeConfig.heightMultiplier),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                boxShadow: [boxShadow]),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 0.7 * SizeConfig.heightMultiplier,
                ),
                Text(
                  'Sign Up',
                  style: fieldText,
                ),
                SizedBox(
                  height: 0.7 * SizeConfig.heightMultiplier,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.widthMultiplier),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: fieldBorder,
                        boxShadow: [boxShadow]),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2 * SizeConfig.widthMultiplier),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5 * SizeConfig.heightMultiplier),
                        child: TextFormField(
                          style: fieldText,
                          onChanged: (e) {
                            name = e;
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: accentColor,
                                      borderRadius: fieldBorder),
                                  height: 15,
                                  width: 30,
                                  child: Center(
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              hintText: 'Name',
                              hintStyle: hintText),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5 * SizeConfig.heightMultiplier,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.widthMultiplier),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: fieldBorder,
                        boxShadow: [boxShadow]),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2 * SizeConfig.widthMultiplier),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5 * SizeConfig.heightMultiplier),
                        child: TextFormField(
                          style: fieldText,
                          onChanged: (e) {
                            email = e;
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: accentColor,
                                      borderRadius: fieldBorder),
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
                  ),
                ),
                SizedBox(
                  height: 1.5 * SizeConfig.heightMultiplier,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.widthMultiplier),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: fieldBorder,
                        boxShadow: [boxShadow]),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2 * SizeConfig.widthMultiplier),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5 * SizeConfig.heightMultiplier),
                        child: TextFormField(
                          style: fieldText,
                          onChanged: (e) {
                            password = e;
                          },
                          obscureText: showPass ? false : true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: accentColor,
                                      borderRadius: fieldBorder),
                                  height: 15,
                                  width: 30,
                                  child: Center(
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showPass = !showPass;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color:
                                        showPass ? accentColor : fieldHintColor,
                                  )),
                              hintText: 'Password',
                              hintStyle: hintText),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 6 * SizeConfig.heightMultiplier,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 5 * SizeConfig.widthMultiplier),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      if (name == null || email == null || password == null) {
                        Toast.show("Please enter all fields", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        return;
                      } else {
                        showDialog(
                            context: context,
                            builder: (x) => Center(
                                  child: loaderDialog()
                                ));
                        createRecord().then((FirebaseUser user) {
                          print("createRecord response >> ${user.email}");
                          var userModal = Provider.of<UserModal>(context,listen: false);
                          userModal.registerUser(user, name, email, context);
                        }).catchError((e) {
                          Navigator.pop(context);

                          if (e is PlatformException) {
                            showErrorDialog(e);
                          }
                          print(' createRecord Errporrr ${e.toString()}');
                        });
                      }
                    },
                    color: accentColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.5 * SizeConfig.heightMultiplier),
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'profile',
      ],
    );
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in " + googleAuth.idToken);
    token = googleAuth.idToken;
    var result=(await _auth.signInWithCredential(credential));

    await updateWithFirebase(result);

    return result.user;
  }

  Future<FirebaseUser> createRecord() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    return user;
  }

  Future<FirebaseUser> loginUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    return user;
  }

  loginFacebook() async {
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        print("Access token = $token");
        final graphResponse = await get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
        final profile = json.decode(graphResponse.body);
        print('Responce $profile');
        AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        FirebaseAuth.instance.signInWithCredential(credential).then((result) async {
         await updateWithFirebase(result);
          navigate(result.user) ;
        }).catchError((e) {
          print(e);
          if (e is PlatformException) {
            showErrorDialog(e);
          }
          facebookLogin.logOut();
        });

        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        Toast.show("Error  ${result.errorMessage}", context,
            gravity: Toast.BOTTOM);
        break;
    }
  }


  void navigate(FirebaseUser user) {
    var login = Provider.of<UserModal>(context,listen: false);
    login.saveUser(user, context) ;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("Login", true);
      Navigator.pushAndRemoveUntil(context,
          CupertinoPageRoute(builder: (c) => MainScreen()), (c) => false);
    });

//    Firestore.instance.collection("user").document(user.uid)
//        .setData({
//      "email":user.email,
//      "user_id":user.uid,
//      "user_name":user.displayName
//    },merge: true).then((r){
//      SharedPreferences.getInstance().then((prefs){
//        prefs.setBool("Login", true);
//        Navigator.pushReplacement(context,CupertinoPageRoute(builder: (c)=>Dashboard()));
//      });
   // });
  }

  void showErrorDialog(PlatformException e) {
    showDialog(
        context: context,
        builder: (c) => CupertinoAlertDialog(
              title: Text("Error"),
              content: Text(e.message),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                  textColor: Colors.red,
                )
              ],
            ));
    print("Error Message = ${e.message}");
  }

  Future<void> updateWithFirebase(AuthResult result) async {

    showDialog(barrierDismissible: false, context:
    context, builder: (c) =>
        Center(child: loaderDialog()
        ));


    print("Profile URL = ${result.user.photoUrl}");
    var snap = await Firestore.instance
        .collection('user')
        .document(result.user.uid)
        .get();
    var userModel = Provider.of<UserModal>(context,listen: false);
    if(!snap.exists){
      Navigator.pop(context);
      await userModel.registerUser(result.user,result.user.displayName, result.user.email==null?"${result.user.uid}@facebook.com" :result.user.email , context);
    }else{
      Navigator.pop(context);
      await userModel.getUserFirebase(result, context);
    }
  }
}
