import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class DeleteUserHolder extends PsHolder<DeleteUserHolder> {
  DeleteUserHolder({
    required this.userId,
  });

  final String? userId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    return map;
  }

  @override
  DeleteUserHolder fromMap(dynamic dynamicData) {
    return DeleteUserHolder(
      userId: dynamicData['user_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId!;
    }

    return key;
  }
}
