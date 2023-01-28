import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class TouchCountParameterHolder extends PsHolder<TouchCountParameterHolder> {
  TouchCountParameterHolder({required this.itemId, required this.userId});

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
  TouchCountParameterHolder fromMap(dynamic dynamicData) {
    return TouchCountParameterHolder(
      itemId: dynamicData['item_id'],
      userId: dynamicData['user_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (itemId != '') {
      key += itemId!;
    }

    if (userId != '') {
      key += userId!;
    }
    return key;
  }
}
