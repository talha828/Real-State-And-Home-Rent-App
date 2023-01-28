import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class RatingParameterHolder extends PsHolder<RatingParameterHolder> {
  RatingParameterHolder({
    required this.fromUserId,
    required this.toUserId,
    required this.title,
    required this.description,
    required this.rating,
  });

  final String? fromUserId;
  final String? toUserId;
  final String? title;
  final String? description;
  final String? rating;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['from_user_id'] = fromUserId;
    map['to_user_id'] = toUserId;
    map['title'] = title;
    map['description'] = description;
    map['rating'] = rating;

    return map;
  }

  @override
  RatingParameterHolder fromMap(dynamic dynamicData) {
    return RatingParameterHolder(
      fromUserId: dynamicData['from_user_id'],
      toUserId: dynamicData['to_user_id'],
      title: dynamicData['title'],
      description: dynamicData['description'],
      rating: dynamicData['rating'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (fromUserId != '') {
      key += fromUserId!;
    }
    if (toUserId != '') {
      key += toUserId!;
    }

    if (title != '') {
      key += title!;
    }
    if (description != '') {
      key += description!;
    }
    if (rating != '') {
      key += rating!;
    }
    return key;
  }
}
