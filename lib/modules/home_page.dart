import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/home_title.dart';
import 'package:food_app/models/colors.dart';
import 'package:food_app/modules/item_details_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String website = "j14foods.com";
  DateTime backbuttonpressedTime;
  List itemmenusData;
  List itemshighestorderData;
  List itemsratingData;
  bool isLoading = false;
  List itemsmenus = [];
  List promotion = [];
  List itemshighestorder = [];
  List itemsrating = [];
  List itemmenusDataFiltered = [];
  int orderStatusData = 0;
  int OderStatus = 0;
  String def_address = "";
  String user_names = "";

  void initState() {
    super.initState();
    this.getOrderStatus();
    this.getItemMenu();
    this.getHighestOrderItems();
    // this.getItemRating();
  }

  Future StoreDeviceID(device_id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('device_id', device_id);
  }

  Future GetDeviceID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String device_id = pref.getString("device_id");
  }

// Item Manu Fetch data//
  Future<String> getItemMenu() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String device_id = pref.getString("device_id");
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        Uri.https(website, 'api/get-item-menu/' + device_id),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var coverDataJson = jsonDecode(response.body);
      itemmenusData = coverDataJson['menu_items'];
      promotion = coverDataJson['promotion'];
      def_address = coverDataJson['default_address']['address'];
      setState(() {
        isLoading = false;
        itemsmenus = itemmenusData;
        // print(itemsmenus);
      });
    } else {
      itemsmenus = [];
      isLoading = false;
      throw Exception('Failed to load Item Menu');
    }
  }

  Future LocationsTracking() {
    Navigator.pushNamed(context, '/location_tracking');
  }

  Future<String> getHighestOrderItems() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String device_id = pref.getString("device_id");
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        Uri.https(website, 'api/get-highest-order-items/' + device_id),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var coverDataJson = jsonDecode(response.body);
      itemsratingData = coverDataJson['highestOrderItems'];
      itemsrating = coverDataJson['highestRating'];
      user_names = coverDataJson['user']['first_name'] +
          " " +
          coverDataJson['user']['last_name'];
      setState(() {
        isLoading = false;
        itemshighestorder = itemsratingData;
      });
    } else {
      itemshighestorder = [];
      isLoading = false;
      throw Exception('Failed to load Highest Order Items Mneu');
    }
  }

  // Future<String> getItemRating() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final response = await http.get(Uri.https(website, 'api/item-rating'),
  //       headers: {"Accept": "application/json"});
  //   if (response.statusCode == 200) {
  //     var coverDataJson = jsonDecode(response.body);
  //     itemsratingData = coverDataJson['highestRating'];
  //     setState(() {
  //       isLoading = false;
  //       itemsrating = itemsratingData;
  //       // print(itemsrating);
  //     });
  //   } else {
  //     itemsrating = [];
  //     isLoading = false;
  //     throw Exception('Failed to load Highest Order Items Mneu');
  //   }
  // }

  Future<String> getOrderStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String device_id = pref.getString("device_id");
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        Uri.https(website, 'api/get-order-status/' + device_id),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var coverDataJson = jsonDecode(response.body);
      orderStatusData = coverDataJson['order_status']['status'];
      setState(() {
        isLoading = false;
        OderStatus = orderStatusData;
      });
    } else {
      itemsrating = [];
      isLoading = false;
      throw Exception('Failed to load Order Tracking Status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: def_address.isNotEmpty
                        ? TextButton.icon(
                            label: Padding(
                              padding: const EdgeInsets.only(top: 1, right: 0),
                              child: Text(
                                def_address,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.pin_drop,
                              color: Colors.grey.shade400,
                              size: 19.0,
                            ),
                          )
                        : Text(""),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: user_names.isNotEmpty
                        ? TextButton.icon(
                            icon: Icon(
                              Icons.person,
                              color: Colors.grey.shade400,
                              size: 19.0,
                            ),
                            label: Padding(
                              padding: const EdgeInsets.only(top: 1, left: 0),
                              child: Text(
                                user_names,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          )
                        : Text(""),
                  ),
                ]),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: orderStatusData == 1
                  ? SizedBox(
                      height: 35,
                      width: MediaQuery.of(context).size.width,
                      child: TextButton.icon(
                        icon: Icon(
                          Icons.where_to_vote_outlined,
                          color: Color(0xfffe9721),
                          size: 25.0,
                        ),
                        label: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            "Where Is My Order ?",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(0xfffe9721),
                            ),
                          ),
                        ),
                        onPressed: () {
                          LocationsTracking();
                        },
                      ),
                    )
                  : Center(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/prevoius_order_page');
                        },
                        icon: Icon(
                          Icons.food_bank,
                          color: Color(0xfffe9721),
                          size: 35.0,
                        ),
                        label: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            "Previous Order",
                            style: TextStyle(
                              fontSize: 19,
                              color: Color(0xfffe9721),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 35,
            ),
            Container(
              child: promotion.isNotEmpty
                  ? CarouselSlider.builder(
                      itemCount: promotion.length,
                      options: CarouselOptions(
                        height: 180,
                        aspectRatio: 18 / 9,
                        viewportFraction: 0.8,
                        initialPage: 1,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 2),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                      itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.network(
                            "https://j14foods.com/promotions_image/${promotion[itemIndex]["image"]}",
                            height: 100,
                            width: 150,
                            fit: BoxFit.fill,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.25)),
                        );
                      },
                    )
                  : Text(""),
            ),
            SizedBox(
              height: 30,
            ),
            HomeTitle(text: "Highest Ordered Food"),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 210,
              child: ListView.builder(
                itemCount: itemshighestorder.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 16),
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          child: Image.network(
                            "https://j14foods.com/item_icon/${itemshighestorder[index]["item_icon"]}",
                            height: 120,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${itemshighestorder[index]["item_name"]}',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        (int.parse(itemshighestorder[index]["average"]
                                    .toString()) >
                                0)
                            ? Row(
                                children: <Widget>[
                                  (int.parse(itemshighestorder[index]["average"]
                                              .toString()) >
                                          0)
                                      ? Icon(
                                          Icons.star,
                                          size: 12,
                                          color: Colors.amber,
                                        )
                                      : Text(""),
                                  (int.parse(itemshighestorder[index]["average"]
                                              .toString()) >
                                          1)
                                      ? Icon(
                                          Icons.star,
                                          size: 12,
                                          color: Colors.amber,
                                        )
                                      : Text(""),
                                  (int.parse(itemshighestorder[index]["average"]
                                              .toString()) >
                                          2)
                                      ? Icon(
                                          Icons.star,
                                          size: 12,
                                          color: Colors.amber,
                                        )
                                      : Text(""),
                                  (int.parse(itemshighestorder[index]["average"]
                                              .toString()) >
                                          3)
                                      ? Icon(
                                          Icons.star,
                                          size: 12,
                                          color: Colors.amber,
                                        )
                                      : Text(""),
                                  (int.parse(itemshighestorder[index]["average"]
                                              .toString()) >
                                          4)
                                      ? Icon(
                                          Icons.star,
                                          size: 12,
                                          color: Colors.grey.shade400,
                                        )
                                      : Text(""),
                                ],
                              )
                            : Column(),
                        SizedBox(
                          height: 30,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                ItemDetailsPage.routeName,
                                arguments: ScreenArguments(
                                    '${itemshighestorder[index]["id"]}',
                                    '${itemshighestorder[index]["puk"]}'),
                              );
                            },
                            child: Text(
                              "Add To Cart",
                              style: TextStyle(color: colors),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            HomeTitle(text: "Top Rated Food"),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 200,
              child: ListView.builder(
                itemCount: itemsrating.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 16),
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var column = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        child: Image.network(
                          "https://j14foods.com/item_icon/${itemsrating[index]["item_icon"]}",
                          height: 80,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('${itemsrating[index]["item_name"]}',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(
                        height: 4,
                      ),
                      (int.parse(itemsrating[index]["Rating"].toString()) > 0)
                          ? Row(
                              children: <Widget>[
                                (int.parse(itemsrating[index]["Rating"]
                                            .toString()) >
                                        0)
                                    ? Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.amber,
                                      )
                                    : Text(""),
                                (int.parse(itemsrating[index]["Rating"]
                                            .toString()) >
                                        1)
                                    ? Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.amber,
                                      )
                                    : Text(""),
                                (int.parse(itemsrating[index]["Rating"]
                                            .toString()) >
                                        2)
                                    ? Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.amber,
                                      )
                                    : Text(""),
                                (int.parse(itemsrating[index]["Rating"]
                                            .toString()) >
                                        3)
                                    ? Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.amber,
                                      )
                                    : Text(""),
                                (int.parse(itemsrating[index]["Rating"]
                                            .toString()) >
                                        4)
                                    ? Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.grey.shade400,
                                      )
                                    : Text(""),
                              ],
                            )
                          : Column(),
                      SizedBox(
                        height: 30,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              ItemDetailsPage.routeName,
                              arguments: ScreenArguments(
                                  '${itemsrating[index]["id"]}',
                                  '${itemsrating[index]["puk"]}'),
                            );
                          },
                          child: Text(
                            "Add To Cart",
                            style: TextStyle(color: colors),
                          ),
                        ),
                      ),
                    ],
                  );
                  return Container(
                    padding: EdgeInsets.only(right: 16),
                    child: column,
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            HomeTitle(text: "Item Menu"),
            SizedBox(
              height: 16,
            ),
            ListView.builder(
              itemCount: itemsmenus.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.only(left: 16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          "https://j14foods.com/item_icon/${itemsmenus[index]["item_icon"]}",
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${itemsmenus[index]["item_name"]}',
                            style: TextStyle(
                                height: 1.3,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          (int.parse(itemsmenus[index]["average_rating"]
                                      .toString()) >
                                  0)
                              ? Row(
                                  children: <Widget>[
                                    (int.parse(itemsmenus[index]
                                                    ["average_rating"]
                                                .toString()) >
                                            0)
                                        ? Icon(
                                            Icons.star,
                                            size: 12,
                                            color: Colors.amber,
                                          )
                                        : Text(""),
                                    (int.parse(itemsmenus[index]
                                                    ["average_rating"]
                                                .toString()) >
                                            1)
                                        ? Icon(
                                            Icons.star,
                                            size: 12,
                                            color: Colors.amber,
                                          )
                                        : Text(""),
                                    (int.parse(itemsmenus[index]
                                                    ["average_rating"]
                                                .toString()) >
                                            2)
                                        ? Icon(
                                            Icons.star,
                                            size: 12,
                                            color: Colors.amber,
                                          )
                                        : Text(""),
                                    (int.parse(itemsmenus[index]
                                                    ["average_rating"]
                                                .toString()) >
                                            3)
                                        ? Icon(
                                            Icons.star,
                                            size: 12,
                                            color: Colors.amber,
                                          )
                                        : Text(""),
                                    (int.parse(itemsmenus[index]
                                                    ["average_rating"]
                                                .toString()) >
                                            4)
                                        ? Icon(
                                            Icons.star,
                                            size: 12,
                                            color: Colors.grey.shade400,
                                          )
                                        : Text(""),
                                  ],
                                )
                              : Column(),
                          SizedBox(
                            height: 30,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  ItemDetailsPage.routeName,
                                  arguments: ScreenArguments(
                                      '${itemsmenus[index]["id"]}',
                                      '${itemsmenus[index]["puk"]}'),
                                );
                              },
                              child: Text(
                                "Add To Cart",
                                style: TextStyle(color: colors),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
