import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:flutteradhouse/viewobject/shipping_zone.dart';

class ShippingCost extends PsObject<ShippingCost> {
  ShippingCost({this.shippingZone});
  ShippingZone? shippingZone;

  @override
  String getPrimaryKey() {
    return '';
  }

  @override
  ShippingCost fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return ShippingCost(
        shippingZone: ShippingZone().fromMap(dynamicData['shipping']),
      );
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['shipping'] = ShippingZone().fromMap(object.shippingZone);

      return data;
    } else {
      return null;
    }
  }

  @override
  List<ShippingCost> fromMapList(List<dynamic> dynamicDataList) {
    final List<ShippingCost> shippingCostList = <ShippingCost>[];

   // if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          shippingCostList.add(fromMap(json));
        }
      }
   // }
    return shippingCostList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<dynamic> objectList) {
    final List<dynamic> dynamicList = <dynamic>[];
    //if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    //}

    return dynamicList as List<Map<String, dynamic>?>;
  }
}
