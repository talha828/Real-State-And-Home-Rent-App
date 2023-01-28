import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class Message extends PsObject<Message?> {
  Message(
      {this.addedDate,
      this.id,
      this.isSold,
      this.isUserBought,
      this.itemId,
      this.message,
      this.offerStatus,
      this.sendByUserId,
      this.sessionId,
      this.type,
      this.addedDateTimeStamp});

  Map<String, String>? addedDate;
  int? addedDateTimeStamp;
  String? id;
  bool? isSold;
  bool? isUserBought;
  String? itemId;
  String? message;
  int? offerStatus;
  String? sendByUserId;
  String? sessionId;
  int? type;

  @override
  bool operator ==(dynamic other) =>
      other is Message && offerStatus == other.offerStatus;

  @override
  int get hashCode => hash2(offerStatus.hashCode, offerStatus.hashCode);

  @override
  String getPrimaryKey() {
    return offerStatus.toString();
  }

  @override
  List<Message?> fromMapList(List<dynamic> dynamicDataList) {
    final List<Message?> subCategoryList = <Message?>[];

    // if (dynamicDataList != null) {
    for (dynamic dynamicData in dynamicDataList) {
      if (dynamicData != null) {
        subCategoryList.add(fromMap(dynamicData));
      }
    }
    // }
    return subCategoryList;
  }

  @override
  Message? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Message(
        //addedDate: dynamicData['added_date'],
        addedDateTimeStamp: dynamicData['addedDate'],
        id: dynamicData['id'],
        isSold: dynamicData['isSold'],
        isUserBought: dynamicData['isUserBought'],
        itemId: dynamicData['itemId'],
        message: dynamicData['message'],
        offerStatus: dynamicData['offerStatus'],
        sendByUserId: dynamicData['sendByUserId'],
        sessionId: dynamicData['sessionId'],
        type: dynamicData['type'],
      );
    } else {
      return null;
    }
  }

  Map<String, dynamic> toInsertMap(Message object) {
    // if (object != null) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addedDate'] = object.addedDate;
    data['id'] = object.id;
    data['isSold'] = object.isSold;
    data['isUserBought'] = object.isUserBought;
    data['itemId'] = object.itemId;
    data['message'] = object.message;
    data['offerStatus'] = object.offerStatus;
    data['sendByUserId'] = object.sendByUserId;
    data['sessionId'] = object.sessionId;
    data['type'] = object.type;
    return data;
    // } else {
    //   return <String, dynamic>{};
    // }
  }

  Map<String, dynamic> toDeleteMap(Message object) {
    // if (object != null) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addedDate'] = object.addedDate;
    data['id'] = object.id;
    data['isSold'] = object.isSold;
    data['isUserBought'] = object.isUserBought;
    data['itemId'] = object.itemId;
    data['message'] = object.message;
    data['offerStatus'] = object.offerStatus;
    data['sendByUserId'] = object.sendByUserId;
    data['sessionId'] = object.sessionId;
    data['type'] = object.type;
    return data;
    // } else {
    //   return <String, dynamic>{};
    // }
  }

  Map<String, dynamic> toUpdateMap(Message object) {
    // if (object != null) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addedDate'] = object.addedDateTimeStamp;
    data['id'] = object.id;
    data['isSold'] = object.isSold;
    data['isUserBought'] = object.isUserBought;
    data['itemId'] = object.itemId;
    data['message'] = object.message;
    data['offerStatus'] = object.offerStatus;
    data['sendByUserId'] = object.sendByUserId;
    data['sessionId'] = object.sessionId;
    data['type'] = object.type;
    return data;
    // } else {
    //   return <String, dynamic>{};
    // }
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<Message?> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
    // if (objectList != null) {
    for (Message? data in objectList) {
      if (data != null) {
        mapList.add(toMap(data));
      }
    }
    // }
    return mapList;
  }

  @override
  Map<String, dynamic>? toMap(Message? object) {
    return null;
  }
}
