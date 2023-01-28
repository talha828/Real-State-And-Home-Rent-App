import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/viewobject/common/ps_holder.dart';

class UserParameterHolder extends PsHolder<dynamic> {
  UserParameterHolder() {
    id = '';
    overallRating = '';
    returnTypes = '';
    loginUserId = '';
    userName = '';
  }

  String? id;
  String? overallRating;
  String? returnTypes;
  String? loginUserId;
  String? userName;

  bool isCatAndSubCatFiltered() {
    return !(overallRating == '' && returnTypes == '');
  }

  UserParameterHolder getFollowingUsers() {
    id = '';
    overallRating = '';
    returnTypes = PsConst.FILTERING__FOLLOWING;
    loginUserId = '';
    userName = '';

    return this;
  }

  UserParameterHolder getFollowerUsers() {
    id = '';
    overallRating = '';
    returnTypes = PsConst.FILTERING__FOLLOWER;
    loginUserId = '';
    userName = '';

    return this;
  }

  UserParameterHolder getOtherUserData() {
    id = '';
    overallRating = '';
    returnTypes = '';
    loginUserId = '';
    userName = '';

    return this;
  }

  UserParameterHolder resetParameterHolder() {
    id = '';
    overallRating = '';
    returnTypes = '';
    loginUserId = '';
    userName = '';

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['overall_rating'] = overallRating;
    map['return_types'] = returnTypes;
    map['login_user_id'] = loginUserId;
    map['user_name'] = userName;

    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    id = '';
    overallRating = '';
    returnTypes = '';
    loginUserId = '';
    userName = '';

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (id != '') {
      result += id! + ':';
    }
    if (overallRating != '') {
      result += overallRating! + ':';
    }
    if (returnTypes != '') {
      result += returnTypes! + ':';
    }
    if (loginUserId != '') {
      result += loginUserId! + ':';
    }
    if (userName != '') {
      result += userName! + ':';
    }

    return result;
  }
}
