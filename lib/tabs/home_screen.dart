import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttergym/components/daily_tip.dart';
import 'package:fluttergym/components/Header.dart';
import 'package:fluttergym/components/image_card_with_basic_footer.dart';
import 'package:fluttergym/components/section.dart';
import 'package:fluttergym/components/image_card_with_internal.dart';
import 'package:fluttergym/components/main_card_programs.dart';
import 'package:fluttergym/components/user_photo.dart';
import 'package:fluttergym/components/user_tip.dart';
import 'package:fluttergym/models/exercise.dart';
import 'package:fluttergym/models/user_modal.dart';
import 'package:fluttergym/pages/activity_detail.dart';

import 'package:flutter/material.dart';
import 'package:fluttergym/screens/all_member_screen.dart';
import 'package:fluttergym/screens/exercise_detail_screen.dart';
import 'package:fluttergym/screens/member_profile.dart';
import 'package:fluttergym/screens/all_exercise_screen.dart';
import 'package:fluttergym/tabs/add_member_screen.dart';
import 'package:fluttergym/utils/const.dart';
import 'package:fluttergym/utils/dialogs.dart';
import 'package:fluttergym/utils/size_config.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<DocumentSnapshot> exerciseList = List();
  List<DocumentSnapshot> memberList = List();
  UserModal  modal ;

  @override
  Widget build(BuildContext context) {
    modal = Provider.of<UserModal>(context) ;

    if(modal.avatar ==null){
      modal.avatar = profileplaceHolderImage ;
    }

    return
      Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 1.0),
                child: Column(
                  children: <Widget>[

                    // MainCardPrograms(), // MainCard


                    Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 10,) ,
                                  Text("Members" , style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                  ),),

                                  Expanded(child: Container(),) ,
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) => AllMemberScreen()));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10.0),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5.0,
                                        horizontal: 15.0,
                                      ),
                                      child: Text(
                                        'Show all',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                  ),

                                ],
                              ) ,

                              SizedBox(height: 10,) ,
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  height: 20 * SizeConfig.heightMultiplier ,
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream:
                                      Firestore.instance.collection("user")
                                          .document("${modal.userId}")
                                          .collection('members')
                                          //.where("days_left", isGreaterThan: 0,)
                                          .snapshots() ,

                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return loaderDialog();
                                        }
                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Text("Error Occured"),
                                          );
                                        }


                                        modal.updateAllMember(snapshot.data.documents) ;

                                        memberList.clear() ;
                                        snapshot.data.documents.forEach((f){
                                          memberList.add(f) ;

                                        });

                                        print("memberList ${memberList.length}") ;
                                        if(memberList.length==0){
                                          return GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, CupertinoPageRoute(builder: (co) => AddMemberScreen()));

                                            },
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                margin: EdgeInsets.all(5),
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 30*SizeConfig.imageSizeMultiplier,
                                                      height: 30*SizeConfig.imageSizeMultiplier,
                                                      child: Icon(Icons.add_circle , size: 20*SizeConfig.imageSizeMultiplier,),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(360.0),
                                                        ),
                                                        border: Border.all(
                                                          color: Colors.white,
                                                          width: 7.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(top: 10.0),
                                                      child: Text(
                                                        "",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black38,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ) ;

                                        }else
                                        {
                                          return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (c, index) =>
                                                GestureDetector(
                                                  onTap: (){
                                                    Navigator.push(context, CupertinoPageRoute(builder: (co) => MemberProfileScreen(memberList[index]))) ;
                                                  },
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Container(
                                                      margin: EdgeInsets.all(5),
                                                      child: Column(
                                                        children: <Widget>[
                                                          GestureDetector(
                                                            onTap: (){

                                                              showDialog(context: context,
                                                                  builder: (c) => FullImageDialog(memberList[index].data["images_url"])
                                                              );


//                                                              showDialog(context: context,builder: (c)=>
//                                                                  SafeArea(child: Padding(
//                                                                padding: const EdgeInsets.symmetric(vertical:8.0),
//                                                                child: Stack(
//                                                                  alignment: Alignment.center,
//                                                                  children: <Widget>[
//                                                                    Container(child: Image.network(
//                                                                      memberList[index]
//                                                                          .data[
//                                                                      "images_url"]!=null ?
//                                                                      memberList[index].data[
//                                                                      "images_url"]
//                                                                          : '${placeHolderImage}',
//                                                                    ),),
//
//                                                                  ],
//                                                                ),
//                                                              )));

                                                            },
                                                            child: Container(
                                                              width: 30*SizeConfig.imageSizeMultiplier,
                                                              height: 30*SizeConfig.imageSizeMultiplier,
                                                              decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                  image:  NetworkImage(
                                                                    memberList[index]
                                                                        .data[
                                                                    "images_url"]!=null ?
                                                                    memberList[index].data[
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
                                                          Container(
                                                            margin: EdgeInsets.only(top: 10.0),
                                                            child: Text(
                                                              "${memberList[index].data["name"]}",
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(top: 0.0),
                                                            child: Text(
                                                              "Days left ${memberList[index].data["days_left"]}",
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors.black38,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ) ,
                                            itemCount: memberList.length ,

                                          );
                                        }
                                      }),
                                ),
                              ),
                            ],),) ,
                          SizedBox(height: 10,) ,
                          Row(
                            children: <Widget>[
                              Text("Dialy Excercise" , style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                              ),),
                              Expanded(child: Container(),) ,
                              GestureDetector(
                                onTap: (){

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) => AllExerciseScreen("all")));


                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 15.0,
                                  ),
                                  child: Text(
                                    'Show all',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                    color: Colors.lightBlue,
                                  ),
                                ),
                              ),
                            ],
                          ) ,

                          SizedBox(height: 10,) ,
                          Container(
                            height: 100 * SizeConfig.heightMultiplier ,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance
                                    .collection('exercise')
                                    .orderBy("time",descending: true)
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
                                  exerciseList.clear() ;
                                  snapshot.data.documents.forEach((f){
                                    exerciseList.add(f) ;
                                  });
                                  Size size = MediaQuery.of(context).size;
                                  double width = size.width * 0.80;
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (c, index) =>

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: (){
                                                showDialog(context: context,builder: (c)=>SafeArea(child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical:8.0),
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: <Widget>[
                                                      Container(child: Image.network(
                                                        List.from(exerciseList[index]
                                                            .data[
                                                        "images_url"])
                                                            .length >
                                                            0
                                                            ? List.from(
                                                            exerciseList[index].data[
                                                            "images_url"])[0]
                                                            : '${placeHolderImage}',
                                                      ),),

                                                    ],
                                                  ),
                                                )));


                                              },
                                              child: Container(
                                                width: width ,
                                                height: 200.0,
                                                margin: EdgeInsets.only(
                                                  right: 15.0,
                                                  bottom: 10.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image:
                                                    NetworkImage(
                                                      List.from(exerciseList[index]
                                                          .data[
                                                      "images_url"])
                                                          .length >
                                                          0
                                                          ? List.from(
                                                          exerciseList[index].data[
                                                          "images_url"])[0]
                                                          : '${placeHolderImage}',
                                                    ),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              exerciseList[index].data["title"],
                                              style: TextStyle(fontSize: 14.0),
                                            ),
                                            Container(
                                              width: width,
                                              margin: EdgeInsets.only(top: 10.0),
                                              child: Text(
                                                exerciseList[index].data["description"],
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (c) => ExerciseDetailScreen(
                                                            exerciseList[index].data)));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(top: 10.0),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 5.0,
                                                  horizontal: 15.0,
                                                ),
                                                child: Text(
                                                  'More',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0),
                                                  ),
                                                  color: Colors.lightBlue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ) ,
                                    itemCount: exerciseList.length,
                                    padding: EdgeInsets.only(bottom: 10),
                                  );
                                }),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      );
  }
}

