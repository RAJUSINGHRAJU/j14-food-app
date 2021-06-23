import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/models/InputDeco_design.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePassword createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  TextEditingController _old_password = TextEditingController();
  TextEditingController _new_password = TextEditingController();
  TextEditingController _con_password = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // String device_id = '';
  // void initState() {
  //   super.initState();
  //   this.GetDeviceID();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.black,
            ),
          ),
        ),
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
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: <
                Widget>[
              Text(
                "Change Your Password!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
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
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 10, right: 10),
                        child: TextFormField(
                          controller: _old_password,
                          autofocus: false,
                          obscureText: true,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          keyboardType: TextInputType.text,
                          decoration: buildInputDecoration(
                              Icons.lock, "Enter Old Password"),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please Old Enter Password";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 10, right: 10),
                        child: TextFormField(
                          controller: _new_password,
                          autofocus: false,
                          obscureText: true,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          keyboardType: TextInputType.text,
                          decoration: buildInputDecoration(
                              Icons.lock, "Enter New Password"),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please New Enter password";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 10, right: 10),
                        child: TextFormField(
                          controller: _con_password,
                          autofocus: false,
                          obscureText: true,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          keyboardType: TextInputType.text,
                          decoration: buildInputDecoration(
                              Icons.lock, "Enter Confirm Password"),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please Enter Re-Password";
                            }
                            if (_new_password.text != _con_password.text) {
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
                              this.GetDeviceID();
                              print("Successful");
                            } else {
                              print("Unsuccessfull");
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color: Color(0xfffe9721), width: 2)),
                          textColor: Colors.white,
                          child: Text("Submit"),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          )
        ]));
  }

  Future StoreDeviceID(device_id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('device_id', device_id);
  }

  Future GetDeviceID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String device_id = pref.getString("device_id");
    this.ChangePasswords(device_id);
  }

  Future ChangePasswords(device_id) async {
    try {
      final http.Response response = await http
          .post(Uri.parse("https://j14foods.com/api/change-password"), body: {
        'device_id': device_id,
        'old_password': _old_password.text,
        'new_password': _new_password.text,
        'con_password': _con_password.text,
      });
      if (response.statusCode == 200) {
        var coverDataJson = jsonDecode(response.body);
        if (coverDataJson['status'] == 1) {
          this.ShowAlert(coverDataJson["message"]);
          Navigator.pushNamed(context, '/profile_pic');
        } else if (coverDataJson['status'] == 0) {
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
