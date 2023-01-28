import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class ResetUnreadMessageParameterHolder
    extends PsHolder<ResetUnreadMessageParameterHolder> {
  ResetUnreadMessageParameterHolder({
    required this.itemId,
    required this.buyerUserId,
    required this.sellerUserId,
    required this.type,
  });

  final String? itemId;
  final String? buyerUserId;
  final String? sellerUserId;
  final String? type;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['item_id'] = itemId;
    map['buyer_user_id'] = buyerUserId;
    map['seller_user_id'] = sellerUserId;
    map['type'] = type;
    return map;
  }

  @override
  ResetUnreadMessageParameterHolder fromMap(dynamic dynamicData) {
    return ResetUnreadMessageParameterHolder(
      itemId: dynamicData['item_id'],
      buyerUserId: dynamicData['buyer_user_id'],
      sellerUserId: dynamicData['seller_user_id'],
      type: dynamicData['type'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (itemId != '') {
      key += itemId!;
    }
    if (buyerUserId != '') {
      key += buyerUserId!;
    }
    if (sellerUserId != '') {
      key += sellerUserId!;
    }
    if (type != '') {
      key += type!;
    }

    return key;
  }
}
