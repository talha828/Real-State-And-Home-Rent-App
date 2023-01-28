import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class UserUnreadMessage extends PsObject<UserUnreadMessage> {
  UserUnreadMessage({
    this.id,
    this.blogNotiUnreadCount,
    this.buyerUnreadCount,
    this.sellerUnreadCount,
  });
  String? id;
  String? blogNotiUnreadCount;
  String? buyerUnreadCount;
  String? sellerUnreadCount;

  @override
  bool operator ==(dynamic other) =>
      other is UserUnreadMessage && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  UserUnreadMessage fromMap(dynamic dynamicData) {
    //if (dynamicData != null) {
      return UserUnreadMessage(
        id: dynamicData['id'],
        blogNotiUnreadCount: dynamicData['blog_noti_unread_count'],
        buyerUnreadCount: dynamicData['buyer_unread_count'],
        sellerUnreadCount: dynamicData['seller_unread_count'],
      );
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(UserUnreadMessage? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['blog_noti_unread_count'] = object.blogNotiUnreadCount;
      data['buyer_unread_count'] = object.buyerUnreadCount;
      data['seller_unread_count'] = object.sellerUnreadCount;

      return data;
    } else {
      return null;
    }
  }

  @override
  List<UserUnreadMessage> fromMapList(List<dynamic> dynamicDataList) {
    final List<UserUnreadMessage> blogList = <UserUnreadMessage>[];

    //if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          blogList.add(fromMap(dynamicData));
        }
      }
   // }
    return blogList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<UserUnreadMessage> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
   // if (objectList != null) {
      for (UserUnreadMessage? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
   // }
    return mapList;
  }
}
