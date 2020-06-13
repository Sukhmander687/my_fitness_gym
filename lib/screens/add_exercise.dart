
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

class AddExercise extends StatefulWidget {
  @override
  _AddExerciseState createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  var title, description;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  File image;
  File video;
  List<File> allVideoList = List();

  List<String> uploadVideoUrl = List();
  List<String> uploadImageUrl = List();

  String path;
  var _uploadedFileURL;
  int imageIndex = 0;

  List<File> _imageList = List();
  List<File> _allImageList = List();

  var documentID;

  bool reverseFlag = true;

  String _currentAddress = "Fatching location...";

  Position position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageList.add(null);
    allVideoList.add(null);
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      this.position = position;
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          position.latitude, position.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        print("_currentAddress $_currentAddress");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
          height: 7 * SizeConfig.heightMultiplier,
          color: accentColor,
          child: InkWell(
            onTap: () {
              uploadVideo(0);
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
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Add Exercise ', style: titleText),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 1.5 * SizeConfig.heightMultiplier,
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
                    title = e;
                  },
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).nextFocus();
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: hintText,
                  ),
                ),
              ),
            ),
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
                  focusNode: FocusNode(),
                  maxLines: 3,
                  style: fieldText,
                  onChanged: (e) {
                    description = e;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Descriptions',
                    hintStyle: hintText,
                  ),
                ),
              ),
            ),
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
            height: 1 * SizeConfig.heightMultiplier,
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
          Padding(
            padding: EdgeInsets.only(
                top: 1.2 * SizeConfig.heightMultiplier,
                left: 5 * SizeConfig.widthMultiplier),
            child: Text(
              'Add Video',
              style: TextStyle(
                  color: accentColor,
                  fontSize: 2.5 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 10 * SizeConfig.heightMultiplier,
            child: ListView.builder(
                itemCount: allVideoList.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 15, right: 15),
                itemBuilder: (c, i) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: DottedBorder(
                    color: Colors.black87,
                    strokeWidth: 1,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10),
                    dashPattern: [6, 6],
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (allVideoList[i] == null) {

                            showDialog(
                                context: context,
                                builder: (c) => AddVideo(getVideo));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (v) => VideoScreen(
                                        allVideoList[i], null)));
                          }
                        },
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: <Widget>[
                            Container(
                              height: 10 * SizeConfig.heightMultiplier,
                              width: 25 * SizeConfig.widthMultiplier,
                              decoration: BoxDecoration(
                                color: lightColor,
//                              shape: BoxShape.rectangle,
                              ),
                              child: Center(
                                child: allVideoList[i] != null
                                    ?
                                // Image.memory(getThumsnails(allVideoList[i]) , fit: BoxFit.cover,):
                                Image.asset(
                                  'add-video.png',
                                  height:
                                  10 * SizeConfig.imageSizeMultiplier,
                                  color: lightGrey,
                                  fit: BoxFit.cover,
                                )
                                    : Icon(
                                  Icons.add,
                                  color: Colors.black87,
                                ),
                                // Image.asset('add-video.png', height: 10 * SizeConfig.imageSizeMultiplier, color: lightGrey,),
                              ),
                            ),
                            if(allVideoList[i] != null) GestureDetector(child: Icon(Icons.cancel), onTap: (){
                              setState(() {
                                allVideoList.removeAt(i);
                              });
                            })
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 1.2 * SizeConfig.heightMultiplier,
                left: 5 * SizeConfig.widthMultiplier),
            child: Text(
              'Location',
              style: TextStyle(
                  color: accentColor,
                  fontSize: 2.5 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 1.5 * SizeConfig.heightMultiplier,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: fieldBorder,
                  boxShadow: [boxShadow]),
              child: TextFormField(
                style: TextStyle(
                    fontSize: 2.0 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w500,
                    color: darkText
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: accentColor,
                    ),
                    hintStyle: hintText,
                    labelText: _currentAddress),
              ),
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  getVideo(ImageSource gallery) async {
    File video = await ImagePicker.pickVideo(source: gallery);
    if(video==null)
      return;
    setState(() {
      this.video = video;
      // videoList.add(video);
      // allVideoList.clear();
      allVideoList.insert(allVideoList.length-1,video);
      //allVideoList.add(null);
    });
    path = video.path;

    // uploadVideo();
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
  Future uploadVideo(index) async {
    print('uploadVideo ${index}');
    if (index == 0) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (c) => Center(child: loaderDialog()));
    }
    if (allVideoList[index] == null) {
      uploadFileNew(0);
    } else {


      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('problem_video/${basename(allVideoList[index].path)}}');
      StorageUploadTask uploadTask =
      storageReference.putFile(allVideoList[index]);
      await uploadTask.onComplete;
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
          uploadVideoUrl.add(fileURL);

          index++;
          uploadVideo(index);

          Toast.show("UPLOADED", context);
        });
      });
    }
  }

  basename(String path) {
    return "image:${DateTime.now().millisecondsSinceEpoch}";
  }

  getData() {
    Firestore.instance
        .collection('exercise')
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => print(doc["title"])));
  }

  void createRecord() async {
    print("createRecord >>");
    var user = Provider.of<UserModal>(context,listen: false);
    DocumentReference ref =
    await Firestore.instance.collection("exercise")

        .add({
      'title': '$title',
      'userid': await user.userId,
      'description': '$description',
      'longitude': '${position.latitude}',
      'latitude': '${position.longitude}',
      'like_counter': 0,
      'share_counter': 0,
      'images_url': FieldValue.arrayUnion(uploadImageUrl),
      'video_list': FieldValue.arrayUnion(uploadVideoUrl),
      'id': "476",
      "time":DateTime.now().millisecondsSinceEpoch
    });

    print("documentID >> ${ref.documentID}");
    documentID = ref.documentID;
    Toast.show("Added Sucessfuly", context);

    update();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  update() async {
    await Firestore.instance
        .collection("exercise")
        .document(documentID)
        .updateData({
      'id': documentID,
    });
  }

  Future uploadFileNew(index) async {
    print('uploadFileNew $index');

    if (_imageList[index] == null) {
      createRecord();
    } else {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('exercise_images/${basename(_imageList[index].path)}}');
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

//  getThumsnails(file) async {
//    final uint8list = await VideoThumbnail.thumbnailData(
//      video: file.path,
//      imageFormat: ImageFormat.JPEG,
//      maxWidth: 128,
//      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
//      quality: 25,
//    );
//
//    return uint8list;
//  }
}

