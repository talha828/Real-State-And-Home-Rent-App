import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class UserReportItemParameterHolder
    extends PsHolder<UserReportItemParameterHolder> {
  UserReportItemParameterHolder({
    required this.itemId,
    required this.reportedUserId,
  });

  final String? itemId;
  final String? reportedUserId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['item_id'] = itemId;
    map['reported_user_id'] = reportedUserId;
    return map;
  }

  @override
  UserReportItemParameterHolder fromMap(dynamic dynamicData) {
    return UserReportItemParameterHolder(
      itemId: dynamicData['item_id'],
      reportedUserId: dynamicData['reported_user_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (reportedUserId != '') {
      key += reportedUserId!;
    }
    if (itemId != '') {
      key += itemId!;
    }

    return key;
  }
}
