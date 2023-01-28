import 'package:flutteradhouse/viewobject/common/ps_map_object.dart';
import 'package:quiver/core.dart';

class UserMap extends PsMapObject<UserMap> {
  UserMap({this.id, this.mapKey, this.userId, int? sorting, this.addedDate}) {
    super.sorting = sorting;
  }

  String? id;
  String? mapKey;
  String? userId;
  String? addedDate;

  @override
  bool operator ==(dynamic other) => other is UserMap && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  UserMap fromMap(dynamic dynamicData) {
    //if (dynamicData != null) {
      return UserMap(
          id: dynamicData['id'],
          mapKey: dynamicData['map_key'],
          userId: dynamicData['user_id'],
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
      data['user_id'] = object.userId;
      data['sorting'] = object.sorting;
      data['added_date'] = object.addedDate;

      return data;
    } else {
      return null;
    }
  }

  @override
  List<UserMap> fromMapList(List<dynamic> dynamicDataList) {
    final List<UserMap> userMapList = <UserMap>[];

    //if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          userMapList.add(fromMap(dynamicData));
        }
      }
   // }
    return userMapList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>?> dynamicList = <Map<String, dynamic>?>[];
    //if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
     // }
    }

    return dynamicList;
  }

  @override
  List<String> getIdList(List<dynamic>? mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (dynamic product in mapList) {
        if (product != null) {
          idList.add(product.userId);
        }
      }
    }
    return idList;
  }
}
