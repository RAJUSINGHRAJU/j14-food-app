import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/models/InputDeco_design.dart';
import 'package:http/http.dart' as http;
import 'package:food_app/models/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

@immutable
class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPage createState() => _PasswordResetPage();
}

class _PasswordResetPage extends State<PasswordResetPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _code = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/food.jpg'), fit: BoxFit.cover)),
      ),
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.transparent,
          Colors.transparent,
          Color(0xff161d27).withOpacity(0.9),
          Color(0xff161d27),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      ),
      Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Text(
            "Password Reset!",
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: _email,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      keyboardType: TextInputType.text,
                      decoration:
                          buildInputDecoration(Icons.email, "Enter Email Id"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please Enter Email Id";
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return "Please Enter Valid Email";
                        }
                        return null;
                      },
                      onSaved: (String email) {},
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: _password,
                      autofocus: false,
                      obscureText: true,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      keyboardType: TextInputType.text,
                      decoration: buildInputDecoration(
                          Icons.lock, "Enter Your Password"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please Enter Your Password";
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: _code,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      keyboardType: TextInputType.text,
                      decoration: buildInputDecoration(Icons.code, "Code"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please Enter Code";
                        }
                        return null;
                      },
                      onSaved: (String name) {},
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: RaisedButton(
                      color: Color(0xfffe9721),
                      onPressed: () {
                        if (_formkey.currentState.validate()) {
                          PasswordReset();
                          print("Successful");
                        } else {
                          print("Unsuccessfull");
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Color(0xfffe9721), width: 2)),
                      textColor: Colors.white,
                      child: Text("Submit"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "It's your first time here?",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  color: colors, fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      )
    ]));
  }

  Future ShowAlert(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future PasswordReset() async {
    try {
      final http.Response response = await http
          .post(Uri.parse("https://j14foods.com/api/possword-reset"), body: {
        'email': _email.text,
        'password': _password.text,
        'code': _code.text,
      });
      if (response.statusCode == 200) {
        var coverDataJson = jsonDecode(response.body);
        if (coverDataJson['error'] == 0) {
          this.ShowAlert(coverDataJson["message"]);
          Navigator.pushNamed(context, '/login');
        } else {
          this.ShowAlert(coverDataJson["message"]);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
