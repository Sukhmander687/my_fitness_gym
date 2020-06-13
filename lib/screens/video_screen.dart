import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:fluttergym/utils/size_config.dart';
import 'package:video_player/video_player.dart';
class VideoScreen extends StatefulWidget {
  File vFile ;
  var videoLink ;
  VideoScreen(File vFile, videoLink){
    this.vFile = vFile ;
    this.videoLink = videoLink ;
  }

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  //VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
//    _videoPlayerController1 = VideoPlayerController.network(
//        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
//

    if(widget.vFile==null){

      _videoPlayerController1 = VideoPlayerController.network(widget.videoLink) ;
    }else{
      _videoPlayerController1 = VideoPlayerController.file(widget.vFile) ;
    }

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 3 / 2,

      autoPlay: true,
      looping: true,

      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }



  @override
  void dispose() {
    _videoPlayerController1.dispose();

    _chewieController.dispose();
    super.dispose();
  }

  var titleText = TextStyle(
      fontSize: 2.5 * SizeConfig.textMultiplier,
      color: Colors.white,
      fontWeight: FontWeight.bold
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context) ;
            }),
        title: Text('Video Player', style: titleText),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              _chewieController.enterFullScreen();
            },
            child: Text('Fullscreen'),
          ),

        ],
      ),
    );

  }
}
