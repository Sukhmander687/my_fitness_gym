import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttergym/models/user_modal.dart';
import 'package:fluttergym/screens/add_exercise.dart';
import 'package:fluttergym/utils/size_config.dart';
import 'package:provider/provider.dart';


import '../utils/const.dart';
import 'exercise_detail_screen.dart';
import 'login_register.dart';

class AllExerciseScreen extends StatefulWidget {String type ;
  AllExerciseScreen(String type){
    this.type = type ;
  }

  @override
  _AllExerciseScreenState createState() => _AllExerciseScreenState();
}

class _AllExerciseScreenState extends State<AllExerciseScreen> {


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
  bool search_flag = false ;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserModal>(context);
    List<DocumentSnapshot> exerciseList = List();
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
        floatingActionButton:
        FloatingActionButton(
          heroTag: "hjhjnh",
          onPressed: () {
            if (user.guestLogin) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 7 * SizeConfig.widthMultiplier),
                          child: Material(
                            color: Colors.transparent,
                            child: Wrap(
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: fieldBorder,
                                      color: Colors.white,
                                      boxShadow: [boxShadow]),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 3 *
                                            SizeConfig.heightMultiplier,
                                      ),
                                      Text(
                                        'LOGIN',
                                        style: dialogTitle,
                                      ),
                                      SizedBox(
                                        height: 1.5 *
                                            SizeConfig.heightMultiplier,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'you need to login',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.w500,
                                                color: darkText,
                                                fontSize: 2.5 *
                                                    SizeConfig
                                                        .textMultiplier),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1 *
                                            SizeConfig.heightMultiplier,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1.5 *
                                                SizeConfig
                                                    .heightMultiplier),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            RaisedButton(
                                                shape:
                                                new RoundedRectangleBorder(
                                                  borderRadius:
                                                  new BorderRadius
                                                      .circular(18.0),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                              LoginRegister()));
                                                },
                                                color: accentColor,
                                                child: Text(
                                                  'ok',
                                                  style: dialogActions,
                                                )),
                                            SizedBox(
                                              width: 3 *
                                                  SizeConfig
                                                      .widthMultiplier,
                                            ),
                                            RaisedButton(
                                                shape:
                                                new RoundedRectangleBorder(
                                                  borderRadius:
                                                  new BorderRadius
                                                      .circular(18.0),
                                                ),
                                                color: accentColor,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: dialogActions,
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => AddExercise()));
            }
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),

      appBar: AppBar(
        leading:
        GestureDetector(
          onTap: (){
           Navigator.pop(context) ;
          },
          child: Icon(Icons.arrow_back , color: Colors.white,
          ),
        ),
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "${widget.type=="my"?"My Exercise" : "All Exercise"}",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white ,
              fontWeight: FontWeight.w700,
            ),
          ),
        ) ,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              search_flag = true ;
              setState(() {

              });
            },
            child: Icon(Icons.search , color: Colors.white,
            ),
          ),
          SizedBox(width: 10,)
        ]
        ,) ,

        body: Column(
          children: <Widget>[
            search_flag?Container(
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
            ):Container(),
            Expanded(
              child:
              StreamBuilder<QuerySnapshot>(
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
                    if (searchText == "") {
                     // exerciseList = snapshot.data.documents ;
                      exerciseList.clear() ;
                      snapshot.data.documents.forEach((f){
                        exerciseList.add(f) ;


                      });

                    } else {
                      exerciseList.clear();
                      snapshot.data.documents.forEach((doc) {
                        if (doc.data["title"]
                            .toString()
                            .toLowerCase()
                            .contains(searchText.toLowerCase())) {
                          exerciseList.add(doc) ;

                        }
                      });
                    }

                    return ListView.builder(
                      itemBuilder: (c, index) => Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4 * SizeConfig.widthMultiplier,
                            vertical: 1 * SizeConfig.widthMultiplier),
                        child: InkWell(
                          onTap: () {

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => ExerciseDetailScreen(
                                        exerciseList[index].data)));

                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: fieldBorder,
                                color: Colors.white,
                                boxShadow: [boxShadow]),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4 * SizeConfig.widthMultiplier,
                                  vertical: 2 * SizeConfig.heightMultiplier),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 14 * SizeConfig.heightMultiplier,
                                    width: 30 * SizeConfig.widthMultiplier,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.grey,
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
                                            fit: BoxFit.cover)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: Text(
                                              '${exerciseList[index]["title"]}',
                                              style: title,
                                            )),
//                                            Icon(
//                                              Icons.more_vert,
//                                              color: Colors.grey,
//                                              size: 5 *
//                                                  SizeConfig
//                                                      .imageSizeMultiplier,
//                                            )
                                          ],
                                        ),
                                        Text(

                                            '${exerciseList[index]["description"]}',
                                            style: content
                                        ,maxLines: 3,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '${exerciseList[index]["comment_counter"] == null ? 0 : exerciseList[index]["comment_counter"]} Comments',
                                                  style: TextStyle(
                                                      color: accentColor,
                                                      fontSize: 2 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                        '${exerciseList[index]["like_counter"]} likes',
                                                        style: bottomText),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        '${exerciseList[index]["share_counter"]} share',
                                                        style: bottomText),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Container(),
                                            ),
                                            InkWell(
                                              onTap: () { },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    boxShadow: [boxShadow],
                                                    color: Colors.white),
                                                child: Padding(
                                                  padding: EdgeInsets.all(1 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                                  child: Icon(
                                                    Icons.share,
                                                    color: primaryColor,
                                                    size: 5 *
                                                        SizeConfig
                                                            .imageSizeMultiplier,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      itemCount: exerciseList.length,
                      padding: EdgeInsets.only(bottom: 80),
                    );
                  }),
            ),
          ],
        ));
  }

}
