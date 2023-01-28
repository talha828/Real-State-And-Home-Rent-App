import 'package:flutteradhouse/viewobject/common/ps_holder.dart'
    show PsHolder;

class MakeIsUserBoughtParameterHolder
    extends PsHolder<MakeIsUserBoughtParameterHolder> {
  MakeIsUserBoughtParameterHolder({
    required this.itemId,
    required this.buyerUserId,
    required this.sellerUserId,
    required this.isUserOnline,
  });

  final String? itemId;
  final String? buyerUserId;
  final String? sellerUserId;
  final String? isUserOnline;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['item_id'] = itemId;
    map['buyer_user_id'] = buyerUserId;
    map['seller_user_id'] = sellerUserId;
    map['is_user_online'] = isUserOnline;
    return map;
  }

  @override
  MakeIsUserBoughtParameterHolder fromMap(dynamic dynamicData) {
    return MakeIsUserBoughtParameterHolder(
        itemId: dynamicData['item_id'],
        buyerUserId: dynamicData['buyer_user_id'],
        sellerUserId: dynamicData['seller_user_id'],
        isUserOnline: dynamicData['is_user_online']);
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
    if (isUserOnline != '') {
      key += isUserOnline!;
    }

    return key;
  }
}