import 'dart:convert';
// import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/models/location.dart';
import 'package:permission_handler/permission_handler.dart';

const LatLng currentLocation = LatLng(16.135855, 80.044958);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Marker> _markers = [];

  // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  // late Position _currentPosition;
  // late String _currentAddress;

  // @override
  // void initState() {
  //   super.initState();
  //   _getCurrentLocation();
  // }

  // _getCurrentLocation() {
  //   geolocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //       .then((Position position) {
  //     setState(() {
  //       _currentPosition = position;
  //     });

  //     _getAddressFromLatLng();
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  // _getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> p = await geolocator.placemarkFromCoordinates(
  //         _currentPosition.latitude, _currentPosition.longitude);

  //     Placemark place = p[0];

  //     setState(() {
  //       _currentAddress =
  //           "${place.locality}, ${place.postalCode}, ${place.country}";
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<List<Marker>> getData() async {
    List<Location> list = [];
    String link = "https://ords-test.efftronics.cloud/ords/ktpapp/test/test";
    var res = await http
        .get(Uri.parse(link), headers: {"Accept": "application/json"});
    //print(res.statusCode);

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var items = data["items"] as List;
      // print(items);
      list = items.map<Location>((json) => Location.fromJson(json)).toList();
      // print(list);
    }

    List<Marker> l = [];
    for (var data in list) {
      l.add(Marker(
          markerId: MarkerId(data.location),
          position: LatLng(
              double.parse(data.lattitude), double.parse(data.longitude)),
          infoWindow: InfoWindow(
              title: data.location, snippet: 'capacity is ${data.capacity}')));
    }
    return l;
  }

  late GoogleMapController mapController;

  Future<void> requestPermission() async {
    await Permission.location.request();
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   getData().then((value) => {
  //         setState(() {
  //           for (var data in value) {
  //             _markers.add(Marker(
  //                 markerId: MarkerId(data.location),
  //                 position: LatLng(double.parse(data.longitude),
  //                     double.parse(data.lattitude)),
  //                 infoWindow: InfoWindow(
  //                     title: data.location,
  //                     snippet: 'capacity is ${data.capacity}')));
  //           }
  //         })
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Marker>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: currentLocation, zoom: 14),
                onMapCreated: (controller) {
                  mapController = controller;
                  setState(() {
                    _markers = snapshot.data!.toList();
                  });
                  // print("markers are $_markers");
                  // getData().then((value) => {
                  //       setState(() {
                  //         for (var data in value) {
                  //           var marker_id = MarkerId(data.location);
                  //           var marker = Marker(
                  //               markerId: MarkerId(data.location),
                  //               position: LatLng(double.parse(data.longitude),
                  //                   double.parse(data.lattitude)),
                  //               infoWindow: InfoWindow(
                  //                   title: data.location,
                  //                   snippet: 'capacity is ${data.capacity}'));
                  //           var markers = _markers;
                  //           markers.add(marker);
                  //           setState(() {
                  //             _markers = markers;
                  //           });
                  //         }
                  //       })
                  //     });
                },
                markers: Set.of(_markers),
                myLocationEnabled: true,
                myLocationButtonEnabled: true);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

//   addMarker(String id, String title, LatLng location) async {
//     var markerIcon = await BitmapDescriptor.fromAssetImage(
//         const ImageConfiguration(), 'assets/images/some.png');
//     var marker = Marker(
//       markerId: MarkerId(id),
//       position: location,
//       infoWindow:
//           InfoWindow(title: title, snippet: 'some Description of the place'),
//       // icon: markerIcon,
//     );
//     _markers[id] = marker;

//     setState(() {});
//   }
// }
