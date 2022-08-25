import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectMapLocation extends StatefulWidget {
  const SelectMapLocation({Key? key, this.lat, this.long}) : super(key: key);

  static String id = "select-map-location";

  final lat, long;

  @override
  _SelectMapLocationState createState() => _SelectMapLocationState();
}

class _SelectMapLocationState extends State<SelectMapLocation> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(24.7136, 46.6753),
    zoom: 11.5,
  );
  GoogleMapController? _googleMapController;

  bool checked = false;
  double lat = 0.0;
  double long = 0.0;
  List<Marker> myMarker = <Marker>[];
  Map<String, double> userLocation = {};
  bool? _serviceEnabled;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 32, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                checked
                    ? InkWell(
                        onTap: () {
                          final data = {'long': long, "lat": lat};

                          Navigator.pop(context, data);
                        },
                        child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Center(
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                            )),
                      )
                    : Container(),
                SizedBox(
                  width: 22,
                ),
                FutureBuilder(
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return InkWell(
                          onTap: () async {
                            setState(() {
                              lat = userLocation['lat']!;
                              long = userLocation['long']!;
                              myMarker = [];
                              LatLng location = LatLng(lat, long);
                              myMarker.add(Marker(
                                markerId: MarkerId(location.toString()),
                                position: location,
                              ));
                              _googleMapController!.moveCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: location, zoom: 11)));
                            });
                            final data = {'long': long, "lat": lat};
                            Navigator.pop(context, data);
                          },
                          child: Container(
                              width: 120,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                child: Text(
                                  localization.myLocation,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        );
                      } else {
                        return Container();
                      }
                    })
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: FutureBuilder(builder: (cont, ext) {
                  return GoogleMap(
                    mapType: MapType.normal,
                    markers: Set<Marker>.of(myMarker),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(25.2048, 55.2708),
                      zoom: 11.5,
                    ),
                    onMapCreated: (controller) =>
                        _googleMapController = controller,
                    onTap: _handleTap,
                  );
                }),
              ),
              Positioned(
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                top: 22,
                right: 22,
              ),
            ],
          )),
    );
  }

  void _handleTap(LatLng tappedPosition) async {
    setState(() {
      lat = tappedPosition.latitude;
      long = tappedPosition.longitude;
      checked = true;
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(tappedPosition.toString()),
        position: tappedPosition,
      ));
    });
  }

}
