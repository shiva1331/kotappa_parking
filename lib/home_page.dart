import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/models/location.dart';
import 'package:permission_handler/permission_handler.dart';

const LatLng currentLocation = LatLng(16.14414, 80.0465);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<Marker> _markers = new Set();
  Future<List<Location>> getData() async {
    List<Location> list = [];
    String link = "https://ords-test.efftronics.cloud/ords/ktpapp/test/test";
    var res = await http
        .get(Uri.parse(link), headers: {"Accept": "application/json"});
    print(res.statusCode);

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var items = data["items"] as List;
      print(items);
      list = items.map<Location>((json) => Location.fromJson(json)).toList();
      print(list);
    }
    return list;
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
      body: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: currentLocation, zoom: 10),
          onMapCreated: (controller) {
            mapController = controller;
            getData().then((value) => {
                  setState(() {
                    for (var data in value) {
                      var marker_id = MarkerId(data.location);
                      var marker = Marker(
                          markerId: MarkerId(data.location),
                          position: LatLng(double.parse(data.longitude),
                              double.parse(data.lattitude)),
                          infoWindow: InfoWindow(
                              title: data.location,
                              snippet: 'capacity is ${data.capacity}'));
                      var markers = _markers;
                      markers.add(marker);
                      setState(() {
                        _markers = markers;
                      });
                    }
                  })
                });
            print("markers are $_markers");
          },
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true),
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
