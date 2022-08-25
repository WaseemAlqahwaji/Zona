import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zona/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController lastName = TextEditingController();

  String gender = '';

  @override
  void initState() {
    phoneNumber.text = widget.user.phone.toString();
    firstName.text = widget.user.firstName.toString();
    lastName.text = widget.user.lastName.toString();
    if (widget.user.gender.toString().toLowerCase() == 'male') {
      gender = 'Mr.';
    } else {
      gender = 'Mrs.';
    }

    // TODO: implement initState
    super.initState();
  }

  bool loading = false;
  GlobalKey<FormState> key = GlobalKey();
  String? genderValueLocalized = null;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Form(
          key: key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  localization.editProfile,
                  style: TextStyle(
                      fontFamily: 'Schyler',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const SizedBox(
                  height: 12,
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      localization.updateYourInformation,
                      style: TextStyle(
                          fontFamily: 'Schyler',
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 22,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                      controller: firstName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                            child: DropdownButton<String>(
                              value: genderValueLocalized ?? localization.mr,
                              dropdownColor: Colors.white,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              underline: Container(
                                height: 2,
                                color: Colors.transparent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  genderValueLocalized = newValue!;
                                  gender = mapGenderLocalizedValue(
                                      genderValueLocalized);
                                });
                              },
                              items: <String>[
                                localization.mr, localization.mrs,
                                // 'Mr.',
                                // 'Mrs.'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(left: 20),
                          fillColor: Colors.white,
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff2b2a2a), width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: localization.firstName,
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
                            controller: lastName,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20),
                                fillColor: Colors.white,
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.5),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff2b2a2a), width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: localization.lastName,
                                errorStyle:
                                    const TextStyle(fontFamily: 'Schyler'),
                                hintStyle: const TextStyle(
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
                        style: const TextStyle(
                            fontFamily: 'Schyler',
                            fontSize: 14.0,
                            height: 1.0,
                            color: Colors.black),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            prefixIcon: CountryCodePicker(
                              initialSelection: 'AE',
                              enabled: false,
                            ),
                            contentPadding: EdgeInsets.only(left: 20),
                            fillColor: Colors.white,
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff2b2a2a), width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: localization.mobileNumber,
                            errorStyle: TextStyle(fontFamily: 'Schyler'),
                            hintStyle: TextStyle(
                              fontFamily: 'Schyler',
                            )))),
                !loading
                    ? InkWell(
                        onTap: () async {
                          setState(() {
                            loading = true;
                          });
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          User user = User(
                              id: widget.user.id,
                              email: widget.user.email,
                              name: '',
                              firstName: firstName.text,
                              lastName: lastName.text,
                              gender: gender == "Mr." ? 'Male' : 'Female',
                              phone: phoneNumber.text,
                              profileImage: widget.user.profileImage,
                              verified: widget.user.verified,
                              emailVerifiedAt: widget.user.emailVerifiedAt,
                              createdAt: widget.user.createdAt,
                              dateOfBirth: widget.user.dateOfBirth,
                              updatedAt: widget.user.updatedAt,
                              verificationCodes: widget.user.verificationCodes);

                          prefs
                              .setString('user', jsonEncode(user))
                              .then((value) {
                            http.post(
                                Uri.parse(
                                    "http://new.zona.ae/api/auth/update_user"),
                                body: {
                                  'first_name': firstName.text,
                                  'last_name': lastName.text,
                                  'phone': phoneNumber.text,
                                  'gender': gender == "Mr." ? 'Male' : 'Female',
                                  'profile_image': widget.user.profileImage,
                                  'date_of_birth ': widget.user.dateOfBirth,
                                }).then((value) {
                              print("steve");

                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              Navigator.pop(context);
                              print(error);
                            });
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(26, 27, 45, 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  localization.save,
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

  String mapGenderLocalizedValue(String? genderValueLocalized) {
    if (genderValueLocalized == "سيد" || genderValueLocalized == "Mr.") {
      return "Mr.";
    }
    return "Mrs.";
  }
}
