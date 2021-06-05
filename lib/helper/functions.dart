import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String USER_LOGGED_IN_KEY = "User Logged In Key";

  static saveUserLoggedInDetail({@required bool isLoggedIn}) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(USER_LOGGED_IN_KEY, isLoggedIn);
  }

  static Future<bool> getUserLoggedInDetail({bool isLoggedIn}) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(USER_LOGGED_IN_KEY);
  }
}