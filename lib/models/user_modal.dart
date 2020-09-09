import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttergym/screens/edit_profile_screen.dart';
import 'package:fluttergym/tabs/main_screen.dart';
import 'package:fluttergym/utils/const.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

UserModal userModalFromJson(String str) => UserModal.fromJson(json.decode(str));

String userModalToJson(UserModal data) => json.encode(data.toJson());

class UserModal extends ChangeNotifier{
  String userId;
  String name = "Guest User";
  String password;
  String contact;
  String email = "guest@gmail.com";
  List<String> likeArray = List() ;

  String address ;
  String gymname ;


  List<Members> memberList = List() ;
  List<DailyTips> dailyTipsList = List() ;
  bool login = false ;
  bool loaded = false ;
  bool guestLogin = false ;
  String avatar;
  bool imageUploading=false;



  UserModal({
    this.userId,
    this.name,
    this.password,
    this.contact,
    this.gymname,
    this.email,
    this.address,
    this.memberList,
    this.dailyTipsList,
    this.avatar
  });

  factory UserModal.fromJson(Map<String, dynamic> json) => UserModal(
    userId: json["user_id"],
    name: json["user_name"],
    password: json["password"],
    contact: json["contact"],
    address: json["address"],
    gymname: json["gymname"],
    email: json["email"],
    avatar: json["avatar"]==null?null:json["avatar"],
    memberList: List<Members>.from(json["member_list"].map((x) => x)),
    dailyTipsList: List<DailyTips>.from(json["dailyTipsList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "password": password,
    "contact": contact,
    "address": address,
    "gymname": gymname,
    "email": email,
    "avatar":avatar,
    "member_list": List<dynamic>.from(memberList.map((x) => x)),
    "dailyTipsList": List<dynamic>.from(dailyTipsList.map((x) => x)),
  };



  loginUser(context , emaill , passwordd){
    if (emaill == "" || passwordd == "") {
      Toast.show("Please enter all fields", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
        context: context,
        builder: (buildContext) => Center(
          child: loaderDialog(),
        ));
    print("Login Email $emaill     passwordd $passwordd");
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: emaill, password: passwordd)
        .then((loginUser) {
      print("Login Success");
      // Toast.show('Login Success', context);

      var user = Provider.of<UserModal>(context,listen: false);
      user.getUserFirebase(loginUser, context);

    }).catchError((e) {

      Navigator.pop(context);
      print("${e.toString()}   errrorr") ;

      if (e is PlatformException) {
        // showErrorDialog(e);
        Toast.show("${e.message.toString()}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      }
    });

  }

  setData(json){
    loaded = true ;
    userId= json["user_id"] ;
    name= json["name"] ;
    password= json["password"] ;
    contact= json["contact"] ;
    address= json["address"] ;
    gymname= json["gymname"] ;
    email= json["email"] ;
    memberList= List<Members>.from(json["member_list"].map((x) => x));
    likeArray= List<String>.from(json["like_array"].map((x) => x));
    dailyTipsList= List<DailyTips>.from(json["dailyTipsList"].map((x) => x));
    avatar=json["avatar"];
    if(email=='guest@gmail.com'){
      guestLogin = true ;
    }else{
      guestLogin = false ;
      login = true ;
    }
    print("loginloginlogin $login") ;
    SharedPreferences.getInstance().then((d){
      d.setBool("login_guest", guestLogin) ;
    }) ;
    notifyListeners() ;
  }

  initUser(){
    SharedPreferences.getInstance().then((pfers){
      print("USER_DETAIL> ${pfers.getString("USER_DETAIL")}") ;
      var root = json.decode(pfers.getString("USER_DETAIL")) ;
      setData(root) ;
    }) ;
  }


  updateUserData(avatar , gymname , contact , address , name , context ){

    UserModal userModal = Provider.of<UserModal>(context,listen: false) ;
    userModal.userId = userId ;
    userModal.name = name;
    userModal.address = address;
    userModal.gymname = gymname;
    userModal.contact = contact;
    userModal.password = userId ;
    userModal.email = email ;
    userModal.avatar = avatar ;
    userModal.memberList = List()  ;
    userModal.dailyTipsList = List()  ;
    userModal.likeArray = List()  ;

    print("Update User>> ${json.encode(userModal)}") ;
    SharedPreferences.getInstance().then((prefs){
      prefs.setString("USER_DETAIL", json.encode(userModal) ) ;
      prefs.setBool("login", true) ;
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (co) => MainScreen()),(c)=>false);
    }) ;


  }

  registerUser(FirebaseUser user , name , email , context , {address , contact , gymname}){
    if(email == null){
      email = "${user.uid}@facebo0k.com" ;}

    print(' IN registerUser email $email');
    Firestore databaseReference = Firestore.instance;
    var map={
      "user_id":user.uid ,
      "name":name ,
      "email":email ,
      "contact":contact ,
      "address":address ,
      "gymname":gymname ,
      "avatar":user.photoUrl==null?"":user.photoUrl ,
      "member_list":(List()) ,
      "dailyTipsList" :List() ,
      "like_array" :List() ,
    };
    databaseReference.
    collection('user')
     .document(user.uid)
     .setData(map);

    UserModal userModal = Provider.of<UserModal>(context,listen: false) ;
    userModal.userId = user.uid ;
    userModal.name = name;
    userModal.address = address;
    userModal.gymname = gymname;
    userModal.contact = contact;
    userModal.password = user.uid ;
    userModal.email = user.email==null?"${user.uid}@facebook.com":user.email ;
    userModal.avatar = user.photoUrl==null?"":user.photoUrl ;
    userModal.memberList = List()  ;
    userModal.dailyTipsList = List()  ;
    userModal.likeArray = List()  ;
    //notifyListeners();
    setData(map);
    print("user registerUser >> ${json.encode(userModal)}") ;
    SharedPreferences.getInstance().then((prefs){
      prefs.setString("USER_DETAIL", json.encode(userModal) ) ;
      prefs.setBool("login", true) ;
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (co) => MainScreen()),(c)=>false);
    }) ;
  }



  void payFees(member_id ,  context , amount , date ){
    Firestore databaseReference = Firestore.instance;
    databaseReference.
    collection('user')
        .document(userId)
        .collection('members')
        .document(member_id)
        .updateData({
      'date':"$date" ,
      'pay_fees':"$amount" ,

        }).then((value) =>
        Navigator.push(context,
            MaterialPageRoute(builder: (co) => MainScreen()))
    ) ;

  }

  void delete_user(member_id ,  context ){
    Firestore databaseReference = Firestore.instance;
    databaseReference.
    collection('user')
        .document(userId)
        .collection('members')
        .document(member_id)
        .updateData({'is_deleted':"1"}).then((value) =>
        Navigator.push(context,
            MaterialPageRoute(builder: (co) => MainScreen()))
    ) ;

  }

  void saveUser(FirebaseUser user, BuildContext context) {
    print(' IN saveUser ${user.uid}');
    SharedPreferences.getInstance().then((prefs){
      prefs.setString("USER_DETAIL", json.encode(this) ) ;
      prefs.setBool("login", true) ;
      var root = json.decode(prefs.getString("USER_DETAIL")) ;
      setData(root) ;
      Navigator.push(context,
          MaterialPageRoute(builder: (co) => MainScreen()));

    }) ;


  }
  getUserFirebase(AuthResult loginUser, BuildContext context) async {
    await Firestore.instance
        .collection('user')
        .document(loginUser.user.uid)
        .get()
        .then((DocumentSnapshot ds) {
      print("getUserFirebase >>>  ${json.encode(ds.data)}") ;
//d1Bn6NuhTBd2xRN7CR97jubaUzA3

      SharedPreferences.getInstance().then((prefs){
        prefs.setString("USER_DETAIL", json.encode(ds.data) ) ;

      }) ;

      setData(ds.data) ;
    });


    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("login", true);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (co) => MainScreen()),(context)=>false);
    });


  }


  basename(String path) {
    return "image:${DateTime.now().millisecondsSinceEpoch}";
  }

  Future<void> changeProfilePic(File image) async {
    if(image==null){
      return;
    }
    imageUploading=true;
    notifyListeners();
    print("USER ID -> $userId");
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profiles/${basename(image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) async {
      avatar=fileURL.toString();
      imageUploading=false;
      await Firestore.instance
          .collection('user')
          .document(userId).setData({"avatar":avatar},merge: true);
      notifyListeners();
    });
  }

  chekDetail(context){
    print("chekDetail $contact") ;
    if(contact==null || contact==""){
      Navigator.push(context,
         CupertinoPageRoute(builder: (c) => EditProfileScreen()));

    }

  }





  updateAllMember(List<DocumentSnapshot> memberList){

    print("in updateAllMember") ;
    DateTime currentDate = DateTime.now();

    var currDt = DateTime.now();
    var toDayDate = "${currDt.day},${currDt.month},${currDt.year}" ;
     SharedPreferences.getInstance().then((prefs){
       if(prefs.getString("current_date")==""){
         prefs.setString("current_date", toDayDate) ;
       }else{
         if(toDayDate == prefs.getString("current_date")){}else{
           //notify member
           prefs.setString("current_date", toDayDate) ;
           memberList.forEach((member){
             var newDateTimeObj = DateTime.parse(member.data["date"]) ;
             var differenceee2 = "${newDateTimeObj.difference(currentDate).inDays}";
             print("SDfdfdfdffddfsfs### ${differenceee2} ") ;
             Firestore databaseReference = Firestore.instance;
             databaseReference.
             collection('user')
                 .document(userId)
                  .collection("members")
                  .document("${member.data["memberid"]}")
                 .updateData({'days_left': differenceee2 ,
               }) ;


           }) ;

         }
       }

     });

  }

}


class Members{
  String id;
  String  image ;
  String  name ;
  String contact ;
  String address ;
  double fullFees ;
  double payFees ;
  String joining_date ;
}
class DailyTips{
  String id;
  String  image ;
  String  title ;
  String description ;
}
