import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zona/models/order.dart';
import 'package:zona/models/service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zona/screens/ngenius_order.dart';
import '../models/user.dart';

class OrderDetails extends StatefulWidget {
  OrderDetails({Key? key, required this.order}) : super(key: key);
  Order order;

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  var _future;

  @override
  void initState() {
    _future = getService();
    super.initState();
  }

  Services service = Services();

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        appBar: null,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localization.orderDetails,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              widget.order.date.toString().substring(0, 10),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            String token = prefs.getString('token').toString();
                            http.post(Uri.parse('http://new.zona.ae/api/invoice/create-pdf'),
                                body: {
                                  "token": token,
                                  "id_order": widget.order.id.toString(),
                                }).then((value) {
                              final url = jsonDecode(value.body.toString());
                              launchUrl(Uri.parse(url['url']), mode: LaunchMode.externalApplication)
                                  .then((value) {
                                print(value);
                              }).onError((error, stackTrace) {
                                print('steve');
                              });
                            }).onError((error, stackTrace) {
                              print('error' + error.toString());
                            });
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                localization.viewBill,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text(localization.createdBy),
                    Text(
                      '' + widget.order.name.toString(),
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: _future,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return InkWell(
                        onTap: () {},
                        child: Card(
                          elevation: 4,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Builder(builder: (context) {
                                        if (service.image.toString() == "null") {
                                          return Container(
                                            height: 130,
                                            width: 130,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: Center(
                                                  child: Icon(Icons.room_service),
                                                )),
                                          );
                                        } else {
                                          return Container(
                                            height: 130,
                                            width: 130,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: Image.network(
                                                "http://new.zona.ae/" + service.image.toString(),
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                      Container(
                                        height: 130,
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: const [
                                                Icon(
                                                  Icons.star,
                                                  color: Color.fromRGBO(255, 197, 84, 1),
                                                ),
                                                Text(
                                                  '0',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color.fromRGBO(26, 29, 31, 1),
                                                  ),
                                                ),
                                                Text(
                                                  " (0)",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color.fromRGBO(111, 118, 126, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  service.name.toString(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(154, 159, 165, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                const Divider(),
                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width - 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            localization.time,
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Builder(builder: (context) {
                            return Text(
                              widget.order.time.toString(),
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            );
                          }),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            localization.status,
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Builder(builder: (context) {
                            print(widget.order.status);
                            if (widget.order.status.toString() == "0") {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.amber, borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          localization.pending,
                                          style: const TextStyle(
                                              fontFamily: 'Schyler',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        const Icon(
                                          Icons.pending,
                                          color: Colors.white,
                                        )
                                      ],
                                    )),
                              );
                            } else if (widget.order.status.toString() == "1") {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.black, borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          localization.inWay,
                                          style: const TextStyle(
                                              fontFamily: 'Schyler',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        const Icon(
                                          Icons.arrow_right_alt,
                                          color: Colors.white,
                                        )
                                      ],
                                    )),
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.green, borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          localization.delivered,
                                          style: const TextStyle(
                                              fontFamily: 'Schyler',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                      ],
                                    )),
                              );
                            }
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width - 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            localization.phone,
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            widget.order.phone.toString(),
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            localization.price,
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            widget.order.totalPrice.toString(),
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            localization.location,
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          InkWell(
                            onTap: () {
                              launchUrl(Uri.parse('https://maps.google.com/?q=' +
                                  widget.order.latitude.toString() +
                                  ',' +
                                  widget.order.longitude.toString() +
                                  ''));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black, borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        localization.openMap,
                                        style: TextStyle(
                                            fontFamily: 'Schyler',
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      const Icon(
                                        Icons.launch,
                                        color: Colors.white,
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                Row(
                  children: [
                    Text(
                      localization.notes,
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.order.notes.toString(),
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Pay Now
                    InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return NGeniusOrder();
                          }),
                        );
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            localization.payNow,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black,
                        ),
                      ),
                    ),

                    /// Cash on Delivery
                    InkWell(
                      onTap: () async {},
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            localization.cashOndelivery,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    http.post(Uri.parse('http://new.zona.ae/api/auth/one_service'),
        body: {"token": token, "id": widget.order.idservice.toString()}).then((value) {
      setState(() {
        service = Services.fromJson(jsonDecode(value.body)[0]);
      });
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }
}
