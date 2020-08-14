import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttergym/components/Header.dart';
import 'package:fluttergym/models/user_modal.dart';
import 'package:fluttergym/screens/all_member_screen.dart';
import 'package:fluttergym/screens/edit_profile_screen.dart';
import 'package:fluttergym/tabs/add_member_screen.dart';
import 'package:fluttergym/tabs/drawer.dart';
import 'package:fluttergym/tabs/home_screen.dart';
import 'package:fluttergym/tabs/profile_screen.dart';
import 'package:fluttergym/tabs/search_screen.dart';
import 'package:fluttergym/utils/const.dart';
import 'package:fluttergym/utils/dialogs.dart';
import 'package:fluttergym/utils/size_config.dart';
import 'package:provider/provider.dart';

import 'dashboard_screen.dart';
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  PageController _myPage = PageController(initialPage: 0);
  var currentTap = 0 ;

  bool home_flag = true , search_flag = false , dashboard_flag = false , profile_flag = false ;
  UserModal modal ;
  var title = "Home" ;
  bool profile_Status  = false ;
  var _scaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    modal = Provider.of<UserModal>(context) ;






//    if(modal.contact==null || modal.contact==""){
//      Navigator.pushAndRemoveUntil(context,
//          CupertinoPageRoute(builder: (c) => EditProfileScreen()),(c) => false);
//    }

    return



      WillPopScope(
      onWillPop: (){
        print("gygg ");


        if(currentTap==0){

          exitBottomSheet(context) ;

        }else{
          currentTap = 0 ;
          setState(() {
            _myPage.jumpToPage(0);
          });
        }

      },
      child: Scaffold(
        key: _scaffold,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
         endDrawer: EndDrawer() ,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 75,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  iconSize: 30.0,
                  padding: EdgeInsets.only(left: 28.0),
                  icon: Icon(Icons.home , color: home_flag?primaryColor:Colors.grey,),
                  onPressed: () {
                    currentTap = 0 ;
                    setState(() {
                      _myPage.jumpToPage(0);
                    });
                  },
                ),
                IconButton(
                  iconSize: 30.0,
                  padding: EdgeInsets.only(right: 28.0),
                  icon: Icon(Icons.search , color: search_flag?primaryColor:Colors.grey),
                  onPressed: () {
                    currentTap = 1 ;
                    setState(() {
                      _myPage.jumpToPage(1);
                    });
                  },
                ),
                IconButton(
                  iconSize: 30.0,
                  padding: EdgeInsets.only(left: 28.0),
                  icon: Icon(Icons.dashboard , color: dashboard_flag?primaryColor:Colors.grey),
                  onPressed: () {
                    currentTap = 2 ;
                    setState(() {
                      _myPage.jumpToPage(2);
                    });
                  },
                ),
                IconButton(
                  iconSize: 30.0,
                  padding: EdgeInsets.only(right: 28.0),
                  icon: Icon(Icons.account_circle  , color: profile_flag?primaryColor:Colors.grey),
                  onPressed: () {
                    currentTap = 3 ;
                    setState(() {
                      _myPage.jumpToPage(3);
                    });
                  },
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){

              _scaffold.currentState.openEndDrawer();

            },
            child: Icon(Icons.menu , color: Colors.white,
            ),
          ),
          title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white ,
              fontWeight: FontWeight.w700,
            ),
          ),
        ) ,
          actions: <Widget>[
            !profile_Status?
            GestureDetector(
              onTap: (){
                showDialog(context: context,
                    builder: (c) => FullImageDialog(modal.avatar==null||modal.avatar==""?"${placeHolderImage}" :modal.avatar)
                );

              },
              child: Container(
                width: 54.0,
                height: 54.0,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(right: 20.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(modal.avatar==null||modal.avatar==""?"${placeHolderImage}" :modal.avatar) ,
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(360),
                  ),
                  color: primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 20.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 4.0,
                  ),
                ),
              ),
            ):
            GestureDetector(
              onTap: (){
                showDialog(context: context,
                    builder: (c) => EditProfileScreen()
                );
              },
              child: Container(
                width: 54.0,
                height: 54.0,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.edit,color: primaryColor,),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(360),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 20.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 4.0,
                  ),
                ),
              ),
            )
          ]
          ,),
        body: SafeArea(
          child: Column(
            children: <Widget>[


              Expanded(
                child: PageView(
                  controller: _myPage,
                  onPageChanged: (int) {
                    print('Page Changes to index $int');
                    if(int== 0 ){
                      profile_Status = false ;
                      home_flag = true ;
                      search_flag = false ;
                      dashboard_flag = false ;
                      profile_flag = false ;
                      title = "Home" ;
                    }else if(int== 1 ){
                      profile_Status = false ;
                      title = "Search" ;
                      home_flag = false ;
                      search_flag = true ;
                      dashboard_flag = false ;
                      profile_flag = false ;
                    }else if(int== 2 ){
                      profile_Status = false ;
                      title = "Dashboard" ;
                      home_flag = false ;
                      search_flag = false ;
                      dashboard_flag = true ;
                      profile_flag = false ;
                    }else{
                      profile_Status = true ;
                      title = "Profile" ;
                      home_flag = false ;
                      search_flag = false ;
                      dashboard_flag = false ;
                      profile_flag = true ;
                    }

                    setState(() {

                    });
                  },
                  children: <Widget>[
                    HomeScreen() ,
                    AllMemberScreen(),
                    DashboardScreen(),
                    ProfileScreen()

                  ],
                  physics: NeverScrollableScrollPhysics(), // Comment this if you need to use Swipe.
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 60.0,
          width: 60.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, CupertinoPageRoute(builder: (c) => AddMemberScreen())) ;
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              // elevation: 5.0,
            ),
          ),
        ),
      ),
    );
  }


  void exitBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return
            Material(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 3 * SizeConfig.heightMultiplier,
                        ),
                        Text(
                          'Exit',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 2.8 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        SizedBox(
                          height: 1.5 * SizeConfig.heightMultiplier,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Are you sure you want to\nExit?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: darkText,
                                  fontSize: 2.3 * SizeConfig.textMultiplier),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1 * SizeConfig.heightMultiplier,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.5 * SizeConfig.heightMultiplier),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 2.3 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                              SizedBox(
                                width: 3 * SizeConfig.widthMultiplier,
                              ),
                              RaisedButton.icon(
                                  elevation: 0,
                                  color: primaryColor,
                                  onPressed: () {
                                    SystemNavigator.pop();
                                  },
                                  icon: Icon(
                                    Icons.exit_to_app,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'Exit',
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
            );
        }
    );
  }

}
