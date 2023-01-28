import 'package:latlong2/latlong.dart';

class MapPinCallBackHolder {
  const MapPinCallBackHolder({
    required this.address,
    required this.latLng,
  });
  final String address;
  final LatLng latLng;
}
