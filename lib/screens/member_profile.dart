import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttergym/components/Header.dart';
import 'package:fluttergym/models/user_modal.dart';
import 'package:fluttergym/utils/const.dart';
import 'package:fluttergym/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
class MemberProfileScreen extends StatefulWidget {
  DocumentSnapshot member ;
  MemberProfileScreen(DocumentSnapshot member){
    this.member = member ;
  }

  @override
  _MemberProfileScreenState createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  _launchURL([link]) async {
    if(link==null){
      const url = 'https://www.google.com/';
    }else{

      if (await canLaunch(link)) {
        await launch(link);
      } else {
        throw 'Could not launch $link';
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;


    return new Scaffold(
        floatingActionButton: Container(
          height: 60.0,
          width: 60.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {

                launch("tel:" + Uri.encodeComponent('${widget.member.data["contact"]}'));


              },
              child: Icon(
                Icons.call,
                color: Colors.white,
              ),
              // elevation: 5.0,
            ),
          ),
        ),

        appBar: AppBar(
          leading: GestureDetector(
              onTap: (){
                Navigator.pop(context) ;
              },
              child: Icon(Icons.arrow_back , color: Colors.white,)),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Member Profile",
              style: TextStyle(
                fontSize: 2.5 * SizeConfig.textMultiplier,
                color: Colors.white ,
                fontWeight: FontWeight.w700,
              ),
            ),
          ) ,
          actions: <Widget>[

                     ]
          ,),
        body:  Stack(

          children: <Widget>[


            ClipPath(
              child: Container(color: primaryColor),
              clipper: getClipper(),
            ),
            Positioned(
                width: 350.0,
                top: MediaQuery.of(context).size.height / 9,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            image: DecorationImage(
                                image: NetworkImage(
                                    '${widget.member.data["images_url"]==null?placeHolderImage:widget.member.data["images_url"]}'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ])),
                    SizedBox(height: 20.0),
                    Text(
                      '${widget.member.data["name"]}',
                      style: TextStyle(
                          fontSize: 3.3 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 1.3 * SizeConfig.heightMultiplier,),
                    Text(
                      '${widget.member.data["contact"]}',
                      style: TextStyle(
                          fontSize: 2.0 * SizeConfig.textMultiplier,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 1.3 * SizeConfig.heightMultiplier),

                    Text(
                      '${widget.member.data["address"]}',
                      style: TextStyle(
                          fontSize: 2.0 * SizeConfig.textMultiplier,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 1.3 * SizeConfig.heightMultiplier),
                    Text(
                      'Full fees : ${widget.member.data["full_fees"]}',
                      style: TextStyle(
                          fontSize: 2.0 * SizeConfig.textMultiplier,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 1.3 * SizeConfig.heightMultiplier),
                    Text(
                      'Pay fees : ${widget.member.data["pay_fees"]}',
                      style: TextStyle(
                          fontSize: 2.0 * SizeConfig.textMultiplier,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'),
                    ),

                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Icon(Icons.delete,
                        color: Colors.red,
                        ) ,

                        SizedBox(width: 10.0),

                        Text(
                          'Delete Member',

                          style: TextStyle(
                              fontSize: 19.0,
                              fontStyle: FontStyle.normal,
                              color: Colors.red,
                              fontFamily: 'Montserrat'),
                        ),
                      ],
                    ),

                  ],
                )) ,

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(4),

                  child: Text(
                    'Days Left : ${widget.member.data["days_left"]}',
                    style: TextStyle(
                        fontSize: 2.2 *SizeConfig.textMultiplier ,
                        color: Colors.white,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ],
            ),

          ],
        ));
  }
}
class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height / 2.5);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}