///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// This file contains widgets that are used in many places in the application
///=============================================================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_maker_app/styles/constants.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    title: buildAppBarTitle(context),
    backgroundColor: Colors.white,
    elevation: 0.0,
    iconTheme: IconThemeData(color: kSecondaryColor), systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}

Widget buildAppBarTitle(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: 22,
        fontFamily: 'Nunito',
      ),
      children: const <TextSpan>[
        TextSpan(
            text: 'BK',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: kSecondaryColor)),
        TextSpan(
            text: 'Quiz',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
      ],
    ),
  );
}

Widget blackButton(
    {required BuildContext context, required String label, buttonWidth}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
      color: kPrimaryColor,
      borderRadius: BorderRadius.circular(30),
    ),
    alignment: Alignment.center,
    width: buttonWidth != null
        ? buttonWidth
        : MediaQuery.of(context).size.width - 48,
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}

Widget outlinedButton(
    {required BuildContext context, required String label, buttonWidth}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: Colors.black87),
      borderRadius: BorderRadius.circular(30),
    ),
    alignment: Alignment.center,
    width: buttonWidth != null
        ? buttonWidth
        : MediaQuery.of(context).size.width - 48,
    child: Text(
      label,
      style: TextStyle(color: kSecondaryColor, fontSize: 16),
    ),
  );
}

/// Loading bar showing while user waiting for a process such as signing in/up
void showSnackBarLoading(BuildContext context) {
  final snackBar = SnackBar(
    duration: Duration(minutes: 10),
    behavior: SnackBarBehavior.fixed,
    content: Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              color: kPrimaryColor,
              backgroundColor: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Loading...",
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    ),
  );

  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}

/// Show toast when an error happens
void showSnackBarError(BuildContext context, String error) {
  final snackBar = SnackBar(
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.fixed,
    content: Row(
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(child: Text(error)),
      ],
    ),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}

/// Show a positive message to user
void showGoodMessage(BuildContext context, String mess) {
  final snackBar = SnackBar(
    duration: Duration(seconds: 4),
    behavior: SnackBarBehavior.floating,
    content: Row(
      children: [
        Icon(
          Icons.check_circle_outlined,
          color: Colors.white,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(child: Text(mess)),
      ],
    ),
  );
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}

/// Show a negative message to user
void showNotGoodMessage(BuildContext context, String mess) {
  final snackBar = SnackBar(
    duration: Duration(seconds: 5),
    behavior: SnackBarBehavior.floating,
    content: Row(
      children: [
        Icon(
          Icons.announcement_outlined,
          color: Colors.white,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(child: Text(mess)),
      ],
    ),
  );
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}
