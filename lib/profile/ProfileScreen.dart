// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, avuseroid_unnecessary_containers

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zona/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  //const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user = User();
  var _future;

  @override
  void initState() {
    super.initState();
    _future = getUser();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Scaffold(
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              return Container(
                color: Color(0xF9F9F9FF),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Builder(builder: (context) {
                              if (user.profileImage.toString() == 'null') {
                                return Container(
                                    height: 44,
                                    width: 44,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(22)),
                                    child: Icon(Icons.person));
                              } else {
                                return Container(
                                  width: 50,
                                  child: SvgPicture.network(
                                    user.profileImage.toString(),
                                  ),
                                );
                              }
                            }),
                          ),
                          title: Builder(builder: (context) {
                            if (user.lastName == null || user.firstName == null) {
                              return Text(
                                localization.fullName,
                                style: TextStyle(fontSize: 15),
                              );
                            } else {
                              return Text(
                                user.firstName.toString() == 'null' ||
                                        user.lastName.toString() == 'null'
                                    ? "Username"
                                    : user.firstName.toString() + " " + user.lastName.toString(),
                                style: TextStyle(fontSize: 15),
                              );
                            }
                          }),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            localization.phoneNumber,
                            //textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(vertical: 20.0),
                          //   child: Container(
                          //     padding: EdgeInsets.symmetric(vertical: 10.0),
                          //     width: double.infinity,
                          //     decoration: BoxDecoration(
                          //       color: Color(0xF5F5F5FF),
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //     child: Text(""),
                          //   ),
                          // ),
                          Container(
                            width: double.infinity,
                            height: 45,
                            padding: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(245, 245, 245, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.phone.toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            localization.email,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: double.infinity,
                            height: 45,
                            padding: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(245, 245, 245, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.email.toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            localization.gender,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: double.infinity,
                            height: 45,
                            padding: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(245, 245, 245, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.gender.toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // Text(
                          //   "Date of Birth",
                          //   style: TextStyle(
                          //       fontSize: 15, fontWeight: FontWeight.bold),
                          // ),
                          // SizedBox(
                          //   height: 8,
                          // ),
                          // Container(
                          //   width: double.infinity,
                          //   height: 45,
                          //   padding: EdgeInsets.only(left: 20),
                          //   decoration: BoxDecoration(
                          //     color: Color.fromRGBO(245, 245, 245, 1),
                          //     borderRadius: BorderRadius.circular(8),
                          //   ),
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text(
                          //         "Not Set",
                          //         textAlign: TextAlign.start,
                          //         style: TextStyle(
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.w600,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ],
                  )
                ],
              );
            }
          }),
    );
  }

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('user'));
    String userString = prefs.getString('user').toString();
    setState(() {
      user = User.fromJson(jsonDecode(userString));
    });
  }
}
