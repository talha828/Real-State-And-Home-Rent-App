import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class NotiRegisterParameterHolder
    extends PsHolder<NotiRegisterParameterHolder> {
  NotiRegisterParameterHolder(
      {required this.platformName,
      required this.deviceId,
      required this.loginUserId});

  final String? platformName;
  final String? deviceId;
  final String? loginUserId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['platform_name'] = platformName;
    map['device_token'] = deviceId;
    map['user_id'] = loginUserId;

    return map;
  }

  @override
  NotiRegisterParameterHolder fromMap(dynamic dynamicData) {
    return NotiRegisterParameterHolder(
      platformName: dynamicData['platform_name'],
      deviceId: dynamicData['device_token'],
      loginUserId: dynamicData['user_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (platformName != '') {
      key += platformName!;
    }
    if (deviceId != '') {
      key += deviceId!;
    }
    if (loginUserId != '') {
      key += loginUserId!;
    }
    return key;
  }
}
