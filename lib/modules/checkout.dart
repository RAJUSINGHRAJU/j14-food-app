import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  handlerPaymentSuccess(response) {
    Navigator.pop(context, "success");
    print(response);
  }

  handlerErrorFailure(response) {
    Navigator.pop(context, "failed");
    print(response);
  }

  handlerExternalWallet(response) {
    Navigator.pop(context, "failed");
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();
    this.checkout();
  }

  void checkout() {
    var _razorpay = new Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
    var options = {
      "key": "rzp_test_q3eRr4ajk8WWot",
      "amount": 10000,
      "name": "J14 Delivery Food",
      "description": "Food Order",
      "prefill": {
        "contact": "0000000000",
        "email": "rs476995@gmail.com",
      },
      "external": {
        "wallet": ["paytm"]
      }
    };
    _razorpay.open(options);
  }
}
