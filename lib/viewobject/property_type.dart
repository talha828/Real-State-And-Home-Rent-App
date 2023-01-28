import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';
import 'default_icon.dart';
import 'default_photo.dart';

class PropertyType extends PsObject<PropertyType> {
  PropertyType(
      {this.id,
      this.name,
      this.status,
      this.addedDate,
      this.addedUserId,
      this.updatedDate,
      this.updatedUserId,
      this.updatedFlag,
      this.addedDateStr,
      this.isSubscribed,
      this.defaultPhoto,
      this.defaultIcon});
  String? id;
  String? name;
  String? status;
  String? addedDate;
  String? addedUserId;
  String? updatedDate;
  String? updatedUserId;
  String? updatedFlag;
  String? addedDateStr;
  String? isSubscribed;
  DefaultPhoto? defaultPhoto;
  DefaultIcon? defaultIcon;

  @override
  bool operator ==(dynamic other) => other is PropertyType && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  PropertyType fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return PropertyType(
          id: dynamicData['id'],
          name: dynamicData['name'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          updatedUserId: dynamicData['updated_user_id'],
          updatedFlag: dynamicData['updated_flag'],
          addedDateStr: dynamicData['added_date_str'],
          isSubscribed:  dynamicData['is_subscribed_mb'],
          defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
          defaultIcon: DefaultIcon().fromMap(dynamicData['default_icon']));
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(PropertyType? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['added_date_str'] = object.addedDateStr;
      data['is_subscribed_mb'] = object.isSubscribed;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      data['default_icon'] = DefaultIcon().toMap(object.defaultIcon);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<PropertyType> fromMapList(List<dynamic> dynamicDataList) {
    final List<PropertyType> propertyTypeList = <PropertyType>[];

    //if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          propertyTypeList.add(fromMap(dynamicData));
        }
      }
   // }
    return propertyTypeList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<PropertyType> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
    //if (objectList != null) {
      for (PropertyType? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    //}

    return mapList;
  }
}
