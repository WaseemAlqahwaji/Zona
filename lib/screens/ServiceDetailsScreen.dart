// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zona/models/category.dart';
import 'package:zona/models/service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/provider.dart';
import '../models/service.dart';
import '../models/user.dart';
import 'create_order.dart';

class ServiceDetailsScreen extends StatefulWidget {
  Services service;
  Provider provider;

  String? categoryName;

  ServiceDetailsScreen({this.categoryName, required this.service, required this.provider});

  @override
  _ServiceDetailsScreenState createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  bool home = true, office = false, villa = false, billPressed = true, colorPressed = true;
  double selectedRate = 2.5;
  ValueNotifier<bool> New = ValueNotifier(false);

  ValueNotifier<bool> old = ValueNotifier(false);

  final String? baseURL = "http://new.zona.ae";
  @override
  void initState() {
    super.initState();
    print("categoryName\t${widget.categoryName}");
    print("Service\t${widget.service.name}");
    print("provider\t${widget.provider.name}");
  }

  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);
  Color screenPickerColor = Colors.blue;

  Color dialogSelectColor = const Color(0xFFA239CA);
  final Map<ColorSwatch<Object>, String> colorsNameMap = <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.blueAccent, //Color.formRGBO(249,249,249,1),
          child: Stack(
            children: [
              /// Service Image
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Image.network(
                  baseURL! + widget.service.image!,
                  fit: BoxFit.cover,
                ),
              ),

              /// Service Name
              Positioned(
                top: -60,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, bottom: 20, right: 20, top: 125),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.3),
                            ],
                            stops: [
                              0.0,
                              1.0
                            ])),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.service.name.toString(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                          SizedBox(
                            height: 12,
                          ),
                          Text(widget.service.address.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// Rating
              Positioned(
                child: SizedBox(
                  width: 70,
                  height: 35,
                  child: RawMaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    fillColor: Color.fromRGBO(251, 148, 80, 1),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              actions: [
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(localization.cancel),
                                    )),
                                InkWell(
                                  onTap: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String token = prefs.getString('token').toString();
                                    print(token);
                                    User user = User.fromJson(
                                        jsonDecode(prefs.getString('user').toString()));
                                    http.post(Uri.parse('http://new.zona.ae/api/auth/add_rate'),
                                        body: {
                                          'token': token,
                                          'iduser': int.parse(user.id.toString()).toString(),
                                          'idservice':
                                              int.parse(widget.service.id.toString()).toString(),
                                          'rate': selectedRate.toString()
                                        }).then((value) {
                                      print(value.body);
                                    }).onError((error, stackTrace) {
                                      print(error);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(localization.rate),
                                  ),
                                ),
                              ],
                              title: Text(localization.rateService),
                              content: RatingBar(
                                initialRating: selectedRate,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  half: const Icon(
                                    Icons.star_half,
                                    color: Colors.amber,
                                  ),
                                  empty: Icon(
                                    Icons.star,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    selectedRate = rating;
                                  });
                                },
                              ));
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                        Text(
                          "  " + widget.service.rate.toString(),
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
                top: 15,
                left: 100,
              ),

              /// Back Arrow
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.black,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                top: 7,
                left: 30,
              ),

              /// Service Details Selection
              Builder(builder: (context) {
                if (widget.categoryName == "Car Wash") {
                  return Positioned(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      width: width,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Column(
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
                                localization.typeOfProperty,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(26, 29, 31, 1),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    home = true;
                                    office = false;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      padding: EdgeInsets.all(14),
                                      decoration: !home
                                          ? BoxDecoration(
                                              border: Border.all(
                                                width: 2,
                                                color: Color.fromRGBO(209, 211, 212, 1),
                                              ),
                                              borderRadius: BorderRadius.circular(18),
                                              color: Colors.white)
                                          : BoxDecoration(
                                              borderRadius: BorderRadius.circular(18),
                                              color: Color.fromRGBO(41, 48, 60, 1),
                                            ),
                                      child: Icon(
                                        Icons.home_outlined,
                                        color: Color.fromRGBO(209, 211, 212, 1),
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      localization.atHome,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromRGBO(39, 43, 48, 1),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    home = false;

                                    office = true;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      padding: EdgeInsets.all(14),
                                      decoration: !office
                                          ? BoxDecoration(
                                              border: Border.all(
                                                width: 2,
                                                color: Color.fromRGBO(209, 211, 212, 1),
                                              ),
                                              borderRadius: BorderRadius.circular(18),
                                              color: Colors.white)
                                          : BoxDecoration(
                                              borderRadius: BorderRadius.circular(18),
                                              color: Color.fromRGBO(41, 48, 60, 1),
                                            ),
                                      child: Icon(
                                        Icons.villa_outlined,
                                        color: office ? Colors.white : Colors.grey,
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      localization.atSite,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromRGBO(39, 43, 48, 1),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    top: 219,
                    left: 20,
                    right: 20,
                  );
                } else if (widget.categoryName == "Cleaning") {
                  return Positioned(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      width: width,
                      height: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Column(
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
                                localization.typeOfProperty,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(26, 29, 31, 1),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    home = true;
                                    villa = false;
                                    office = false;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      padding: EdgeInsets.all(14),
                                      decoration: !home
                                          ? BoxDecoration(
                                              border: Border.all(
                                                width: 2,
                                                color: Color.fromRGBO(209, 211, 212, 1),
                                              ),
                                              borderRadius: BorderRadius.circular(18),
                                              color: Colors.white)
                                          : BoxDecoration(
                                              borderRadius: BorderRadius.circular(18),
                                              color: Color.fromRGBO(41, 48, 60, 1),
                                            ),
                                      child: Icon(
                                        Icons.home_outlined,
                                        color: Color.fromRGBO(209, 211, 212, 1),
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      localization.home,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromRGBO(39, 43, 48, 1),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    home = false;
                                    villa = false;
                                    office = true;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      padding: EdgeInsets.all(14),
                                      decoration: !office
                                          ? BoxDecoration(
                                              border: Border.all(
                                                width: 2,
                                                color: Color.fromRGBO(209, 211, 212, 1),
                                              ),
                                              borderRadius: BorderRadius.circular(18),
                                              color: Colors.white)
                                          : BoxDecoration(
                                              borderRadius: BorderRadius.circular(18),
                                              color: Color.fromRGBO(41, 48, 60, 1),
                                            ),
                                      child: Icon(
                                        Icons.villa_outlined,
                                        color: office ? Colors.white : Colors.grey,
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      localization.office,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromRGBO(39, 43, 48, 1),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    home = false;
                                    villa = true;
                                    office = false;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      padding: EdgeInsets.all(14),
                                      decoration: !villa
                                          ? BoxDecoration(
                                              border: Border.all(
                                                width: 2,
                                                color: Color.fromRGBO(209, 211, 212, 1),
                                              ),
                                              borderRadius: BorderRadius.circular(18),
                                              color: Colors.white)
                                          : BoxDecoration(
                                              borderRadius: BorderRadius.circular(18),
                                              color: Color.fromRGBO(41, 48, 60, 1),
                                            ),
                                      child: Icon(
                                        Icons.storefront_outlined,
                                        size: 30,
                                        color: Color.fromRGBO(209, 211, 212, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      localization.vila,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromRGBO(39, 43, 48, 1),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ValueListenableBuilder(
                                    builder: (BuildContext context, bool value, Widget? child) {
                                      return Checkbox(
                                        value: value,
                                        onChanged: (value) {
                                          old.value = value!;

                                          New.value = false;
                                        },
                                        activeColor: Colors.black,
                                        splashRadius: 12,
                                      );
                                    },
                                    valueListenable: old,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        old.value = !old.value;

                                        New.value = false;
                                      },
                                      child: Text(localization.old))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ValueListenableBuilder(
                                    builder: (BuildContext context, bool value, Widget? child) {
                                      return Checkbox(
                                        value: value,
                                        onChanged: (value) {
                                          New.value = value!;

                                          old.value = false;
                                        },
                                        activeColor: Colors.black,
                                        splashRadius: 12,
                                      );
                                    },
                                    valueListenable: New,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        New.value = !New.value;

                                        old.value = false;
                                      },
                                      child: Text(localization.newNew))
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    top: 170,
                    left: 20,
                    right: 20,
                  );
                } else {
                  return Container();
                }
              }),
              billPressed
                  ? Positioned(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          width: width,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      localization.serviceCost,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(26, 27, 45, 1),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.service.price.toString() + localization.aED,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(147, 152, 158, 1),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      localization.totalCost,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(26, 27, 45, 1),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.service.price.toString() + localization.aED,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(147, 152, 158, 1),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          )),
                      top: 450,
                      left: 20,
                      right: 20,
                    )
                  : Container(),
              Positioned(
                child: Container(
                  height: 200,
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Builder(builder: (context) {
                                if (widget.service.name == "Hair Coloring") {
                                  return Row(
                                    children: [
                                      ColorIndicator(
                                          width: 40,
                                          height: 40,
                                          borderRadius: 20,
                                          color: dialogSelectColor,
                                          elevation: 1,
                                          onSelectFocus: false,
                                          onSelect: () async {
                                            // Wait for the dialog to return color selection result.
                                            final Color newColor = await showColorPickerDialog(
                                              // The dialog needs a context, we pass it in.
                                              context,
                                              // We use the dialogSelectColor, as its starting color.
                                              dialogSelectColor,
                                              title: Text(localization.colorPicker,
                                                  style: Theme.of(context).textTheme.headline6),
                                              width: 60,
                                              height: 40,
                                              spacing: 0,
                                              runSpacing: 0,
                                              borderRadius: 0,
                                              wheelDiameter: 165,
                                              enableOpacity: true,
                                              showColorCode: true,
                                              colorCodeHasColor: true,
                                              pickersEnabled: <ColorPickerType, bool>{
                                                ColorPickerType.wheel: true,
                                              },
                                              copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                                                copyButton: false,
                                                pasteButton: false,
                                                longPressMenu: false,
                                              ),
                                              actionButtons: const ColorPickerActionButtons(
                                                okButton: true,
                                                closeButton: true,
                                                dialogActionButtons: false,
                                              ),
                                              constraints: const BoxConstraints(
                                                  minHeight: 480, minWidth: 320, maxWidth: 350),
                                            );

                                            setState(() {
                                              dialogSelectColor = newColor;
                                            });
                                          }),
                                      Text(
                                        '   '
                                        ' ${ColorTools.nameThatColor(dialogSelectColor)}',
                                      )
                                    ],
                                  );
                                } else {
                                  return Text('');
                                }
                              }),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    colorPressed = !colorPressed;
                                    billPressed = false;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    localization.totalAED,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(147, 152, 158, 1),
                                    ),
                                  ),
                                  Builder(builder: (context) {
                                    int total = int.parse(widget.service.price.toString());

                                    return Text(
                                      total.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(26, 29, 31, 1),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    billPressed = !billPressed;
                                    colorPressed = false;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      localization.billDetails,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(252, 148, 77, 1),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          billPressed = !billPressed;
                                          colorPressed = false;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_up),
                                      color: Color.fromRGBO(252, 148, 77, 1),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 48,
                              child: RawMaterialButton(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                fillColor: Color.fromRGBO(239, 239, 239, 1),
                                onPressed: () {},
                                child: Text(
                                  localization.saveDraft,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(26, 27, 45, 1),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 140,
                              height: 48,
                              child: RawMaterialButton(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                fillColor: Color.fromRGBO(26, 27, 45, 1),
                                onPressed: () {
                                  if (widget.service.isColor.toString() == "1") {
                                    showBarModalBottomSheet(
                                        duration: const Duration(milliseconds: 300),
                                        expand: true,
                                        context: context,
                                        elevation: 0,
                                        builder: (context) => CreateOrder(
                                            status: old.value
                                                ? "Old"
                                                : New.value
                                                    ? 'New'
                                                    : 'none',
                                            color: dialogSelectColor.hex,
                                            provider: widget.provider,
                                            service: widget.service,
                                            type: home ? "Home" : "At Site"));
                                  } else {
                                    showBarModalBottomSheet(
                                        duration: const Duration(milliseconds: 300),
                                        expand: true,
                                        context: context,
                                        elevation: 0,
                                        builder: (context) => CreateOrder(
                                            status: old.value
                                                ? "Old"
                                                : New.value
                                                    ? 'New'
                                                    : 'none',
                                            color: 'none',
                                            provider: widget.provider,
                                            service: widget.service,
                                            type: office
                                                ? "Office"
                                                : villa
                                                    ? "Villa"
                                                    : "Home"));
                                  }
                                },
                                child: Text(
                                  localization.bookNow,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                left: 0,
                right: 0,
                bottom: -40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
