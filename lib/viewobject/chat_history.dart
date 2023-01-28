import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:flutteradhouse/viewobject/user.dart';
import 'package:quiver/core.dart';

import 'default_photo.dart';

class ChatHistory extends PsObject<ChatHistory> {
  ChatHistory({
    this.id,
    this.itemId,
    this.buyerUserId,
    this.sellerUserId,
    this.negoPrice,
    this.buyerUnreadCount,
    this.sellerUnreadCount,
    this.isAccept,
    this.addedDate,
    this.isOffer,
    this.offerAmount,
    this.addedDateStr,
    this.photoCount,
    this.isFavourited,
    this.isOwner,
    this.defaultPhoto,
    this.item,
    this.buyer,
    this.seller,
  });

  String? id;
  String? itemId;
  String? buyerUserId;
  String? sellerUserId;
  String? negoPrice;
  String? buyerUnreadCount;
  String? sellerUnreadCount;
  String? isAccept;
  String? addedDate;
  String? isOffer;
  String? offerAmount;
  String? addedDateStr;
  String? photoCount;
  String? isFavourited;
  String? isOwner;
  DefaultPhoto?defaultPhoto;
  Product? item;
  User? buyer;
  User? seller;
  @override
  bool operator ==(dynamic other) => other is ChatHistory && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  ChatHistory fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return ChatHistory(
        id: dynamicData['id'],
        itemId: dynamicData['item_id'],
        buyerUserId: dynamicData['buyer_user_id'],
        sellerUserId: dynamicData['seller_user_id'],
        negoPrice: dynamicData['nego_price'],
        buyerUnreadCount: dynamicData['buyer_unread_count'],
        sellerUnreadCount: dynamicData['seller_unread_count'],
        isAccept: dynamicData['is_accept'],
        addedDate: dynamicData['added_date'],
        isOffer: dynamicData['is_offer'],
        offerAmount: dynamicData['offer_amount'],
        photoCount: dynamicData['photo_count'],
        addedDateStr: dynamicData['added_date_str'],
        isFavourited: dynamicData['is_favourited'],
        isOwner: dynamicData['is_owner'],
        defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
        item: Product().fromMap(dynamicData['item']),
        buyer: User().fromMap(dynamicData['buyer']),
        seller: User().fromMap(dynamicData['seller']),
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
      data['item_id'] = object.itemId;
      data['buyer_user_id'] = object.buyerUserId;
      data['seller_user_id'] = object.sellerUserId;
      data['nego_price'] = object.negoPrice;
      data['buyer_unread_count'] = object.buyerUnreadCount;
      data['seller_unread_count'] = object.sellerUnreadCount;
      data['is_accept'] = object.isAccept;
      data['added_date'] = object.addedDate;
      data['is_offer'] = object.isOffer;
      data['offer_amount'] = object.offerAmount;
      data['added_date_str'] = object.addedDateStr;
      data['photo_count'] = object.photoCount;
      data['is_favourited'] = object.isFavourited;
      data['is_owner'] = object.isOwner;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      data['item'] = Product().toMap(object.item);
      data['buyer'] = User().toMap(object.buyer);
      data['seller'] = User().toMap(object.seller);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ChatHistory> fromMapList(List<dynamic> dynamicDataList) {
    final List<ChatHistory> newFeedList = <ChatHistory>[];
   // if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          newFeedList.add(fromMap(json));
        }
   //   }
    }
    return newFeedList;
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
    //}
    return dynamicList;
  }
}
