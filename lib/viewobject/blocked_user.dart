import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:flutteradhouse/viewobject/rating_detail.dart';
import 'package:quiver/core.dart';

class BlockedUser extends PsObject<BlockedUser> {
  BlockedUser(
      {this.userId,
      this.userIsSysAdmin,
      this.facebookId,
      this.googleId,
      this.phoneId,
      this.userName,
      this.userEmail,
      this.userPhone,
      this.userAddress,
      this.userLat,
      this.userLng,
      this.city,
      this.userPassword,
      this.userAboutMe,
      this.userCoverPhoto,
      this.userProfilePhoto,
      this.roleId,
      this.status,
      this.isBanned,
      this.addedDate,
      this.deviceToken,
      this.code,
      this.applicationStatus,
      this.applyTo,
      this.userType,
      this.overallRating,
      this.whatsapp,
      this.messenger,
      this.followerCount,
      this.followingCount,
      this.emailVerify,
      this.facebookVerify,
      this.googleVerify,
      this.phoneVerify,
      this.ratingCount,
      this.isFollowed,
      this.ratingDetail,
      this.isFavourited,
      this.isOwner});
  String? userId;
  String? userIsSysAdmin;
  String? facebookId;
  String? googleId;
  String? phoneId;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userAddress;
  String? userLat;
  String? userLng;
  String? city;
  String? userPassword;
  String? userAboutMe;
  String? userCoverPhoto;
  String? userProfilePhoto;
  String? roleId;
  String? status;
  String? isBanned;
  String? addedDate;
  String? deviceToken;
  String? code;
  String? applicationStatus;
  String? applyTo;
  String? userType;
  String? overallRating;
  String? whatsapp;
  String? messenger;
  String? followerCount;
  String? followingCount;
  String? emailVerify;
  String? facebookVerify;
  String? googleVerify;
  String? phoneVerify;
  String? ratingCount;
  String? isFollowed;
  RatingDetail? ratingDetail;
  String? isFavourited;
  String? isOwner;

  @override
  bool operator ==(dynamic other) =>
      other is BlockedUser && userId == other.userId;

  @override
  int get hashCode {
    return hash2(userId.hashCode, userId.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return userId;
  }

  @override
  BlockedUser fromMap(dynamic dynamicData) {
    //if (dynamicData != null) {
      return BlockedUser(
        userId: dynamicData['user_id'],
        userIsSysAdmin: dynamicData['user_is_sys_admin'],
        facebookId: dynamicData['facebook_id'],
        googleId: dynamicData['google_id'],
        phoneId: dynamicData['phone_id'],
        userName: dynamicData['user_name'],
        userEmail: dynamicData['user_email'],
        userPhone: dynamicData['user_phone'],
        userAddress: dynamicData['user_address'],
        userLat: dynamicData['user_lat'],
        userLng: dynamicData['user_lng'],
        city: dynamicData['city'],
        userPassword: dynamicData['user_password'],
        userAboutMe: dynamicData['user_about_me'],
        userCoverPhoto: dynamicData['user_cover_photo'],
        userProfilePhoto: dynamicData['user_profile_photo'],
        roleId: dynamicData['role_id'],
        status: dynamicData['status'],
        isBanned: dynamicData['is_banned'],
        addedDate: dynamicData['added_date'],
        deviceToken: dynamicData['device_token'],
        code: dynamicData['code'],
        applicationStatus: dynamicData['application_status'],
        applyTo: dynamicData['apply_to'],
        userType: dynamicData['user_type'],
        overallRating: dynamicData['overall_rating'],
        whatsapp: dynamicData['whatsapp'],
        messenger: dynamicData['messenger'],
        followerCount: dynamicData['follower_count'],
        followingCount: dynamicData['following_count'],
        emailVerify: dynamicData['email_verify'],
        facebookVerify: dynamicData['facebook_verify'],
        googleVerify: dynamicData['google_verify'],
        phoneVerify: dynamicData['phone_verify'],
        ratingCount: dynamicData['rating_count'],
        isFollowed: dynamicData['is_followed'],
        ratingDetail: RatingDetail().fromMap(dynamicData['rating_details']),
        isFavourited: dynamicData['is_favourited'],
        isOwner: dynamicData['is_owner'],
        // city: ShippingCity().fromMap(dynamicData['city'])
      );
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(BlockedUser? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['user_id'] = object.userId;
      data['user_is_sys_admin'] = object.userIsSysAdmin;
      data['facebook_id'] = object.facebookId;
      data['google_id'] = object.googleId;
      data['phone_id'] = object.phoneId;
      data['user_name'] = object.userName;
      data['user_email'] = object.userEmail;
      data['user_phone'] = object.userPhone;
      data['user_address'] = object.userAddress;
      data['user_lat'] = object.userLat;
      data['user_lng'] = object.userLng;
      data['city'] = object.city;
      data['user_password'] = object.userPassword;
      data['user_about_me'] = object.userAboutMe;
      data['user_cover_photo'] = object.userCoverPhoto;
      data['user_profile_photo'] = object.userProfilePhoto;
      data['role_id'] = object.roleId;
      data['status'] = object.status;
      data['is_banned'] = object.isBanned;
      data['added_date'] = object.addedDate;
      data['device_token'] = object.deviceToken;
      data['code'] = object.code;
      data['application_status'] = object.applicationStatus;
      data['apply_to'] = object.applyTo;
      data['user_type'] = object.userType;
      data['overall_rating'] = object.overallRating;
      data['whatsapp'] = object.whatsapp;
      data['messenger'] = object.messenger;
      data['follower_count'] = object.followerCount;
      data['following_count'] = object.followingCount;
      data['email_verify'] = object.emailVerify;
      data['facebook_verify'] = object.facebookVerify;
      data['google_verify'] = object.googleVerify;
      data['phone_verify'] = object.phoneVerify;
      data['rating_count'] = object.ratingCount;
      data['is_followed'] = object.isFollowed;
      data['rating_details'] = RatingDetail().toMap(object.ratingDetail);
      data['is_favourited'] = object.isFavourited;
      data['is_owner'] = object.isOwner;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<BlockedUser> fromMapList(List<dynamic> dynamicDataList) {
    final List<BlockedUser> subUserList = <BlockedUser>[];

   // if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subUserList.add(fromMap(dynamicData));
        }
      }
   // }
    return subUserList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<BlockedUser> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
    //if (objectList != null) {
      for (BlockedUser? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
   // }

    return mapList;
  }
}
