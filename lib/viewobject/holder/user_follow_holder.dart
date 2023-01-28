import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class UserFollowHolder extends PsHolder<UserFollowHolder> {
  UserFollowHolder({
    required this.userId,
    required this.followedUserId,
  });

  final String? userId;
  final String? followedUserId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['user_id'] = userId;
    map['followed_user_id'] = followedUserId;
    return map;
  }

  @override
  UserFollowHolder fromMap(dynamic dynamicData) {
    return UserFollowHolder(
      userId: dynamicData['user_id'],
      followedUserId: dynamicData['followed_user_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (followedUserId != '') {
      key += followedUserId!;
    }
    if (userId != '') {
      key += userId!;
    }

    return key;
  }
}
