import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class ShippingCity extends PsObject<ShippingCity> {
  ShippingCity({
    this.id,
    this.countryId,
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
  String? countryId;
  String? name;
  String? status;
  String? addedDate;
  String? addedUserId;
  String? updatedDate;
  String? updatedUserId;
  String? updatedFlag;
  String? addedDateStr;

  @override
  bool operator ==(dynamic other) => other is ShippingCity && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  ShippingCity fromMap(dynamic dynamicData) {
    //if (dynamicData != null) {
      return ShippingCity(
          id: dynamicData['id'],
          name: dynamicData['name'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          updatedUserId: dynamicData['updated_user_id'],
          updatedFlag: dynamicData['updated_flag'],
          countryId: dynamicData['country_id'],
          addedDateStr: dynamicData['added_date_str']);
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(ShippingCity? object) {
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
      data['country_id'] = object.countryId;
      data['added_date_str'] = object.addedDateStr;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ShippingCity> fromMapList(List<dynamic> dynamicDataList) {
    final List<ShippingCity> shippingCountryAndCityList = <ShippingCity>[];

   // if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          shippingCountryAndCityList.add(fromMap(dynamicData));
        }
      }
    //}
    return shippingCountryAndCityList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<ShippingCity> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
   // if (objectList != null) {
      for (ShippingCity? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
   // }

    return mapList;
  }
}
