import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class ShippingMethod extends PsObject<ShippingMethod> {
  ShippingMethod({
    this.id,
    this.name,
    this.price,
    this.days,
    this.addedDate,
    this.addedUserId,
    this.updatedDate,
    this.updatedUserId,
    this.addedDateStr,
    this.updatedFlag,
    this.isPublished,
    this.currencySymbol,
    this.currencyShortForm,
  });
  String? id;
  String? name;
  String? price;
  String? days;
  String? addedDate;
  String? addedUserId;
  String? updatedDate;
  String? updatedUserId;
  String? addedDateStr;
  String? updatedFlag;
  String? isPublished;
  String? currencySymbol;
  String? currencyShortForm;
  @override
  bool operator ==(dynamic other) => other is ShippingMethod && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  ShippingMethod fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return ShippingMethod(
        id: dynamicData['id'],
        name: dynamicData['name'],
        price: dynamicData['price'],
        days: dynamicData['days'],
        addedDate: dynamicData['added_date'],
        addedUserId: dynamicData['added_user_id'],
        updatedDate: dynamicData['updated_date'],
        updatedUserId: dynamicData['updated_user_id'],
        addedDateStr: dynamicData['added_date_str'],
        updatedFlag: dynamicData['updated_flag'],
        isPublished: dynamicData['is_published'],
        currencySymbol: dynamicData['currency_symbol'],
        currencyShortForm: dynamicData['currency_short_form'],
      );
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(ShippingMethod? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['price'] = object.price;
      data['days'] = object.days;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedUserId;
      data['added_date_str'] = object.addedDateStr;
      data['updated_flag'] = object.updatedFlag;
      data['is_published'] = object.isPublished;
      data['currency_symbol'] = object.currencySymbol;
      data['currency_short_form'] = object.currencyShortForm;

      return data;
    } else {
      return null;
    }
  }

  @override
  List<ShippingMethod> fromMapList(List<dynamic> dynamicDataList) {
    final List<ShippingMethod> shippingMethodList = <ShippingMethod>[];

   // if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          shippingMethodList.add(fromMap(dynamicData));
        }
      }
    //}
    return shippingMethodList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<ShippingMethod> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
   // if (objectList != null) {
      for (ShippingMethod? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    //}
    return mapList;
  }
}
