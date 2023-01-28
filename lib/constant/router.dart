import 'package:flutter/material.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/ui/agent/agent_list_container.dart';
import 'package:flutteradhouse/ui/app_info/app_info_view.dart';
import 'package:flutteradhouse/ui/app_loading/app_loading_view.dart';
import 'package:flutteradhouse/ui/blog/detail/blog_view.dart';
import 'package:flutteradhouse/ui/blog/list/blog_list_container.dart';
import 'package:flutteradhouse/ui/chat/detail/chat_view.dart';
import 'package:flutteradhouse/ui/chat/image/chat_image_detail_view.dart';
import 'package:flutteradhouse/ui/contact/contact_us_container_view.dart';
import 'package:flutteradhouse/ui/dashboard/core/dashboard_view.dart';
import 'package:flutteradhouse/ui/faq/setting_faq_view.dart';
import 'package:flutteradhouse/ui/force_update/force_update_view.dart';
import 'package:flutteradhouse/ui/gallery/detail/gallery_view.dart';
import 'package:flutteradhouse/ui/gallery/grid/gallery_grid_view.dart';
import 'package:flutteradhouse/ui/history/list/history_list_container.dart';
import 'package:flutteradhouse/ui/introslider/intro_slider_view.dart';
import 'package:flutteradhouse/ui/item/condition/item_condition_view.dart';
import 'package:flutteradhouse/ui/item/currency/item_currency_view.dart';
import 'package:flutteradhouse/ui/item/deal_option/item_deal_option_view.dart';
import 'package:flutteradhouse/ui/item/detail/product_detail_view.dart';
import 'package:flutteradhouse/ui/item/entry/amenities/amenities_list_view.dart';
import 'package:flutteradhouse/ui/item/entry/custom_camera_view.dart';
import 'package:flutteradhouse/ui/item/entry/item_entry_container.dart';
import 'package:flutteradhouse/ui/item/entry/video_view.dart';
import 'package:flutteradhouse/ui/item/entry/video_view_online_view.dart';
import 'package:flutteradhouse/ui/item/favourite/favourite_product_list_container.dart';
import 'package:flutteradhouse/ui/item/item/user_item_follower_list_view.dart';
import 'package:flutteradhouse/ui/item/item/user_item_list_for_profile_view.dart';
import 'package:flutteradhouse/ui/item/item/user_item_list_view.dart';
import 'package:flutteradhouse/ui/item/list_with_filter/filter/filter/item_search_view.dart';
import 'package:flutteradhouse/ui/item/list_with_filter/filter/post_type/post_type_filter/post_type_item_search_view.dart';
import 'package:flutteradhouse/ui/item/list_with_filter/filter/post_type/post_type_filter_list_view.dart';
import 'package:flutteradhouse/ui/item/list_with_filter/filter/post_type/post_type_product_list_with_filter_container.dart';
import 'package:flutteradhouse/ui/item/list_with_filter/filter/property_type/filter_list_view.dart';
import 'package:flutteradhouse/ui/item/list_with_filter/filter/property_type/nearest_product_list_view.dart';
import 'package:flutteradhouse/ui/item/list_with_filter/filter/property_type/product_list_with_filter_container.dart';
import 'package:flutteradhouse/ui/item/paid_ad/paid_ad_item_list_container.dart';
import 'package:flutteradhouse/ui/item/paid_ad_product/paid_ad_product_list_container.dart';
import 'package:flutteradhouse/ui/item/price_type/item_price_type_view.dart';
import 'package:flutteradhouse/ui/item/promote/CreditCardView.dart';
import 'package:flutteradhouse/ui/item/promote/InAppPurchaseView.dart';
import 'package:flutteradhouse/ui/item/promote/ItemPromoteView.dart';
import 'package:flutteradhouse/ui/item/promote/choose_payment_view.dart';
import 'package:flutteradhouse/ui/item/promote/pay_stack_view.dart';
import 'package:flutteradhouse/ui/item/reported_item/reported_item_container_view.dart';
import 'package:flutteradhouse/ui/item/type/type_list_view.dart';
import 'package:flutteradhouse/ui/language/list/language_list_view.dart';
import 'package:flutteradhouse/ui/language/setting/language_setting_container_view.dart';
import 'package:flutteradhouse/ui/location_city/entry_location/item_entry_location_view.dart';
import 'package:flutteradhouse/ui/location_city/filter_location_view.dart';
import 'package:flutteradhouse/ui/location_city/item_location_container.dart';
import 'package:flutteradhouse/ui/location_township/entry_location_township/item_entry_location_township_view.dart';
import 'package:flutteradhouse/ui/location_township/item_location_township_container.dart';
import 'package:flutteradhouse/ui/map/google_map_filter_view.dart';
import 'package:flutteradhouse/ui/map/google_map_pin_view.dart';
import 'package:flutteradhouse/ui/map/map_filter_view.dart';
import 'package:flutteradhouse/ui/map/map_pin_view.dart';
import 'package:flutteradhouse/ui/noti/detail/noti_view.dart';
import 'package:flutteradhouse/ui/noti/list/noti_list_view.dart';
import 'package:flutteradhouse/ui/noti/notification_setting/notification_setting_view.dart';
import 'package:flutteradhouse/ui/offer/list/offer_container_view.dart';
import 'package:flutteradhouse/ui/offline_payment/offline_payment_view.dart';
import 'package:flutteradhouse/ui/package/package_shop_view.dart';
import 'package:flutteradhouse/ui/post_type/filter/post_type_search_list_view.dart';
import 'package:flutteradhouse/ui/post_type/list/post_type_list_view_container.dart';
import 'package:flutteradhouse/ui/property_type/filter_list/property_type_filter_list_view.dart';
import 'package:flutteradhouse/ui/property_type/list/property_type_sorting_list_view.dart';
import 'package:flutteradhouse/ui/rating/list/rating_list_view.dart';
import 'package:flutteradhouse/ui/safety_tips/safety_tips_view.dart';
import 'package:flutteradhouse/ui/search/search_location/search_location_view.dart';
import 'package:flutteradhouse/ui/search/serach_location_township/search_location_township_view.dart';
import 'package:flutteradhouse/ui/setting/camera/camera_setting_view.dart';
import 'package:flutteradhouse/ui/setting/setting_container_view.dart';
import 'package:flutteradhouse/ui/setting/setting_privacy_policy_view.dart';
import 'package:flutteradhouse/ui/sold_out/filter/sold_out_search_list_view.dart';
import 'package:flutteradhouse/ui/terms_and_conditions/setting_terms_and_conditions_view.dart';
import 'package:flutteradhouse/ui/user/blocked_user/block_user_container_view.dart';
import 'package:flutteradhouse/ui/user/buy_adpost_transaction/buy_adpost_transaction_history_container_view.dart';
import 'package:flutteradhouse/ui/user/edit_profile/edit_phone_verify/edit_phone_verify_container_view.dart';
import 'package:flutteradhouse/ui/user/edit_profile/edit_profile_view.dart';
import 'package:flutteradhouse/ui/user/edit_profile/sign_in/edit_phone_sign_in_container_view.dart';
import 'package:flutteradhouse/ui/user/forgot_password/forgot_password_container_view.dart';
import 'package:flutteradhouse/ui/user/list/follower_user_list_view.dart';
import 'package:flutteradhouse/ui/user/list/following_user_list_view.dart';
import 'package:flutteradhouse/ui/user/login/login_container_view.dart';
import 'package:flutteradhouse/ui/user/more/more_container_view.dart';
import 'package:flutteradhouse/ui/user/password_update/change_password_view.dart';
import 'package:flutteradhouse/ui/user/phone/sign_in/phone_sign_in_container_view.dart';
import 'package:flutteradhouse/ui/user/phone/verify_phone/verify_phone_container_view.dart';
import 'package:flutteradhouse/ui/user/profile/profile_sold_out_item_viewall.dart';
import 'package:flutteradhouse/ui/user/register/register_container_view.dart';
import 'package:flutteradhouse/ui/user/user_detail/user_detail_view.dart';
import 'package:flutteradhouse/ui/user/verify/verify_email_container_view.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/blog.dart';
import 'package:flutteradhouse/viewobject/default_photo.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/amenities_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/item_list_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/safety_tips_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/user_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/verify_phone_internt_holder.dart';
import 'package:flutteradhouse/viewobject/holder/location_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/paid_history_holder.dart';
import 'package:flutteradhouse/viewobject/holder/paystack_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/message.dart';
import 'package:flutteradhouse/viewobject/noti.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:flutteradhouse/viewobject/ps_app_info.dart';
import 'package:flutteradhouse/viewobject/ps_app_version.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return AppLoadingView();
      });

    case '${RoutePaths.home}':
      return MaterialPageRoute<dynamic>(
          settings: const RouteSettings(name: RoutePaths.home),
          builder: (BuildContext context) {
            return DashboardView();
          });
          
    case '${RoutePaths.introSlider}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final int settingSlider = args as int;
        return IntroSliderView(settingSlider:settingSlider);
      });      

    case '${RoutePaths.force_update}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final PSAppVersion psAppVersion = args as PSAppVersion;
        return ForceUpdateView(psAppVersion: psAppVersion);
      });

    case '${RoutePaths.user_register_container}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => RegisterContainerView());

    case '${RoutePaths.contactUs}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => ContactUsContainerView());

    // case '${RoutePaths.login_container}':
    //   return MaterialPageRoute<dynamic>(
    //       builder: (BuildContext context) => LoginContainerView());
            case '${RoutePaths.login_container}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        bool fromAppStart = true;
        if (args != null) {
          fromAppStart = (args as bool? ?? bool) as bool;
        }
        // final bool? fromAppStart = (args as bool? ?? bool) as bool;
        return LoginContainerView(fromAppStart: fromAppStart);
      });

    case '${RoutePaths.user_verify_email_container}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final String userId = args as String;
        return VerifyEmailContainerView(userId: userId);
      });

    case '${RoutePaths.user_forgot_password_container}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => ForgotPasswordContainerView());

    case '${RoutePaths.user_phone_signin_container}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => PhoneSignInContainerView());

    case '${RoutePaths.edit_phone_signin_container}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => EditPhoneSignInContainerView());
          
    case '${RoutePaths.user_phone_verify_container}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;

        final VerifyPhoneIntentHolder verifyPhoneIntentParameterHolder =
            args as VerifyPhoneIntentHolder;
        return VerifyPhoneContainerView(
          userName: verifyPhoneIntentParameterHolder.userName,
          phoneNumber: verifyPhoneIntentParameterHolder.phoneNumber,
          phoneId: verifyPhoneIntentParameterHolder.phoneId,
        );
      });

      case '${RoutePaths.edit_phone_verify_container}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;

        final VerifyPhoneIntentHolder verifyPhoneIntentParameterHolder =
            args as VerifyPhoneIntentHolder;
        return EditPhoneVerifyContainerView(
          userName: verifyPhoneIntentParameterHolder.userName,
          phoneNumber: verifyPhoneIntentParameterHolder.phoneNumber,
          phoneId: verifyPhoneIntentParameterHolder.phoneId,
        );
      });

    case '${RoutePaths.user_update_password}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => ChangePasswordView());

    case '${RoutePaths.languageList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return LanguageListView();
      });

   case '${RoutePaths.languagesetting}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return LanguageSettingContainerView();
      });

    case '${RoutePaths.propertyTypeList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return PropertyTypeSortingListView(
          //  appBarTitle: Utils.getString(context, 'dashboard__property_type_list')
            );
      });

    case '${RoutePaths.notiList}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => NotiListView());

    case '${RoutePaths.offerList}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => OfferContainerView());

    case '${RoutePaths.blockUserList}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => BlockUserContainerView());

    case '${RoutePaths.reportItemList}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => ReportItemContainerView());

    case '${RoutePaths.followingUserList}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => FollowingUserListView());

    case '${RoutePaths.followerUserList}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => FollowerUserListView());

    case '${RoutePaths.chatView}':
      return MaterialPageRoute<dynamic>(
          settings: const RouteSettings(name: RoutePaths.chatView),
          builder: (BuildContext context) {
            final Object? args = settings.arguments;
            final ChatHistoryIntentHolder chatHistoryIntentHolder =
                args as ChatHistoryIntentHolder;
            return ChatView(
              chatFlag: chatHistoryIntentHolder.chatFlag,
              itemId: chatHistoryIntentHolder.itemId ?? '',
              buyerUserId: chatHistoryIntentHolder.buyerUserId ?? '',
              sellerUserId: chatHistoryIntentHolder.sellerUserId ?? '',
            );
          });
    case '${RoutePaths.notiSetting}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => NotificationSettingView());

    case '${RoutePaths.setting}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => SettingContainerView());

    case '${RoutePaths.more}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final String userName = args as String;
        return MoreContainerView(userName: userName);
      });

    case '${RoutePaths.noti}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final Noti noti = args as Noti;
        return NotiView(noti: noti);
      });

    case '${RoutePaths.cameraSetting}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => CameraSettingView());

    case '${RoutePaths.cameraView}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => CustomCameraView());

    case '${RoutePaths.filterProductList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final ProductListIntentHolder productListIntentHolder =
            args as ProductListIntentHolder;
        return ProductListWithFilterContainerView(
            appBarTitle: productListIntentHolder.appBarTitle,
            productParameterHolder:
                productListIntentHolder.productParameterHolder,
            tabTitleItem: Utils.getString(context, 'search_filter__item'),
            tabTitleAccount: Utils.getString(context, 'search_filter__account'));
      });

                case '${RoutePaths.nearestProductList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final ProductListIntentHolder holder =
            args as ProductListIntentHolder ;
        return NearestProductListView(
            appBarTitle: holder.appBarTitle,
            productParameterHolder:
                holder.productParameterHolder,
            tabTitleItem: Utils.getString(context, 'search_filter__item'),
            tabTitleAccount: Utils.getString(context, 'search_filter__account')
          );
      });

    case '${RoutePaths.postedFilterProductList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final ProductListIntentHolder productListIntentHolder =
            args as ProductListIntentHolder;
        return PostTypeProductListWithFilterContainerView(
            appBarTitle: productListIntentHolder.appBarTitle,
            productParameterHolder:
                productListIntentHolder.productParameterHolder);
      });

    case '${RoutePaths.filterLocationList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final LocationParameterHolder locationParameterHolder =
            args as LocationParameterHolder;
        return FilterLocationView(
            locationParameterHolder: locationParameterHolder);
      });

    case '${RoutePaths.privacyPolicy}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final int checkPolicyType = args as int;
        return SettingPrivacyPolicyView(
          checkPolicyType: checkPolicyType,
        );
      });

          case '${RoutePaths.termsAndCondition}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const SettingTermsAndCondition()); 

              case '${RoutePaths.faq}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const SettingFAQView());  

    case '${RoutePaths.blogList}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => BlogListContainerView());

    case '${RoutePaths.appinfo}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => AppInfoView());

    case '${RoutePaths.blogDetail}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final Blog blog = args as Blog;
        return BlogView(
          blog: blog,
          heroTagImage: blog.id!,
        );
      });

    case '${RoutePaths.paidAdItemList}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => PaidItemListContainerView());

    case '${RoutePaths.agentList}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => AgentListContainerView());

    case '${RoutePaths.userItemList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final ItemListIntentHolder itemEntryIntentHolder =
            args as ItemListIntentHolder;
        return UserItemListView(
          addedUserId: itemEntryIntentHolder.userId,
          status: itemEntryIntentHolder.status,
          title: itemEntryIntentHolder.title,
        );
      });
    case '${RoutePaths.userItemListForProfile}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final ItemListIntentHolder itemEntryIntentHolder =
            args as ItemListIntentHolder;
        return UserItemListForProfileView(
          addedUserId: itemEntryIntentHolder.userId,
          status: itemEntryIntentHolder.status,
          title: itemEntryIntentHolder.title,
        );
      });
    // case '${RoutePaths.transactionList}':
    //   return MaterialPageRoute<dynamic>(builder: (BuildContext context) => TransactionListContainerView());
    case '${RoutePaths.historyList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return HistoryListContainerView();
      });

    case '${RoutePaths.productDetail}':
      final Object? args = settings.arguments;
      final ProductDetailIntentHolder holder =
          args as ProductDetailIntentHolder;

      return MaterialPageRoute<dynamic>(
          settings: const RouteSettings(name: RoutePaths.productDetail),
          builder: (BuildContext context) {
            return ProductDetailView(
              productId: holder.productId,
              heroTagImage: holder.heroTagImage!,
              heroTagTitle: holder.heroTagTitle!,
            );
          });

    case '${RoutePaths.filterExpantion}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final dynamic args = settings.arguments;

        return FilterListView(selectedData: args);
      });

    case '${RoutePaths.postedFilterExpantion}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final dynamic args = settings.arguments;

        return PostTypeFilterListView(selectedData: args);
      });
   
    case '${RoutePaths.itemSearch}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final ProductParameterHolder productParameterHolder =
            args as ProductParameterHolder;
        return ItemSearchView(productParameterHolder: productParameterHolder);
      });
  
    case '${RoutePaths.postedItemSearch}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final ProductParameterHolder productParameterHolder =
            args as ProductParameterHolder;
        return PostTypeItemSearchView(productParameterHolder: productParameterHolder);
      });

    case '${RoutePaths.mapFilter}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final ProductParameterHolder productParameterHolder =
            args as ProductParameterHolder;
        return MapFilterView(productParameterHolder: productParameterHolder);
      });

    case '${RoutePaths.mapPin}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final MapPinIntentHolder mapPinIntentHolder =
            args as MapPinIntentHolder;
        return MapPinView(
          flag: mapPinIntentHolder.flag,
          maplat: mapPinIntentHolder.mapLat,
          maplng: mapPinIntentHolder.mapLng,
        );
      });

          case '${RoutePaths.googleMapFilter}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final ProductParameterHolder productParameterHolder =
            args as ProductParameterHolder;
        return GoogleMapFilterView(
            productParameterHolder: productParameterHolder);
      });

          case '${RoutePaths.googleMapPin}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final MapPinIntentHolder mapPinIntentHolder =
            args as MapPinIntentHolder;
        return GoogleMapPinView(
          flag: mapPinIntentHolder.flag,
          maplat: mapPinIntentHolder.mapLat,
          maplng: mapPinIntentHolder.mapLng,
        );
      });

    case '${RoutePaths.favouriteProductList}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              FavouriteProductListContainerView());

    case '${RoutePaths.paidAdProductList}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => PaidAdProductListContainerView());

    case '${RoutePaths.ratingList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final String itemUserId = args as String;
        return RatingListView(
          itemUserId: itemUserId,
        );
      });

    case '${RoutePaths.editProfile}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return EditProfileView();
      });

    case '${RoutePaths.galleryGrid}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final Product product = args as Product;
        return GalleryGridView(product: product);
      });

    case '${RoutePaths.galleryDetail}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final DefaultPhoto selectedDefaultImage = args as DefaultPhoto;
        return GalleryView(selectedDefaultImage: selectedDefaultImage);
      });

    case '${RoutePaths.chatImageDetailView}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final Message message = args as Message;
        return ChatImageDetailView(messageObj: message);
      });

      case '${RoutePaths.video}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final String videoPath = args as String;
        return PlayerVideoView(videoPath);
      });

    case '${RoutePaths.video_online}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final String videoPath = args as String;
        return PlayerVideoOnlineView(videoPath);
      });   

    case '${RoutePaths.searchPropertyBy}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => PropertyTypeFilterListView());

    case '${RoutePaths.searchPostType}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => PostTypeSearchListView());

    case '${RoutePaths.searchSoldOut}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => SoldOutSearchListView()); 

    case '${RoutePaths.itemSoldOutProductList}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => SoldOutProductListView());     

    case '${RoutePaths.entryAmenitiesList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final AmenitiesIntentHolder amenitiesIntentHolder =
            args as AmenitiesIntentHolder;
        return ItemEntryAmenitiesListView(
          amenityId: amenitiesIntentHolder.amenityId,
          selectedAmenitiesList: amenitiesIntentHolder.selectedAmenitiesList,
        );
      });

    case '${RoutePaths.userDetail}':
      return MaterialPageRoute<dynamic>(
          settings: const RouteSettings(name: RoutePaths.userDetail),
          builder: (BuildContext context) {
            final Object? args = settings.arguments;

            final UserIntentHolder userIntentHolder = args as UserIntentHolder;
            return UserDetailView(
              userName: userIntentHolder.userName,
              userId: userIntentHolder.userId,
            );
          });

    case '${RoutePaths.safetyTips}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final SafetyTipsIntentHolder safetyTipsIntentHolder =
            args as SafetyTipsIntentHolder;
        return SafetyTipsView(
          animationController: safetyTipsIntentHolder.animationController,
          safetyTips: safetyTipsIntentHolder.safetyTips,
        );
      });

    case '${RoutePaths.itemLocationList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return ItemLocationContainerView();
      });

    case '${RoutePaths.itemLocationTownshipList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final String cityId = args as String;
        return ItemLocationTownshipContainerView(cityId: cityId);
      });
          case '${RoutePaths.searchLocationList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return SearchLocationView();
      });

    case '${RoutePaths.searchLocationTownshipList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final String cityId = args as String;
        return SearchLocationTownshipView(cityId: cityId);
      });

    // case '${RoutePaths.itemEntry}':
    //   return MaterialPageRoute<dynamic>(
    //     settings: const RouteSettings(name: RoutePaths.itemEntry),
    //     builder: (BuildContext context) {
    //     final Object? args = settings.arguments;
    //     final ItemEntryIntentHolder itemEntryIntentHolder =
    //         args as ItemEntryIntentHolder;
    //     return ItemEntryContainerView(
    //       flag: itemEntryIntentHolder.flag,
    //       item: itemEntryIntentHolder.item,
    //     );
    //   });

          case '${RoutePaths.itemEntry}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final ItemEntryIntentHolder itemEntryIntentHolder =
            args as ItemEntryIntentHolder;
        return ItemEntryContainerView(
          flag: itemEntryIntentHolder.flag,
          item: itemEntryIntentHolder.item,
        );
      });

    case '${RoutePaths.itemType}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => TypeListView());

    case '${RoutePaths.itemCondition}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => ItemConditionView());

    case '${RoutePaths.itemPriceType}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => ItemPriceTypeView());

    case '${RoutePaths.itemCurrencySymbol}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => ItemCurrencyView());

    case '${RoutePaths.itemDealOption}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => ItemDealOptionView());

    case '${RoutePaths.itemLocation}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => ItemEntryLocationView());

    case '${RoutePaths.itemLocationTownship}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final String cityId = args as String;
        return ItemEntryLocationTownshipView(cityId: cityId);
      });

    case '${RoutePaths.itemPromote}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final Product product = args as Product;
        return ItemPromoteView(product: product);
      });

    case '${RoutePaths.choosePayment}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Map<String, dynamic> args = settings.arguments  as Map<String, dynamic>;
        final Product product = args['product'];
        final PSAppInfo appInfo = args['appInfo'];
        Utils.psPrint(appInfo.inAppPurchasedPrdIdAndroid!);
       
        return ChoosePaymentVIew(product: product, appInfo: appInfo);
      });

    case '${RoutePaths.postTypeList}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        return PostTypeListViewContainerView(
            appBarTitle: Utils.getString(context, 'dashboard__posted_list'));
      });

    case '${RoutePaths.itemListFromFollower}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final String loginUserId = args as String;

        return UserItemFollowerListView(
          loginUserId: loginUserId,
        );
      });

    case '${RoutePaths.inAppPurchase}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Map<String, dynamic> args = settings.arguments  as Map<String, dynamic>;
        // final String itemId = args as String;
        final String itemId = args['productId'];
        final PSAppInfo appInfo = args['appInfo'];

        return InAppPurchaseView(itemId, appInfo);
      });

      //     case '${RoutePaths.buyPackage}':
      // return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
      //   final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
      //   // final String itemId = args ?? String;
      //   final String? userId = args['userId'];

      //   return PackageBoughtInAppPurchaseView(userId);
      // }); 


 case '${RoutePaths.buyPackage}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        final String androidKeyList = args['android'];
        final String iosKeyList = args['ios'];
        return PackageShopInAppPurchaseView(androidKeyList: androidKeyList, iosKeyList: iosKeyList);
      }); 

      case '${RoutePaths.packageTransactionHistoryList}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
               BuyAdTransactionContainerView());

    case '${RoutePaths.creditCard}':
      final Object? args = settings.arguments;

      final PaidHistoryHolder paidHistoryHolder = args as PaidHistoryHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CreditCardView(
                product: paidHistoryHolder.product,
                amount: paidHistoryHolder.amount,
                howManyDay: paidHistoryHolder.howManyDay,
                paymentMethod: paidHistoryHolder.paymentMethod,
                stripePublishableKey: paidHistoryHolder.stripePublishableKey,
                startDate: paidHistoryHolder.startDate,
                startTimeStamp: paidHistoryHolder.startTimeStamp,
                itemPaidHistoryProvider:
                    paidHistoryHolder.itemPaidHistoryProvider,
              ));
    case '${RoutePaths.payStackPayment}':
      final Object? args = settings.arguments;

      final PayStackInterntHolder payStackInterntHolder =
          args as PayStackInterntHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              PayStackView(
                product: payStackInterntHolder.product,
                amount: payStackInterntHolder.amount,
                howManyDay: payStackInterntHolder.howManyDay,
                paymentMethod: payStackInterntHolder.paymentMethod,
                stripePublishableKey:
                    payStackInterntHolder.stripePublishableKey ?? '',
                startDate: payStackInterntHolder.startDate,
                startTimeStamp: payStackInterntHolder.startTimeStamp,
                itemPaidHistoryProvider:
                    payStackInterntHolder.itemPaidHistoryProvider,
                userProvider: payStackInterntHolder.userProvider,
                payStackKey: payStackInterntHolder.payStackKey,
              ));
    case '${RoutePaths.offlinePayment}':
      final Object? args = settings.arguments;

      final PaidHistoryHolder paidHistoryHolder = args as PaidHistoryHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              OfflinePaymentView(
                product: paidHistoryHolder.product,
                amount: paidHistoryHolder.amount,
                howManyDay: paidHistoryHolder.howManyDay,
                paymentMethod: paidHistoryHolder.paymentMethod,
                stripePublishableKey: paidHistoryHolder.stripePublishableKey,
                startDate: paidHistoryHolder.startDate,
                startTimeStamp: paidHistoryHolder.startTimeStamp,
                itemPaidHistoryProvider:
                    paidHistoryHolder.itemPaidHistoryProvider,
              ));

    default:
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              AppLoadingView());
  }
}
