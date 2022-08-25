// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zona/profile/ProfileScreen.dart';
import 'package:zona/screens/NotificationEmptyScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bookings/OrdersPage.dart';
import '../models/user.dart';
import '../profile/edit_profile.dart';
import 'dashboard.dart';

import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({Key? key}) : super(key: key);

  static String id = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user = User();

  int index = 0;
  int drawerIndex = 0;
  String? address = "";

  bool? _serviceEnabled;
  LocationPermission? permission;
  late var locationData;

  Future<void> getLocation() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled!) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    }

    locationData = await Geolocator.getCurrentPosition();

    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: locationData.latitude,
        longitude: locationData.longitude,
        googleMapApiKey: "AIzaSyCrq81n7DWxfPL_-Dmh8afFw6W0zl6sNm0");

    //Formated Address
    print(data.address);
    setState(() {
      address = data.address;
    });
    //City Name
    print(data.city);
    //Country Name
    print(data.country);
    //Country Code
    print(data.countryCode);
    //Latitude
    print(data.latitude);
    //Longitude
    print(data.longitude);
    //Postal Code
    print(data.postalCode);
    //State
    print(data.state);
    //Street Number
    print(data.street_number);
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          elevation: 2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            color: Color.fromRGBO(41, 48, 60, 1),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Builder(builder: (context) {
                                if (user.profileImage.toString() == 'null') {
                                  return Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                          BorderRadius.circular(22)),
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
                            title: FutureBuilder(
                              // future: getUser(),
                                builder: (context, snap) {
                                  print(user.firstName);
                                  return Text(
                                    user.firstName.toString() == 'null' ||
                                        user.lastName.toString() == 'null'
                                        ? localization.userName
                                        : user.firstName.toString() +
                                        " " +
                                        user.lastName.toString(),
                                    style:
                                    TextStyle(fontSize: 15, color: Colors.white),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.home,
                                    color: Color.fromRGBO(41, 48, 60, 1),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  localization.home,
                                  style: TextStyle(
                                      color: Color.fromRGBO(41, 48, 60, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.transparent),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.payment,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  localization.paymentMethods,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                index = 2;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              height: 48,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.transparent),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      IconlyLight.notification,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    localization.notifications,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.transparent),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.call_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  localization.support,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: double.infinity,
                              height: 48,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.transparent),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    "delete Account",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: index == 0
          ? AppBar(
              foregroundColor: Colors.black,
              elevation: 0,
              toolbarHeight: 60,
              backgroundColor: Colors.white,
              title: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.currentLocation,
                          style: TextStyle(color: Color.fromRGBO(99, 106, 117, 1), fontSize: 9),
                        ),
                        Text(
                          address!,
                          style: TextStyle(color: Color.fromRGBO(23, 43, 77, 1), fontSize: 13),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "BRONZE",
                    //           style: TextStyle(
                    //               color: Color.fromRGBO(244, 191, 75, 1), fontSize: 12),
                    //         ),
                    //         Text(
                    //           "0 POINTS",
                    //           style: TextStyle(
                    //               color: Color.fromRGBO(99, 106, 117, 1), fontSize: 10),
                    //         ),
                    //       ],
                    //     ),
                    //     Container(
                    //       height: 33,
                    //       child: Image.asset(
                    //         'assets/images/Badge.png',
                    //         fit: BoxFit.fitHeight,
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
            )
          : index == 1
              ? AppBar(
                  leadingWidth: 0,
                  elevation: 0,
                  backgroundColor: const Color(0xF9F9F9FF),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localization.iBookings,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                )
              : index == 2
                  ? AppBar(
                      elevation: 0,
                      leadingWidth: 0,
                      backgroundColor: const Color(0xF9F9F9FF),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            localization.iNotifications,
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 100,
                            height: 33,
                            child: RawMaterialButton(
                              //padding: EdgeInsets.symmetric(horizontal: 20),
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              fillColor: const Color(0xFFFFFFFF),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    localization.recent,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : AppBar(
                      elevation: 0,
                      leadingWidth: 0,
                      backgroundColor: const Color(0xF9F9F9FF),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            localization.iProfile,
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            child: RawMaterialButton(
                              //padding: EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              fillColor: const Color(0xFFFFFFFF),
                              onPressed: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                String token = prefs.getString('user').toString();
                                User user =
                                    User.fromJson(jsonDecode(prefs.getString('user').toString()));
                                showBarModalBottomSheet(
                                    duration: const Duration(milliseconds: 300),
                                    expand: true,
                                    context: context,
                                    elevation: 0,
                                    builder: (context) => EditProfile(
                                          user: user,
                                        ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      localization.editProfile,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
      body: index == 0 ? DashBoard() : index == 1 ? OrdersPage() : index == 2 ? NotificationEmptyScreen() : ProfileScreen(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40),
        child: GNav(
            onTabChange: (int index) {
              if (index == 0) {
                getLocation();
              }
            },
            selectedIndex: index,
            haptic: true,
            tabBorderRadius: 15,
            curve: Curves.easeOutExpo,
            duration: Duration(milliseconds: 500),
            gap: 8,
            color: Color.fromRGBO(111, 118, 126, 1),
            rippleColor: Color.fromRGBO(26, 27, 45, 1),
            activeColor: Color.fromRGBO(26, 27, 45, 1),
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            tabs: [
              GButton(
                  icon: Icons.home,
                  text: '',
                  onPressed: () {
                    setState(() {
                      index = 0;
                    });
                  }),
              GButton(
                  icon: Icons.article_rounded,
                  text: '',
                  onPressed: () {
                    setState(() {
                      index = 1;
                    });
                  }),
              GButton(
                  icon: IconlyLight.notification,
                  text: '',
                  onPressed: () {
                    setState(() {
                      index = 2;
                    });
                  }),
              GButton(
                  icon: Icons.person,
                  text: '',
                  curve: Curves.bounceIn,
                  backgroundColor: Colors.grey[200],
                  onPressed: () {
                    setState(() {
                      index = 3;
                    });
                  }),
            ]),
      ),
    );
  }
}
