///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// The sign up page for new users
/// ============================================================================
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_maker_app/helper/functions.dart';
import 'package:quiz_maker_app/models/user.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/views/signin.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';

import 'home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = DatabaseService();
  String userName = "";
  String email = "";
  String password = "";
  String error = "";
  bool _obscureText = true;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  /// Show loading toast while the user is waiting for sign up process
  void showSnackBarLoading() {
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

  /// User object based on FirebaseUser
  UserModel? _userFromFirebaseUser(User user) {
    return UserModel(uid: user.uid);
  }

  /// The function to communicate with Firebase Authentication to sign up a new user
  Future signUpEmailAndPassword(String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = authResult.user;

      return _userFromFirebaseUser(firebaseUser!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// The function to do some staffs associated with sign up process:
  /// 1. Show a loading toast
  /// 2. Save log in state of the user
  /// 3. Add [userName] to the database
  /// 4. Navigate the user to [Home] page
  ///
  signUp() async {
    if (_formKey.currentState!.validate()) {
      showSnackBarLoading();
      dynamic val = await signUpEmailAndPassword(email, password);
      if (val != null) {
        HelperFunctions.saveUserLoggedInDetail(isLoggedIn: true);
        await databaseService.addUserInfo(userName);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
        showGoodMessage(context, "Welcome $userName, signed in as $email");
      } else {
        setState(() {
          error = "The email address is already in use by another account";
        });
        showSnackBarError(context, error);
        return null;
      }
    }
  }

  /// The UI of [SignUp] page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: buildAppBar(context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          reverse: true,
          child: Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Spacer(),
                    Image.asset("assets/foreground.png",
                        width: 200, height: 200),
                    Spacer(),

                    /// Name text field
                    TextFormField(
                      validator: (val) {
                        return val!.isEmpty ? "Enter your name!" : null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.person),
                        hintText: "Your name",
                      ),
                      onChanged: (val) {
                        userName = val;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    /// Email text field
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.mail),
                        hintText: "Email",
                      ),
                      validator: (email) {
                        return !EmailValidator.validate(email!)
                            ? "Enter a valid email!"
                            : null;
                      },
                      onChanged: (val) {
                        email = val;
                      },
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: [AutofillHints.email],
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    /// Password text field
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obscureText,
                      validator: (val) {
                        return val!.length < 6
                            ? "Password at least 6 characters"
                            : null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.vpn_key),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: _obscureText
                              ? Icon(Icons.visibility_off_outlined)
                              : Icon(Icons.visibility_outlined),
                        ),
                        hintText: "Password",
                      ),
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    ElevatedButton(
                      onPressed: () {
                        signUp();
                      },
                      child: Text(
                        "Sign up with your email",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          fixedSize:
                              Size(MediaQuery.of(context).size.width - 48, 54),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    /// Ask whether the user had an account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()));
                          },
                          child: Text(
                            " Sign in",
                            style: TextStyle(
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
