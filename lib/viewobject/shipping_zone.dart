import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class ShippingZone extends PsObject<ShippingZone> {
  ShippingZone({
    this.id,
    this.shippingZonePackageName,
    this.shippingCost,
  });

  String? id;
  String? shippingZonePackageName;
  String? shippingCost;

  @override
  bool operator ==(dynamic other) => other is ShippingZone && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  ShippingZone fromMap(dynamic dynamicData) {
    //if (dynamicData != null) {
      return ShippingZone(
        id: dynamicData['id'],
        shippingZonePackageName: dynamicData['shipping_zone_package_name'],
        shippingCost: dynamicData['shipping_cost'],
      );
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(ShippingZone? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['shipping_zone_package_name'] = object.shippingZonePackageName;
      data['shipping_cost'] = object.shippingCost;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ShippingZone> fromMapList(List<dynamic> dynamicDataList) {
    final List<ShippingZone> shippingZoneAndCityList = <ShippingZone>[];

   // if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          shippingZoneAndCityList.add(fromMap(dynamicData));
        }
      }
  //  }
    return shippingZoneAndCityList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<ShippingZone> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
   // if (objectList != null) {
      for (ShippingZone? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
   // }

    return mapList;
  }
}
