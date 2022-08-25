// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zona/config/routing.dart';
import 'package:zona/models/provider.dart';
import 'package:zona/models/service.dart';
import 'package:zona/screens/ServiceDetailsScreen.dart';
import 'package:zona/screens/provider_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/constant.dart';
import '../models/category.dart';

class ProviderServices extends StatefulWidget {
  ProviderServices({Key? key, required this.provider, required this.categoryName})
      : super(key: key);

  static String id = "provider-services";

  final Provider provider;
  String categoryName;
  @override
  State<ProviderServices> createState() => _ProviderServicesState();
}

class _ProviderServicesState extends State<ProviderServices> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getServices();
  }

  List<Services> services = [];
  String name = '';

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Color.fromRGBO(26, 27, 45, 1),
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          obscureText: false,
          keyboardType: TextInputType.text,
          onChanged: (val) {
            setState(() {
              name = val;
            });
          },
          decoration: kTextFieldDecoration.copyWith(
              suffixIcon: Icon(
                Icons.search_rounded,
                color: Color.fromRGBO(26, 27, 45, 1),
              ),
              hintText: localization.searchByNamePrice,
              hintStyle: TextStyle()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            height: 900,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          localization.i,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(202, 189, 255, 1),
                          ),
                        ),
                        Text(
                          "  " +
                              (widget.provider.firstName.toString() +
                                  " " +
                                  widget.provider.lastName.toString()) +
                              ' Services',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(26, 29, 31, 1),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: getServices(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        return Expanded(
                            child: ListView.builder(
                          itemCount: services.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (services.elementAt(index).idcategory.toString() ==
                                widget.provider.id.toString()) {
                              if (services.isEmpty) {
                                return Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              } else {
                                if (services
                                        .elementAt(index)
                                        .name
                                        .toString()
                                        .toLowerCase()
                                        .contains(name.toLowerCase()) ||
                                    services
                                        .elementAt(index)
                                        .price
                                        .toString()
                                        .toLowerCase()
                                        .contains(name.toLowerCase())) {
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(Routing().createRoute(ServiceDetailsScreen(
                                            service: services.elementAt(index),
                                            categoryName: widget.categoryName,
                                            provider: widget.provider,
                                          )));
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 130,
                                                  width: 130,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: Image.network(
                                                      services.elementAt(index).image.toString(),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 130,
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceEvenly,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: Color.fromRGBO(255, 197, 84, 1),
                                                          ),
                                                          Text(
                                                            services
                                                                .elementAt(index)
                                                                .rate
                                                                .toString(),
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
                                                              color:
                                                                  Color.fromRGBO(111, 118, 126, 1),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        services
                                                                    .elementAt(index)
                                                                    .name
                                                                    .toString()
                                                                    .length >
                                                                14
                                                            ? services
                                                                    .elementAt(index)
                                                                    .name
                                                                    .toString()
                                                                    .substring(0, 12) +
                                                                '..'
                                                            : services
                                                                .elementAt(index)
                                                                .name
                                                                .toString(),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          color: Color.fromRGBO(26, 29, 31, 1),
                                                        ),
                                                      ),
                                                      Text(
                                                        localization.startsFrom,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color.fromRGBO(154, 159, 165, 1),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 50,
                                                        height: 30,
                                                        child: RawMaterialButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(10)),
                                                          fillColor:
                                                              Color.fromRGBO(181, 228, 202, 1),
                                                          onPressed: () {},
                                                          child: Text(
                                                            localization.aED +
                                                                services
                                                                    .elementAt(index)
                                                                    .price
                                                                    .toString(),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color: Color.fromRGBO(26, 29, 31, 1),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10, top: 10),
                                              child: IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.workspaces),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Divider(
                                        thickness: 2,
                                      )
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              }
                            } else {
                              return Container();
                            }
                          },
                        ));
                      } else {
                        return Center(child: CircularProgressIndicator.adaptive());
                      }
                    })
              ],
            )),
      ),
    );
  }

  Future<List<Services>> getServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    http.post(Uri.parse('http://new.zona.ae/api/auth/provider_services'),
        body: {"token": token, "idprovider": widget.provider.id.toString()}).then((value) {
      setState(() {
        Iterable l = jsonDecode(value.body);
        services = List<Services>.from(l.map((model) => Services.fromJson(model)));
      });
    }).onError((error, stackTrace) {});
    return services;
  }
}
