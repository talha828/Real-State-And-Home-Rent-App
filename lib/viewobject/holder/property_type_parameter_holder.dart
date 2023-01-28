import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/viewobject/common/ps_holder.dart';

class PropertyTypeParameterHolder extends PsHolder<dynamic> {
  PropertyTypeParameterHolder() {
    searchTerm = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
  }
  
  String? searchTerm;
  String? orderBy;
  String? orderType;

  PropertyTypeParameterHolder getTrendingParameterHolder() {
    searchTerm = '';
    orderBy = PsConst.FILTERING__TRENDING;
     orderType = PsConst.FILTERING__DESC;

    return this;
  }

  PropertyTypeParameterHolder getLatestParameterHolder() {
    searchTerm = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
     orderType = PsConst.FILTERING__DESC;

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    
    map['searchterm']= searchTerm;
    map['order_by'] = orderBy;
    map['order_type'] = orderType;


    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    searchTerm = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  @override
  String getParamKey() {
 
    String result = '';

    if (searchTerm != '') {
      result += searchTerm! + ':';
    }

    if (orderBy != '') {
      result += orderBy! + ':';
    }

        if (orderType != '') {
      result += orderType!;
    }

    return result;
  }
}
