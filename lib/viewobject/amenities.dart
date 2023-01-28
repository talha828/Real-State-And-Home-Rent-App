import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class Amenities extends PsObject<Amenities> {
  Amenities({
    this.id,
    this.name,
    this.status,
    this.addedDate,
    this.addedUserId,
    this.updatedDate,
    this.updatedUserId,
    this.updatedFlag,
    this.addedDatedStr,
  });

  String? id;
  String? name;
  String? status;
  String? addedDate;
  String? addedUserId;
  String? updatedDate;
  String? updatedUserId;
  String? updatedFlag;
  String? addedDatedStr;

  @override
  bool operator ==(dynamic other) => other is Amenities && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  Amenities fromMap(dynamic dynamicData) {
    //if (dynamicData != null) {
      return Amenities(
          id: dynamicData['id'],
          name: dynamicData['name'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          updatedUserId: dynamicData['updated_user_id'],
          updatedFlag: dynamicData['updated_flag'],
          addedDatedStr: dynamicData['added_date_str']);
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(Amenities? object) {
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
      data['added_date_str'] = object.addedDatedStr;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Amenities> fromMapList(List<dynamic> dynamicDataList) {
    final List<Amenities> amenitiesList = <Amenities>[];

    //if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          amenitiesList.add(fromMap(dynamicData));
        }
      }
  //  }
    return amenitiesList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<Amenities> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
   // if (mapList != null) {
      for (Amenities? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    //}

    return mapList;
  }
}
