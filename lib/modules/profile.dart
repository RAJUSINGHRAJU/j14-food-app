import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class Profile {
  String email;
  String first_name;
  String last_name;
  int id;
  Profile(
    this.email,
    this.first_name,
    this.last_name,
    this.id,
  );
}

class _ProfilePageState extends State<ProfilePage> {
  Profile ProfileDetails = new Profile("", "", "", 0);
  TextEditingController _first_name = TextEditingController();
  TextEditingController _last_name = TextEditingController();
  TextEditingController _email = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    this.GetDeviceID();
  }

  bool showPassword = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/food.jpg'), fit: BoxFit.cover)),
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.transparent,
                Colors.transparent,
                Color(0xff161d27).withOpacity(0.5),
                Color(0xff161d27),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CustomPaint(
                size: Size(width, height),
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 15 + MediaQuery.of(context).padding.top,
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          height: 25,
                          width: 25,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.keyboard_backspace,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   bottom: 30,
                    //   left: 20,
                    //   child: Image.asset(
                    //     'images/2.png',
                    //     width: width * 0.9,
                    //     color: Colors.white70,
                    //   ),
                    // ),
                    Column(
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        Center(
                          child: Image.asset(
                            'images/profile-setting.png',
                            color: Colors.white,
                            width: width * 0.3,
                          ),
                        ),
                        Text(
                          'Profile Setting',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        detailWidget(
                          icon: Icons.person,
                          text: ProfileDetails.first_name +
                              " " +
                              ProfileDetails.last_name,
                        ),
                        detailWidget(
                          icon: Icons.email,
                          text: ProfileDetails.email,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 275,
                          height: 40,
                          child: RaisedButton(
                            color: Color(0xfffe9721),
                            onPressed: () {
                              AddAddressProfile();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                side: BorderSide(
                                    color: Color(0xfffe9721), width: 2)),
                            textColor: Colors.white,
                            child: Text("Address"),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 275,
                          height: 40,
                          child: RaisedButton(
                            color: Colors.deepPurple[700],
                            onPressed: () {
                              PrevioseOrder();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                side: BorderSide(
                                    color: Colors.deepPurple[700], width: 2)),
                            textColor: Colors.white,
                            child: Text("Previous Order"),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 275,
                          height: 40,
                          child: RaisedButton(
                            color: Colors.red,
                            onPressed: () {
                              Logout();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                side: BorderSide(color: Colors.red, width: 2)),
                            textColor: Colors.white,
                            child: Text("Logout"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailWidget({IconData icon, String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  Future StoreDeviceID(device_id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('device_id', device_id);
  }

  Future GetDeviceID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String device_id = pref.getString("device_id");
    this.getUserProfile(device_id);
  }

  Future<List> getUserProfile(device_id) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(
          Uri.https("j14foods.com", 'api/get-profile/' + device_id),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        var coverDataJson = jsonDecode(response.body);
        ProfileDetails.first_name = coverDataJson['user']['first_name'];
        ProfileDetails.last_name = coverDataJson['user']['last_name'];
        ProfileDetails.email = coverDataJson['user']['email'];
        ProfileDetails.id = coverDataJson['user']['id'];
        setState(() {
          isLoading = true;
        });
      } else {
        isLoading = false;
        throw Exception('Failed to load Item Details');
      }
    } catch (e) {
      print(e);
    }
  }

  Future AddAddressProfile() {
    Navigator.pushNamed(context, '/customer_adrress');
  }

  Future PrevioseOrder() {
    Navigator.pushNamed(context, '/prevoius_order_page');
  }

  Future Logout() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String device_id = pref.getString("device_id");
      final http.Response response = await http.post(
          Uri.parse("https://j14foods.com/api/logout"),
          body: {'device_id': device_id});
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
