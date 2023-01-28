import 'package:flutteradhouse/viewobject/common/ps_holder.dart';

class MarkSoldOutItemParameterHolder extends PsHolder<dynamic> {
  MarkSoldOutItemParameterHolder() {
    itemId = '';
  }

  String? itemId;

  MarkSoldOutItemParameterHolder markSoldOutItemHolder() {
    itemId = '';
    return this;
  }

  MarkSoldOutItemParameterHolder resetParameterHolder() {
    itemId = '';
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['item_id'] = itemId;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    itemId = '';
    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (itemId != '') {
      result += itemId! + ':';
    }
    return result;
  }
}
