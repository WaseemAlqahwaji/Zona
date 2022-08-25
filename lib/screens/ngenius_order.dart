import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zona/models/PaymentSharedClass.dart';
import 'package:zona/screens/HomeScreen.dart';
import 'package:zona/services/NGenuisPayment.dart';
import 'package:zona/models/NGeniusPaymentModel.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NGeniusOrder extends StatefulWidget {
  @override
  _NGeniusOrderState createState() => _NGeniusOrderState();
}

class _NGeniusOrderState extends State<NGeniusOrder> {
  var _future;
  String? accessToken;
  Map<String, dynamic> requestBody = {};
  NGeniusPaymentModel returnData = NGeniusPaymentModel();
  String? initialURL = "";
  Color primary = Color(0xff41d9a5);

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    _future = NGenuisPaymentService.getAccessToken().then((value) {
      setState(() {
        accessToken = value;
        PaymentSharedClass.accessToken = value;
      });

      requestBody["action"] = "PURCHASE";
      requestBody["amount"] = {"currencyCode": "AED", "value": 1};

      ///******************************************************************
      _future = null;

      _future = NGenuisPaymentService.createOrder(requestBody: requestBody).then((value) {
        setState(() {
          returnData = value;
          requestBody = {};

          initialURL = returnData.links;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (Platform.isAndroid)
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.blue,
                          ))
                        : CupertinoActivityIndicator(
                            radius: 20.0,
                          ),
                    Text(
                      localization.paymentLoadingMsg,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: WebView(
                        initialUrl: initialURL,
                        javascriptMode: JavascriptMode.unrestricted,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20.0)),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) { return HomeScreen(); }),
                                (route) => false);
                      },
                      child: Container(
                        child: Center(
                          child: Text(
                            localization.homePage,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25), color: Colors.black),
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 50,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20.0)),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
