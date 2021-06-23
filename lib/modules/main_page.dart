import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/modules/add_cart_page.dart';
import 'package:food_app/modules/profile.dart';
// import 'package:http/http.dart' as http;
import 'home_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // final String website = "j14.24techsoft.xyz";
  // List itemmenusData;
  int _currentIndex = 0;
  // DateTime backbuttonpressedTime;
  // bool isLoading = false;
  // List itemsmenus = [];

  // Loading Item Call Function//
  // @override
  // void initState() {
  //   super.initState();
  //   this.getItemMenu();
  // }

// Item Manu Fetch data//
  // Future<String> getItemMenu() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final response = await http.get(Uri.https(website, 'api/get-item-menu'),
  //       headers: {"Accept": "application/json"});
  //   if (response.statusCode == 200) {
  //     var coverDataJson = jsonDecode(response.body);
  //     itemmenusData = coverDataJson['menu_items'];
  //     setState(() {
  //       isLoading = false;
  //       itemsmenus = itemmenusData;
  //       print(itemmenusData);
  //     });
  //   } else {
  //     itemsmenus = [];
  //     isLoading = false;
  //     throw Exception('Failed to load Item Menu');
  //   }
  // }
// End Function

  @override
  Widget build(BuildContext context) {
    String heroTag;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey.shade300,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddCardPage();
            }));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProfilePage();
            }));
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Item Menu"),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.assignment),
          //   title: Text("Orders"),
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text("Cart"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("User"),
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
      body: getBodyWidget(),
    );
  }

  getBodyWidget() {
    if (_currentIndex == 0) {
      return HomePage();
    } else {
      return Container();
    }
  }

  // Future<bool> onWillPop() async {
  //   DateTime currenTime = DateTime.now();

  //   bool backButton = backbuttonpressedTime == null ||
  //       currenTime.difference(backbuttonpressedTime) > Duration(seconds: 3);
  //   if (backButton) {
  //     backbuttonpressedTime = currenTime;
  //     Fluttertoast.showToast(
  //         msg: "Double click to exit app",
  //         backgroundColor: Colors.amber,
  //         textColor: Colors.white);
  //     return false;
  //   }
  //   return true;
  // }
}
