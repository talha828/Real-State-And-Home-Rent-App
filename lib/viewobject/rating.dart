import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:flutteradhouse/viewobject/user.dart';
import 'package:quiver/core.dart';

class Rating extends PsObject<Rating> {
  Rating(
      {this.id,
      this.fromUserId,
      this.toUserId,
      this.rating,
      this.title,
      this.description,
      this.addedDate,
      this.addedDateStr,
      this.fromUser,
      this.toUser});
  String? id;
  String? fromUserId;
  String? toUserId;
  String? rating;
  String? title;
  String? description;
  String? addedDate;
  String? addedDateStr;
  User? fromUser;
  User? toUser;

  @override
  bool operator ==(dynamic other) => other is Rating && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  Rating fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return Rating(
        id: dynamicData['id'],
        fromUserId: dynamicData['from_user_id'],
        toUserId: dynamicData['to_user_id'],
        rating: dynamicData['rating'],
        title: dynamicData['title'],
        description: dynamicData['description'],
        addedDate: dynamicData['added_date'],
        addedDateStr: dynamicData['added_date_str'],
        fromUser: User().fromMap(dynamicData['from_user']),
        toUser: User().fromMap(dynamicData['to_user']),
      );
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(Rating? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['from_user_id'] = object.fromUserId;
      data['to_user_id'] = object.toUserId;
      data['rating'] = object.rating;
      data['title'] = object.title;
      data['description'] = object.description;
      data['added_date'] = object.addedDate;
      data['from_user'] = User().toMap(object.fromUser);
      data['to_user'] = User().toMap(object.toUser);
      data['added_date_str'] = object.addedDateStr;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Rating> fromMapList(List<dynamic> dynamicDataList) {
    final List<Rating> commentList = <Rating>[];

   // if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          commentList.add(fromMap(dynamicData));
        }
      }
    //}
    return commentList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<Rating> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
  //  if (objectList != null) {
      for (Rating? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
   // }

    return mapList;
  }
}
