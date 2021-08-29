import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_maker_app/helper/functions.dart';
import 'package:quiz_maker_app/models/user.dart';
import 'package:quiz_maker_app/services/database.dart';
import 'package:quiz_maker_app/views/home.dart';
import 'package:quiz_maker_app/views/signup.dart';
import 'package:quiz_maker_app/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SignIn> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  String password;

  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseService databaseService = DatabaseService();

  final _user = FirebaseAuth.instance.currentUser;

  // Google Sign in
  final googleSignIn = GoogleSignIn();

  // User object based on FirebaseUser
  UserObject _userFromFirebaseUser(User user) {
    // ignore: unnecessary_null_comparison
    return user != null ? UserObject(uid: user.uid) : null;
  }

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
                color: Colors.blue,
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

  void showSnackBarMessage(String mess) {
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
          Expanded(child: Text(mess)),
        ],
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  // A dialog requiring an email to reset password
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
              MaterialButton(
                  elevation: 5.0,
                  child: Text("Submit"),
                  onPressed: () {
                    resetPassword(email);
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  // Reset password function
  Future resetPassword(email) async {
    try {
      showSnackBarMessage("An email has been sent to you");
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (e.code == "unknown")
        showSnackBarMessage("Please provide a valid email");
      if (e.code == "invalid-email")
        showSnackBarMessage("Invalid email, try again");
    }
  }

  /// Sign in functions //////////////////////////////////////////

  /// Using user email and password
  Future signInEmailAndPassword(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User firebaseUser = authResult.user;

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      if (e.code == 'wrong-password')
        showSnackBarMessage(
            "The password is invalid or the user does not have a password");
      else if (e.code == 'user-not-found') {
        showSnackBarMessage(
            "There is no user record corresponding to this identifier. The user may have been deleted");
      }
      return null;
    }
  }

  // Sign In function which call firebase function service
  signInEmailAndPass() async {
    if (_formKey.currentState.validate()) {
      showSnackBarLoading();

      dynamic result = await signInEmailAndPassword(email, password);
      if (result != null) {
        // update sign in status
        HelperFunctions.saveUserLoggedInDetail(isLoggedIn: true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));

        // hide the snackBar after sign in done
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      } else {
        showSnackBarMessage("Something wrong with your email or password");
        return null;
      }
    }
  }

  /// Sign In using Google account
  Future googleSignInFunction() async {
    showSnackBarLoading();

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
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));

          // Hide snackBar
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          //databaseService.addUserInfo(_user.displayName);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // logout function
  void googleLogOut() async {
    try {
      await googleSignIn.disconnect();
      _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: appBar(context),
        ),
        body: SingleChildScrollView(
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
                    Container(
                      padding: EdgeInsets.all(2),
                      //decoration: kBoxDecorationStyle,
                      child: TextFormField(
                        validator: (email) {
                          return !EmailValidator.validate(email)
                              ? "Enter a valid email!"
                              : null;
                        },
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(2),
                      //decoration: kBoxDecorationStyle,
                      child: TextFormField(
                        obscureText: true,
                        validator: (val) {
                          return val.isEmpty ? "Enter password!" : null;
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
                    GestureDetector(
                        onTap: () {
                          signInEmailAndPass();
                        },
                        child: blueButton(
                            context: context,
                            label: "Sign in with your email")),
                    SizedBox(
                      height: 10,
                    ),
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
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
