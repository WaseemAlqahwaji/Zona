import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweet_snackbar/sweet_snackbar.dart';
import 'package:sweet_snackbar/top_snackbar.dart';
import 'package:zona/bookings/order_details.dart';
import 'package:zona/constants/api_paths.dart';
import 'package:zona/models/order.dart';
import 'package:zona/screens/select_map_location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/provider.dart';
import '../models/service.dart';
import '../models/user.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder(
      {Key? key,
      required this.service,
      required this.status,
      required this.type,
      required this.provider,
      required this.color})
      : super(key: key);
  final String type;
  final Services service;
  final Provider provider;
  final String color;
  final String status;

  @override
  _BookVenueState createState() => _BookVenueState();
}

class _BookVenueState extends State<CreateOrder> {
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController address = TextEditingController();
  DateTime selectedDate = DateTime.now();

  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  bool loading = false;
  Map<String, dynamic> data = {};
  @override
  void dispose() {
    location.dispose();
    phoneNumber.dispose();
    notesController.dispose();
    address.dispose();
    date.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (timeOfDay != null) {
      setState(() {
        startTime = timeOfDay;
        startTimeController.text = "${startTime.hour}:${startTime.minute} ${startTime.period.name}";
      });
    }
  }

  GlobalKey<FormState> key = GlobalKey();

  @override
  void initState() {
    super.initState();
    phoneNumber.text = "+971";
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Form(
            key: key,
            child: Column(
              children: [
                Text(
                  localization.createOrder,
                  style: const TextStyle(
                      fontFamily: 'Schyler', fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.service.name.toString(),
                        style: const TextStyle(
                            fontFamily: 'Schyler', fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (int.parse(widget.service.price.toString())).toString() +
                              localization.aED,
                          style: const TextStyle(
                              fontFamily: 'Schyler',
                              fontSize: 16,
                              color: Color.fromRGBO(252, 148, 77, 1),
                              fontWeight: FontWeight.bold),
                        ),
                        Builder(builder: (context) {
                          if (widget.status == 'none') {
                            return Text(
                              "At " + widget.type,
                              style: const TextStyle(
                                  fontFamily: 'Schyler', fontSize: 16, fontWeight: FontWeight.bold),
                            );
                          } else {
                            return Text(
                              widget.status + " " + widget.type,
                              style: const TextStyle(
                                  fontFamily: 'Schyler', fontSize: 16, fontWeight: FontWeight.bold),
                            );
                          }
                        }),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.service.address.toString(),
                      style: const TextStyle(
                          fontFamily: 'Schyler', fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      localization.pleaseProvideOrderInformation,
                      style: const TextStyle(
                          fontFamily: 'Schyler', fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 22,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                      validator: (value) {
                        DateTime date = DateTime.parse(value.toString());
                        if (value!.isEmpty) {
                          return localization.pleaseSelectADate;
                        } else if (date.isBefore(DateTime.now())) {
                          return localization.pleaseSelectValidDate;
                        } else {
                          return null;
                        }
                      },
                      readOnly: true,
                      onTap: () async {
                        await _selectDate(context);
                        date.text = "${selectedDate.toLocal()}".split(' ')[0];
                      },
                      controller: date,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20),
                          fillColor: Colors.white,
                          disabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 0.5),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff2b2a2a), width: 0.5),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          hintText: localization.selectDate,
                          suffixIcon: const Icon(Icons.calendar_today),
                          errorStyle: const TextStyle(fontFamily: 'Schyler'),
                          hintStyle: const TextStyle(
                            fontFamily: 'Schyler',
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return localization.fieldRequired;
                              } else {
                                return null;
                              }
                            },
                            readOnly: true,
                            onTap: () async {
                              _selectStartTime(context);
                            },
                            controller: startTimeController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.timelapse_rounded),
                                contentPadding: EdgeInsets.only(left: 20),
                                fillColor: Colors.white,
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.5),
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff2b2a2a), width: 0.5),
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                hintText: localization.selectTime,
                                errorStyle: TextStyle(fontFamily: 'Schyler'),
                                hintStyle: TextStyle(
                                  fontFamily: 'Schyler',
                                ))),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return localization.pleaseAddMobileNumber;
                          } else {
                            return null;
                          }
                        },
                        controller: phoneNumber,
                        obscureText: false,
                        maxLength: 13,
                        style: const TextStyle(
                            fontFamily: 'Schyler',
                            fontSize: 14.0,
                            height: 1.0,
                            color: Colors.black),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            fillColor: Colors.white,
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff2b2a2a), width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            hintText: localization.mobileNumber,
                            errorStyle: TextStyle(fontFamily: 'Schyler'),
                            hintStyle: TextStyle(
                              fontFamily: 'Schyler',
                            )))),
                Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return localization.pleaseSetLocation;
                          } else {
                            return null;
                          }
                        },
                        readOnly: true,
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (c) => SelectMapLocation()))
                              .then((value) {
                            setState(() {
                              location.text = localization.locationSet;
                              data = value;
                            });
                          });
                        },
                        controller: location,
                        obscureText: false,
                        style: const TextStyle(
                            fontFamily: 'Schyler',
                            fontSize: 14.0,
                            height: 1.0,
                            color: Colors.black),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            suffixIcon: data.isEmpty
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.transparent,
                                  )
                                : Icon(
                                    Icons.check_circle,
                                    color: Colors.black,
                                  ),
                            contentPadding: EdgeInsets.only(left: 20),
                            fillColor: Colors.white,
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff2b2a2a), width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            hintText: localization.mapLocation,
                            errorStyle: TextStyle(fontFamily: 'Schyler'),
                            hintStyle: TextStyle(
                              fontFamily: 'Schyler',
                            ))),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return localization.pleaseAddAddress;
                        } else {
                          return null;
                        }
                      },
                      controller: address,
                      obscureText: false,
                      style: const TextStyle(
                          fontFamily: 'Schyler', fontSize: 14.0, height: 1.0, color: Colors.black),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20),
                          fillColor: Colors.white,
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.5),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff2b2a2a), width: 0.5),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          hintText: localization.fullAddress,
                          errorStyle: TextStyle(fontFamily: 'Schyler'),
                          hintStyle: TextStyle(
                            fontFamily: 'Schyler',
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: notesController,
                      obscureText: false,
                      style: const TextStyle(
                          fontFamily: 'Schyler', fontSize: 14.0, height: 1.0, color: Colors.black),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return localization.pleaseAddADescription;
                        } else {
                          return null;
                        }
                      },
                      scrollPadding: const EdgeInsets.all(22),
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          alignLabelWithHint: true,
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff2b2a2a), width: 0.5),
                              borderRadius: BorderRadius.all(Radius.circular(16))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.all(Radius.circular(16))),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff2b2a2a), width: 0.5),
                              borderRadius: BorderRadius.all(Radius.circular(16))),
                          hintText: localization.writeYourNotesHere,
                          hintStyle: TextStyle(
                            fontFamily: 'Schyler',
                          ),
                          errorStyle: TextStyle(
                            fontFamily: 'Schyler',
                          ))),
                ),
                !loading
                    ? InkWell(
                        onTap: () async {
                          if (key.currentState!.validate()) {
                            print('steve');
                            setState(() {
                              loading = true;
                            });
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            String token = prefs.getString('token').toString();

                            User user = User();
                            if(prefs.getString('user') != null) {
                              user =
                                User.fromJson(jsonDecode(prefs.getString('user').toString()));
                            } else {
                              if(prefs.getString('googleUsername') != null) {
                                user.name = prefs.getString('googleUsername');
                              } else {
                                user.name = "John Doe";
                              }
                            }

                            http.post(Uri.parse(ApiPath.baseAuthUrl + "add_order"), body: {
                              'token': token,
                              'idservice': widget.service.id.toString(),
                              'username': user.firstName.toString() + " " + user.lastName.toString(),
                              'idprovider': widget.provider.id.toString(),
                              'order_number': generateCode(),
                              'date': selectedDate.toString(),
                              'time': startTimeController.text,
                              'address': address.text,
                              'name': user.firstName.toString() + " " + user.lastName.toString(),
                              'phone': phoneNumber.text,
                              'notes': notesController.text,
                              'total_price':
                                  (double.parse(widget.service.price.toString())).toString(),
                              "color": widget.color.toString(),
                              "longitude": data['long'].toString(),
                              "latitude": data['lat'].toString()
                            }).then((value) {
                              print('after order create' + value.body);
                              setState(() {
                                loading = false;
                              });
                              if (value.body.toString().contains('Too Many Requests')) {
                                showTopSnackBar(
                                    context,
                                    CustomSnackBar.error(
                                      message: localization.serverDidNotRespond,
                                      backgroundColor: Colors.black,
                                    ));
                              } else {
                                setState(() {
                                  loading = false;
                                });

                                showTopSnackBar(
                                    context,
                                    CustomSnackBar.success(
                                      message: localization.orderCreatedSuccessfully,
                                      backgroundColor: Colors.black,
                                    ));

                                Order returnedOrder = Order.fromJson(jsonDecode(value.body));

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (BuildContext context) {
                                    return OrderDetails(order: returnedOrder);
                                  }),
                                );
                              }
                            }).onError((error, stackTrace) {
                              print(error);
                              setState(() {
                                loading = false;
                              });
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(26, 27, 45, 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  localization.createOrder,
                                  style: TextStyle(
                                      fontFamily: 'Schyler',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const CircularProgressIndicator()
              ],
            ),
          ),
        ),
      ),
    );
  }

  String generateCode() {
    var rng = Random();
    var code = rng.nextInt(90000000) + 10000000;

    return code.toString();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1800, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      if (picked.isBefore(DateTime.now())) {
      } else {
        setState(() {
          selectedDate = picked;
        });
      }
    }
  }
}
