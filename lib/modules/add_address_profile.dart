import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class AddAddressProfilePage extends StatefulWidget {
  @override
  _AddAddressProfilePageState createState() => _AddAddressProfilePageState();
}

class _AddAddressProfilePageState extends State<AddAddressProfilePage> {
  TextEditingController _pincode = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _landmarks = TextEditingController();
  TextEditingController location = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool showPassword = false;
  bool isLoading = false;
  var locationMassage = "";
  String address1 = "";
  String address2 = "";

  @override
  void initState() {
    super.initState();
  }

  void getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      var lat = position.latitude;
      var long = position.longitude;
      setState(() {
        locationMassage = "latitude:$lat, longitude:$long";
        getAddressBaseOnLocation(lat, long);
      });
    }).catchError((e) {
      print(e);
    });
    // var position = await Geolocator()
    //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // var lastPosition = await Geolocator().getLastKnownPosition();
    // print(lastPosition);

    // var lat = position.latitude;
    // var long = position.longitude;
    // setState(() {
    //   locationMassage = "latitude:$lat, longitude:$long";
    //   getAddressBaseOnLocation(lat, long);
    // });
  }

  getAddressBaseOnLocation(lat, long) async {
    final coordinates = new Coordinates(lat, long);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      address1 = addresses.first.featureName;
      address2 = addresses.first.addressLine;
      print(address1 + address2);
      location.text = address1 + address2;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.amber.withOpacity(0.2),
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/food.jpg'), fit: BoxFit.cover)),
          ),
          Center(
            child: ClipRRect(
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
                          width: 30,
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
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 20.0),
                    //   child: Positioned(
                    //     bottom: 5,
                    //     left: 20,
                    //     child: Image.asset(
                    //       'images/2.png',
                    //       width: width * 0.9,
                    //       color: Colors.white70,
                    //     ),
                    //   ),
                    // ),
                    Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: SizedBox.fromSize(
                            size: Size(250, 160), // button width and height

                            child: Material(
                              color: Colors.transparent, // button color
                              child: InkWell(
                                // splash color
                                onTap: () {
                                  this.getCurrentLocation();
                                }, // button pressed
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.pin_drop,
                                      color: Colors.white,
                                      size: 90.0,
                                    ), // icon
                                    Text(
                                      "Click For Find Your Current Locations",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ), // text
                                    // Text(
                                    //   "Address: " + address1 + address2 + ".",
                                    //   style: TextStyle(
                                    //     color: Colors.deepPurple[700],
                                    //     fontSize: 10,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ), // text
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     // AddProfileInformation();
                        //   },
                        //   icon: Icon(
                        //     Icons.list_alt,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 100,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 1, left: 10, right: 10),
                          child: TextFormField(
                            controller: location,
                            autofocus: false,
                            onTap: () async {
                              AddressList();
                            },
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            keyboardType: TextInputType.text,
                            decoration: buildInputDecoration(
                                Icons.location_city, "Search Address"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 1, left: 10, right: 10),
                          child: TextFormField(
                            controller: _address,
                            autofocus: false,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            keyboardType: TextInputType.text,
                            decoration: buildInputDecoration(
                                Icons.location_city, "Address"),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please Enter Full Address";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 1, left: 10, right: 10),
                          child: TextFormField(
                            controller: _pincode,
                            autofocus: false,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            keyboardType: TextInputType.text,
                            decoration: buildInputDecoration(
                                Icons.pin_drop, "Pin Code"),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please Enter Pin Code";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 1, left: 10, right: 10),
                          child: TextFormField(
                            controller: _landmarks,
                            autofocus: false,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            keyboardType: TextInputType.text,
                            decoration: buildInputDecoration(
                                Icons.location_city, "Landmark"),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please Enter Landmark";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 275,
                          height: 50,
                          child: RaisedButton(
                            color: Color(0xfffe9721),
                            onPressed: () {
                              AddProfileInformation();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: BorderSide(
                                    color: Color(0xfffe9721), width: 2)),
                            textColor: Colors.white,
                            child: Text("Submit"),
                          ),
                        ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        // SizedBox(
                        //   width: 275,
                        //   height: 50,
                        //   child: RaisedButton(
                        //     color: Colors.deepPurple[700],
                        //     onPressed: () {
                        //       getCurrentLocation();
                        //     },
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(15.0),
                        //         side: BorderSide(
                        //             color: Colors.deepPurple[700], width: 2)),
                        //     textColor: Colors.white,
                        //     child: Text("Find Your Address"),
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
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

  InputDecoration buildInputDecoration(IconData icons, String hinttext) {
    return InputDecoration(
      hintText: hinttext,
      filled: true,
      fillColor: Color(0xFFFAFAFA).withOpacity(0.11),
      hintStyle: TextStyle(color: Color(0xFFFAFAFA)),
      prefixIcon: Icon(icons, color: Color(0xFFFAFAFA)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Color(0xFFFAFAFA), width: 1.5),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Color(0xFFFAFAFA),
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Color(0xFFFAFAFA),
          width: 1.5,
        ),
      ),
    );
  }

  Future StoreDeviceID(device_id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('device_id', device_id);
  }

  Future AddProfileInformation() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String device_id = pref.getString("device_id");
      final data = {
        'device_id': device_id,
        'pincode': _pincode.text,
        'address': _address.text,
        'location': address1 + address2,
        'landmarks': _landmarks.text,
      };
      print(data);
      final http.Response response = await http.post(
          Uri.parse("https://j14foods.com/api/add-profile-address"),
          body: data);
      if (response.statusCode == 200) {
        var coverDataJson = jsonDecode(response.body);
        if (coverDataJson['success'] == 1) {
          this.ShowAlert(coverDataJson["message"]);
          Navigator.pushNamed(context, "customer_adrress");
        } else {
          this.ShowAlert(coverDataJson["message"]);
          Navigator.pushNamed(context, "customer_adrress");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future AddressList() async {
    var result = await Navigator.pushNamed(context, "/address_search");
    location.text = result;
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
