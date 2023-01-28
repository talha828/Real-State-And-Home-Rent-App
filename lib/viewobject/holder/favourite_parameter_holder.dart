import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class FavouriteParameterHolder extends PsHolder<FavouriteParameterHolder> {
  FavouriteParameterHolder({
    required this.itemId,
    required this.userId,
  });

  final String? itemId;
  final String? userId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['item_id'] = itemId;
    map['user_id'] = userId;
    return map;
  }

  @override
  FavouriteParameterHolder fromMap(dynamic dynamicData) {
    return FavouriteParameterHolder(
      itemId: dynamicData['item_id'],
      userId: dynamicData['user_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId!;
    }
    if (itemId != '') {
      key += itemId!;
    }

    return key;
  }
}
