import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/viewobject/common/ps_holder.dart';

class OfferParameterHolder extends PsHolder<dynamic> {
  OfferParameterHolder() {
    userId = '';
    returnType = '';
  }

  String? userId;
  String? returnType;

  OfferParameterHolder getOfferSentList() {
    userId = '';
    returnType = PsConst.CHAT_TYPE_SELLER;

    return this;
  }

  OfferParameterHolder getOfferReceivedList() {
    userId = '';
    returnType = PsConst.CHAT_TYPE_BUYER;

    return this;
  }

  OfferParameterHolder resetParameterHolder() {
    userId = '';
    returnType = '';

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['user_id'] = userId;
    map['return_type'] = returnType;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    userId = '';
    returnType = '';

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (userId != '') {
      result += userId! + ':';
    }
    if (returnType != '') {
      result += returnType! + ':';
    }
    return result;
  }
}
