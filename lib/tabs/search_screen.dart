import 'package:flutter/material.dart';
import 'package:fluttergym/components/Header.dart';
import 'package:fluttergym/components/daily_tip.dart';
import 'package:fluttergym/components/section.dart';
import 'package:fluttergym/components/user_photo.dart';
import 'package:fluttergym/components/user_tip.dart';
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                children: <Widget>[

                  // MainCardPrograms(), // MainCard


                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    padding: EdgeInsets.only(top: 10.0, bottom: 40.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                    ),
                    child: Column(
                      children: <Widget>[
                        Section(
                          title: 'New Users',
                          horizontalList: <Widget>[
                            UserTip(
                              image: 'assets/images/image010.jpg',
                              name: 'User Img',
                            ),
                            UserTip(
                              image: 'assets/images/image010.jpg',
                              name: 'User Img',
                            ),
                            UserTip(
                              image: 'assets/images/image010.jpg',
                              name: 'User Img',
                            ),
                            UserTip(
                              image: 'assets/images/image010.jpg',
                              name: 'User Img',
                            ),
                          ],
                        ),



                        Section(
                          title: "Dialy Tips" ,
                          horizontalList: <Widget>[
                            DailyTip(),
                            DailyTip(),
                            DailyTip(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
