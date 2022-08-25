import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zona/Provider/google_sign_in.dart';
import 'package:zona/l10n/l10n.dart';
import 'package:zona/login/SignInScreen.dart';
import 'package:zona/login/SignUpScreen.dart';
import 'package:zona/login/VerifyCodeScreen.dart';
import 'package:zona/screens/HomeScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zona/src/features/view/screens/signin_signup_screens/signIn_screen.dart';
import 'firebase_options.dart';
import 'models/user.dart' as userModel;
import 'src/features/view/screens/onbording_screens/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "The-Zona",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool intro = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.black),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
        supportedLocales: L10n.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          VerifyCodeScreen.id: (context) => const VerifyCodeScreen(
                email: '',
                // code: '',
              ),
          SignInScreen.id: (context) => const SignInScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool intro = false;
  bool logged = false;
  int id = -1;
  String userJson = '';
  userModel.User user = userModel.User();

  Future<void> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("UserJson") != null) {
      setState(() {
        intro = prefs.getBool("SeenIntro")!;
        logged = prefs.getBool("Logged")!;
        userJson = prefs.getString("UserJson")!;
        user = userModel.User.fromJson(jsonDecode(userJson));
      });
    }
  }

  @override
  void initState() {
    getSharedPrefs();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        if (logged) {
          return const SignInScreen();
        } else if (intro) {
          return const SignInScreen();
        } else {
          return const OnBoardingScreens();
        }
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
                tag: "zona",
                child: Image.asset(
                  "assets/images/ZonaLogo.png",
                  width: 200,
                )),
          ],
        ),
      ),
    );
  }
}
