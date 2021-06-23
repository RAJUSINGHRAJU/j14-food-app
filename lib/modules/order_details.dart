import 'dart:convert';
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:food_app/models/CustomTextStyle.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_app/models/InputDeco_design.dart';

class OrderDetailsPage extends StatefulWidget {
  static const routeName = '/order_details';
  @override
  _OrderDetailsPage createState() => _OrderDetailsPage();
}

class ScreenArguments {
  final String order_id;

  ScreenArguments(this.order_id);
}

class Order {
  String order_code;
  String total;
  String address;

  Order(this.order_code, this.total, this.address);
}

class _OrderDetailsPage extends State<OrderDetailsPage> {
  Order OrderDetail = new Order("", "", "");

  final String website = "j14foods.com";
  List OrderDetailsData;
  List orderdetails = [];
  bool isLoading = false;

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final order =
          ModalRoute.of(context).settings.arguments as ScreenArguments;
      this.getOrderDetails(order.order_id);
    });
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
            Navigator.pushNamed(context, '/prevoius_order_page');
          },
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.black,
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          return new Stack(
            children: <Widget>[
              createHeader(),
              createSubTitle(),
              createCartList(),
              Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Center(
                  child: SizedBox(
                      width: 250,
                      child: RaisedButton(
                        color: Color(0xfffe9721),
                        child: Text("SUBMIT"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side:
                                BorderSide(color: Color(0xfffe9721), width: 2)),
                        textColor: Colors.white,
                        onPressed: () {
                          SubmitRating();
                        },
                      )),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  createHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ),
      child: Container(
        alignment: Alignment.topLeft,
        child: Text(
          "ORDER DETAILS",
          style: CustomTextStyle.textFormFieldBold
              .copyWith(fontSize: 16, color: Colors.black),
        ),
        margin: EdgeInsets.only(left: 12, top: 12, bottom: 20),
      ),
    );
  }

  createSubTitle() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 12, top: 4),
    );
  }

  createCartList() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ListView.builder(
        itemCount: orderdetails.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          return new Stack(
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
                        "https://j14foods.com/item_icon/${orderdetails[index]["item_icon"]}",
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
                                "Item Name: "
                                "${orderdetails[index]['item_name']}",
                                maxLines: 2,
                                softWrap: true,
                                style: CustomTextStyle.textFormFieldSemiBold
                                    .copyWith(fontSize: 12, color: Colors.red),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 8, top: 4),
                              child: Text(
                                "Items Size: "
                                "${orderdetails[index]['portion_name']}",
                                maxLines: 2,
                                softWrap: true,
                                style: CustomTextStyle.textFormFieldSemiBold
                                    .copyWith(
                                        fontSize: 12, color: Colors.black),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 8, top: 4),
                              child: Text(
                                "Price: "
                                "${orderdetails[index]['total']}",
                                maxLines: 2,
                                softWrap: true,
                                style: CustomTextStyle.textFormFieldSemiBold
                                    .copyWith(fontSize: 12, color: Colors.red),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 8, top: 4),
                              child: Text(
                                "Quantity: "
                                "${orderdetails[index]['quantity']}",
                                maxLines: 2,
                                softWrap: true,
                                style: CustomTextStyle.textFormFieldSemiBold
                                    .copyWith(
                                        fontSize: 12, color: Color(0xfffe9721)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                  child: (orderdetails[index]['rating'] == null)
                                      ? RatingBar.builder(
                                          initialRating: 4,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                          itemSize: 20,
                                          onRatingUpdate: (current_rating) {
                                            orderdetails[index]['rating_1'] =
                                                int.parse(
                                                    current_rating.toString());
                                            //print(rating);
                                          })
                                      : Text("")),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                  child: (orderdetails[index]['rating'] == null)
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 15, left: 10, right: 10),
                                          child: TextField(
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                            keyboardType: TextInputType.text,
                                            decoration: buildInputDecoration(
                                                Icons.comment, "Remarks"),
                                            onChanged: (String val) {
                                              orderdetails[index]['remarks_1'] =
                                                  val;
                                            },
                                          ),
                                        )
                                      : Text("")),
                            ),
                          ],
                        ),
                      ),
                      flex: 100,
                    ),
                  ],
                ),
              ),
              // Container(
              //     child: (orderdetails[index]['rating'] == null)
              //         ? RatingBar.builder(
              //             initialRating: 4,
              //             minRating: 1,
              //             direction: Axis.horizontal,
              //             itemCount: 5,
              //             itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              //             itemBuilder: (context, _) => Icon(
              //                   Icons.star,
              //                   color: Colors.amber,
              //                 ),
              //             itemSize: 20,
              //             onRatingUpdate: (current_rating) {
              //               orderdetails[index]['rating_1'] =
              //                   int.parse(current_rating.toString());
              //               //print(rating);
              //             })
              //         : Text("")),
              // Container(
              //     child: (orderdetails[index]['rating'] == null)
              //         ? Padding(
              //             padding: const EdgeInsets.only(
              //                 bottom: 15, left: 10, right: 10),
              //             child: TextField(
              //               style: TextStyle(fontSize: 16, color: Colors.white),
              //               keyboardType: TextInputType.text,
              //               decoration:
              //                   buildInputDecoration(Icons.email, "Email"),
              //               onChanged: (String val) {
              //                 orderdetails[index]['remarks_1'] = val;
              //               },
              //             ),
              //           )
              //         : Text(""))
            ],
          );
        },
      ),
    );
  }

  InputDecoration buildInputDecoration(IconData icons, String hinttext) {
    return InputDecoration(
      hintText: hinttext,
      filled: true,
      fillColor: Colors.white.withOpacity(0.11),
      hintStyle: TextStyle(color: Color(0xfffe9721)),
      prefixIcon: Icon(icons, color: Color(0xfffe9721)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Color(0xfffe9721), width: 1.5),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Color(0xfffe9721),
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Color(0xfffe9721),
          width: 1.5,
        ),
      ),
    );
  }

  Future SubmitRating() async {
    try {
      final http.Response response = await http.post(
          Uri.parse("https://j14foods.com/api/save-rating"),
          body: {"ratings": jsonEncode(orderdetails)});
      if (response.statusCode == 200) {
        print(response.body);
        final order =
            ModalRoute.of(context).settings.arguments as ScreenArguments;
        this.getOrderDetails(order.order_id);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> getOrderDetails(order_id) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        Uri.https(website, 'api/get-order-details/' + order_id),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var coverDataJson = jsonDecode(response.body);
      OrderDetail.order_code = coverDataJson['order']['order_code'];
      OrderDetail.total = coverDataJson['order']['total'];
      OrderDetail.address = coverDataJson['order']['address'];
      print(OrderDetailsData);

      setState(() {
        isLoading = false;
        orderdetails = coverDataJson['items'];
      });
    } else {
      orderdetails = [];
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
