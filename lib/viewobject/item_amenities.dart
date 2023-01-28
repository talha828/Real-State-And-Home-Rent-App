import 'package:flutteradhouse/viewobject/amenities.dart';
import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class ItemAmenities extends PsObject<ItemAmenities> {
  ItemAmenities({
    this.id,
    this.itemId,
    this.amenityId,
    this.amenities,
  });

  String? id;
  String? itemId;
  String? amenityId;
  Amenities? amenities;

  @override
  bool operator ==(dynamic other) => other is ItemAmenities && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  ItemAmenities fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return ItemAmenities(
          id: dynamicData['id'],
          itemId: dynamicData['item_id'],
          amenityId: dynamicData['amenity_id'],
          amenities: Amenities().fromMap(dynamicData['amenities']));
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(ItemAmenities? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['item_id'] = object.itemId;
      data['amenity_id'] = object.amenityId;
      data['amenities'] = Amenities().toMap(object.amenities);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ItemAmenities> fromMapList(List<dynamic> dynamicDataList) {
    final List<ItemAmenities> itemAmenitiesList = <ItemAmenities>[];

   // if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          itemAmenitiesList.add(fromMap(dynamicData));
        }
      }
   // }
    return itemAmenitiesList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<ItemAmenities> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
   // if (mapList != null) {
      for (ItemAmenities? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
     // }
    }

    return mapList;
  }
}