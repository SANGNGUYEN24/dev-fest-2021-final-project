///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// The app run first here
///=============================================================================
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker_app/helper/functions.dart';
import 'package:quiz_maker_app/views/home.dart';
import 'package:quiz_maker_app/views/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

/// This widget is the root of the application.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  @override
  void initState() {
    checkUserLoggedInStatus();
    super.initState();
  }

  /// Check whether the user logged in the app
  /// If the user LOGGED IN, change [_isLoggedIn] to TRUE, otherwise FALSE.
  /// If TRUE -> go to [Home] page
  /// If FALSE -> go to [SignIn] page
  checkUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInDetail().then((value) {
      setState(() {
        _isLoggedIn = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Maker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Roboto',
      ),
      home: (_isLoggedIn) ? Home() : SignIn(),
    );
  }
}
