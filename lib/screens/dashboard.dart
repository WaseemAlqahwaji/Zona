import 'dart:convert';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zona/config/routing.dart';
import 'package:zona/models/provider.dart';
import 'package:zona/models/service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zona/screens/LoadingIndicatorWidget.dart';
import '../constants/constant.dart';
import '../models/category.dart';
import 'ServiceDetailsScreen.dart';
import 'SubCategoriesScreen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key, this.user}) : super(key: key);
  final user;

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final TextEditingController _phoneController = TextEditingController();
  final List<String> name = [
    'U ... UP\nSpecial',
    'Main\nCategory2',
    'Main\nCategory3',
    'Main\nCategory4',
    'Main\nCategory5',
    'Main\nCategory6',
    'Main\nCategory7',
  ];
  int index = 0;
  List<Category> categories = [];
  List<Services> services = [];

  List<Widget> carouselItems = [];

  final String? baseURL = "http://new.zona.ae";

  var _future;
  var _future2;

  Future<void> getSliderPhotos() async {
    final response = await http.get(Uri.parse(baseURL! + "/api/offers/all-offers"));
    List<dynamic> photos = jsonDecode(response.body);
    print(photos);

    carouselItems = [];

    setState(() {
      photos.forEach((element) {
        carouselItems.add(Image.network(element['img']));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCategories();
    _future2 = getSliderPhotos();
    getCategories();
    _future = getServices();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: null,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                FutureBuilder(
                    future: _future2,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingIndicatorWidget();
                      } else {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8), color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: width,
                                height: height * 0.2,
                                child: Swiper(
                                  itemCount: carouselItems.length,
                                  scale: 2.0,
                                  loop: true,
                                  index: 0,
                                  layout: SwiperLayout.DEFAULT,
                                  containerWidth: width,
                                  containerHeight: height * 0.35,
                                  autoplay: true,
                                  autoplayDisableOnInteraction: false,
                                  duration: 800,
                                  itemWidth: width,
                                  itemHeight: height * 0.35,
                                  pagination: const SwiperPagination(),
                                  control: const SwiperControl(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      width: width,
                                      height: height * 0.35,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 3,
                                          color: Colors.transparent,
                                          style: BorderStyle.solid,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(0.0),
                                          bottomRight: Radius.circular(30.0),
                                          bottomLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(0.0),
                                        ),
                                      ),
                                      child: carouselItems[index],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              /// What you are looking for today
                              // Text(
                              //   localization.whatYouAreLooking + "\n" + localization.forToday,
                              //   style: const TextStyle(
                              //       fontSize: 20,
                              //       fontWeight: FontWeight.bold,
                              //       color: Color.fromRGBO(23, 43, 77, 1)),
                              // ),
                              // const SizedBox(
                              //   height: 3,
                              // ),
                              // /// search text field
                              // TextField(
                              //   obscureText: false,
                              //   keyboardType: TextInputType.text,
                              //   onChanged: (val) {
                              //     _phoneController.text = val;
                              //   },
                              //   decoration: kTextFieldDecoration.copyWith(
                              //       suffixIcon: Container(
                              //         child: const Center(
                              //           child: Icon(
                              //             IconlyLight.search,
                              //             color: Colors.white,
                              //             size: 20,
                              //           ),
                              //         ),
                              //         margin: const EdgeInsets.fromLTRB(0, 6, 10, 6),
                              //         width: 30,
                              //         decoration: BoxDecoration(
                              //             borderRadius: BorderRadius.circular(8),
                              //             color: const Color(0xff1A1B2D)),
                              //       ),
                              //       hintText: localization.searchWhatYouNeed,
                              //       hintStyle: const TextStyle()),
                              // ),
                              // const SizedBox(
                              //   height: 3,
                              // ),
                            ],
                          ),
                        );
                      }
                    }),
                Container(
                    width: double.infinity,
                    height: 150,
                    padding: const EdgeInsets.all(16),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FutureBuilder(
                            future: getCategories(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        categories.isEmpty ? 0 : categories.sublist(0, 3).length,
                                    itemBuilder: (BuildContext context, int index) {
                                      String color = '0x' + categories[index].color.toString();
                                      return categories.isNotEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.only(right: 32),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                        Routing().createRoute(
                                                          CategoryProviders(
                                                            idCategory:
                                                                categories[index].id.toString(),
                                                            categoryName: categories[index].name,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 70,
                                                      height: 70,
                                                      padding: const EdgeInsets.all(14),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(100),
                                                          color: Color(int.parse(color))),
                                                      child: Image.network(
                                                        categories[index].image.toString(),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    categories[index].name.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromRGBO(65, 64, 93, 1)),
                                                  )
                                                ],
                                              ),
                                            )
                                          : const Center(
                                              child: CircularProgressIndicator.adaptive(),
                                            );
                                      //
                                    },
                                  ),
                                );
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            }),
                      ],
                    )),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: FutureBuilder(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return SizedBox(
                            height: 350.0 * categories.length,
                            child: ListView.builder(
                                itemCount: categories.length,
                                shrinkWrap: false,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          /// Category Name
                                          Text(
                                            categories[index].name!,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(23, 43, 77, 1),
                                            ),
                                          ),

                                          /// See All Button
                                          SizedBox(
                                            height: 33,
                                            child: RawMaterialButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100)),
                                              fillColor: const Color.fromRGBO(255, 255, 255, 1),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  Routing().createRoute(
                                                    CategoryProviders(
                                                      idCategory: categories[index].id.toString(),
                                                      categoryName: categories[index].name,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    localization.seeAll,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromRGBO(111, 118, 126, 1),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.keyboard_arrow_right,
                                                    color: Color.fromRGBO(111, 118, 126, 1),
                                                    size: 20,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),

                                      /// List Category Related Services
                                      SizedBox(
                                        width: width,
                                        height: 250.0,
                                        child: ListView.builder(
                                          itemCount: services.length,
                                          itemBuilder: (BuildContext context, int index2) {
                                            if (categories[index].id.toString() ==
                                                services[index2].idcategory) {
                                              return Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  /// Service Image
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(Routing()
                                                          .createRoute(ServiceDetailsScreen(
                                                        service: services.elementAt(index2),
                                                        categoryName: categories[int.parse(
                                                                    services[index2].idcategory!) -
                                                                1]
                                                            .name,
                                                        provider: Provider(
                                                            id: int.parse(services
                                                                .elementAt(index2)
                                                                .idprovider
                                                                .toString())),
                                                      )));
                                                    },
                                                    child: Container(
                                                        padding: const EdgeInsets.all(5),
                                                        height: 200,
                                                        child: Column(children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(14),
                                                              color: Colors
                                                                  .red, //Color.fromRGBO(236, 234, 246, 1),
                                                            ),
                                                            width: 170,
                                                            height: 180,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(14),
                                                              child: Image.network(
                                                                baseURL! + services[index2].image!,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ])),
                                                  ),

                                                  /// Service Name
                                                  Text(
                                                    services[index2].name!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color.fromRGBO(23, 43, 77, 1),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 40,
                                      ),
                                    ],
                                  );
                                }),
                          );
                        } else {
                          return LoadingIndicatorWidget();
                        }
                      }),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Category>> getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    http.post(Uri.parse('$baseURL/api/auth/categories'), body: {"token": token}).then((value) {
      try {
        setState(() {
          Iterable l = jsonDecode(value.body);
          categories = List<Category>.from(l.map((model) => Category.fromJson(model)));
        });
      } catch (e) {}
    }).onError((error, stackTrace) {});
    return categories;
  }

  Future<void> getServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    final String? servicesURL = "$baseURL/api/auth/all_services";

    /// NO NEED FOR THE TOKEN ANYMORE !!
    http.post(Uri.parse(servicesURL!), body: {"token": token}).then((value) {
      setState(() {
        Iterable l = jsonDecode(value.body);
        print("iterable:\t$l");
        services = List<Services>.from(l.map((model) => Services.fromJson(model)));
        print("services:\t$services");
      });
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }
}
