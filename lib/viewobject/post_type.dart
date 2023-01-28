import 'package:flutteradhouse/viewobject/color.dart';
import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class PostType extends PsObject<PostType> {
  PostType({
    this.id,
    this.name,
    this.postByUserId,
    this.status,
    this.addedDate,
    this.addedUserId,
    this.updatedDate,
    this.updatedUserId,
    this.updatedFlag,
    this.addedDateStr,
    this.colors,
  });

  String? id;
  String? name;
  String? postByUserId;
  String? status;
  String? addedDate;
  String? addedUserId;
  String? updatedDate;
  String? updatedUserId;
  String? updatedFlag;
  String? addedDateStr;
  Colors? colors;

  @override
  bool operator ==(dynamic other) => other is PostType && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  PostType fromMap(dynamic dynamicData) {
    //if (dynamicData != null) {
      return PostType(
          id: dynamicData['id'],
          name: dynamicData['name'],
          postByUserId: dynamicData['post_by_user_id'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          updatedUserId: dynamicData['updated_user_id'],
          updatedFlag: dynamicData['updated_flag'],
          addedDateStr: dynamicData['added_date_str'],
          colors: Colors().fromMap(dynamicData['colors']));
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(PostType? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['post_by_user_id'] = object.postByUserId;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['added_date_str'] = object.addedDateStr;
      data['colors'] = Colors().toMap(object.colors);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<PostType> fromMapList(List<dynamic> dynamicDataList) {
    final List<PostType> postTypeList = <PostType>[];
    //if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          postTypeList.add(fromMap(dynamicData));
        }
      }
   // }
    return postTypeList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<PostType> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
    //if (mapList != null) {
      for (PostType? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
   // }

    return mapList;
  }
}
