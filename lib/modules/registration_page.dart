import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/models/InputDeco_design.dart';
import 'package:http/http.dart' as http;
import 'package:food_app/models/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Registration extends StatefulWidget {
  @override
  _Registration createState() => _Registration();
}

class _Registration extends State<Registration> {
  TextEditingController _first_name = TextEditingController();
  TextEditingController _last_name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Stack(children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/food.jpg'), fit: BoxFit.cover),
        ),
      ),
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.transparent,
          Color(0xff161d27).withOpacity(0.9),
          Color(0xff161d27),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      ),
      SizedBox(height: 50),
      Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: <
              Widget>[
            Text(
              "Sign Up!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 10, right: 10),
                      child: TextFormField(
                        controller: _first_name,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        keyboardType: TextInputType.text,
                        decoration:
                            buildInputDecoration(Icons.person, "First Name"),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please Enter Fisrt Name";
                          }
                          return null;
                        },
                        onSaved: (String name) {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 10, right: 10),
                      child: TextFormField(
                        controller: _last_name,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        keyboardType: TextInputType.text,
                        decoration:
                            buildInputDecoration(Icons.person, "Last Name"),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please Enter Last Name";
                          }
                          return null;
                        },
                        onSaved: (String name) {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 10, right: 10),
                      child: TextFormField(
                        controller: _email,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        keyboardType: TextInputType.text,
                        decoration: buildInputDecoration(Icons.email, "Email"),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please Enter Email ID";
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return "Please Email Valid Email";
                          }
                          return null;
                        },
                        onSaved: (String email) {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 10, right: 10),
                      child: TextFormField(
                        controller: _phone,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration:
                            buildInputDecoration(Icons.phone, "Phone No"),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please enter  phone";
                          }
                          if (value.length < 9) {
                            return "Please enter valid phone";
                          }
                          return null;
                        },
                        onSaved: (String phone) {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 10, right: 10),
                      child: TextFormField(
                        controller: _password,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        keyboardType: TextInputType.text,
                        decoration:
                            buildInputDecoration(Icons.lock, "Password"),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please enter password";
                          }

                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 10, right: 10),
                      child: TextFormField(
                        controller: _confirmpassword,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: buildInputDecoration(
                            Icons.lock, "Confirm Password"),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please enter re-password";
                          }
                          if (_password.text != _confirmpassword.text) {
                            return "Password Do not match";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: RaisedButton(
                        color: Color(0xfffe9721),
                        onPressed: () {
                          if (_formkey.currentState.validate()) {
                            RegistrationUserAPI();
                            print("Successful");
                          } else {
                            print("Unsuccessfull");
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side:
                                BorderSide(color: Color(0xfffe9721), width: 2)),
                        textColor: Colors.white,
                        child: Text("Submit"),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "You' have Aready Register?",
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
                        Center(
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/password_reset_request_page');
                              },
                              child: Text(
                                "Password Reset",
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
        ),
      )
    ])));
  }

  Future RegistrationUserAPI() async {
    try {
      final http.Response response = await http
          .post(Uri.parse("https://j14foods.com/api/user-register"), body: {
        'first_name': _first_name.text,
        'last_name': _last_name.text,
        'email': _email.text,
        'phone': _phone.text,
        'password': _password.text
      });
      if (response.statusCode == 200) {
        var coverDataJson = jsonDecode(response.body);
        if (coverDataJson['error'] == 0) {
          this.ShowAlert(coverDataJson["message"]);
          Navigator.pushNamed(context, "/login");
        } else {
          this.ShowAlert(coverDataJson["message"]);
        }
      }
    } catch (e) {
      print(e);
    }
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
}
