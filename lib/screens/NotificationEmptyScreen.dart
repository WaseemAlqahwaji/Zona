import 'package:flutter/material.dart';
import 'package:zona/config/routing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationEmptyScreen extends StatelessWidget {
  const NotificationEmptyScreen({Key? key}) : super(key: key);

  static String id = "notification-empty";

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        color: const Color(0xF9F9F9FF),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset("assets/images/Notification.png")),
              const SizedBox(
                height: 40,
              ),
              Text(
                localization.noNotifications,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                localization.youDoNotHaveNotificationYet,
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(176, 176, 176, 1),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 239,
                height: 48,
                child: RawMaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: const Color.fromRGBO(41, 48, 60, 1),
                    onPressed: () {},
                    child: Text(localization.viewAllServices,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
