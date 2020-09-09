import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttergym/models/user_modal.dart';
import 'package:fluttergym/utils/dialogs.dart';
import 'package:fluttergym/utils/size_config.dart';
import 'package:provider/provider.dart';


import '../utils/const.dart';
import 'login_register.dart';
import 'member_profile.dart';

class AllMemberScreen extends StatefulWidget {
  AllMemberScreen();

  @override
  _AllMemberScreenState createState() => _AllMemberScreenState();
}

class _AllMemberScreenState extends State<AllMemberScreen> {


  QuerySnapshot snapshot;

  // bool likePress = true;
  bool sharePress = true;

  List likeList = List();

  bool loadData = false;

  TextStyle title;

  TextStyle content;

  TextStyle bottomText;

  UserModal user;

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserModal>(context);
    List<DocumentSnapshot> problemsList = List();
    title = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 2.5 * SizeConfig.textMultiplier,
    );

    content = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 1.8 * SizeConfig.textMultiplier,
    );

    bottomText = TextStyle(
        color: lightGrey,
        fontSize: 1.9 * SizeConfig.textMultiplier,
        fontWeight: FontWeight.w500);
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: scaffoldCol,


        body: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                color: scaffoldCol,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 4 * SizeConfig.widthMultiplier, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius:fieldBorder),
                    child: TextFormField(
                      style: fieldText,
                      textAlign: TextAlign.center,
                      onChanged: (e) {
                        searchText = e;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '\u2315 Search...',
                          hintStyle: hintText),
                    ),
                  ),
                ),
              ),
              Expanded(
                child:
                StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection("user")
                        .document("${user.userId}")
                        .collection('members')
                        .where("is_deleted", isEqualTo: "0")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return loaderDialog();
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error Occured"),
                        );
                      }
                      if (searchText == "") {
                        // problemsList = snapshot.data.documents ;
                        problemsList.clear() ;
                        snapshot.data.documents.forEach((f){
                          problemsList.add(f) ;


                        });

                      } else {
                        problemsList.clear();
                        snapshot.data.documents.forEach((doc) {
                          if (doc.data["name"]
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase())) {
                            problemsList.add(doc) ;

                          }
                        });
                      }

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemBuilder: (c, index) =>
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, CupertinoPageRoute(builder: (co) => MemberProfileScreen(problemsList[index]))) ;
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10 , right: 10),
                                child: Card(

                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      child: Stack(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  GestureDetector(onTap: (){

                                                    showDialog(context: context,
                                                        builder: (c) => FullImageDialog(
                                                          problemsList[index]
                                                              .data[
                                                          "images_url"]!=null ?
                                                          problemsList[index].data[
                                                          "images_url"]
                                                              : '${placeHolderImage}',
                                                        )
                                                    );

                                                  },
                                                    child: Container(
                                                      width: 22*SizeConfig.imageSizeMultiplier,
                                                      height: 22*SizeConfig.imageSizeMultiplier,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image:  NetworkImage(
                                                            problemsList[index]
                                                                .data[
                                                            "images_url"]!=null ?
                                                            problemsList[index].data[
                                                            "images_url"]
                                                                : '${placeHolderImage}',
                                                          ),
                                                        ),
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(360.0),
                                                        ),
                                                        border: Border.all(
                                                          color: Colors.white,
                                                          width: 7.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,) ,

                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[

                                                      Container(
                                                        child: Text(
                                                          "${problemsList[index].data["name"]}",
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black38,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 7.0),
                                                        child: Text(
                                                          "${problemsList[index].data["contact"]}",
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black38,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),

                                              Divider()

                                            ],
                                          ),

                                          Container(
                                              margin: EdgeInsets.only(right:  6 , top: 3*SizeConfig.heightMultiplier),
                                              alignment: Alignment.centerRight,
                                              child: Icon(Icons.call))

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ) ,
                        itemCount: problemsList.length ,

                      );
                    }),
              ),
            ],
          ),
        ));
  }

}
