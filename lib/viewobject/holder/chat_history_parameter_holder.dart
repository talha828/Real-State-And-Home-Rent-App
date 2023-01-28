import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/viewobject/common/ps_holder.dart';

class ChatHistoryParameterHolder extends PsHolder<dynamic> {
  ChatHistoryParameterHolder() {
    userId = '';
    returnType = '';
  }

  String? userId;
  String? returnType;

  ChatHistoryParameterHolder getSellerHistoryList() {
    userId = '';
    returnType = PsConst.CHAT_TYPE_SELLER;

    return this;
  }

  ChatHistoryParameterHolder getBuyerHistoryList() {
    userId = '';
    returnType = PsConst.CHAT_TYPE_BUYER;

    return this;
  }

  ChatHistoryParameterHolder resetParameterHolder() {
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
