///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// This file helps check or save login state of the user
///=============================================================================
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userLoggedInKey = "User Logged In Key";
  static String userIdFromFirestore = "UserId Key";

  static saveUserLoggedInDetail({required bool isLoggedIn}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(userLoggedInKey, isLoggedIn);
  }

  static Future<bool?> getUserLoggedInDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(userLoggedInKey);
  }

  static saveUserId({required userId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(userIdFromFirestore, userId);
  }

  static Future<String?> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userIdFromFirestore);
  }
}
