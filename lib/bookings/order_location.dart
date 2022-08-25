import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class OrderMap extends StatefulWidget {
  const OrderMap({Key? key,required this.lat,required this.long}) : super(key: key);
  final double lat,  long;

  @override
  _OrderMapState createState() => _OrderMapState();
}

class _OrderMapState extends State<OrderMap> {
  GoogleMapController? _googleMapController;



  bool checked = false;
  double lat = 0.0;
  double long = 0.0;
  List<Marker> myMarker = <Marker>[];

  @override
  void initState() {
    if (widget.lat != 0.0) {
      myMarker.add(Marker(
        markerId: MarkerId(CameraPosition(
          target: LatLng(widget.lat, widget.long),
          zoom: 11.5,
        ).target.toString()),
        position: LatLng(25.2048, 55.2708),
      ));
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

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
}