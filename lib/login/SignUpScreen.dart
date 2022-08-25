import 'dart:math';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweet_snackbar/sweet_snackbar.dart';
import 'package:sweet_snackbar/top_snackbar.dart';
import 'package:zona/config/routing.dart';
import 'package:zona/screens/HomeScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/api_paths.dart';
import '../../constants/constant.dart';
import 'VerifyCodeScreen.dart';

class SignUpScreen extends StatefulWidget {
  //const SignUpScreen({Key? key}) : super(key: key);

  static String id = "sign-up";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String gender = 'Mr.';
  String? genderValueLocalized = null;
  bool loading = false;
  GlobalKey<FormState> key = GlobalKey();

  @override
  void dispose() {
    phoneController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            "assets/images/ZonaLogo.png",
            fit: BoxFit.contain,
            height: 100,
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  localization.signUp,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 24,
                ),
                Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.firstName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: firstNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return localization.pleaseEnterFirstName;
                          } else {
                            return null;
                          }
                        },
                        cursorColor: Colors.deepPurple,
                        keyboardType: TextInputType.text,
                        decoration: kTextFieldDecoration.copyWith(
                          prefixIconColor: Colors.red,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                            child: DropdownButton<String>(
                              value: genderValueLocalized ?? localization.mr,
                              dropdownColor: Colors.white,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              elevation: 16,
                              style:
                                  const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              underline: Container(
                                height: 2,
                                color: Colors.transparent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  genderValueLocalized = newValue!;
                                  gender = mapGenderLocalizedValue(genderValueLocalized);
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
                          hintText: localization.firstName,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        localization.lastName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: lastNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return localization.pleaseEnterLastName;
                          } else {
                            return null;
                          }
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: localization.lastName,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        localization.phoneNumber,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: phoneController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return localization.pleaseEnterPhoneNumber;
                          } else {
                            return null;
                          }
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          prefixIcon: CountryCodePicker(
                            onChanged: print,
                            initialSelection: 'AE',
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            enabled: false,
                          ),
                          hintText: localization.phoneNumber,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        localization.email,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: localization.email,
                        ),
                      ),
                      Text(
                        localization.password,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: localization.password,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 48.0,
                  width: 235.0,
                  color: Colors.white,
                  child: !loading
                      ? MaterialButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          height: 48.0,
                          minWidth: 35.0,
                          color: const Color(0xEFEFEFFF),
                          child: Text(
                            localization.signUp,
                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                          onPressed: () {
                            if (key.currentState!.validate()) {
                              //String code = generateCode();
                              setState(() {
                                loading = true;
                              });

                              http.post(Uri.parse(ApiPath.baseAuthUrl + "register"), body: {
                                "first_name": firstNameController.text,
                                "last_name": lastNameController.text,
                                "phone": "+971" + phoneController.text,
                                "email": emailController.text,
                                "password": passwordController.text,
                                "gender": gender,
                                'verified': '0'
                              }).then((value) async {
                                print(value.reasonPhrase);
                                if (value.reasonPhrase == 'OK') {
                                  setState(() {
                                    loading = false;
                                  });
                                  showTopSnackBar(
                                      context,
                                      const CustomSnackBar.success(
                                          message:
                                              'Account created, check your mail for verification code.'));
                                  Navigator.of(context).push(Routing()
                                      .createRoute(VerifyCodeScreen(email: emailController.text)));
                                } else if (value.reasonPhrase == "Bad Request") {
                                  showTopSnackBar(
                                      context,
                                      CustomSnackBar.error(
                                          message: localization.anotherAccountUsesThisEmail +
                                              '\n' +
                                              localization.pleaseTryAnotherOne));
                                  setState(() {
                                    loading = false;
                                  });
                                } else {
                                  showTopSnackBar(
                                      context,
                                      CustomSnackBar.error(
                                          message: localization.failedToCreateAccount +
                                              '\n' +
                                              localization.pleaseTryAgain));
                                }
                              }).onError((error, stackTrace) {
                                // showTopSnackBar(context, CustomSnackBar.error(message: 'Failed to create account\nplease try again later!'));
                                setState(() {
                                  loading = false;
                                });
                              });
                            }
                          },
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    localization.alreadyHaveAnAccount,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            localization.signIn,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          )))
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  String generateCode() {
    var rng = Random();
    var code = rng.nextInt(9000) + 1000;

    return code.toString();
  }
}

String mapGenderLocalizedValue(String? genderValueLocalized) {
  if (genderValueLocalized == "سيد" || genderValueLocalized == "Mr.") {
    return "Mr.";
  }
  return "Mrs.";
}
