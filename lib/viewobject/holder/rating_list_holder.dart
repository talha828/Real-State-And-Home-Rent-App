import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class RatingListHolder extends PsHolder<RatingListHolder> {
  RatingListHolder({required this.userId});

  final String? userId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;

    return map;
  }

  @override
  RatingListHolder fromMap(dynamic dynamicData) {
    return RatingListHolder(
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
