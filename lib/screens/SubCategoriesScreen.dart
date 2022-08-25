// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zona/config/routing.dart';
import 'package:zona/models/provider.dart';
import 'package:zona/screens/provider_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/constant.dart';
import '../models/category.dart';

class CategoryProviders extends StatefulWidget {
  String? idCategory;
  String? categoryName;

  CategoryProviders({this.idCategory, this.categoryName});

  @override
  State<CategoryProviders> createState() => _CategoryProvidersState();
}

class _CategoryProvidersState extends State<CategoryProviders> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getproviders();
  }

  List<Provider> providers = [];
  String name = '';

  final String? baseURL = "http://new.zona.ae";

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
              hintText: localization.searchByNameLocation,
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
                          "  " + widget.categoryName! + ' Providers',
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
                    future: getproviders(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        return Expanded(
                            child: ListView.builder(
                          itemCount: providers.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (providers.elementAt(index).idcategory.toString() ==
                                widget.idCategory) {
                              if (providers.isEmpty) {
                                return Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              } else {
                                if (providers
                                        .elementAt(index)
                                        .firstName
                                        .toString()
                                        .toLowerCase()
                                        .contains(name.toLowerCase()) ||
                                    providers
                                        .elementAt(index)
                                        .location
                                        .toString()
                                        .toLowerCase()
                                        .contains(name.toLowerCase())) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(Routing().createRoute(ProviderServices(
                                        provider: providers.elementAt(index),
                                        categoryName: widget.categoryName!,
                                      )));
                                    },
                                    child: Card(
                                      elevation: 4,
                                      child: Column(
                                        children: [
                                          FittedBox(
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
                                                          baseURL! +
                                                              providers
                                                                  .elementAt(index)
                                                                  .profileImage
                                                                  .toString(),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 130,
                                                      padding: EdgeInsets.all(10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                color:
                                                                    Color.fromRGBO(255, 197, 84, 1),
                                                              ),
                                                              Text(
                                                                '0',
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w700,
                                                                  color:
                                                                      Color.fromRGBO(26, 29, 31, 1),
                                                                ),
                                                              ),
                                                              Text(
                                                                " (0)",
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w700,
                                                                  color: Color.fromRGBO(
                                                                      111, 118, 126, 1),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            (providers
                                                                                .elementAt(index)
                                                                                .firstName
                                                                                .toString() +
                                                                            " " +
                                                                            providers
                                                                                .elementAt(index)
                                                                                .lastName
                                                                                .toString())
                                                                        .length >
                                                                    12
                                                                ? (providers
                                                                                .elementAt(index)
                                                                                .firstName
                                                                                .toString() +
                                                                            " " +
                                                                            providers
                                                                                .elementAt(index)
                                                                                .lastName
                                                                                .toString())
                                                                        .substring(0, 10) +
                                                                    ".."
                                                                : (providers
                                                                        .elementAt(index)
                                                                        .firstName
                                                                        .toString() +
                                                                    " " +
                                                                    providers
                                                                        .elementAt(index)
                                                                        .lastName
                                                                        .toString()),
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w600,
                                                              color: Color.fromRGBO(26, 29, 31, 1),
                                                            ),
                                                          ),
                                                          // Row(
                                                          //   children: [
                                                          //     Text(
                                                          //       providers
                                                          //           .elementAt(
                                                          //               index)
                                                          //           .location
                                                          //           .toString().length>16?providers
                                                          //           .elementAt(
                                                          //           index)
                                                          //           .location
                                                          //           .toString().substring(0,14) + "...":providers
                                                          //           .elementAt(
                                                          //           index)
                                                          //           .location
                                                          //           .toString(),
                                                          //       style: TextStyle(
                                                          //         fontSize: 12,
                                                          //         fontWeight:
                                                          //             FontWeight
                                                          //                 .w500,
                                                          //         color: Color
                                                          //             .fromRGBO(
                                                          //                 154,
                                                          //                 159,
                                                          //                 165,
                                                          //                 1),
                                                          //       ),
                                                          //     ),
                                                          //   ],
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(14.0),
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    child: RawMaterialButton(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10)),
                                                      fillColor: Color.fromRGBO(41, 48, 60, 1),
                                                      onPressed: () {
                                                        launchUrl(Uri.parse('tel:' +
                                                            providers
                                                                .elementAt(index)
                                                                .phone
                                                                .toString()));
                                                      },
                                                      child: Icon(
                                                        Icons.call,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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

  Future<List<Provider>> getproviders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    http.post(Uri.parse('http://new.zona.ae/api/auth/provider_by_idcategory'),
        body: {"token": token, "idcategory": widget.idCategory}).then((value) {
      setState(() {
        Iterable l = jsonDecode(value.body);
        print("iterable:\t$l");
        providers = List<Provider>.from(l.map((model) => Provider.fromJson(model)));
        print("providers:\t$providers");
      });
    }).onError((error, stackTrace) {
      print(error.toString());
    });
    return providers;
  }
}
