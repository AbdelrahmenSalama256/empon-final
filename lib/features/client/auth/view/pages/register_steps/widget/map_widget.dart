import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final CameraPosition initialCameraPosition;
  final Set<Marker> markers;
  final Completer<GoogleMapController> controller;
  final VoidCallback onMapLoaded;
  final Function(CameraPosition) onCameraMove;

  const MapWidget({
    super.key,
    required this.initialCameraPosition,
    required this.markers,
    required this.controller,
    required this.onMapLoaded,
    required this.onCameraMove,
  });

  void _loadMapStyle(GoogleMapController mapController, BuildContext context) {
    DefaultAssetBundle.of(context)
        .loadString("assets/map_styles/light.json")
        .then((style) {
      // ignore: deprecated_member_use
      mapController.setMapStyle(style);
      onMapLoaded();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      markers: markers,
      onMapCreated: (GoogleMapController mapController) {
        if (!controller.isCompleted) {
          controller.complete(mapController);
          _loadMapStyle(mapController, context);
        }
      },
      buildingsEnabled: true,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      onCameraMove: onCameraMove,
    );
  }
}
