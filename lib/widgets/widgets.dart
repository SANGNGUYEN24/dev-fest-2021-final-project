///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// This file contains widgets that are used in many places in the application
///=============================================================================
import 'package:flutter/material.dart';
import 'package:quiz_maker_app/styles/constants.dart';

Widget appBar(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: 22,
        fontFamily: 'Montserrat',
      ),
      children: const <TextSpan>[
        TextSpan(
            text: 'Quiz',
            style:
                TextStyle(fontWeight: FontWeight.w600, color: kSecondaryColor)),
        TextSpan(
            text: 'Maker',
            style:
                TextStyle(fontWeight: FontWeight.w600, color: kPrimaryColor)),
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
