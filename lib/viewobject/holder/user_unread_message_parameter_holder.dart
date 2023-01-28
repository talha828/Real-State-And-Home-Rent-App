import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class UserUnreadMessageParameterHolder
    extends PsHolder<UserUnreadMessageParameterHolder> {
  UserUnreadMessageParameterHolder({
    required this.userId,
    required this.deviceToken,
  });

  final String? userId;
  final String? deviceToken;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['user_id'] = userId;
    map['device_token'] = deviceToken;
    return map;
  }

  @override
  UserUnreadMessageParameterHolder fromMap(dynamic dynamicData) {
    return UserUnreadMessageParameterHolder(
      userId: dynamicData['user_id'],
      deviceToken: dynamicData['device_token'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId ?? '';
    }
    if (deviceToken != '') {
      key += deviceToken ?? '';
    }

    return key;
  }
}
