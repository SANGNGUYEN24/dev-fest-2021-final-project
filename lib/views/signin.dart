///=============================================================================
/// @author sangnd
/// @date 29/08/2021
/// The sign in page for users
///=============================================================================
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_maker_app/helper/functions.dart';
import 'package:quiz_maker_app/models/user.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/styles/constants.dart';
import 'package:quiz_maker_app/views/home.dart';
import 'package:quiz_maker_app/views/signup.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SignIn> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  final googleSignIn = GoogleSignIn();
  final textFieldController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    textFieldController.addListener(() => setState(() {}));
  }

  /// User object based on FirebaseUser
  UserModel? _getUserModel(User user) {
    return UserModel(uid: user.uid);
  }

  /// A dialog requiring an email to reset password
  /// If the users forget password, they will provide his/her email to reset it
  fillEmailResetPasswordDialog(BuildContext context) {
    String email = "";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Reset your password?"),
            content: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.mail),
                hintText: "Email",
              ),
              keyboardType: TextInputType.emailAddress,
              autofillHints: [AutofillHints.email],
              onChanged: (val) {
                email = val;
              },
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  resetPassword(email);
                  Navigator.pop(context);
                },
                child: Text("SEND"),
              ),
            ],
          );
        });
  }

  /// The function to send user's email to Firebase for resetting password
  Future resetPassword(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showGoodMessage(context, "An email has been sent to you");
    } catch (e) {
      showSnackBarError(context, "Please provide a valid email");
    }
  }

  /// Sign in functions
  /// The function to communicate with Firebase Authentication
  /// Using user's email and password
  Future signInEmailAndPassword(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? firebaseUser = authResult.user;

      return _getUserModel(firebaseUser!);
    } catch (e) {
      showSnackBarError(context,
          "Something wrong with your email or password. Please try again!");
      return null;
    }
  }

  /// The function to do some staffs associated with sign in process
  /// 1. Show a loading toast
  /// 2. Save log in state of the user
  /// 4. Navigate the user to [Home] page
  signInEmailAndPass() async {
    if (_formKey.currentState!.validate()) {
      showSnackBarLoading(context);
      dynamic result = await signInEmailAndPassword(email, password);
      if (result != null) {
        // update sign in status
        HelperFunctions.saveUserLoggedInDetail(isLoggedIn: true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
        // hide the snackBar after sign in process done
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      } else {
        showSnackBarError(
            context, "Something wrong with your email or password");
        return null;
      }
    }
  }

  /// Sign In using Google account
  Future googleSignInFunction() async {
    showSnackBarLoading(context);
    try {
      final user = await googleSignIn.signIn();
      if (user == null) {
        return;
      } else {
        final googleAuth = await user.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential).then((value) {
          HelperFunctions.saveUserLoggedInDetail(isLoggedIn: true);

          /// Update user name to database
          final userName = value.additionalUserInfo!.profile!["given_name"];
          databaseService.addUserInfo(userName);
          showGoodMessage(context, "Welcome $userName");

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
          // Hide snackBar
          // ScaffoldMessenger.of(context).removeCurrentSnackBar();
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /// The UI of sign in page
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
            height: MediaQuery.of(context).size.height - 50,
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

                    /// Email text field
                    Container(
                      padding: EdgeInsets.all(2),
                      //decoration: kBoxDecorationStyle,
                      child: TextFormField(
                        controller: textFieldController,
                        validator: (email) {
                          return !EmailValidator.validate(email!)
                              ? "Enter a valid email!"
                              : null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.mail),
                          suffixIcon: textFieldController.text.isEmpty
                              ? Container(width: 0)
                              : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => textFieldController.clear(),
                                ),
                          hintText: "Email",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: [AutofillHints.email],
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    /// Password text field
                    Container(
                      padding: EdgeInsets.all(2),
                      //decoration: kBoxDecorationStyle,
                      child: TextFormField(
                        obscureText: true,
                        validator: (val) {
                          return val!.isEmpty ? "Enter password!" : null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.vpn_key),
                          hintText: "Password",
                        ),
                        onChanged: (val) {
                          password = val;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    /// If the user forgot his/her password
                    GestureDetector(
                      onTap: () {
                        fillEmailResetPasswordDialog(context);
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text("Forgot password?"),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),

                    /// Sign in button using email, and password
                    ElevatedButton(
                      onPressed: () {
                        signInEmailAndPass();
                      },
                      child: Text(
                        "Sign in with your email",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black87,
                          fixedSize:
                              Size(MediaQuery.of(context).size.width - 48, 54),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    /// Sign in button using Google account
                    OutlinedButton.icon(
                      onPressed: () {
                        googleSignInFunction();
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.redAccent,
                      ),
                      label: Text(
                        'Sign in with Google',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width - 48, 54),
                        shape: StadiumBorder(),
                        side: BorderSide(color: kPrimaryColor),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    /// If user had an account, navigate to sign in page
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text(
                            " Sign up",
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
