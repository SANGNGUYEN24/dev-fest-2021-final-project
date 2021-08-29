/// @author sangnd
/// @date 29/08/2021
/// The app run first here
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

// This widget is the root of the application.
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
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (_isLoggedIn ?? false) ? Home() : SignIn(),
    );
  }
}
