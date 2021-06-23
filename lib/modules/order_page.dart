import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  TextEditingController _landmarks = TextEditingController();
  var totalPriceSum = 0.0;
  String radioItem = '';
  final String website = "j14foods.com";
  List addtocartitemData;
  int discountAmountCoupon = 0;
  int discountAmount = 0;
  int cart_total = 0;
  List addtocartitems = [];
  List cumtomer_address = [];
  List coupons = [];
  String OrderIdData = "";
  String CouponCode = "";
  String default_address = "";
  int subtotal = 0;
  int tax = 0;
  int final_total = 0;
  int delivery_charge = 0;
  // List restaurant = [];
  bool isLoading = false;
  String puk = '';
  String xaddress;
  // String xrestaurant;
  bool _value = false;
  String _selectAddress_items = "";
  String _selectCoupan = "";

  @override
  void initState() {
    super.initState();
    this.GetDeviceID();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void unregisteredReceiver() {
    print("Success");
  }

  /*handlerPaymentSuccess() {
    Navigator.pushNamed(context, "/profile_page");
    this.AddItemOrder();
    ShowAlert("Payment Success");
    print("Payment Successfull");
  }

  handlerErrorFailure() {
    Navigator.pushNamed(context, "/profile_page");
    print("failed");
    ShowAlert("Payment Failed");
  }

  handlerExternalWallet() {
    Navigator.pushNamed(context, "/profile_page");
    ShowAlert("External Wallet");
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Order Summary",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      itemCount: addtocartitems.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ClipRRect(
                                  child: Image.network(
                                    "https://j14foods.com/item_icon/${addtocartitems[index]["item_icon"]}",
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text("*"),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${addtocartitems[index]["item_name"]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        '${addtocartitems[index]["portion_name"]}' +
                                            ": x"
                                                '${addtocartitems[index]["quantity"]}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade500),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\₹${addtocartitems[index]["subtotal"]}',
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1.3,
                              color: Colors.grey.shade200,
                              height: 1,
                            ),
                          ],
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Total Amount",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "\₹${cart_total.toString()}",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Discount",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "₹" + discountAmountCoupon.toString(),
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Subtotal Amount",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "₹" + subtotal.toString(),
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Tax Amount",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "₹" + tax.toString(),
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Delivery Charge",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "₹" + delivery_charge.toString(),
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1.3,
                      color: Colors.grey.shade200,
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Final Amount",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "₹" + final_total.toString(),
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1.3,
                      color: Colors.grey.shade200,
                      height: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, top: 20),
                      child: SizedBox(
                          width: 800,
                          child: default_address != null
                              ? Text(default_address,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))
                              : RaisedButton(
                                  color: Color(0xfffe9721),
                                  child: Text("Add New Address"),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(
                                          color: Color(0xfffe9721), width: 2)),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    this.AddnewAddress();
                                  },
                                )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, top: 20),
                      child: SizedBox(
                          width: 400,
                          child: cumtomer_address.length > 0
                              ? RaisedButton(
                                  color: Color(0xfffe9721),
                                  child: Text("Change Address"),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(
                                          color: Color(0xfffe9721), width: 2)),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    this.modalListAddress();
                                  },
                                )
                              : Center(
                                  child: Text(
                                  "You have not added any address yet",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red),
                                ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0, top: 5),
                      child: SizedBox(
                          width: 400,
                          child: CouponCode == ""
                              ? RaisedButton(
                                  color: Color(0xfffe9721),
                                  child: Text("View Offers"),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(
                                          color: Color(0xfffe9721), width: 2)),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    this.modalListCoupose();
                                  },
                                )
                              : RaisedButton(
                                  color: Color(0xfffe9721),
                                  child: Text("Clear Coupon"),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(
                                          color: Color(0xfffe9721), width: 2)),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    CouponCode = "";
                                    discountAmountCoupon = 0;
                                  },
                                )),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 10, left: 0, right: 20),
                      child: Column(
                        children: <Widget>[
                          RadioListTile(
                            groupValue: radioItem,
                            title: Text('Online Payment'),
                            activeColor: Color(0xfffe9721),
                            value: 'Online Payment',
                            onChanged: (val) {
                              setState(() {
                                radioItem = val;
                              });
                            },
                          ),
                          RadioListTile(
                            groupValue: radioItem,
                            title: Text('Delivery Time Payment'),
                            value: 'Offline',
                            activeColor: Color(0xfffe9721),
                            onChanged: (val) {
                              setState(() {
                                radioItem = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, top: 20),
                      child: SizedBox(
                          width: 400,
                          child: RaisedButton(
                            color: Color(0xfffe9721),
                            child: Text("SUBMIT ORDER"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: BorderSide(
                                    color: Color(0xfffe9721), width: 2)),
                            textColor: Colors.white,
                            onPressed: () {
                              this.AddItemOrder();
                            },
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void modalListAddress() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 240,
            child: Container(
              child: ListView.builder(
                  itemCount: cumtomer_address.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          // tileColor: Colors.amber,
                          leading: Icon(
                            Icons.location_city,
                            color: Colors.amber,
                          ),
                          title: Text(
                            '${cumtomer_address[index]["address"]}',
                          ),
                          onTap: () => _selectAddress(
                              cumtomer_address[index]["id"].toString()),
                        )
                      ],
                    );
                  }),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  bottomRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  void _selectAddress(String address) {
    Navigator.pop(context);
    setState(() {
      _selectAddress_items = address;
    });
  }

  void modalListCoupose() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 240,
            child: Container(
              child: ListView.builder(
                  itemCount: coupons.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          // tileColor: Colors.amber,
                          leading: Image.network(
                            "https://j14foods.com/coupon_image/${coupons[index]["coupon_image"]}",
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            "Coupon Code: " +
                                '${coupons[index]["coupon_code"]}' +
                                '-' +
                                "Discount Amount: " +
                                '${coupons[index]["discount_amount"]}  ' +
                                "Discount: " +
                                '${coupons[index]["description"]}',
                          ),
                          onTap: () => _selectCoupons(
                              coupons[index]["coupon_code"].toString()),
                        )
                      ],
                    );
                  }),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  bottomRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  void _selectCoupons(String coupon_code) {
    Navigator.pop(context);
    setState(() {
      this.getApplyCoupon(coupon_code);
    });
  }

  InputDecoration buildInputDecoration(IconData icons, String hinttext) {
    return InputDecoration(
      hintText: hinttext,
      filled: true,
      fillColor: Color(0xfffe9721).withOpacity(0.11),
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

  Future StoreDeviceID(device_id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('device_id', device_id);
  }

  Future GetDeviceID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String device_id = pref.getString("device_id");
    this.getAddCartItems(device_id);
  }

  void openCheckout() async {
    var result = await Navigator.pushNamed(context, "/checkout");
    if (result == "success") {
      SaveOrder();
    } else {
      ShowAlert("Payment failed");
    }
  }

  Future getAddCartItems(device_id) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(
          Uri.https(website, 'api/get-add-cart-items-order/' + device_id),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        var coverDataJson = jsonDecode(response.body);
        addtocartitemData = coverDataJson['add_to_cart_items'];

        cumtomer_address = coverDataJson['cumtomer_address'];
        if (coverDataJson['default_address'] != null) {
          default_address = coverDataJson['default_address']['address'] +
              ", " +
              coverDataJson['default_address']['pin_code'].toString();
          _selectAddress_items =
              coverDataJson['default_address']["id"].toString();
        } else {
          default_address = null;
        }

        coupons = coverDataJson['coupons'];
        delivery_charge =
            int.parse(coverDataJson['delivery_charge'].toString());
        OrderIdData = coverDataJson['order_id'];
        cart_total = int.parse(coverDataJson['cart_total'].toString());
        setState(() {
          isLoading = false;
          addtocartitems = addtocartitemData;
          if (CouponCode != "") {
            getApplyCoupon(CouponCode);
          } else {
            Calculate();
          }
        });
      } else {
        addtocartitems = [];
        isLoading = false;
        throw Exception('Failed to load Add To Cart Items');
      }
    } catch (e) {
      print("Error found");
      print(e);
    }
  }

  Future getApplyCoupon(coupon_code) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String device_id = pref.getString("device_id");
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        Uri.https(website, 'api/apply-coupon/' + coupon_code + '/' + device_id),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var coverDataJson = jsonDecode(response.body);
      discountAmount = int.parse(coverDataJson['discount_amount'].toString());
      if (coverDataJson["error"] == 0) {
        CouponCode = coupon_code;
        Calculate();
      }
      setState(() {
        isLoading = false;
        discountAmountCoupon = int.parse(discountAmount.toString());
      });
      print(discountAmountCoupon);
    } else {
      addtocartitems = [];
      isLoading = false;
      throw Exception('Failed to load Add To Cart Items');
    }
  }

  Future Calculate() {
    try {
      subtotal = cart_total - discountAmount;
      tax = int.parse((subtotal * 0.18).round().toString());
      final_total = subtotal + tax + delivery_charge;
    } catch (e) {
      print("error in Calculate");
      print(e);
    }
  }

  void SaveOrder() async {
    var payment_status = 1;
    if (radioItem == "Offline") {
      payment_status = 0;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    String device_id = pref.getString("device_id");
    final data = {
      'device_id': device_id,
      'total': cart_total.toString(),
      'address': _selectAddress_items,
      'delivery_charge': delivery_charge.toString(),
      'discount': discountAmount.toString(),
      'subtotal': subtotal.toString(),
      'coupon_code': CouponCode,
      'tax': tax.toString(),
      'final_total': final_total.toString(),
      'payment_status': payment_status.toString()
    };
    print(data);
    final http.Response response = await http
        .post(Uri.parse("https://j14foods.com/api/add-item-order"), body: data);
    print(data);
    if (response.statusCode == 200) {
      var coverDataJson = jsonDecode(response.body);
      if (coverDataJson['success'] == 1) {
        this.ShowAlert(coverDataJson["message"]);
      } else {
        this.ShowAlert(coverDataJson["message"]);
        Navigator.pushNamed(context, '/main_item_menu');
      }
    }
  }

  Future AddItemOrder() async {
    try {
      if (radioItem == "Offline") {
        SaveOrder();
      } else {
        openCheckout();
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

  Future AddnewAddress() {
    Navigator.pushNamed(context, '/add_address_profile_page');
  }
}
