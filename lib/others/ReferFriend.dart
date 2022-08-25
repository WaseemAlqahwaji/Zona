import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReferAFriendScreen extends StatefulWidget {
  //const ReferAFriendScreen({Key? key}) : super(key: key);

  @override
  State<ReferAFriendScreen> createState() => _ReferAFriendScreenState();
}

class _ReferAFriendScreenState extends State<ReferAFriendScreen> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        color: const Color.fromRGBO(249, 249, 249, 1), //Color(0xF9F9F9FF),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/Friend.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                localization.referFriend + "\n" + localization.get50Off,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                localization.get50OffUpto20 +
                    "\n" +
                    localization.yourFriendGets50Off,
                style: TextStyle(
                  height: 2,
                  fontSize: 14,
                  color: Color.fromRGBO(83, 87, 99, 1),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 165,
                height: 48,
                child: RawMaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  fillColor: const Color.fromRGBO(41, 48, 60, 1),
                  onPressed: () {},
                  child: Text(localization.referFriend,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
