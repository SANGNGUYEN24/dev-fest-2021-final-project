import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker_app/helper/functions.dart';
import 'package:quiz_maker_app/services/auth.dart';
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
  AuthService authService = new AuthService();
  bool _isLoading = false;

  signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.signInEmailAndPass(email, password).then((val){
        setState(() {
          _isLoading = false;
        });
        HelperFunctions.saveUserLoggedInDetail(isLoggedIn: true);
        Future<bool> x = HelperFunctions.getUserLoggedInDetail();
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => Home()
        ));
      });

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
        body: _isLoading
            ? Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
            : Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Spacer(),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty ? "Enter email!" : null;
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                  onChanged: (val) {
                    email = val;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  validator: (val) {
                    return val.isEmpty ? "Enter password!" : null;
                  },
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                  onChanged: (val) {
                    password = val;
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: blueButton(
                      context: context,
                      label: "Sign in")
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
        ));
  }
}
