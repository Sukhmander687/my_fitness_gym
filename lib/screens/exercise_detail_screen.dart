import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttergym/models/user_modal.dart';
import 'package:fluttergym/screens/video_screen.dart';
import 'package:fluttergym/utils/const.dart';
import 'package:fluttergym/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data ;
  ExerciseDetailScreen(this.data);

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen>
    with SingleTickerProviderStateMixin {

  var commentController = TextEditingController()  ;
  Future<void> share() async {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return Center(child: loaderDialog());
        });





  }

  // SolutionsModal solutionModal ;
  int solutionSize = 0 ;

  var imageList = [
    'https://images.pexels.com/photos/1342529/pexels-photo-1342529.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.unsplash.com/photo-1575325345079-cce3a789be43?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80',
    'https://images.unsplash.com/photo-1558640476-437a2b9438a2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1198&q=80',
    'https://images.unsplash.com/photo-1562027224-de24a4d4acf4?ixlib=rb-1.2.1&auto=format&fit=crop&w=1051&q=80',
  ];

  List<String> allVideoList = List() ;

  double page = 0;
  var _scrollController = ScrollController();
  AnimationController animationController;
  TextStyle title;
  TextStyle content;
  bool load = true ;
  String docId;
  @override
  void initState() {
    _scrollController.addListener(() {
      setState(() {});
    });

    docId=widget.data['id'];
    docId=widget.data['id'];
    imageList = List.from(widget.data["images_url"]) ;
    allVideoList = List.from(widget.data["video_list"]) ;

    if(allVideoList==null){
      allVideoList = List() ;
    }


    if(imageList==null||imageList.length==0){
      imageList.add(placeHolderImage) ;
    }

    super.initState();
  }
  UserModal user ;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserModal>(context) ;


    title = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 2.5 * SizeConfig.textMultiplier,
    );

    content = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 1.8 * SizeConfig.textMultiplier,
    );

    return Scaffold(
      backgroundColor: Colors.blue[50],

      bottomNavigationBar: Padding(padding: MediaQuery.of(context).viewInsets,
        child:
        Container(
          color:  Colors.white,
          padding: EdgeInsets.only(left: 10 , right: 2),
          child: Container(
            height: 50.0,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: commentController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write your reply...',
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xffAEA4A3),
                      ),
                    ),
                    textInputAction: TextInputAction.send,

                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),

                  ),
                ),
                Container(
                  width: 50.0,
                  child: InkWell(
                    onTap: (){
                      if(commentController.text==null||commentController.text==""){
                        Toast.show("write comment", context) ;
                      }else{
                        Firestore.instance.collection("exercise")
                            .document(docId).collection("comments").add({
                          "user_name" : "${user.name}" ,
                          "profile_image" : "${user.avatar}" ,
                          "comment" : "${commentController.text}" ,
                        }) ;
                        commentController.text = "" ;

                        var v = FieldValue.increment(1) ;
                        var element = "comment_counter" ;
                         // v = FieldValue.increment(-1) ;


                        Firestore databaseReference = Firestore.instance;
                        databaseReference.
                        collection('exercise')
                            .document(docId)
                            .updateData({'${element}': v,
                            }) ;



                        setState(() {

                        });
                      }

                    },
                    child: Icon(
                      Icons.send,
                      color: primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        )

      ),
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
//                floating: true,
                snap: false,
                leading: IconButton(
                    icon: Icon(
                      Icons.keyboard_backspace,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),



                actions: <Widget>[

                  SizedBox(
                    width: 2 * SizeConfig.widthMultiplier,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if(user.likeArray
                            .contains(widget.data["id"])){
                          user.likeArray.remove(widget.data["id"]) ;
                          likeSolutionUpdate(widget.data["id"] , "remove") ;
                        }else{
                          user.likeArray.add(widget.data["id"]) ;
                          likeSolutionUpdate(widget.data["id"] , "add") ;
                        }

                      });
                    },
                    child: Container(

                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [boxShadow],

                          color: Colors.white),
                      child: Padding(
                        padding: EdgeInsets.all(1 * SizeConfig.heightMultiplier),
                        child: Icon(
                          Icons.favorite,
                          color: !user.likeArray.contains(widget.data["id"])
                              ? lightGrey
                              : Colors.red,
                          size: 5 * SizeConfig.imageSizeMultiplier,
                        ),
                      ),
                    ),
                  ),

//                  IconButton(
//                      icon: Icon(
//                        Icons.more_vert,
//                        color: Colors.white,
//                        size: 5 * SizeConfig.imageSizeMultiplier,
//                      ),
//                      onPressed: () {}),
                ],
                centerTitle: true,
                title: Text(""),
                expandedHeight: 35 * SizeConfig.heightMultiplier,
                flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: PageView.builder(
                      onPageChanged: (e) {
                        setState(() {
                          page = e.toDouble();
                        });
                      },
                      itemBuilder: (context, position) {
                        return Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(imageList[position]),
                                  fit: BoxFit.cover
                              )
                          ),
                        );
                      },
                      itemCount: imageList.length, // Can be null
                    )),
              ),




              SliverList(
                  delegate: SliverChildListDelegate([

                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),

                        SizedBox(height:3.0*SizeConfig.heightMultiplier),
                        Visibility(child:Column(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 1.2 * SizeConfig.heightMultiplier, left: 5 * SizeConfig.widthMultiplier, bottom: 2 * SizeConfig.widthMultiplier),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Videos',
                                  style: TextStyle(
                                      color: accentColor,
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 10 * SizeConfig.heightMultiplier,
                            child: ListView.builder(
                                itemCount: allVideoList.length ,
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
                                        onTap: (){

                                          Navigator.push(context, MaterialPageRoute(builder: (con)=>
                                              VideoScreen(null , allVideoList[i]))) ;

                                        },
                                        child: Container(
                                          height: 10 * SizeConfig.heightMultiplier,
                                          width: 25 * SizeConfig.widthMultiplier,
                                          decoration: BoxDecoration(
                                            color: lightColor,
//                              shape: BoxShape.rectangle,
                                          ),
                                          child: Center(
                                            child: allVideoList[i]!=null?
                                            // Image.memory(getThumsnails(allVideoList[i]) , fit: BoxFit.cover,):
                                            Image.asset('add-video.png' , height: 10 * SizeConfig.imageSizeMultiplier, color: lightGrey, fit: BoxFit.cover,):


                                            Icon(Icons.add , color: Colors.black87,),
                                            // Image.asset('add-video.png', height: 10 * SizeConfig.imageSizeMultiplier, color: lightGrey,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          ),

                        ],), visible: allVideoList.length>0?true:false,),

                        SizedBox(height: 20,) ,



                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1.2 * SizeConfig.heightMultiplier, left: 5 * SizeConfig.widthMultiplier, bottom: 2 * SizeConfig.widthMultiplier),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Comment',
                            style: TextStyle(
                                color: accentColor,
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection("exercise")
                            .document(docId)
                            .collection("comments")
                            //.orderBy("time",descending: true)
                            .snapshots(),
                        builder: (c,snap){
                          if(!snap.hasData){
                            return loaderDialog();
                          }
                          if(snap.hasError){
                            return Center(child: Text("Error Occured"));
                          }

                          return Column(
                            children: <Widget>[
                              for(var doc in snap.data.documents)
                                getList(doc)
                            ],
                          );

                        }),
                    SizedBox(height:5 * SizeConfig.heightMultiplier,)

                  ])
              )],

          ),

          _buildFab(),
        ],
      ),
    );
  }

  getList(DocumentSnapshot doc) {
    return GestureDetector(child:
    Padding(
      padding: EdgeInsets.symmetric(
          horizontal:   1* SizeConfig.widthMultiplier, vertical:  1 * SizeConfig.heightMultiplier),
      child: Row(
        children: <Widget>[
          Container(
            width: 54.0,
            height: 54.0,
            margin: EdgeInsets.only(right: 20.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(doc.data["profile_image"] == null?"${placeHolderImage}" :doc.data["profile_image"]),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(360),
              ),
              color: Colors.grey,
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5.0,
                  offset: Offset(2.0, 2.0),
                ),
              ],
              border: Border.all(
                color: Colors.white,
                width: 1.0,
              ),
            ),
          ) ,
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[


                      Expanded(child: Text('${doc.data["comment"]}', style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 1.8 * SizeConfig.textMultiplier,
                      ))),
//                          Icon(Icons.more_vert, size: 5 * SizeConfig.imageSizeMultiplier,),
                    ],
                  ),
                  Text('${doc.data['user_name']}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 1.3 * SizeConfig.textMultiplier,
                    ),
                  ),


                  SizedBox(height: 3,) ,
                  Divider()


                ],
              ))
        ],
      ),
    )
      ,onTap: (){

      },);
  }



  double scale = 1.0;
  Widget _buildFab() {
    //starting fab position
    final double defaultTopMargin = 30 * SizeConfig.heightMultiplier - 4.0;
    //pixels from top where scaling should start
    final double scaleStart = 96.0;
    //pixels from top where scaling should end
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;


    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      //print("offset = $offset");
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      left: 15,
      right: 15,
      child: GestureDetector(
        onTap: (){

        },
        child: new Transform(
            transform: new Matrix4.identity()..scale(scale),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[

//                DotsIndicator(
//                  dotsCount: imageList.length,
//                  position: page,
//                  decorator: DotsDecorator(
//                    color: Colors.white,
//                    activeColor: accentColor,
//                  ),
//                ),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: fieldBorder,
                      color: Colors.white,
                      boxShadow: [boxShadow]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Text('${widget.data['title']}', style: title,),

                        SizedBox(height: 3,),

                        Text('${widget.data['description']}', style: content,),

                        SizedBox(height: 10,),

                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }







  likeSolutionUpdate(solDocId , type){
    var v = FieldValue.increment(1) ;
    var element = "like_counter" ;
    if(type!="add"){
      v = FieldValue.increment(-1) ;
    }
    if(type=="share_counter"){
      v = FieldValue.increment(1) ;
      element="share_counter" ;
    }
    Firestore databaseReference = Firestore.instance;
    databaseReference.
    collection('exercise')
        .document(docId)
        .updateData({'${element}': v,
      "likedBy":type=="add"?FieldValue.arrayUnion([user.userId]):FieldValue.arrayRemove([user.userId])}) ;

  }


}