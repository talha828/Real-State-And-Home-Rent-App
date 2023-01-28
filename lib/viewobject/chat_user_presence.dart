import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class ChatUserPresence extends PsObject<ChatUserPresence> {
  ChatUserPresence({this.userId, this.userName});

  String? userId;
  String? userName;

  @override
  bool operator ==(dynamic other) =>
      other is ChatUserPresence && userId == other.userId;

  @override
  int get hashCode => hash2(userId.hashCode, userId.hashCode);

  @override
  String? getPrimaryKey() {
    return userId;
  }

  @override
  List<ChatUserPresence> fromMapList(List<dynamic> dynamicDataList) {
    final List<ChatUserPresence> subpropertyByList = <ChatUserPresence>[];

  //  if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subpropertyByList.add(fromMap(dynamicData));
        }
      }
    //}
    return subpropertyByList;
  }

  @override
  ChatUserPresence fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return ChatUserPresence(
          userId: dynamicData['userId'], userName: dynamicData['userName']);
    // } else {
    //   return null;
    // }
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<ChatUserPresence> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
    //if (objectList != null) {
      for (ChatUserPresence? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
   //   }
    }
    return mapList;
  }

  @override
  Map<String, dynamic>? toMap(ChatUserPresence? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['userId'] = object.userId;
      data['userName'] = object.userName;

      return data;
    } else {
      return null;
    }
  }
}
