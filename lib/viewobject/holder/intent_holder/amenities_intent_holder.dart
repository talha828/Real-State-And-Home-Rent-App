import 'package:flutteradhouse/viewobject/amenities.dart';

class AmenitiesIntentHolder {
  const AmenitiesIntentHolder({
    required this.amenityId,
    required this.selectedAmenitiesList,
  });
  
  final String amenityId;
  final Map<Amenities, bool> selectedAmenitiesList;
}
