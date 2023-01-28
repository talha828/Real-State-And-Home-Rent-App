import 'package:flutteradhouse/viewobject/common/language.dart';
import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart' show hash2;

class PSMobileConfigSetting extends PsObject<PSMobileConfigSetting?> {
  PSMobileConfigSetting({
    this.googlePlayStoreUrl,
    this.appleAppStoreUrl,
    this.priceFormat,
    this.dateFormat,
    this.iosAppStoreId,
    this.isUseThumbnailAsPlaceHolder,
    this.isShowTokenId,
    this.isShowSubcategory,
    this.fbKey,
    this.isShowAdmob,
    this.defaultLoadingLimit,
    this.categoryLoadingLimit,
    this.postedByLoadingLimit,
    this.agentLoadingLimit,
    this.amenitiesLoadingLimit,
    this.recentItemLoadingLimit,
    this.populartItemLoadingLimit,
    this.discountItemLoadingLimit,
    this.featuredItemLoadingLimit,
    this.blockSliderLoadingLimit,
    this.followerItemLoadingLimit,
    this.blockItemLoadingLimit,
    this.showFacebookLogin,
    this.showGoogleLogin,
    this.showPhoneLogin,
    this.isRazorSupportMultiCurrency,
    this.defaultRazorCurrency,
    this.itemDetailViewCountForAds,
    this.isShowAdsInItemDetail,
    this.isShowAdmobInsideList,
    this.bluemarkSize,
    this.mile,
    this.videoDuration,
    this.isUseGoogleMap,
    this.profileImageSize,
    this.uploadImageSize,
    this.chatImageSize,
    this.promoteFirstChoiceDay,
    this.promoteSecondChoiceDay,
    this.promoteThirdChoiceDay,
    this.promoteFourthChoiceDay,
    this.noFilterWithLocationOnMap,
    this.isShowOwnerInfo,
    this.isForceLogin,
    this.isLanguageConfig,
    this.defaultLanguage,
    this.excludedLanguages,
  });

      
  String? googlePlayStoreUrl;
  String? appleAppStoreUrl;
  String? priceFormat;
  String? dateFormat;
  String? iosAppStoreId;
  String? isUseThumbnailAsPlaceHolder;
  String? isShowTokenId;
  String? isShowSubcategory;
  String? fbKey;
  String? isShowAdmob;
  String? defaultLoadingLimit;
  String? categoryLoadingLimit;
  String? postedByLoadingLimit;
  String? agentLoadingLimit;
  String? amenitiesLoadingLimit;
  String? recentItemLoadingLimit;
  String? populartItemLoadingLimit;
  String? discountItemLoadingLimit;
  String? featuredItemLoadingLimit;
  String? blockSliderLoadingLimit;
  String? followerItemLoadingLimit;
  String? blockItemLoadingLimit;
  String? showFacebookLogin;
  String? showGoogleLogin;
  String? showPhoneLogin;
  String? isRazorSupportMultiCurrency;
  String? defaultRazorCurrency;
  String? itemDetailViewCountForAds;
  String? isShowAdsInItemDetail;
  String? isShowAdmobInsideList;
  String? bluemarkSize;
  String? mile;
  String? videoDuration;
  String? isUseGoogleMap;
  String? profileImageSize;
  String? uploadImageSize;
  String? chatImageSize;
  String? promoteFirstChoiceDay;
  String? promoteSecondChoiceDay;
  String? promoteThirdChoiceDay;
  String? promoteFourthChoiceDay;
  String? noFilterWithLocationOnMap;
  String? isShowOwnerInfo;
  String? isForceLogin;
  String? isLanguageConfig;
  Language? defaultLanguage;
  List<Language?>? excludedLanguages;

  @override
  bool operator ==(dynamic other) =>
      other is PSMobileConfigSetting && googlePlayStoreUrl == other.googlePlayStoreUrl;

  @override
  int get hashCode => hash2(googlePlayStoreUrl.hashCode, googlePlayStoreUrl.hashCode);

  @override
  String? getPrimaryKey() {
    return googlePlayStoreUrl;
  }

  @override
  PSMobileConfigSetting? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return PSMobileConfigSetting(
          googlePlayStoreUrl : dynamicData['google_playstore_url'],
          appleAppStoreUrl : dynamicData['apple_appstore_url'],
          priceFormat : dynamicData['price_format'],
          dateFormat : dynamicData['date_format'],
          iosAppStoreId : dynamicData['ios_appstore_id'],
          isUseThumbnailAsPlaceHolder : dynamicData['is_use_thumbnail_as_placeholder'],
          isShowTokenId : dynamicData['is_show_token_id'],
          isShowSubcategory : dynamicData['is_show_subcategory'],
          fbKey : dynamicData['fb_key'],
          isShowAdmob : dynamicData['is_show_admob'],
          defaultLoadingLimit : dynamicData['default_loading_limit'],
          categoryLoadingLimit : dynamicData['category_loading_limit'],
          postedByLoadingLimit : dynamicData['posted_by_loading_limit'],
          agentLoadingLimit : dynamicData['agent_loading_limit'],
          amenitiesLoadingLimit : dynamicData['amenities_loading_limit'],
          recentItemLoadingLimit : dynamicData['recent_item_loading_limit'],
          populartItemLoadingLimit : dynamicData['popular_item_loading_limit'],
          discountItemLoadingLimit : dynamicData['discount_item_loading_limit'],
          featuredItemLoadingLimit : dynamicData['feature_item_loading_limit'],
          blockSliderLoadingLimit : dynamicData['block_slider_loading_limit'],
          followerItemLoadingLimit : dynamicData['follower_item_loading_limit'],
          blockItemLoadingLimit : dynamicData['block_item_loading_limit'],
          showFacebookLogin : dynamicData['show_facebook_login'],
          showGoogleLogin : dynamicData['show_google_login'],
          showPhoneLogin : dynamicData['show_phone_login'],
          isRazorSupportMultiCurrency : dynamicData['is_razor_support_multi_currency'],
          defaultRazorCurrency : dynamicData['default_razor_currency'],
          itemDetailViewCountForAds : dynamicData['item_detail_view_count_for_ads'],
          isShowAdsInItemDetail : dynamicData['is_show_ads_in_item_detail'],
          isShowAdmobInsideList : dynamicData['is_show_admob_inside_list'],
          bluemarkSize : dynamicData['blue_mark_size'],
          mile : dynamicData['mile'],
          videoDuration : dynamicData['video_duration'],
          isUseGoogleMap : dynamicData['is_use_googlemap'],
          profileImageSize : dynamicData['profile_image_size'],
          uploadImageSize : dynamicData['upload_image_size'],
          chatImageSize : dynamicData['chat_image_size'],
          promoteFirstChoiceDay : dynamicData['promote_first_choice_day'],
          promoteSecondChoiceDay : dynamicData['promote_second_choice_day'],
          promoteThirdChoiceDay : dynamicData['promote_third_choice_day'],
          promoteFourthChoiceDay : dynamicData['promote_fourth_choice_day'],
          noFilterWithLocationOnMap : dynamicData['no_filter_with_location_on_map'],
          isShowOwnerInfo : dynamicData['is_show_owner_info'],
          isForceLogin: dynamicData['is_force_login'],
          isLanguageConfig: dynamicData['is_language_config'],
          defaultLanguage : Language().fromMap(dynamicData['default_language']),
          excludedLanguages : Language().fromMapList(dynamicData['exclude_language'])
        );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['google_playstore_url'] = object.googlePlayStoreUrl;
      data['apple_appstore_url'] = object.appleAppStoreUrl;
      data['price_format'] = object.priceFormat;
      data['date_format'] = object.dateFormat;
      data['ios_appstore_id'] = object.iosAppStoreId;
      data['is_use_thumbnail_as_placeholder'] = object.isUseThumbnailAsPlaceHolder;
      data['is_show_token_id'] = object.isShowTokenId;
      data['is_show_subcategory'] = object.isShowSubcategory;
      data['fb_key'] = object.fbKey;
      data['is_show_admob'] = object.isShowAdmob;
      data['default_loading_limit'] = object.defaultLoadingLimit;
      data['category_loading_limit'] = object.categoryLoadingLimit;
      data['posted_by_loading_limit'] = object.postedByLoadingLimit;
      data['agent_loading_limit'] = object.agentLoadingLimit;
      data['amenities_loading_limit'] = object.amenitiesLoadingLimit;
      data['recent_item_loading_limit'] = object.recentItemLoadingLimit;
      data['popular_item_loading_limit'] = object.populartItemLoadingLimit;
      data['discount_item_loading_limit'] = object.discountItemLoadingLimit;
      data['feature_item_loading_limit'] = object.featuredItemLoadingLimit;
      data['block_slider_loading_limit'] = object.blockSliderLoadingLimit;
      data['follower_item_loading_limit'] = object.followerItemLoadingLimit;
      data['block_item_loading_limit'] = object.blockItemLoadingLimit;
      data['show_facebook_login'] = object.showFacebookLogin;
      data['show_google_login'] = object.showGoogleLogin;
      data['show_phone_login'] = object.showPhoneLogin;
      data['is_razor_support_multi_currency'] = object.isRazorSupportMultiCurrency;
      data['default_razor_currency'] = object.defaultRazorCurrency;
      data['item_detail_view_count_for_ads'] = object.itemDetailViewCountForAds;
      data['is_show_ads_in_item_detail'] = object.isShowAdsInItemDetail;
      data['is_show_admob_inside_list'] = object.isShowAdmobInsideList;
      data['blue_mark_size'] = object.bluemarkSize;
      data['mile'] = object.mile;
      data['video_duration'] = object.videoDuration;
      data['is_use_googlemap'] = object.isUseGoogleMap;
      data['profile_image_size'] = object.profileImageSize;
      data['upload_image_size'] = object.uploadImageSize;
      data['chat_image_size'] = object.chatImageSize;
      data['promote_first_choice_day'] = object.promoteFirstChoiceDay;
      data['promote_second_choice_day'] = object.promoteSecondChoiceDay;
      data['promote_third_choice_day'] = object.promoteThirdChoiceDay;
      data['promote_fourth_choice_day'] = object.promoteFourthChoiceDay;
      data['no_filter_with_location_on_map'] = object.noFilterWithLocationOnMap;
      data['is_show_owner_info'] = object.isShowOwnerInfo;
      data['is_force_login'] = object.isForceLogin;
      data['is_language_config'] = object.isLanguageConfig;
      data['default_language'] = Language().fromMap(object.defaultLanguage);
      data['exclude_language'] = Language().fromMapList(object.excludedLanguages);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<PSMobileConfigSetting?> fromMapList(List<dynamic> dynamicDataList) {
    final List<PSMobileConfigSetting?> mobileConfigSettingList = <PSMobileConfigSetting?>[];

    // if (dynamicDataList != null) {
    for (dynamic json in dynamicDataList) {
      if (json != null) {
        mobileConfigSettingList.add(fromMap(json));
      }
    }
    // }
    return mobileConfigSettingList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<PSMobileConfigSetting?> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
    // if (objectList != null) {
    for (PSMobileConfigSetting? data in objectList) {
      if (data != null) {
        mapList.add(toMap(data));
      }
    }
    // }

    return mapList;
  }
}
