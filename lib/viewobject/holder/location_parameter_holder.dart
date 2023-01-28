import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/viewobject/common/ps_holder.dart';

class LocationParameterHolder extends PsHolder<dynamic> {
  LocationParameterHolder() {
    keyword = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
  }

  String? keyword;
  String? orderBy;
  String? orderType;

  LocationParameterHolder getDefaultParameterHolder() {
    keyword = '';
    orderBy = PsConst.FILTERING__ORDERING;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  LocationParameterHolder getLatestParameterHolder() {
    keyword = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['keyword'] = keyword;
    map['order_by'] = orderBy;
    map['order_type'] = orderType;

    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    keyword = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;

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

    return key;
  }
}
