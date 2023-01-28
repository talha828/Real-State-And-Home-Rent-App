import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPinCallBackHolder {
  const GoogleMapPinCallBackHolder({
    required this.address,
    required this.latLng,
  });
  final String address;
  final LatLng latLng;
}
