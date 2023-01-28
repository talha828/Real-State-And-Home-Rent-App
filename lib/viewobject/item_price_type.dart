import 'package:quiver/core.dart';
import 'common/ps_object.dart';

class ItemPriceType extends PsObject<ItemPriceType> {
  ItemPriceType(
      {this.id, this.name, this.status, this.addedDate, this.isEmptyObject});

  String? id;
  String? name;
  String? status;
  String? addedDate;
  String? isEmptyObject;

  @override
  bool operator ==(dynamic other) => other is ItemPriceType && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  ItemPriceType fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return ItemPriceType(
        id: dynamicData['id'],
        name: dynamicData['name'],
        status: dynamicData['status'],
        addedDate: dynamicData['added_date'],
        isEmptyObject: dynamicData['is_empty_object'],
      );
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['is_empty_object'] = object.isEmptyObject;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ItemPriceType> fromMapList(List<dynamic> dynamicDataList) {
    final List<ItemPriceType> userLoginList = <ItemPriceType>[];

    //if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          userLoginList.add(fromMap(dynamicData));
        }
      }
   // }
    return userLoginList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>?> dynamicList = <Map<String, dynamic>?>[];
  //  if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
   // }
    return dynamicList;
  }
}
