import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class UserDeleteItemParameterHolder
    extends PsHolder<UserDeleteItemParameterHolder> {
  UserDeleteItemParameterHolder({
    required this.itemId,
  });

  final String? itemId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['item_id'] = itemId;
    return map;
  }

  @override
  UserDeleteItemParameterHolder fromMap(dynamic dynamicData) {
    return UserDeleteItemParameterHolder(
      itemId: dynamicData['item_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (itemId != '') {
      key += itemId!;
    }

    return key;
  }
}
