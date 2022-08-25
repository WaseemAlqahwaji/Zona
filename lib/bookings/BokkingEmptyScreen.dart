// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../shared_components/Module.dart';

class BookingEmptyScreen extends StatefulWidget {
  //const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingEmptyScreen> createState() => _BookingEmptyScreenState();
}

class _BookingEmptyScreenState extends State<BookingEmptyScreen> {
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
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.amber,
                  ),
                  child: Container(
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
                            child: Container(
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
                  height: 600,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        child: Image.asset(
                          "assets/images/Upcoming.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        localization.noUpcomingOrders,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(26, 29, 31, 1)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        localization.currentlyNoUpcomingOrder,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(83, 87, 99, 1)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 170,
                        height: 48,
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          fillColor: Color.fromRGBO(26, 27, 45, 1),
                          onPressed: () {},
                          child: Text(
                            localization.viewAllServices,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
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
                  Container(
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
                            child: Container(
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
