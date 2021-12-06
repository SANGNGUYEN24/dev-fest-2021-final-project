///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// This file contains some constant values in the app
///=============================================================================
import 'package:flutter/material.dart';

const kPrimaryColor = Colors.black87;
const kSecondaryColor = Colors.blueGrey;
const kBackgroundColor = Colors.white;
const kEmptyImageQuizList = 'assets/undraw_elements_cipa.svg';
const kLoadingImage = 'assets/loading.gif';
final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

const String kGuideCreateQuiz =
    "Press on the below preview card to change thumbnails";
