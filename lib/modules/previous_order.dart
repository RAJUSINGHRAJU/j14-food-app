import 'dart:convert';
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:food_app/models/CustomTextStyle.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/modules/order_details.dart';

class PreviousOrderPage extends StatefulWidget {
  @override
  _PreviousOrderPage createState() => _PreviousOrderPage();
}

class _PreviousOrderPage extends State<PreviousOrderPage> {
  // Item ItemDetail = new Item(1);
  var totalPriceSum = 0.0;
  final String website = "j14foods.com";
  List previousOrderData;
  List previouseorder = [];
  bool isLoading = false;
  String puk = '';

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
            Navigator.pushNamed(context, '/main_item_menu');
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
              createSubTitle(),
              createCartList(),
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
        "PREVIOUS ORDER",
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

  createCartList() {
    return ListView.builder(
      itemCount: previouseorder.length,
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
                              "Customer Name: "
                                      "${previouseorder[index]['first_name']}" +
                                  " " +
                                  "${previouseorder[index]['last_name']}",
                              maxLines: 2,
                              softWrap: true,
                              style: CustomTextStyle.textFormFieldSemiBold
                                  .copyWith(fontSize: 12, color: Colors.red),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 8, top: 4),
                            child: Text(
                              "Order Code: "
                              "${previouseorder[index]['order_code']}",
                              maxLines: 2,
                              softWrap: true,
                              style: CustomTextStyle.textFormFieldSemiBold
                                  .copyWith(fontSize: 12, color: Colors.black),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 8, top: 4),
                            child: Text(
                              "Price: "
                              "${previouseorder[index]['total']}",
                              maxLines: 2,
                              softWrap: true,
                              style: CustomTextStyle.textFormFieldSemiBold
                                  .copyWith(fontSize: 12, color: Colors.red),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 8, top: 4),
                            child: Text(
                              "Address: "
                              "${previouseorder[index]['address']}",
                              maxLines: 2,
                              softWrap: true,
                              style: CustomTextStyle.textFormFieldSemiBold
                                  .copyWith(
                                      fontSize: 12, color: Color(0xfffe9721)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: 150,
                              height: 25,
                              child: RaisedButton(
                                color: Color(0xfffe9721),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    OrderDetailsPage.routeName,
                                    arguments: ScreenArguments(
                                        '${previouseorder[index]["id"]}'),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide(
                                        color: Color(0xfffe9721), width: 2)),
                                textColor: Colors.white,
                                child: Text("View Order Details"),
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
    this.getPrevoiusOrder(device_id);
  }

  Future<String> getPrevoiusOrder(device_id) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        Uri.https(website, 'api/get-previous-order/' + device_id),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var coverDataJson = jsonDecode(response.body);
      previousOrderData = coverDataJson['order'];

      setState(() {
        isLoading = false;
        previouseorder = previousOrderData;
      });
    } else {
      previouseorder = [];
      isLoading = false;
      throw Exception('Failed to load Add To Cart Items');
    }
  }

  Future<String> OrderDetails() async {}
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
