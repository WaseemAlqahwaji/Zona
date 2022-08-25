// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zona/bookings/AllCategoriesScreen.dart';
import 'package:zona/screens/HomeScreen.dart';
import 'package:zona/screens/NotificationEmptyScreen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int index;
  savePref(int inIn) async {
    SharedPreferences Preferences = await SharedPreferences.getInstance();
    Preferences.setInt("index", inIn);
    setState(() {
      index = Preferences.getInt("index") ?? 0;
    });
  }

  getPref() async {
    SharedPreferences Preferences = await SharedPreferences.getInstance();

    setState(() {
      index = Preferences.getInt("index") ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40),
        child: GNav(
            selectedIndex: index,
            haptic: true, // haptic feedback
            tabBorderRadius: 15,
            // tabActiveBorder:
            //     Border.all(color: Colors.black, width: 0), // tab button border
            // tabBorder:
            //     Border.all(color: Colors.grey, width: 0), // tab button border
            curve: Curves.easeOutExpo, // tab animation curves
            duration: Duration(milliseconds: 500), // tab animation duration
            gap: 8, // the tab button gap between icon and text
            color: Color.fromRGBO(111, 118, 126, 1),
            rippleColor: Color.fromRGBO(26, 27, 45, 1), // unselected icon color
            activeColor: Color.fromRGBO(26, 27, 45, 1),
            iconSize: 24, // tab button icon size
            // tabBackgroundColor:
            //     Colors.purple.withOpacity(0.1), // selected tab background color
            padding: EdgeInsets.symmetric(
                horizontal: 10, vertical: 5), // navigation bar padding
            tabs: [
              GButton(
                  icon: Icons.home,
                  text: '',
                  onPressed: () {
                    setState(() {
                      savePref(0);
                    });
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }),
              GButton(
                  icon: Icons.article_rounded,
                  text: '',
                  onPressed: () {
                    setState(() {
                      savePref(0);
                    });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoriesScreen(categories: [],)));
                  }),
              GButton(
                  icon: Icons.notifications,
                  text: '',
                  onPressed: () {
                    setState(() async {
                      savePref(2);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationEmptyScreen()));
                    });
                  }),
              GButton(
                  icon: Icons.density_large,
                  text: '',
                  onPressed: () {
                    setState(() {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationEmptyScreen()));
                      savePref(3);
                    });
                  }),
            ]),
      ),
    );
  }
}
