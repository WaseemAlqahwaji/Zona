import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:sweet_snackbar/sweet_snackbar.dart';
import 'package:sweet_snackbar/top_snackbar.dart';
import 'package:zona/constants/api_paths.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zona/screens/HomeScreen.dart';

import '../../shared_components/colors.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({Key? key, required this.email}) : super(key: key);
  final String email;
  static String id = "verify-code";

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  int i = 1;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  getMobileFormWidget(context) {}

  getOtpFormWidget(BuildContext context) {}
  bool loading = false;
  Color color1 = Colors.grey;
  Color color2 = Colors.grey;
  Color color3 = Colors.grey;
  Color color4 = Colors.grey;

  var tec1 = TextEditingController();
  var tec2 = TextEditingController();
  var tec3 = TextEditingController();
  var tec4 = TextEditingController();

  int _start = 5;

  start() {
    setState(() {
      resent = true;
    });
    const oneSec = Duration(seconds: 1);
    Timer _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 1) {
          setState(() {
            resent = false;
            _start = 10;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    start();
    super.initState();
  }

  bool resent = true;
  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/images/ZonaLogo.png",
          height: 0100,
          fit: BoxFit.contain,
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
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Verification code",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 9,
              ),
              Text("We just send you a verify code to the email address '" +
                  widget.email +
                  localization.checkYourInbox),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        keyboardType: TextInputType.none,
                        controller: tec1,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        buildCounter: (BuildContext context,
                                {int? currentLength, int? maxLength, bool? isFocused}) =>
                            null,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          if (value != '') {
                            setState(() {
                              color1 = const Color(0xff9676FF);
                            });
                            FocusScope.of(context).nextFocus();
                          } else {
                            setState(() {
                              color1 = Colors.grey;
                            });
                          }
                        },
                        cursorColor: const Color(0xff9676FF),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xEFEFEFFF),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xEFEFEFFF)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xEFEFEFFF)),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xEFEFEFFF)),
                          ),
                          focusColor: color1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        keyboardType: TextInputType.none,
                        controller: tec2,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        buildCounter: (BuildContext context,
                                {int? currentLength, int? maxLength, bool? isFocused}) =>
                            null,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          if (value != '') {
                            setState(() {
                              color2 = const Color(0xff9676FF);
                            });
                            FocusScope.of(context).nextFocus();
                          } else {
                            setState(() {
                              color2 = Colors.grey;
                            });
                          }
                        },
                        cursorColor: const Color(0xff9676FF),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xEFEFEFFF),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xEFEFEFFF)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xEFEFEFFF)),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xEFEFEFFF)),
                          ),
                          focusColor: color2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        keyboardType: TextInputType.none,
                        controller: tec3,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        buildCounter: (BuildContext context,
                                {int? currentLength, int? maxLength, bool? isFocused}) =>
                            null,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          if (value != '') {
                            setState(() {
                              color3 = const Color(0xff9676FF);
                            });
                            FocusScope.of(context).nextFocus();
                          } else {
                            setState(() {
                              color3 = Colors.grey;
                            });
                          }
                        },
                        cursorColor: const Color(0xff9676FF),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xEFEFEFFF),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xEFEFEFFF)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xEFEFEFFF)),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xEFEFEFFF)),
                          ),
                          focusColor: color3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        keyboardType: TextInputType.none,
                        controller: tec4,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        buildCounter: (BuildContext context,
                                {int? currentLength, int? maxLength, bool? isFocused}) =>
                            null,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          if (value != '') {
                            setState(() {
                              color4 = const Color(0xff9676FF);
                            });
                            FocusScope.of(context).nextFocus();
                          } else {
                            setState(() {
                              color4 = Colors.grey;
                            });
                          }
                        },
                        cursorColor: const Color(0xff9676FF),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xEFEFEFFF),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xEFEFEFFF)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xEFEFEFFF)),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xEFEFEFFF)),
                          ),
                          focusColor: color4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              !loading
                  ? SizedBox(
                      width: 139,
                      height: 48,
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        fillColor: const Color(0xEFEFEFFF),
                        onPressed: () {
                          String enteredCode = tec1.text + tec2.text + tec3.text + tec4.text;

                          if (enteredCode.length < 4) {
                            showTopSnackBar(context,
                                CustomSnackBar.error(message: localization.pleaseFillUpAllFields));
                          } else {
                            setState(() {
                              loading = true;
                            });
                            http.post(Uri.parse(ApiPath.baseAuthUrl + "check_code"),
                                body: {"email": widget.email, "code": enteredCode}).then((value) {
                              final response = jsonDecode(value.body);

                              if (response['code'] == "1") {
                                setState(() {
                                  loading = false;
                                });
                                showTopSnackBar(context,
                                    CustomSnackBar.success(message: localization.emailVerified));
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  HomeScreen.id,
                                  (route) => false,
                                );
                              } else if (response['code'] == "-3") {
                                setState(() {
                                  loading = false;
                                });
                                showTopSnackBar(
                                    context, CustomSnackBar.error(message: localization.wrongOTP));
                              } else {
                                print(response['code']);
                                setState(() {
                                  loading = false;
                                });
                                showTopSnackBar(context,
                                    CustomSnackBar.error(message: localization.somethingWentWrong));
                              }
                            });
                          }
                        },
                        child: Text(localization.continueContinue),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !resent
                      ? TextButton(
                          onPressed: () async {
                            start();
                            http.post(Uri.parse(ApiPath.baseAuthUrl + "get_verification_code"),
                                body: {"email": widget.email}).then((value) async {
                              String code = value.body.replaceAll('"', '');
                            });
                          },
                          child: Text(
                            localization.resend,
                            style: TextStyle(
                                color: Colors_().primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ))
                      : Text(
                          localization.resendIn + _start.toString(),
                          style: const TextStyle(color: Colors.grey),
                        )
                ],
              ),
              NumericKeyboard(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                onKeyboardTap: _onKeyboardTap,
                textColor: Colors.black,
                rightButtonFn: () {
                  setState(() {
                    if (i == 2) {
                      setState(() {
                        tec1.clear();
                        color1 = Colors.grey;
                        i--;
                      });
                    } else if (i == 3) {
                      setState(() {
                        tec2.clear();
                        color2 = Colors.grey;
                        i--;
                      });
                    } else if (i == 4) {
                      setState(() {
                        tec3.clear();
                        color3 = Colors.grey;
                        i--;
                      });
                    } else if (i == 5) {
                      setState(() {
                        tec4.clear();
                        color4 = Colors.grey;
                        i--;
                      });
                    }

                    //text = text.substring(0, text.length - 1);
                  });
                },
                rightIcon: const Icon(
                  Icons.backspace,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onKeyboardTap(String value) {
    setState(() {});
    _numberChange(value);
  }

  _numberChange(String value) {
    if (i == 1) {
      setState(() {
        tec1.text = value;
        color1 = const Color(0xff9676FF);
        i++;
      });
    } else if (i == 2) {
      setState(() {
        tec2.text = value;
        color2 = const Color(0xff9676FF);
        i++;
      });
    } else if (i == 3) {
      setState(() {
        tec3.text = value;
        color3 = const Color(0xff9676FF);
        i++;
      });
    } else if (i == 4) {
      setState(() {
        tec4.text = value;
        color4 = const Color(0xff9676FF);
        i++;
      });
    }
  }
}
