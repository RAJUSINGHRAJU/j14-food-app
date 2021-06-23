import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ItemDetailsPage extends StatefulWidget {
  static const routeName = '/item_details';
  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class ScreenArguments {
  final String id;
  final String puk;
  ScreenArguments(this.id, this.puk);
}

class Item {
  String availability;
  String created_at;
  String date;
  String description;
  int id;
  String item_icon;
  String item_image;
  String item_name;
  String puk;
  int quantity;
  String subtotal;
  Item(
      this.availability,
      this.created_at,
      this.date,
      this.description,
      this.id,
      this.item_icon,
      this.item_image,
      this.item_name,
      this.puk,
      this.quantity,
      this.subtotal);
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  Item ItemDetail = new Item("", "", "", "", 0, "", "", "", "", 1, "");
  List Sizes = [];
  List Addons = [];
  String arguments;
  final String website = "j14foods.com";
  List itemdetailsData;
  String xsize;
  bool isLoading = false;
  List itemsdetails = [];
  bool valuefirst = false;
  bool valuesecond = false;
  bool _value = false;
  int quantity = 1;
  int _itemCount = 0;
  String price = "";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
      //this.getItemDetails(args.id);
      this.GetDeviceID("", 0, 0, args.id, "get_item_details");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 2,
            child: Image.network(
              "https://j14foods.com/item_icon/${ItemDetail.item_icon}",
              height: 120,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 30,
            top: 30 + MediaQuery.of(context).padding.top,
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 42,
                width: 41,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.25),
                      offset: Offset(0, 4),
                      blurRadius: 8)
                ]),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.0),
                          offset: Offset(0, -4),
                          blurRadius: 8)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 30,
                        right: 30,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${ItemDetail.item_name}",
                              style: GoogleFonts.ptSans(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                'images/like.svg',
                                height: 24,
                                width: 24,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Row(
                        children: [
                          Text(
                            'Price: ' + price,
                            style: GoogleFonts.ptSans(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 20,
                        right: 30,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          DropdownButton(
                            value: xsize,
                            focusColor: Colors.yellow,
                            //elevation: 5,
                            style: TextStyle(color: Colors.yellow),
                            iconEnabledColor: Colors.black,
                            items: Sizes.map((item) {
                              return DropdownMenuItem<String>(
                                value: Sizes.indexOf(item).toString(),
                                child: new Text(
                                    item['portion_name'] +
                                        ' - ' +
                                        item['price'],
                                    style: TextStyle(color: Colors.black)),
                              );
                            }).toList(),
                            hint: Text(
                              "Please choose a size                                                        ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500),
                            ),
                            onChanged: (item) {
                              setState(() {
                                this.xsize = item;
                                this.price =
                                    Sizes[int.parse(item)]['price'].toString();
                                child:
                                Text(
                                  xsize,
                                );

                                // print(this.xsize);
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ItemDetail.quantity > 0
                                  ? new IconButton(
                                      icon: new Icon(
                                        Icons.remove,
                                        color: Colors.green.shade400,
                                      ),
                                      onPressed: () => setState(() => {
                                            this.GetDeviceID(
                                                ItemDetail.puk,
                                                Sizes[int.parse(xsize)]["id"],
                                                -1,
                                                0,
                                                "add_to_cart")
                                          }),
                                    )
                                  : new Container(),
                              new Text(ItemDetail.quantity.toString()),
                              new IconButton(
                                  icon: new Icon(
                                    Icons.add,
                                    color: Colors.red.shade400,
                                  ),
                                  onPressed: () => setState(() => {
                                        this.GetDeviceID(
                                            ItemDetail.puk,
                                            Sizes[int.parse(xsize)]["id"],
                                            1,
                                            0,
                                            "add_to_cart")
                                      }))
                            ])),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 17, horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.07),
                                offset: Offset(0, -3),
                                blurRadius: 12)
                          ]),
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(
                                  'Total',
                                  style: GoogleFonts.ptSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  ItemDetail.subtotal,
                                  style: GoogleFonts.ptSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )
                              ])),
                          Material(
                            color: Color.fromRGBO(243, 175, 43, 1),
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () {
                                print('click');
                              },
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextButton(
                                    onPressed: () {
                                      this.GetDeviceID(
                                          ItemDetail.puk,
                                          Sizes[int.parse(xsize)]["id"],
                                          1,
                                          0,
                                          "add_to_cart");
                                    },
                                    child: Text(
                                      "Add To Cart",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

// Start Item Manu Fetch data//
  Future<List> getItemDetails(id, device_id) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(
          Uri.https("j14foods.com",
              'api/get-item-menu-details/' + id + '/' + device_id),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        // print(jsonDecode(response.body));
        var coverDataJson = jsonDecode(response.body);
        // print(coverDataJson);
        ItemDetail.item_name = coverDataJson['items']['item_name'];
        ItemDetail.item_icon = coverDataJson['items']['item_icon'];
        ItemDetail.quantity =
            int.parse(coverDataJson['items']['quantity'].toString());
        ItemDetail.subtotal = coverDataJson['items']['subtotal'].toString();
        ItemDetail.puk = coverDataJson['items']['puk'];
        Sizes = coverDataJson['items']['sizes'];
        if (Sizes.length > 0) {
          Addons = Sizes[0]['adons'];
          xsize = "0";
          price = Sizes[0]['price'].toString();
        }
        setState(() {
          isLoading = true;
          itemsdetails = itemdetailsData;
        });
      } else {
        itemsdetails = [];
        isLoading = false;
        throw Exception('Failed to load Item Details');
      }
    } catch (e) {
      print(e);
    }
  }

// End Item Manu Fetch data//
  Future StoreDeviceID(device_id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('device_id', device_id);
  }

  Future GetDeviceID(puk, xsize, quantity, id, task) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String device_id = pref.getString("device_id");
    if (task == 'add_to_cart') {
      this.AddToCart(device_id, quantity, xsize);
    } else if (task == 'get_item_details') {
      this.getItemDetails(id, device_id);
      print("Item loaded");
    }
  }

  Future AddToCart(device_id, quantity, xsize) async {
    try {
      final data = {
        'device_id': device_id,
        'puk': ItemDetail.puk,
        'xsize': xsize.toString(),
        'quantity': quantity.toString()
      };
      final http.Response response = await http.post(
          Uri.parse("https://j14foods.com/api/add-to-cart-items"),
          body: data);
      if (response.statusCode == 200) {
        var coverDataJson = jsonDecode(response.body);
        if (coverDataJson['success'] == 1) {
          this.ShowAlert(coverDataJson["message"]);
          final args =
              ModalRoute.of(context).settings.arguments as ScreenArguments;
          this.GetDeviceID(
              ItemDetail.puk, xsize, 0, args.id, "get_item_details");
          // Navigator.pushNamed(context, '/item_details');
        } else {
          this.ShowAlert(coverDataJson["message"]);
          Navigator.pushNamed(context, '/item_details');
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
