import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class MakeMarkAsSoldParameterHolder
    extends PsHolder<MakeMarkAsSoldParameterHolder> {
  MakeMarkAsSoldParameterHolder({
    required this.itemId,
    required this.buyerUserId,
    required this.sellerUserId,
  });

  final String? itemId;
  final String? buyerUserId;
  final String? sellerUserId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['item_id'] = itemId;
    map['buyer_user_id'] = buyerUserId;
    map['seller_user_id'] = sellerUserId;
    return map;
  }

  @override
  MakeMarkAsSoldParameterHolder fromMap(dynamic dynamicData) {
    return MakeMarkAsSoldParameterHolder(
      itemId: dynamicData['item_id'],
      buyerUserId: dynamicData['buyer_user_id'],
      sellerUserId: dynamicData['seller_user_id'],
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

    return key;
  }
}
