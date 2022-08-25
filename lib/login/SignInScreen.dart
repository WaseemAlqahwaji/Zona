import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweet_snackbar/sweet_snackbar.dart';
import 'package:sweet_snackbar/top_snackbar.dart';
import 'package:zona/Provider/google_sign_in.dart';
import 'package:zona/config/routing.dart';
import 'package:zona/constants/api_paths.dart';
import 'package:zona/models/login_response.dart';
import 'package:zona/screens/HomeScreen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:zona/src/features/view/screens/signin_signup_screens/signup_screen.dart';
import 'package:zona/utils/responsive_widget.dart';

import '../../../../../constants/constant.dart';
import '../src/utils/colors.dart';
import '../utils/app_components.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static String id = "sign-in";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(localization.somethingWentWrong),
          );
        } else if (snapshot.hasData) {
          showTopSnackBar(
            context,
            CustomSnackBar.success(
                message: localization.loggedSuccessfully,
                backgroundColor: Colors.black),
          );

          return HomeScreen();
        } else {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveWidget.getScreenWidth(context) * 0.03,
                    ),
                    child: Form(
                      key: key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.0575,
                          ),
                          Image.asset(
                            "assets/images/ZonaLogo.png",
                            fit: BoxFit.contain,
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.15,
                            //  width: Responsive.getScreenWidth(context)*0.1,
                          ),
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.0575,
                          ),
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.08, //33
                            child: Text(
                              localization.signIn,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                          ), //33
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.07,
                            child: Text(
                              localization.emailAddress,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ), //40
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.08,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return localization.pleaseEnterEmail;
                                } else {
                                  return null;
                                }
                              },
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: localization.email,
                              ),
                            ),
                          ), //48
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.015, //50
                          ), //50
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.08,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return localization.pleaseEnterPassword;
                                } else {
                                  return null;
                                }
                              },
                              obscureText: true,
                              controller: passwordController,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: localization.password,
                              ),
                            ),
                          ), //58-4
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.015,
                          ), //56
                          Container(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.06,
                            width: ResponsiveWidget.getScreenHeight(context) * 0.02,
                            color: Colors.white,
                            child: !loading
                                ? AppComponents.defaultPrimaryButton(
                                text: localization.signIn,
                                press: () async {
                                  if (key.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    http.post(
                                        Uri.parse(
                                            ApiPath.baseAuthUrl + "login"),
                                        body: {
                                          "email": emailController.text,
                                          "password":
                                          passwordController.text
                                        }).then((value) async {
                                      print(value.reasonPhrase);
                                      setState(() {
                                        loading = false;
                                      });
                                      if (value.reasonPhrase ==
                                          'Unauthorized') {
                                        showTopSnackBar(
                                            context,
                                            CustomSnackBar.error(
                                                message: localization
                                                    .wrongEmailOrPassword));
                                      } else {
                                        SharedPreferences prefs =
                                        await SharedPreferences
                                            .getInstance();
                                        LoginResponse response =
                                        LoginResponse.fromJson(
                                            jsonDecode(value.body));
                                        prefs.setString(
                                            'token',
                                            response.accessToken
                                                .toString());
                                        print(response.accessToken
                                            .toString());
                                        http.post(
                                            Uri.parse(
                                                ApiPath.baseAuthUrl + "me"),
                                            body: {
                                              'token': response.accessToken
                                                  .toString()
                                            }).then((value) {
                                          prefs.setString(
                                              'user', value.body);
                                          prefs.setBool('Logged', true);
                                          showTopSnackBar(
                                              context,
                                              CustomSnackBar.success(
                                                  message: localization
                                                      .loggedSuccessfully,
                                                  backgroundColor:
                                                  Colors.black));
                                          Navigator.of(context).push(
                                              Routing().createRoute(
                                                  HomeScreen()));
                                        });
                                      }
                                    }).onError((error, stackTrace) {
                                      showTopSnackBar(
                                          context,
                                          CustomSnackBar.error(
                                              message: localization
                                                  .loginAttemptFailed +
                                                  '\n' +
                                                  localization
                                                      .pleaseTryAgain,
                                              backgroundColor:
                                              Colors.black));
                                      setState(() {
                                        loading = false;
                                      });
                                      print(error);
                                    });
                                  }
                                },
                                color: AppColor.mainColor,
                                context: context)
                                : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          ), //62
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.015,
                          ), //64
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.04,
                            child: Text(
                              localization.signInWith,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ), //68
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.08, //76
                            width: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.08,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    final provider =
                                    Provider.of<GoogleSignInProvider>(
                                        context,
                                        listen: false);
                                    provider.googleLogin();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                        ResponsiveWidget.getScreenWidth(context) *
                                            0.02),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: const Color(0xEFEFEFFF),
                                            width: 2)),
                                    height: ResponsiveWidget
                                        .getScreenHeightWithoutStatusBar(
                                        context) *
                                        0.08,
                                    width: ResponsiveWidget
                                        .getScreenHeightWithoutStatusBar(
                                        context) *
                                        0.08,
                                    child: SvgPicture.asset(
                                      'assets/images/google.svg',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.02,
                          ), //76
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.06,
                            child: RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              fillColor: const Color(0xFCFCFCFF),
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, HomeScreen.id, (route) => false);
                              },
                              child: Text(localization.continueAsAGuest),
                            ),
                          ), //82
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.02,
                          ), //88
                          SizedBox(
                            height: ResponsiveWidget.getScreenHeightWithoutStatusBar(
                                context) *
                                0.07,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  localization.createANewAccount,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      Routing().createRoute(
                                        SignupScreen(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      localization.signUp,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ), //95
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
