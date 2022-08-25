// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../shared_components/Module.dart';

class BookingScreen extends StatefulWidget {
  //const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedIndex = 0;
  final List<String> categories = [
    'Upcoming',
    'History',
    'Draft',
  ];

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    var size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    if (selectedIndex == 0)
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(249, 249, 249, 1),
          title: Text(
            localization.iBookings,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(26, 27, 45, 1),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    //color: Colors.white,
                    height: 90.0,
                    width: width,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            child: SizedBox(
                              width: 90,
                              height: 50,
                              child: RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                fillColor: selectedIndex == index
                                    ? Color.fromRGBO(8, 7, 29, 0.2)
                                    : Colors.white,
                                onPressed: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Text(
                                  categories[index],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: selectedIndex == index
                                          ? Color.fromRGBO(26, 27, 45, 1)
                                          : Color.fromRGBO(83, 87, 99, 1)),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: 320,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          width: 60,
                          height: 60,
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color.fromRGBO(255, 188, 153, 1)),
                          child: Image.asset(
                            "assets/images/AC.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        title: Text(
                          localization.acInstallation,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          localization.referenceCodeD571224,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black, //Color.fromRGBO(239, 239, 239, 1),
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            localization.status,
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            width: 90,
                            height: 30,
                            child: RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              fillColor: Color.fromRGBO(236, 248, 241, 1),
                              onPressed: () {},
                              child: Text(
                                localization.confirmed,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(127, 192, 156, 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Container(
                          width: 60,
                          height: 60,
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: Color.fromRGBO(239, 239, 239, 1),
                            ),
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.transparent,
                          ),
                          child: Image.asset(
                            "assets/images/Schedule.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        title: Text(
                          localization.customDateTime,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          localization.schedule,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: ListTile(
                              leading: Container(
                                width: 60,
                                height: 60,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                    color: Color.fromRGBO(239, 239, 239, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.transparent,
                                ),
                                child: Image.asset(
                                  "assets/images/Westinghouse.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              title: Text(
                                localization.westinghouse,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                localization.serviceProvider,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            height: 40,
                            child: RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fillColor: Color.fromRGBO(26, 27, 45, 1),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    localization.call,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: 320,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          width: 60,
                          height: 60,
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color.fromRGBO(202, 189, 255, 1),
                          ),
                          child: Image.asset(
                            "assets/images/Beauty.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        title: Text(
                          localization.multiMaskFacial,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          localization.referenceCodeD571224,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.black, //Color.fromRGBO(239, 239, 239, 1),
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            localization.status,
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            width: 90,
                            height: 30,
                            child: RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              fillColor: Color.fromRGBO(231, 183, 151, 1.0),
                              onPressed: () {},
                              child: Text(
                                localization.pending,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(235, 131, 60, 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Container(
                          width: 60,
                          height: 60,
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: Color.fromRGBO(239, 239, 239, 1),
                            ),
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.transparent,
                          ),
                          child: Image.asset(
                            "assets/images/Schedule.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        title: Text(
                          localization.customDateTime,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          localization.schedule,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: ListTile(
                              leading: Container(
                                width: 60,
                                height: 60,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                    color: Color.fromRGBO(239, 239, 239, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.transparent,
                                ),
                                child: Image.asset(
                                  "assets/images/Sindenayu.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              title: Text(
                                localization.sindenayu,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                localization.serviceProvider,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            height: 40,
                            child: RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fillColor: Color.fromRGBO(26, 27, 45, 1),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    localization.call,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      );
    else if (selectedIndex == 1)
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(249, 249, 249, 1),
          title: Text(
            localization.iBookings,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(26, 27, 45, 1),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(
                    //color: Colors.white,
                    height: 90.0,
                    width: width,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            child: SizedBox(
                              width: 90,
                              height: 50,
                              child: RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                fillColor: selectedIndex == index
                                    ? Color.fromRGBO(8, 7, 29, 0.2)
                                    : Colors.white,
                                onPressed: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Text(
                                  categories[index],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: selectedIndex == index
                                          ? Color.fromRGBO(26, 27, 45, 1)
                                          : Color.fromRGBO(83, 87, 99, 1)),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      );
    else
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(249, 249, 249, 1),
          title: Text(
            localization.iBookings,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(26, 27, 45, 1),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: 90.0,
                    width: width,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            child: Container(
                              color: Colors.white,
                              width: 90,
                              height: 50,
                              child: RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                fillColor: selectedIndex == index
                                    ? Color.fromRGBO(8, 7, 29, 0.2)
                                    : Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Text(
                                  categories[index],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: selectedIndex == index
                                          ? Color.fromRGBO(26, 27, 45, 1)
                                          : Color.fromRGBO(83, 87, 99, 1)),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      );
  }
}
