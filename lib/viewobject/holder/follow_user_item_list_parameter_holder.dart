import 'package:flutteradhouse/viewobject/common/ps_holder.dart';

class FollowUserItemParameterHolder extends PsHolder<dynamic> {
  FollowUserItemParameterHolder() {
    itemLocationId = '';
    itemLocationTownshipId = '';
  }

  String? itemLocationId;
  String? itemLocationTownshipId;

  FollowUserItemParameterHolder getTrendingParameterHolder() {
    itemLocationId = '';
    itemLocationTownshipId = '';

    return this;
  }

  FollowUserItemParameterHolder getLatestParameterHolder() {
    itemLocationId = '';
    itemLocationTownshipId = '';

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['item_location_id'] = itemLocationId;
    map['item_location_township_id'] = itemLocationTownshipId;

    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    itemLocationId = '';
    itemLocationTownshipId = '';

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (itemLocationId != '') {
      result += itemLocationId! + ':';
    }
    if (itemLocationTownshipId != '') {
      result += itemLocationTownshipId!;
    }

    return result;
  }
}
