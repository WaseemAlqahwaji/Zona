import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/order.dart';
import '../models/user.dart';
import 'order_details.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> orders = [];

  int selected = 0;
  var _future;

  @override
  void initState() {
    super.initState();
    _future = getOrders();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selected = 1;
                        });
                      },
                      child: Container(
                        width: 90,
                        decoration: BoxDecoration(
                            color: const Color(0xF908071D).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Center(child: Text(localization.history)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: FutureBuilder(
                  future: _future,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else {
                      if (orders.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/no_orders.png',
                                height: 120,
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              Text(
                                localization.noCreatedOrderYet +
                                    "\n" +
                                    localization.pleaseCreateSome,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: orders.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              if (orders.isEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Image.asset("assets/images/no_orders.png")),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Text(
                                      localization.noOrders,
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      localization.noOrderYet,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(176, 176, 176, 1),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    SizedBox(
                                      width: 239,
                                      height: 48,
                                      child: RawMaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)),
                                          fillColor: const Color.fromRGBO(41, 48, 60, 1),
                                          onPressed: () {},
                                          child: Text(localization.viewAllServices,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold))),
                                    ),
                                  ],
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 4,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    orders
                                                        .elementAt(0)
                                                        .name
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontFamily: 'Schyler'),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    showBarModalBottomSheet(
                                                        duration: const Duration(milliseconds: 300),
                                                        expand: true,
                                                        context: context,
                                                        elevation: 0,
                                                        builder: (context) => OrderDetails(
                                                              order: orders[index],
                                                            ));
                                                  },
                                                  child: const Icon(
                                                    IconlyBroken.info_square,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 30),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      orders
                                                          .elementAt(0)
                                                          .date
                                                          .toString()
                                                          .substring(0, 10),
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black.withOpacity(0.6),
                                                          fontStyle: FontStyle.italic,
                                                          fontSize: 14,
                                                          fontFamily: 'Schyler'),
                                                      overflow: TextOverflow.fade,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Divider(),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Builder(builder: (context) {
                                                    print(orders.elementAt(index).status);
                                                    if (orders.elementAt(index).status.toString() ==
                                                        "0") {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.amber,
                                                            borderRadius: BorderRadius.circular(8)),
                                                        child: Padding(
                                                            padding: const EdgeInsets.fromLTRB(
                                                                8, 4, 8, 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  localization.pending,
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
                                                                  Icons.pending,
                                                                  color: Colors.white,
                                                                )
                                                              ],
                                                            )),
                                                      );
                                                    } else if (orders
                                                            .elementAt(index)
                                                            .status
                                                            .toString() ==
                                                        "1") {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius: BorderRadius.circular(8)),
                                                        child: Padding(
                                                            padding: const EdgeInsets.fromLTRB(
                                                                8, 4, 8, 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  localization.inWay,
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
                                                                  Icons.arrow_right_alt,
                                                                  color: Colors.white,
                                                                )
                                                              ],
                                                            )),
                                                      );
                                                    } else {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius: BorderRadius.circular(8)),
                                                        child: Padding(
                                                            padding: const EdgeInsets.fromLTRB(
                                                                8, 4, 8, 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  localization.delivered,
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
                                                                  Icons.check,
                                                                  color: Colors.white,
                                                                )
                                                              ],
                                                            )),
                                                      );
                                                    }
                                                  }),
                                                  Container(
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(16),
                                                        color: Colors.white),
                                                    child: Builder(builder: (context) {
                                                      return Center(
                                                        child: Text(orders
                                                                .elementAt(0)
                                                                .totalPrice
                                                                .toString() +
                                                            localization.aED),
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      }
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getOrders() async {
    print("getOrders Called !");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = User();
    if (prefs.getString('user') != null) {
      user = User.fromJson(jsonDecode(prefs.getString('user').toString()));
    } else {
      if (prefs.getString('googleUsername') != null) {
        user.name = prefs.getString('googleUsername');
      } else {
        user.name = "John Doe";
      }
    }

    await http.post(Uri.parse('http://new.zona.ae/api/auth/my_orders'),
        body: {"username": user.name}).then((value) {
      print("getOrders return value=${value.body}");
      print("username:${user.name}");
      if (value.body.toString() != "0") {
        setState(() {
          Iterable l = jsonDecode(value.body);
          orders = List<Order>.from(l.map((model) => Order.fromJson(model)));
        });
      } else {
        setState(() {
          orders.clear();
        });
      }
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
