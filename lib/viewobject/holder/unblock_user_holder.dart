import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class UnblockUserHolder extends PsHolder<UnblockUserHolder> {
  UnblockUserHolder({
    required this.fromBlockUserId,
    required this.toBlockUserId,
  });

  final String? fromBlockUserId;
  final String? toBlockUserId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['from_block_user_id'] = fromBlockUserId;
    map['to_block_user_id'] = toBlockUserId;
    return map;
  }

  @override
  UnblockUserHolder fromMap(dynamic dynamicData) {
    return UnblockUserHolder(
      fromBlockUserId: dynamicData['from_block_user_id'],
      toBlockUserId: dynamicData['to_block_user_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (fromBlockUserId != '') {
      key += fromBlockUserId!;
    }
    if (toBlockUserId != '') {
      key += toBlockUserId!;
    }

    return key;
  }
}
