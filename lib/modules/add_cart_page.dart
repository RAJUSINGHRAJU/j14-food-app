import 'dart:convert';
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:food_app/models/CustomTextStyle.dart';
import 'package:food_app/models/CustomUtils.dart';
import 'package:food_app/modules/order_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCardPage extends StatefulWidget {
  @override
  _AddCardPage createState() => _AddCardPage();
}

class _AddCardPage extends State<AddCardPage> {
  // Item ItemDetail = new Item(1);
  var totalPriceSum = 0.0;
  final String website = "j14foods.com";
  List addtocartitemData;
  String cart_total = "0";
  List addtocartitems = [];
  bool isLoading = false;
  String puk = '';
  void initState() {
    super.initState();
    this.GetDeviceID(puk, 0);
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
              footer(context)
            ],
          );
        },
      ),
    );
  }

  footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  "Total",
                  style: CustomTextStyle.textFormFieldMedium
                      .copyWith(color: Colors.grey, fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  "\₹${cart_total}",
                  style: CustomTextStyle.textFormFieldBlack
                      .copyWith(color: Colors.amber, fontSize: 14),
                ),
              ),
            ],
          ),
          Utils.getSizedBox(height: 6),
          addtocartitems.length > 0
              ? RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => OrderPage()));
                  },
                  color: Color(0xfffe9721),
                  padding:
                      EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Text(
                    "Checkout",
                    style: CustomTextStyle.textFormFieldSemiBold
                        .copyWith(color: Colors.white),
                  ),
                )
              : Text(""),
          Utils.getSizedBox(height: 8),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "CART ITEMS",
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
      itemCount: addtocartitems.length,
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
                  Container(
                    margin:
                        EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                    width: 80,
                    height: 80,
                    child: Image.network(
                      "https://j14foods.com/item_icon/${addtocartitems[index]["item_icon"]}",
                      height: 120,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
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
                              "${addtocartitems[index]['item_name']}",
                              maxLines: 2,
                              softWrap: true,
                              style: CustomTextStyle.textFormFieldSemiBold
                                  .copyWith(fontSize: 18, color: Colors.red),
                            ),
                          ),
                          Utils.getSizedBox(height: 8),
                          Text(
                            "Quantity: "
                            "${addtocartitems[index]['quantity']}",
                            style: CustomTextStyle.textFormFieldRegular
                                .copyWith(color: Colors.grey, fontSize: 14),
                          ),
                          Container(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Price:"
                                    " \₹${addtocartitems[index]["subtotal"]}",
                                    style: CustomTextStyle.textFormFieldBlack
                                        .copyWith(
                                            color: Colors.amber, fontSize: 14),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            addtocartitems[index]["quantity"] >
                                                    0
                                                ? new IconButton(
                                                    icon: new Icon(
                                                      Icons.remove,
                                                      color:
                                                          Colors.green.shade400,
                                                    ),
                                                    onPressed: () =>
                                                        setState(() => {
                                                              this.QuantityUpdate(
                                                                  addtocartitems[
                                                                          index]
                                                                      ["puk"],
                                                                  addtocartitems[
                                                                          index]
                                                                      ["size"],
                                                                  "-1")
                                                            }),
                                                  )
                                                : new Container(),
                                            new Text(addtocartitems[index]
                                                    ["quantity"]
                                                .toString()),
                                            new IconButton(
                                                icon: new Icon(
                                                  Icons.add,
                                                  color: Colors.red.shade400,
                                                ),
                                                onPressed: () => setState(() =>
                                                    {
                                                      this.QuantityUpdate(
                                                          addtocartitems[index]
                                                              ["puk"],
                                                          addtocartitems[index]
                                                              ["size"],
                                                          "1")
                                                    }))
                                          ]))
                                ]),
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
                    String puk = addtocartitems[index]["puk"];
                    this.GetDeviceID(puk, 0);
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

  Future GetDeviceID(puk, quantity) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String device_id = pref.getString("device_id");
    // this.QuantityUpdate(device_id, puk, quantity);
    this.getAddCartItems(device_id);
    this.RemoveToCart(puk);
  }

  Future<String> getAddCartItems(device_id) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        Uri.https(website, 'api/get-add-cart-items/' + device_id),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var coverDataJson = jsonDecode(response.body);
      addtocartitemData = coverDataJson['add_to_cart_items'];
      cart_total = coverDataJson['cart_total'];
      setState(() {
        isLoading = false;
        addtocartitems = addtocartitemData;
        cart_total = cart_total;
      });
    } else {
      addtocartitems = [];
      isLoading = false;
      throw Exception('Failed to load Add To Cart Items');
    }
  }

  Future QuantityUpdate(puk, xsize, quantity) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String device_id = pref.getString("device_id");
      final data = {
        'device_id': device_id,
        'puk': puk.toString(),
        'quantity': quantity.toString(),
        'xsize': xsize.toString()
      };
      final http.Response response = await http.post(
          Uri.parse("https://j14foods.com/api/add-to-cart-items"),
          body: data);
      if (response.statusCode == 200) {
        var coverDataJson = jsonDecode(response.body);
        if (coverDataJson['success'] == 1) {
          this.ShowAlert(coverDataJson["message"]);
          getAddCartItems(device_id);
        } else {
          this.ShowAlert(coverDataJson["message"]);
          getAddCartItems(device_id);
        }
      }
    } catch (e) {}
  }

  Future<String> RemoveToCart(puk) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String device_id = pref.getString("device_id");
    try {
      final http.Response response = await http.post(
          Uri.parse("https://j14foods.com/api/remove-to-cart"),
          body: {'device_id': device_id, 'puk': puk.toString()});
      if (response.statusCode == 200) {
        var coverDataJson = jsonDecode(response.body);
        if (coverDataJson['success'] == 1) {
          this.ShowAlert(coverDataJson["message"]);
          Navigator.pushNamed(context, '/cart');
        } else {
          this.ShowAlert(coverDataJson["message"]);
          Navigator.pushNamed(context, '/cart');
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
