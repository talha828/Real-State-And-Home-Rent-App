import 'package:quiver/core.dart';
import 'common/ps_object.dart';

class ItemLocationCity extends PsObject<ItemLocationCity> {
  ItemLocationCity({
    this.id,
    this.name,
    this.ordering,
    this.lat,
    this.lng,
    this.status,
    this.addedDate,
  });
  String? id;
  String? name;
  String? ordering;
  String? lat;
  String? lng;
  String? status;
  String? addedDate;

  @override
  bool operator ==(dynamic other) =>
      other is ItemLocationCity && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  ItemLocationCity fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return ItemLocationCity(
          id: dynamicData['id'],
          name: dynamicData['name'],
          ordering: dynamicData['ordering'],
          lat: dynamicData['lat'],
          lng: dynamicData['lng'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date']);
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(ItemLocationCity? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['odering'] = object.ordering;
      data['lat'] = object.lat;
      data['lng'] = object.lng;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ItemLocationCity> fromMapList(List<dynamic> dynamicDataList) {
    final List<ItemLocationCity> itemLocationList = <ItemLocationCity>[];

   // if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          itemLocationList.add(fromMap(dynamicData));
        }
      }
   // }
    return itemLocationList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<ItemLocationCity> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
   // if (objectList != null) {
      for (ItemLocationCity? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
     // }
    }

    return mapList;
  }

  bool isListEqual(
      List<ItemLocationCity> cache, List<ItemLocationCity> newList) {
    if (cache.length == newList.length) {
      bool status = true;
      for (int i = 0; i < cache.length; i++) {
        if (cache[i].id != newList[i].id) {
          status = false;
          break;
        }
      }

      return status;
    } else {
      return false;
    }
  }
}
