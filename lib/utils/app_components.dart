import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:zona/src/utils/responsive.dart';
import 'app_colors.dart';



class AppComponents {
  static Widget defaultPageOnBoard({
    required String imagePath,
    required String title,
    required String lable,
    required BuildContext context,
  }) =>
      Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Spacer(),
          Center(
            child: Container(
              width: Responsive.getScreenWidth(context) * 0.7,
              height: Responsive.getScreenHeight(context) * 0.5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                  )),
            ),
          ),
          FittedBox(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'RaleWay',
                fontSize: 25.0,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: FittedBox(
              child: Text(
                lable,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'RaleWay',
                  fontSize: 15.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      );

  static Widget defaultButtonOnBoard({
    required VoidCallback onPress,
    required String lable,
    required BuildContext context,
  }) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: AnimatedButton(
        shadowDegree: ShadowDegree.light,
        onPressed: onPress,
        child: Text(
          lable,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: AppColors.mainColor,
        width: Responsive.getScreenWidth(context) * 0.25,
        height: Responsive.getScreenHeight(context) * 0.05,
        enabled: true,
      ));

  static Widget defaultPrimaryButton({
    required String text,
    required VoidCallback press,
    required Color color ,
    required BuildContext context,
  })=>  MaterialButton(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(40)),
    ),
    color: color,
    minWidth: Responsive.getScreenWidth(context) * 0.06,
    onPressed: press,
    child: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
  );
}


