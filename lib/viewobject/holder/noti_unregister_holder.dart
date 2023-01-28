import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class NotiUnRegisterParameterHolder
    extends PsHolder<NotiUnRegisterParameterHolder> {
  NotiUnRegisterParameterHolder(
      {required this.platformName, required this.deviceId, this.userId});

  final String? platformName;
  final String? deviceId;
  final String? userId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['platform_name'] = platformName;
    map['device_token'] = deviceId;
    map['user_id'] = userId;

    return map;
  }

  @override
  NotiUnRegisterParameterHolder fromMap(dynamic dynamicData) {
    return NotiUnRegisterParameterHolder(
        platformName: dynamicData['platform_name'],
        deviceId: dynamicData['device_token'],
        userId: dynamicData['user_id']);
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
    return key;
  }
}
