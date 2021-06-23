import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_app/models/CustomTextStyle.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_app/modules/edit_address_page.dart';

class CustomerAddressPage extends StatefulWidget {
  @override
  _CustomerAddressPage createState() => _CustomerAddressPage();
}

class _CustomerAddressPage extends State<CustomerAddressPage> {
  final String website = "j14foods.com";
  List cumtomeraddress = [];
  bool isLoading = false;

  void initState() {
    super.initState();
    this.GetDeviceID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
      body: Builder(
        builder: (context) {
          return ListView(
            children: <Widget>[
              createHeader(),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10, left: 15.0, right: 15.0),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 35,
                    child: RaisedButton(
                      color: Color(0xfffe9721),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/add_address_profile_page');
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: Color(0xfffe9721), width: 2)),
                      textColor: Colors.white,
                      child: Text("Add Address"),
                    ),
                  ),
                ),
              ),
              createSubTitle(),
              //createCartList(),
              createCartList1()
            ],
          );
        },
      ),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "LIST OF ADDRESS",
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 16, color: Colors.black),
      ),
      margin: EdgeInsets.only(left: 12, top: 12),
    );
  }

  createSubTitle() {
    return Container(
      alignment: Alignment.topLeft,
      // child: Text(
      //   "Total() Items",
      //   style: CustomTextStyle.textFormFieldBold
      //       .copyWith(fontSize: 12, color: Colors.grey),
      // ),
      margin: EdgeInsets.only(left: 12, top: 4),
    );
  }

  // createCartList() {
  //   return ListView.builder(
  //     itemCount: cumtomeraddress.length,
  //     shrinkWrap: true,
  //     primary: false,
  //     itemBuilder: (context, index) {
  //       return Stack(
  //         children: <Widget>[
  //           Container(
  //             margin: EdgeInsets.only(left: 16, right: 16, top: 16),
  //             decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.all(Radius.circular(16))),
  //             child: Row(
  //               children: <Widget>[
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 8.0),
  //                   child: Expanded(
  //                     child: Container(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.max,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: <Widget>[
  //                           Container(
  //                             padding: EdgeInsets.only(right: 8, top: 4),
  //                             child: Text(
  //                               "Address: "
  //                               "${cumtomeraddress[index]['address']}",
  //                               maxLines: 2,
  //                               softWrap: true,
  //                               style: CustomTextStyle.textFormFieldSemiBold
  //                                   .copyWith(fontSize: 14, color: Colors.red),
  //                             ),
  //                           ),
  //                           Container(
  //                             padding: EdgeInsets.only(right: 8, top: 4),
  //                             child: Text(
  //                               "Landmark:"
  //                               "${cumtomeraddress[index]['landmarks']}",
  //                               maxLines: 2,
  //                               softWrap: true,
  //                               style: CustomTextStyle.textFormFieldSemiBold
  //                                   .copyWith(
  //                                       fontSize: 14, color: Colors.black),
  //                             ),
  //                           ),
  //                           Container(
  //                             padding: EdgeInsets.only(right: 8, top: 4),
  //                             child: Text(
  //                               "Pin Code:"
  //                               "${cumtomeraddress[index]['pin_code']}",
  //                               maxLines: 2,
  //                               softWrap: true,
  //                               style: CustomTextStyle.textFormFieldSemiBold
  //                                   .copyWith(
  //                                       fontSize: 14, color: Colors.amber),
  //                             ),
  //                           ),
  //                           // Container(
  //                           //   padding: EdgeInsets.only(right: 8, top: 4),
  //                           //   child: Text(
  //                           //     "Locations:"
  //                           //     "${cumtomeraddress[index]['location']}",
  //                           //     maxLines: 2,
  //                           //     softWrap: true,
  //                           //     style: CustomTextStyle.textFormFieldSemiBold
  //                           //         .copyWith(
  //                           //             fontSize: 14, color: Colors.black),
  //                           //   ),
  //                           // ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(top: 20),
  //                             child: SizedBox(
  //                               width: 120,
  //                               height: 35,
  //                               child: RaisedButton(
  //                                 color: Color(0xfffe9721),
  //                                 onPressed: () {
  //                                   Navigator.pushNamed(
  //                                     context,
  //                                     AddressEditPage.routeName,
  //                                     arguments: ScreenArguments(
  //                                         '${cumtomeraddress[index]["id"]}'),
  //                                   );
  //                                 },
  //                                 shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(25.0),
  //                                     side: BorderSide(
  //                                         color: Color(0xfffe9721), width: 2)),
  //                                 textColor: Colors.white,
  //                                 child: Text("Edit Address"),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     flex: 100,
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //           Align(
  //             alignment: Alignment.topRight,
  //             child: Container(
  //               width: 35,
  //               height: 35,
  //               alignment: Alignment.center,
  //               margin: EdgeInsets.only(right: 15, top: 8),
  //               child: IconButton(
  //                 icon: Icon(
  //                   Icons.close,
  //                   color: Colors.white,
  //                   size: 20,
  //                 ),
  //                 onPressed: () {
  //                   String id = cumtomeraddress[index]["id"].toString();
  //                   this.RemoveAddress(id);
  //                 },
  //               ),
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.all(Radius.circular(4)),
  //                   color: Colors.red),
  //             ),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  createCartList1() {
    return ListView.builder(
      itemCount: cumtomeraddress.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 8, top: 4),
                            child: Text(
                              "Address: "
                              "${cumtomeraddress[index]['address']}",
                              maxLines: 2,
                              softWrap: true,
                              style: CustomTextStyle.textFormFieldSemiBold
                                  .copyWith(fontSize: 12, color: Colors.red),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 8, top: 4),
                            child: Text(
                              "Landmark:"
                              "${cumtomeraddress[index]['landmarks']}",
                              maxLines: 2,
                              softWrap: true,
                              style: CustomTextStyle.textFormFieldSemiBold
                                  .copyWith(fontSize: 12, color: Colors.black),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 8, top: 4),
                            child: Text(
                              "Pin Code:"
                              "${cumtomeraddress[index]['pin_code']}",
                              maxLines: 2,
                              softWrap: true,
                              style: CustomTextStyle.textFormFieldSemiBold
                                  .copyWith(fontSize: 12, color: Colors.red),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: 120,
                              height: 35,
                              child: RaisedButton(
                                color: Color(0xfffe9721),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AddressEditPage.routeName,
                                    arguments: ScreenArguments(
                                        '${cumtomeraddress[index]["id"]}'),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide(
                                        color: Color(0xfffe9721), width: 2)),
                                textColor: Colors.white,
                                child: Text("Edit Address"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    flex: 100,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 35,
                height: 35,
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 15, top: 8),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    String id = cumtomeraddress[index]["id"].toString();
                    this.RemoveAddress(id);
                  },
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Colors.red),
              ),
            )
          ],
        );
      },
    );
  }

  Future StoreDeviceID(device_id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('device_id', device_id);
  }

  Future GetDeviceID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String device_id = pref.getString("device_id");
    this.getUserAddress(device_id);
  }

  Future<String> getUserAddress(device_id) async {
    final response = await http.get(
        Uri.https(website, 'api/get-user-address/' + device_id),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var coverDataJson = jsonDecode(response.body);
      setState(() {
        isLoading = false;
        cumtomeraddress = coverDataJson['address'];
      });
    } else {
      cumtomeraddress = [];
      isLoading = false;
      throw Exception('Failed to load Address List');
    }
  }

  Future<String> RemoveAddress(id) async {
    try {
      final http.Response response = await http.post(
          Uri.parse("https://j14foods.com/api/remove-address"),
          body: {'address_id': id});
      if (response.statusCode == 200) {
        var coverDataJson = jsonDecode(response.body);
        if (coverDataJson['success'] == 1) {
          this.ShowAlert(coverDataJson["message"]);
          Navigator.pushNamed(context, '/customer_adrress');
        } else {
          this.ShowAlert(coverDataJson["message"]);
        }
      }
    } catch (e) {}
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
