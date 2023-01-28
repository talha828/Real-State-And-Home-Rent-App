import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class ShippingCountry extends PsObject<ShippingCountry> {
  ShippingCountry({
    this.id,
    this.name,
    this.status,
    this.addedDate,
    this.addedUserId,
    this.updatedDate,
    this.updatedUserId,
    this.updatedFlag,
    this.addedDateStr,
  });

  String? id;
  String? name;
  String? status;
  String? addedDate;
  String? addedUserId;
  String? updatedDate;
  String? updatedUserId;
  String? updatedFlag;
  String? addedDateStr;

  @override
  bool operator ==(dynamic other) => other is ShippingCountry && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  ShippingCountry fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return ShippingCountry(
          id: dynamicData['id'],
          name: dynamicData['name'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          updatedUserId: dynamicData['updated_user_id'],
          updatedFlag: dynamicData['updated_flag'],
          addedDateStr: dynamicData['added_date_str']);
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(ShippingCountry? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedFlag;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['added_date_str'] = object.addedDateStr;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ShippingCountry> fromMapList(List<dynamic> dynamicDataList) {
    final List<ShippingCountry> shippingCountryAndCityList =
        <ShippingCountry>[];

    //if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          shippingCountryAndCityList.add(fromMap(dynamicData));
        }
      }
    //}
    return shippingCountryAndCityList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<ShippingCountry> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
  //  if (objectList != null) {
      for (ShippingCountry? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
   // }

    return mapList;
  }
}
