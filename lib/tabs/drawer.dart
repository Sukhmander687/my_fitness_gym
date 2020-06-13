import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttergym/models/user_modal.dart';
import 'package:fluttergym/screens/all_exercise_screen.dart';
import 'package:fluttergym/utils/const.dart';
import 'package:fluttergym/utils/dialogs.dart';
import 'package:fluttergym/utils/size_config.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EndDrawer extends StatefulWidget {
  @override
  _EndDrawerState createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {

  bool _isOpen = false;
  bool _profileView = false;
  UserModal user ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 200), (){
      setState(() {
        _isOpen = true;
      });
    });
    Timer(Duration(milliseconds: 400), (){
      setState(() {
        _profileView = true;
      });
    });
  }

  var homeAccentText = TextStyle(
    fontSize: 2.8 * SizeConfig.textMultiplier,
    color: accentColor,
  );

  @override
  Widget build(BuildContext context) {

    user = Provider.of<UserModal>(context) ;
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;


    return Container(
      color: Colors.white,
      width: 73 * SizeConfig.widthMultiplier,
      child: Column(
        children: <Widget>[

          Stack(
            children: <Widget>[

              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
                height: _isOpen?36 * SizeConfig.heightMultiplier:0,
                decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40)
                    )
                ),
              ),

              AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                height: _isOpen?34 * SizeConfig.heightMultiplier:0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40)
                  )
                ),
                child: AnimatedOpacity(
                  duration: Duration(
                    milliseconds: 400
                  ),
                  opacity: _profileView?1.0:0.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[


                      GestureDetector(
                        onTap: (){
                          if (user.guestLogin){}else{
                            changeImage() ;
//                            if(user.avatar==""){
//                              changeImage();
//                            }else{
//
//                            }
                          }

                        },
                        child: Container(
                          height: 14 * SizeConfig.heightMultiplier,
                          width: 21 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white, width: 1)
                          ),
                          child: Center(
                            child: user.imageUploading?Center(child: CircularProgressIndicator()):Container(
                              height: 11.5 * SizeConfig.heightMultiplier,
                              width: 11.5 * SizeConfig.heightMultiplier,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: NetworkImage(user.avatar==null||user.avatar==""?"${placeHolderImage}" :user.avatar) ,
                                    fit: BoxFit.fill, )
                              ),
                            ),
                          ),
                        ),
                      ),


                      Text('${user.name}', style: TextStyle(
                          color: Colors.white,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w600
                      ),),

                      Text('${user.guestLogin?"":user.email}', style: TextStyle(
                          color: Colors.white,
                          fontSize: 1.5 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w500
                      ),)

                    ],
                  ),
                ),
              ),




            ],
          ),

          Expanded(child:
            ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 5, left: 2 * SizeConfig.widthMultiplier, right: 2 * SizeConfig.widthMultiplier),
              children: <Widget>[

                Container(
                  color: Colors.white,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context) ;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => AllExerciseScreen("my")));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.7 * SizeConfig.heightMultiplier),
                        child: user.guestLogin?null:showFab ?Row(
                          children: <Widget>[

                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1.6 * SizeConfig.widthMultiplier),
                                child: Icon(Icons.airline_seat_recline_extra, size: 5.5 * SizeConfig.imageSizeMultiplier, color: accentColor,)
                            ),

                            Expanded(child:


                            GestureDetector(
                              onTap: (){ },
                              child: Text('My Exercise', style: TextStyle(
                                color: darkText,
                                fontWeight: FontWeight.w600,
                                fontSize: 2.5 * SizeConfig.textMultiplier
                              ),),
                            )),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2 * SizeConfig.widthMultiplier),
                              child: Icon(Icons.arrow_forward, color: accentColor, size: 5 * SizeConfig.imageSizeMultiplier,),
                            )

                          ],
                        ):null,
                      ),
                    ),
                  ),
                ),





                Container(
                  color: Colors.white,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: (){ },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.7 * SizeConfig.heightMultiplier),
                        child: user.guestLogin?null:showFab ?Row(
                          children: <Widget>[

                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1.6 * SizeConfig.widthMultiplier),
                                child: Icon(Icons.lock, size: 5.5 * SizeConfig.imageSizeMultiplier, color: accentColor,)
                            ),

                            Expanded(child: Text('Privacy Policy', style: TextStyle(
                                color: darkText,
                                fontWeight: FontWeight.w600,
                                fontSize: 2.5 * SizeConfig.textMultiplier
                            ),)),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2 * SizeConfig.widthMultiplier),
                              child: Icon(Icons.arrow_forward, color: accentColor, size: 5 * SizeConfig.imageSizeMultiplier,),
                            )

                          ],
                        ):null,
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: !user.guestLogin,
                  child: Container(
                    color: Colors.white,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context) ;
                          showDialog(context: context,
                              builder: (c) => LogoutDialog()
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.7 * SizeConfig.heightMultiplier),
                          child: Row(
                            children: <Widget>[

                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1.6 * SizeConfig.widthMultiplier),
                                  child: Icon(Icons.exit_to_app, size: 5.5 * SizeConfig.imageSizeMultiplier, color: accentColor,)
                              ),

                              Expanded(child: Text('Logout', style: TextStyle(
                                  color: darkText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 2.5 * SizeConfig.textMultiplier
                              ),)),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2 * SizeConfig.widthMultiplier),
                                child: Icon(Icons.arrow_forward, color: accentColor, size: 5 * SizeConfig.imageSizeMultiplier,),
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: user.guestLogin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {  },
                          child: Text(
                            'Sign In',
                            style: homeAccentText,
                          )),
                      Container(
                        width: 2,
                        height: 2 * SizeConfig.heightMultiplier,
                        color: accentColor,
                      ),
                      FlatButton(
                          onPressed: () {  },
                          child: Text(
                            'Sign Up',
                            style: homeAccentText,
                          ))
                    ],
                  ),
                ),

              ],
            ),
          )

        ],
      ),
    );
  }


  logoutCallBacks(){
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("login", false);
      user.login = false ;
     // user.notifyListeners() ;
    });
  }

  changeImage(){
    showDialog(context: context,
        builder: (c) => ChooseImageDialog(getImage)
    );
  }
  getImage(ImageSource gallery) async {
    File image = await ImagePicker.pickImage(source: gallery);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    ) ;

    user.changeProfilePic(croppedFile);
    //  uploadFile();
  }

}
