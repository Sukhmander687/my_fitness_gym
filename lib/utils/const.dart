import 'package:flutter/material.dart';
import 'package:fluttergym/utils/size_config.dart';
import 'package:loading_indicator/loading_indicator.dart';


//var primaryColor = Color(0xff45DD89);
var primaryColor = Color(0xff016260);
var scaffoldCol = Color(0xffEFEEF5);
var primaryLight = Color(0xffE3E6F3);
//var accentColor = Color(0xff45DD89);
var accentColor = Color(0xff016260);
var darkText = Color(0xff47535F);
var lightGrey = Color(0xffC3C8D5);
var fieldHintColor = Color(0xffB1B7C6);
var lightColor = Color(0xffF4F2F8);

var placeHolderImage = "https://images.unsplash.com/photo-1558365916-848463c5d803?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60" ;
var profileplaceHolderImage = "https://images.unsplash.com/photo-1533227268428-f9ed0900fb3b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60" ;


var fieldText = TextStyle(
  fontSize: 2.4 * SizeConfig.textMultiplier,
  fontWeight: FontWeight.w500,
  color: darkText
);

var dialogTitle = TextStyle(
  color: Colors.black,
  fontSize: 3.8 * SizeConfig.textMultiplier,
  fontWeight: FontWeight.w600
);

var dialogContent = TextStyle(
    color: Colors.black87,
    fontSize: 2.3 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w500
);

var dialogActions = TextStyle(
    fontSize: 2.5 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w500,
    color: Colors.white
);

var hintText = TextStyle(
    fontSize: 2.0 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w500,
    color: fieldHintColor
);

var titleText = TextStyle(
  fontSize: 2.5 * SizeConfig.textMultiplier,
  color: Colors.white,
  fontWeight: FontWeight.bold
);

var fieldBorder = BorderRadius.all(Radius.circular(10));

var checkBoxBorder = BorderRadius.all(Radius.circular(5));


var boxShadow = BoxShadow(
  color: Colors.grey.withOpacity(0.35),
  blurRadius: 40.0,
  offset: Offset(0.0, 15),
);


Widget loaderDialog() {
  return Container(
    height: 90,
    width: 90,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white
    ),
    child: Center(
      child: Container(
          height: 90,
          width: 90,
          child: LoadingIndicator(indicatorType: Indicator.ballClipRotateMultiple, color: primaryColor,)),
    ),
  );
}