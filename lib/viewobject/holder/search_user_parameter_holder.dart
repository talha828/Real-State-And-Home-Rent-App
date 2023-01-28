

import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/viewobject/common/ps_holder.dart';

class SearchUserParameterHolder extends PsHolder<dynamic> {
  SearchUserParameterHolder() {
    orderBy = PsConst.FILTERING__USER_NAME;
    orderType = PsConst.FILTERING__DESC;
    keyword = '';
  }

  String? orderBy;
  String? orderType;
  String? keyword;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['order_by'] = orderBy;
    map['order_type'] = orderType;
    map['keyword'] = keyword;

    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    orderBy = dynamicData['keyword'];

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (orderBy != '') {
      result += orderBy! + ':';
    }
    if (orderType != '') {
      result += orderType! + ':';
    }
    if (keyword != '') {
      result += keyword!;
    }

    return result;
  }
}
