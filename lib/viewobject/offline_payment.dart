import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:flutteradhouse/viewobject/default_icon.dart';
import 'package:quiver/core.dart';

class OfflinePayment extends PsObject<OfflinePayment> {
  OfflinePayment(
      {this.id,
      this.description,
      this.title,
      this.addedDate,
      this.addedUserId,
      this.updatedDate,
      this.updatedUserId,
      this.defaultIcon});

  String? id;
  String? description;
  String? title;
  String? addedDate;
  String? addedUserId;
  String? updatedDate;
  String? updatedUserId;
  DefaultIcon? defaultIcon;

  @override
  bool operator ==(dynamic other) => other is OfflinePayment && id == other.id;
  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  OfflinePayment fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return OfflinePayment(
          id: dynamicData['id'],
          description: dynamicData['description'],
          title: dynamicData['title'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          updatedUserId: dynamicData['updated_user_id'],
          defaultIcon: DefaultIcon().fromMap(dynamicData['default_icon']));
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(OfflinePayment? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['title'] = object.title;
      data['description'] = object.description;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['default_icon'] = DefaultIcon().toMap(object.defaultIcon);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<OfflinePayment> fromMapList(List<dynamic> dynamicDataList) {
    final List<OfflinePayment> subpropertyByList = <OfflinePayment>[];

  //  if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subpropertyByList.add(fromMap(dynamicData));
        }
      }
   // }
    return subpropertyByList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<OfflinePayment> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
  //  if (objectList != null) {
      for (OfflinePayment? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    //}

    return mapList;
  }
}
