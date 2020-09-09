import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:unicorndial/unicorndial.dart';
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

  UserModal modal ;
  var amount = "0";
  var date_select ="" ;


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var childButtons = List<UnicornButton>();

    modal = Provider.of<UserModal>(context) ;


    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Phone",
        currentButton: FloatingActionButton(
          onPressed: (){
            Toast.show("Comming Soon..", context) ;
          },
          heroTag: "Phone",
          backgroundColor: Colors.blueAccent,
          mini: true,
          child: Icon(Icons.phone , color: Colors.white,),

        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Pay Fees",
        currentButton: FloatingActionButton(
          onPressed: (){



            AwesomeDialog(
              context: context,
              animType: AnimType.SCALE,
              dialogType: DialogType.INFO,
              body: Center(child:

              Padding(
                padding: EdgeInsets.all(5) ,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select Date',
                        textAlign: TextAlign.left ,
                        style: TextStyle(fontStyle: FontStyle.normal , fontSize: 20) ,
                      ),
                    ),

                    SizedBox(height: 5,) ,
                    Container(
                      height: 200,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime(2020, 1, 1),
                        onDateTimeChanged: (DateTime newDateTime) {
                          // Do something
                          print(newDateTime.toIso8601String()) ;
                          date_select =newDateTime.toIso8601String() ;
                        },


                      ),
                    ),

                    SizedBox(height: 10,) ,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter Amount',
                        textAlign: TextAlign.left ,
                        style: TextStyle(fontStyle: FontStyle.normal , fontSize: 20) ,
                      ),
                    ),
                    SizedBox(height: 10,) ,
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1 * SizeConfig.widthMultiplier),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: fieldBorder,
                            boxShadow: [boxShadow]),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5 * SizeConfig.widthMultiplier),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            style: fieldText,
                            onChanged: (e) {
                              amount = e ;
                            },
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).nextFocus();
                            },

                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Amount',
                              hintStyle: hintText,
                            ),
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),),
              title: 'This is Ignored',
              desc:   'This is also Ignored',
              btnOkOnPress: () {
                if(amount==""||date_select==""){
                  Toast.show("Please select Date or amount", context) ;
                }else{

                  modal.payFees(widget.member.documentID , context , amount , date_select)  ;

                }

              },
            )..show();




          },
            heroTag: "Payfees",
            backgroundColor: Colors.greenAccent,
            mini: true,
            child: Icon(Icons.account_balance_wallet , color: Colors.white,))));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Delete User",
        currentButton: FloatingActionButton(
            onPressed: (){
              AwesomeDialog(
                context: context,
                animType: AnimType.SCALE,
                dialogType: DialogType.ERROR,
                body: Center(child: Text(
                  'Are You sure you want to delete this user ?',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),),
                title: 'Delete',
                desc:   'This is delete user',
                btnOkOnPress: () {
                  modal.delete_user(widget.member.documentID , context)  ;
                },
              )..show();
            },
            heroTag: "delete",
            backgroundColor: Colors.red,
            mini: true,
            child: Icon(Icons.delete ,color: Colors.white,))));

    return new Scaffold(
        floatingActionButton:

        UnicornDialer(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
            parentButtonBackground: primaryColor,
            orientation: UnicornOrientation.VERTICAL,
            parentButton: Icon(Icons.add),
            childButtons: childButtons ,


        ),

//
//        Container(
//          height: 60.0,
//          width: 60.0,
//          child: FittedBox(
//            child: FloatingActionButton(
//              onPressed: () {
//
//                launch("tel:" + Uri.encodeComponent('${widget.member.data["contact"]}'));
//
//
//              },
//              child: Icon(
//                Icons.call,
//                color: Colors.white,
//              ),
//              // elevation: 5.0,
//            ),
//          ),
//        ),

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