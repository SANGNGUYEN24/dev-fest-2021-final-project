import 'package:flutter/material.dart';
import 'package:quiz_maker_app/helper/functions.dart';
import 'package:quiz_maker_app/views/home.dart';
import 'package:quiz_maker_app/views/signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  @override
  void initState(){
    checkUserLoggedInStatus();
    //TODO implement inittial State
    super.initState();
  }

  checkUserLoggedInStatus()async {
    await HelperFunctions.getUserLoggedInDetail().then((value) {
      setState(() {
        _isLoggedIn = value;
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
      home: (_isLoggedIn?? false)? Home(): SignIn(),
    );
  }
}
