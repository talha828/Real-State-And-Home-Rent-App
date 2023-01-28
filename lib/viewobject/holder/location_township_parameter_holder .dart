import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/viewobject/common/ps_holder.dart';

class TownshipLocationParameterHolder extends PsHolder<dynamic> {
  TownshipLocationParameterHolder() {
    keyword = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    cityId = '';
  }

  String? keyword;
  String? orderBy;
  String? orderType;
  String? cityId;

  TownshipLocationParameterHolder getDefaultParameterHolder() {
    keyword = '';
    orderBy = PsConst.FILTERING__ORDERING;
    orderType = PsConst.FILTERING__DESC;
    cityId = '';

    return this;
  }

  TownshipLocationParameterHolder getLatestParameterHolder() {
    keyword = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    cityId = '';

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['keyword'] = keyword;
    map['order_by'] = orderBy;
    map['order_type'] = orderType;
    map['city_id'] = cityId;

    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    keyword = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    cityId = '';

    return this;
  }

  @override
  String getParamKey() {
    String key = '';

    if (keyword != '') {
      key += keyword!;
    }
    if (orderBy != '') {
      key += orderBy!;
    }
    if (orderType != '') {
      key += orderType!;
    }
    if (cityId != '') {
      key += cityId!;
    }

    return key;
  }
}
