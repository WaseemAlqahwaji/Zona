import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zona/src/utils/colors.dart';
import '../../../../../config/routing.dart';
import '../../../../../login/SignInScreen.dart';
import '../../../../utils/components.dart';
import '../../../../utils/images_pathes.dart';
import '../../../../utils/responsive.dart';
import '../signin_signup_screens/signIn_screen.dart';


class OnBoardingScreens extends StatefulWidget {
  const OnBoardingScreens({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreens> createState() => _OnBoardingScreensState();
}

class _OnBoardingScreensState extends State<OnBoardingScreens> {
  final PageController controller = PageController();
  final int onBoardScreenCount = 3;
  bool inLastScreen = false;
  bool moveToNextButton = true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(
            bottom: 60.0,
          ),
          child: PageView(
            onPageChanged: (index) {
              if (onBoardScreenCount - 1 == index) {
                moveToNextButton = false;
              } else {
                moveToNextButton = true;
              }
            },
            physics: const BouncingScrollPhysics(),
            controller: controller,
            children: [
              Components.defaultPageOnBoard(
                context: context,
                imagePath: ImagesPaths.onBoardingFirstImage,
                lable: "Makeup information",
                title: "Makeup",
              ),
              Components.defaultPageOnBoard(
                context: context,
                imagePath: ImagesPaths.onBoardingSecondImage,
                lable: "Worker Information",
                title: "Worker",
              ),
              Components.defaultPageOnBoard(
                context: context,
                imagePath: ImagesPaths.onBoardingThirdImage,
                lable: "Cleaner Information",
                title: "Cleaner",
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        height: Responsive.getScreenHeight(context)*0.08,
        // color: Colors.purple,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ConditionalBuilder(
                condition: !inLastScreen,
                fallback: (context) => const SizedBox(),
                builder: (context) => Components.defaultButtonOnBoard(
                  context: context,
                  lable: "Skip",
                  onPress: () {
                    controller.animateToPage(
                      onBoardScreenCount,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                    setState(() {
                      inLastScreen = true;
                    });
                  },
                ),
              ),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: onBoardScreenCount,
                effect: WormEffect(
                  spacing: 7,
                  dotColor: Colors.black12,
                  dotHeight: 7.0,
                  dotWidth: 10.0,
                  activeDotColor: AppColor.mainColor,
                ),
              ),
            ),
            Expanded(
              child: Components.defaultButtonOnBoard(
                context: context,
                lable: "Next",
                onPress: ()async {
                  if (moveToNextButton) {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool('SeenIntro', true).then((value) {
                      Navigator.push(context, Routing().createRoute(const SigninScreen(),),);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
