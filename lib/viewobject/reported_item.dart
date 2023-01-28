import 'package:flutteradhouse/viewobject/default_photo.dart';
import 'package:quiver/core.dart';
import 'common/ps_object.dart';

class ReportedItem extends PsObject<ReportedItem> {
  ReportedItem({
    this.id,
    this.title,
    this.status,
    this.addedDate,
    this.defaultPhoto,
  });

  String? id;
  String? title;
  String? status;
  String? addedDate;
  DefaultPhoto? defaultPhoto;

  @override
  bool operator ==(dynamic other) => other is ReportedItem && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  ReportedItem fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return ReportedItem(
        id: dynamicData['id'],
        title: dynamicData['title'],
        status: dynamicData['status'],
        addedDate: dynamicData['added_date'],
        defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
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
      data['title'] = object.title;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ReportedItem> fromMapList(List<dynamic> dynamicDataList) {
    final List<ReportedItem> userLoginList = <ReportedItem>[];

   // if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          userLoginList.add(fromMap(dynamicData));
        }
   //   }
    }
    return userLoginList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>?> dynamicList = <Map<String, dynamic>?>[];
   // if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
   // }
    return dynamicList;
  }
}
