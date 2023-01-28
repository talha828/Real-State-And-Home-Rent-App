import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class UserBlockParameterHolder extends PsHolder<UserBlockParameterHolder> {
  UserBlockParameterHolder({
    required this.loginUserId,
    required this.addedUserId,
  });

  final String? loginUserId;
  final String? addedUserId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['from_block_user_id'] = loginUserId;
    map['to_block_user_id'] = addedUserId;
    return map;
  }

  @override
  UserBlockParameterHolder fromMap(dynamic dynamicData) {
    return UserBlockParameterHolder(
      loginUserId: dynamicData['from_block_user_id'],
      addedUserId: dynamicData['to_block_user_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (loginUserId != '') {
      key += loginUserId!;
    }
    if (addedUserId != '') {
      key += addedUserId!;
    }

    return key;
  }
}
