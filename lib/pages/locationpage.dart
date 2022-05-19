import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: const CameraPosition(
        target: LatLng(13.7650836, 100.5379664),
        zoom: 16,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    ));
  }
}
