
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergym/components/Header.dart';
import 'package:fluttergym/models/user_modal.dart';
import 'package:fluttergym/screens/video_screen.dart';
import 'package:fluttergym/utils/const.dart';
import 'package:fluttergym/utils/dialogs.dart';
import 'package:fluttergym/utils/size_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class AddMemberScreen extends StatefulWidget {
  @override
  _AddMemberScreenState createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  File image;
  List<String> uploadImageUrl = List();
  var name , contact , address , full_fees , pay_fees ;


  String path;
  var _uploadedFileURL;
  int imageIndex = 0;

  List<File> _imageList = List();

 UserModal modal ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageList.add(null);
  }


  @override
  Widget build(BuildContext context) {
    modal = Provider.of<UserModal>(context) ;
    return Scaffold(
      bottomNavigationBar: Container(
          height: 7 * SizeConfig.heightMultiplier,
          color: accentColor,
          child: InkWell(
            onTap: () {
              uploadFileNew(0) ;
            },
            child: Center(
              child: Text(
                'Save'.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600),
              ),
            ),
          )),

      body: SafeArea(
        child: Container(
            color: Colors.blue[50] ,
          child: ListView(
            children: <Widget>[

              Container(
                  color: Colors.white,
                  child: Header("Add Member")) ,

              SizedBox(
                height: 1.5 * SizeConfig.heightMultiplier,
              ),

              Padding(
                padding: EdgeInsets.only(
                    top: 1.2 * SizeConfig.heightMultiplier,
                    left: 5 * SizeConfig.widthMultiplier),
                child: Text('Add picture',
                    style: TextStyle(
                        color: accentColor,
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: 2 * SizeConfig.heightMultiplier,
              ),


              Container(
                height: 10 * SizeConfig.heightMultiplier,
                child: ListView.builder(
                    itemCount: _imageList.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 15, right: 15),
                    itemBuilder: (c, i) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: DottedBorder(
                        color: _imageList[i] != null
                            ? Colors.transparent
                            : Colors.black87,
                        strokeWidth: 1,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(10),
                        dashPattern: [6, 6],
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (_imageList[i] == null) {
                                imageIndex = i;

                                showDialog(
                                    context: context,
                                    builder: (c) =>
                                        ChooseImageDialog(getImage));
                              }else{
                                showDialog(context: context,builder: (c)=>SafeArea(child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical:8.0),
                                  child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: <Widget>[
                                      Container(child: Image.file(_imageList[i]),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal:8.0),
                                            child: FloatingActionButton(
                                              backgroundColor: Colors.white,onPressed: (){
                                              Navigator.pop(context);
                                              setState(() {
                                                _imageList.removeAt(i);
                                                //_allImageList.remove(_imageList[i]);
                                              });
                                            },mini: true,child: Icon(Icons.delete,color: Colors.black,),),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )));
                              }
                            },
                            child: Container(
                              height: 10 * SizeConfig.heightMultiplier,
                              width: 25 * SizeConfig.widthMultiplier,
                              decoration: BoxDecoration(
                                color: lightColor,
//                              shape: BoxShape.rectangle,
                              ),
                              child: FittedBox(
                                fit: _imageList[i] != null
                                    ? BoxFit.cover
                                    : BoxFit.none,
                                child: _imageList[i] != null
                                    ? Image.file(
                                  _imageList[i],
                                  fit: BoxFit.cover,
                                )
                                    :
                                //Image.asset('add-image.png', height: 10 * SizeConfig.imageSizeMultiplier, color: lightGrey,),
                                Icon(
                                  Icons.add,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
              ),

              SizedBox(
                height: 2 * SizeConfig.heightMultiplier,
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5 * SizeConfig.widthMultiplier),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: fieldBorder,
                      boxShadow: [boxShadow]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5 * SizeConfig.widthMultiplier),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      style: fieldText,
                      onChanged: (e) {
                        name = e;
                      },
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name',
                        hintStyle: hintText,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1 * SizeConfig.heightMultiplier,
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5 * SizeConfig.widthMultiplier),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: fieldBorder,
                      boxShadow: [boxShadow]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5 * SizeConfig.widthMultiplier),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      style: fieldText,
                      maxLength: 10,
                      onChanged: (e) {
                        contact = e;
                      },
                      keyboardType: TextInputType.phone,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Contact',
                        hintStyle: hintText,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1 * SizeConfig.heightMultiplier,
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5 * SizeConfig.widthMultiplier),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: fieldBorder,
                      boxShadow: [boxShadow]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5 * SizeConfig.widthMultiplier),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      style: fieldText,
                      onChanged: (e) {
                        address = e ;
                      },
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Address',
                        hintStyle: hintText,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1 * SizeConfig.heightMultiplier,
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5 * SizeConfig.widthMultiplier),
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
                        full_fees = e ;
                      },
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).nextFocus();
                      },

                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Full Fees',
                        hintStyle: hintText,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1 * SizeConfig.heightMultiplier,
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5 * SizeConfig.widthMultiplier),
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
                      textInputAction: TextInputAction.done,
                      style: fieldText,
                      onChanged: (e) {
                        pay_fees = e;
                      },
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Pay Fees',
                        hintStyle: hintText,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1 * SizeConfig.heightMultiplier,
              ),


            ],
          ),
        ),
      ),
    );
  }


  getImage(ImageSource gallery) async {
    File imagee = await ImagePicker.pickImage(source: gallery);
    if(imagee==null){
      return;
    }

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imagee.path,
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


    setState(() {
      this.image = croppedFile;
      path = croppedFile.path;
      _imageList.insert(_imageList.length-1,croppedFile);

    });
  }
//

  basename(String path) {
    return "image:${DateTime.now().millisecondsSinceEpoch}";
  }


  void createRecord() async {

    DateTime currentDate = DateTime.now();
    var now = new DateTime.now();
    var sixtyDaysFromNow = now.add(new Duration(days: 30));
    print("Dfgdgfgf ${sixtyDaysFromNow}") ;
    // difference = "${currentDate.difference(sixtyDaysFromNow).inDays}";
    var differenceee = "${sixtyDaysFromNow.difference(currentDate).inDays}";
    print("SDfdfdfdffddfsfs ${differenceee}") ;


    var documentID ;
    print("createRecord >>");
    var user = Provider.of<UserModal>(context,listen: false);
    DocumentReference ref =
    await Firestore.instance.collection("user")
        .document("${modal.userId}")
        .collection('members')
        .add({
      'days_left': '$differenceee',
      'name': '$name',
      'contact': '$contact',
      'address': '$address',
      'full_fees': '$full_fees',
      'pay_fees': '$pay_fees',
      'userid': await user.userId,
      'memberid': await user.userId,
      'images_url': "${uploadImageUrl[0]}",
      "time":DateTime.now().millisecondsSinceEpoch ,
      "date":"${sixtyDaysFromNow.toIso8601String()}"
    });

    print("documentID >> ${ref.documentID}");
    documentID = ref.documentID;
    Toast.show("Added Sucessfuly", context);
    update(documentID) ;
    Navigator.pop(context);
    Navigator.pop(context);
  }

  update(documentID) async {
    await Firestore.instance.collection("user")
        .document("${modal.userId}")
        .collection('members')
        .document(documentID)
        .updateData({
      'memberid': documentID,
    });
  }

  Future uploadFileNew(index) async {
    print('uploadFileNew $index');
    if (index == 0) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (c) => Center(child: loaderDialog()));
    }

    if (_imageList[index] == null) {
      createRecord();
    } else {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('members_images/${basename(_imageList[index].path)}}');
      StorageUploadTask uploadTask =
      storageReference.putFile(_imageList[index]);
      await uploadTask.onComplete;
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        _uploadedFileURL = fileURL;
        print('fileURL >> File Uploaded _uploadedFileURL $_uploadedFileURL');
        uploadImageUrl.add(fileURL);
        index++;
        uploadFileNew(index);
      });
    }
  }

}

