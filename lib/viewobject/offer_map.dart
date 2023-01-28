import 'package:flutteradhouse/viewobject/common/ps_map_object.dart';
import 'package:quiver/core.dart';

class OfferMap extends PsMapObject<OfferMap> {
  OfferMap({this.id, this.mapKey, this.offerId, int? sorting, this.addedDate}) {
    super.sorting = sorting;
  }

  String? id;
  String? mapKey;
  String? offerId;
  String? addedDate;

  @override
  bool operator ==(dynamic other) => other is OfferMap && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  OfferMap fromMap(dynamic dynamicData) {
    //if (dynamicData != null) {
      return OfferMap(
          id: dynamicData['id'],
          mapKey: dynamicData['map_key'],
          offerId: dynamicData['offer_id'],
          sorting: dynamicData['sorting'],
          addedDate: dynamicData['added_date']);
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['map_key'] = object.mapKey;
      data['offer_id'] = object.offerId;
      data['sorting'] = object.sorting;
      data['added_date'] = object.addedDate;

      return data;
    } else {
      return null;
    }
  }

  @override
  List<OfferMap> fromMapList(List<dynamic> dynamicDataList) {
    final List<OfferMap> productMapList = <OfferMap>[];

   // if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          productMapList.add(fromMap(dynamicData));
        }
      }
   // }
    return productMapList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>?> dynamicList = <Map<String, dynamic>?>[];
   // if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
   // }

    return dynamicList;
  }

  @override
  List<String> getIdList(List<dynamic> ?mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (dynamic product in mapList) {
        if (product != null) {
          idList.add(product.offerId);
        }
      }
    }
    return idList;
  }
}
