import 'package:flutter/material.dart';
import 'package:food_app/modules/add_cart_page.dart';
import 'package:food_app/modules/checkout.dart';
import 'modules/login_page.dart';
import 'modules/registration_page.dart';
import 'modules/order_page.dart';
import 'modules/main_page.dart';
import 'modules/add_cart_page.dart';
import 'modules/item_details_page.dart';
import 'modules/home_page.dart';
import 'modules/password_reset_request_page.dart';
import 'modules/password_reset_page.dart';
import 'modules/profile.dart';
import 'modules/change_password_page.dart';
import 'modules/add_address_profile.dart';
import 'modules/previous_order.dart';
import 'modules/order_details.dart';
import 'modules/customer_address_list.dart';
import 'modules/edit_address_page.dart';
import 'modules/address_search.dart';
import 'modules/locations_track.dart';
import 'modules/checkout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'J14 Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => Registration(),
        '/cart': (BuildContext context) => AddCardPage(),
        '/order': (BuildContext context) => OrderPage(),
        '/main_item_menu': (BuildContext context) => MainPage(),
        '/item_details': (BuildContext context) => ItemDetailsPage(),
        '/home_page': (BuildContext context) => HomePage(),
        '/password_reset_request_page': (BuildContext context) =>
            PasswordResetRequestPage(),
        '/password_reset_page': (BuildContext context) => PasswordResetPage(),
        '/profile_page': (BuildContext context) => ProfilePage(),
        '/change_password': (BuildContext context) => ChangePassword(),
        '/add_address_profile_page': (BuildContext context) =>
            AddAddressProfilePage(),
        '/prevoius_order_page': (BuildContext context) => PreviousOrderPage(),
        '/order_details': (BuildContext context) => OrderDetailsPage(),
        '/customer_adrress': (BuildContext context) => CustomerAddressPage(),
        '/address_edit': (BuildContext context) => AddressEditPage(),
        '/address_search': (BuildContext context) => AddressSearch(),
        '/location_tracking': (BuildContext context) => LocationsTracking(),
        '/checkout': (BuildContext context) => Checkout(),
        // ItemDetailsPage.routeName: (context) => ItemDetailsPage(),
        // OrderDetailsPage.routeName: (context) => OrderDetailsPage(),
        // AddressEditPage.routeName: (context) => AddressEditPage(),
      },
    );
  }

  // getUserToken() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String token = pref.getString("userToken");
  //   return token;
  // }

  // setUserToken() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.setString('userToken', value);
  // }
}
