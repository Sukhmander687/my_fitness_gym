import 'package:flutter/material.dart';
import 'package:fluttergym/models/user_modal.dart';
import 'package:fluttergym/screens/login_register.dart';
import 'package:fluttergym/utils/const.dart';
import 'package:fluttergym/utils/size_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ChooseImageDialog extends StatefulWidget {
  Function(ImageSource gallery) getImage;

  ChooseImageDialog(this.getImage);

  @override
  _ChooseImageDialogState createState() => _ChooseImageDialogState();
}

class _ChooseImageDialogState extends State<ChooseImageDialog> {
  var shape = RoundedRectangleBorder(borderRadius: fieldBorder);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 7 * SizeConfig.widthMultiplier),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 3 * SizeConfig.heightMultiplier,
                    ),
                    Text(
                      'ADD IMAGE',
                      style: dialogTitle,
                    ),
                    SizedBox(
                      height: 1.5 * SizeConfig.heightMultiplier,
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
                                Colors.grey,
                                Colors.white.withOpacity(0.5)
                              ])),
                        ),
                        Text(
                          'From',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: darkText,
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
                                Colors.grey
                              ])),
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
                          RaisedButton.icon(
                              elevation: 0,
                              shape: shape,
                              color: primaryColor,
                              onPressed: () {
                                Navigator.pop(context);
                                widget.getImage(ImageSource.camera);
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Camera',
                                style: dialogActions,
                              )),
                          SizedBox(
                            width: 3 * SizeConfig.widthMultiplier,
                          ),
                          RaisedButton.icon(
                              elevation: 0,
                              color: primaryColor,
                              shape: shape,
                              onPressed: () {
                                Navigator.pop(context);
                                widget.getImage(ImageSource.gallery);
                              },
                              icon: Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Gallery',
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
    );
  }
}

// ignore: must_be_immutable
class AddVideo extends StatefulWidget {
  Function(ImageSource gallery) getVideo;

  AddVideo(this.getVideo);

  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  var shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(35)));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 7 * SizeConfig.widthMultiplier),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 3 * SizeConfig.heightMultiplier,
                    ),
                    Text(
                      'ADD VIDEO',
                      style: dialogTitle,
                    ),
                    SizedBox(
                      height: 1.5 * SizeConfig.heightMultiplier,
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
                                Colors.grey,
                                Colors.white.withOpacity(0.5)
                              ])),
                        ),
                        Text(
                          'From',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: darkText,
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
                                Colors.grey
                              ])),
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
                          RaisedButton.icon(
                              elevation: 0,
                              shape: shape,
                              color: primaryColor,
                              onPressed: () {
                                Navigator.pop(context);
                                widget.getVideo(ImageSource.camera);
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Camera',
                                style: dialogActions,
                              )),
                          SizedBox(
                            width: 3 * SizeConfig.widthMultiplier,
                          ),
                          RaisedButton.icon(
                              elevation: 0,
                              color: primaryColor,
                              shape: shape,
                              onPressed: () {
                                Navigator.pop(context);
                                widget.getVideo(ImageSource.gallery);
                              },
                              icon: Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Gallery',
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
    );
  }
}



class LogoutDialog extends StatefulWidget {
  LogoutDialog();

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}
class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return
      Center(
      child: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: 7 * SizeConfig.widthMultiplier),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 3 * SizeConfig.heightMultiplier,
                    ),
                    Text(
                      'LOGOUT',
                      style: dialogTitle,
                    ),
                    SizedBox(
                      height: 1.5 * SizeConfig.heightMultiplier,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Are you sure you want to\nLogout?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: darkText,
                              fontSize: 2.5 * SizeConfig.textMultiplier),
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
                                  fontSize: 2.5 * SizeConfig.textMultiplier,
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
                                SharedPreferences.getInstance().then((prefs){

                                  prefs.setBool("login", false) ;
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (con) => LoginRegister()),
                                          (context) => false);

                                }) ;


                                 },
                              icon: Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Logout',
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
    );
  }
}


class FullImageDialog extends StatefulWidget {
  var path ;
  FullImageDialog(path){
    this.path = path ;
  }

  @override
  _FullImageDialogState createState() => _FullImageDialogState();
}
class _FullImageDialogState extends State<FullImageDialog> {
  @override
  Widget build(BuildContext context) {
    return
      Material(
        color: Colors.transparent,
        child:  SafeArea(child: Padding(
          padding: const EdgeInsets.symmetric(vertical:8.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(child: Image.network(
                widget.path!=null ?
                widget.path
                    : '${placeHolderImage}',
              ),),

            ],
          ),
        ))
      );
  }
}

