import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkUtils {


  static String authHeaderS = "";

  static Future  getRequest(endpoint, {headers,base}) async {
    var url=  endpoint;
    var response = await get(url, headers: headers);
    print("Response of  $endpoint = ${response.body}");
    return response.body;
  }


  static Future  postRequest(context, {headers,body,baseUrl}) async {
    Response r = await post('https://api.mailjet.com/v3.1/send',
        headers: headers);
    print("REsponse>>>  ${r.body}");
    return r.body ;
  }



}
