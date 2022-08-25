import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RateUs extends StatefulWidget {
  //const Rate({Key? key}) : super(key: key);

  @override
  State<RateUs> createState() => _RateUsState();
}

class _RateUsState extends State<RateUs> {
  double rating = 0;
  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(249, 249, 249, 1),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromRGBO(249, 249, 249, 1),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.clear_rounded,
                      ),
                      color: Colors.black,
                    ),
                  ],
                ),
                Text(
                  localization.rateZonaApplication,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(26, 29, 31, 1)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  localization.yourFeedback + "\n" + localization.improvements,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(83, 87, 99, 1),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                RatingBar.builder(
                  minRating: 1,
                  itemBuilder: (context, _) => const Icon(
                    IconlyBold.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) => setState(() {
                    this.rating = rating;
                  }),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 139,
                      height: 48,
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: const Color.fromRGBO(239, 239, 239, 1),
                        onPressed: () {},
                        child: Text(
                          localization.noThanks,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(26, 27, 45, 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    SizedBox(
                      width: 150,
                      height: 48,
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: const Color.fromRGBO(26, 27, 45, 1),
                        onPressed: () {},
                        child: Text(
                          localization.rateInStore,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
