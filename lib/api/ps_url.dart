import 'package:flutteradhouse/config/ps_config.dart';

class PsUrl {
  PsUrl._();

  ///
  /// APIs Url
  ///
  static const String ps_item_detail_url = 'rest/items/get';

  static const String ps_search_item_url = 'rest/items/search';

  static const String ps_search_user_url = 'rest/userfollows/search';

  static const String ps_blocked_user_url =
      'rest/users/get_blocked_user_by_loginuser';

  static const String ps_user_follow_url = 'rest/userfollows/add_follow';

  static const String ps_agents_url = 'rest/agents/get';

  static const String ps_user_detail_url =
      'rest/userfollows/search/api_key/${PsConfig.ps_api_key}';

  static const String ps_offer_url =
      'rest/chats/offer_list/api_key/${PsConfig.ps_api_key}';

  static const String ps_chat_history_url =
      'rest/chat_items/get_buyer_seller_list/api_key/${PsConfig.ps_api_key}';

  static const String ps_chat_sell_item_url =
      'rest/chats/item_sold_out/api_key/${PsConfig.ps_api_key}/';

  static const String ps_add_chat_history_url =
      'rest/chats/add/api_key/${PsConfig.ps_api_key}';

  static const String ps_accepted_offer_url =
      'rest/chats/update_accept/api_key/${PsConfig.ps_api_key}';

  static const String ps_rejected_offer_url =
      'rest/chats/update_price/api_key/${PsConfig.ps_api_key}';

  static const String ps_get_chat_history_url =
      'rest/chats/get_chat_history/api_key/${PsConfig.ps_api_key}';

  static const String ps_mark_as_sold_url =
      'rest/chats/item_sold_out/api_key/${PsConfig.ps_api_key}';

  static const String ps_is_user_bought_url =
      'rest/chats/is_user_bought/api_key/${PsConfig.ps_api_key}';

  static const String ps_about_us_url = 'rest/abouts/get';

  static const String ps_mark_sold_out_url =
      'rest/items/sold_out_from_itemdetails/api_key/${PsConfig.ps_api_key}/';

  static const String ps_report_item_url =
      'rest/itemreports/add/api_key/${PsConfig.ps_api_key}';

  static const String ps_block_user_url =
      'rest/blockusers/add/api_key/${PsConfig.ps_api_key}';

  static const String ps_unblock_user_url =
      'rest/blockusers/unblock/api_key/${PsConfig.ps_api_key}';

  static const String ps_reset_unread_message_count_url =
      'rest/chats/reset_count/api_key/${PsConfig.ps_api_key}';

  static const String ps_user_unread_count_url =
      'rest/users/unread_count/api_key/${PsConfig.ps_api_key}';

  static const String ps_chat_image_upload_url =
      'rest/images/chat_image_upload/api_key/${PsConfig.ps_api_key}';

  static const String ps_shipping_method_url =
      'rest/shippings/get/api_key/${PsConfig.ps_api_key}/';

  static const String ps_news_feed_url =
      'rest/feeds/get/api_key/${PsConfig.ps_api_key}/';

  static const String ps_property_type_url = 'rest/propertybys/search/';

    static const String ps_delete_item_image_url =
      'rest/images/delete_item_image/api_key/${PsConfig.ps_api_key}';

  static const String ps_offline_payment_method_url =
      'rest/offline_payments/get_offline_payment/';

  static const String ps_contact_us_url =
      'rest/Contacts/add/api_key/${PsConfig.ps_api_key}';

  static const String ps_image_upload_url =
      'rest/images/upload/api_key/${PsConfig.ps_api_key}';

  static const String ps_video_upload_url =
      'rest/images/video_upload/api_key/${PsConfig.ps_api_key}';

  static const String ps_video_thumbnail_upload_url =
      'rest/images/upload_video_icon/api_key/${PsConfig.ps_api_key}';  

  static const String ps_item_reorder_image_upload_url = 
      'rest/images/reorder_image/api_key/${PsConfig.ps_api_key}';  

  static const String ps_delete_item_video_url =
      'rest/images/delete_video_and_icon/api_key/${PsConfig.ps_api_key}';    
      
  static const String ps_item_image_upload_url =
      'rest/images/upload_item/api_key/${PsConfig.ps_api_key}';

  static const String ps_collection_url = 'rest/collections/get';

  static const String ps_all_collection_url =
      'rest/products/all_collection_products';

  static const String ps_post_ps_app_info_url =
      'rest/appinfo/get_delete_history/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_user_register_url =
      'rest/users/add/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_user_email_verify_url =
      'rest/users/verify/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_zone_shipping_method_url =
      'rest/shipping_zones/get_shipping_cost/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_user_login_url =
      'rest/users/login/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_user_forgot_password_url =
      'rest/users/reset/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_user_change_password_url =
      'rest/users/password_update/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_user_update_profile_url =
      'rest/users/profile_update/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_phone_login_url =
      'rest/users/phone_register/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_fb_login_url =
      'rest/users/facebook_register/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_google_login_url =
      'rest/users/google_register/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_apple_login_url =
      'rest/users/apple_register/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_resend_code_url =
      'rest/users/request_code/api_key/${PsConfig.ps_api_key}';

  static const String ps_post_ps_touch_count_url =
      'rest/touches/touch_item/api_key/${PsConfig.ps_api_key}';

  static const String ps__property_subscribe_url =
      'rest/property_by_subscribes/subcategory_subscribe/api_key/${PsConfig.ps_api_key}';

  static const String ps_product_url = 'rest/items/search';

  static const String ps_products_search_url =
      'rest/products/search/api_key/${PsConfig.ps_api_key}/';

  static const String ps_post_type_url = 'rest/postedbys/get';

  static const String ps_amenities_url = 'rest/amenities/get';

  static const String ps_user_url = 'rest/users/get';

  static const String ps_noti_url = 'rest/noti_messages/all_notis';

  static const String ps_apply_agent_url =
      'rest/agents/add/api_key/${PsConfig.ps_api_key}';

// static const String ps_shop_info_url = 'rest/shops/get_shop_info';

  static const String ps_bloglist_url = 'rest/feeds/search';

  static const String ps_transactionList_url = 'rest/transactionheaders/get';

  static const String ps_transactionDetail_url = 'rest/transactiondetails/get';

  static const String ps_shipping_country_url =
      'rest/shipping_zones/get_shipping_country';

  static const String ps_shipping_city_url =
      'rest/shipping_zones/get_shipping_city';

  static const String ps_relatedProduct_url =
      'rest/products/related_product_trending';

  static const String ps_commentList_url = 'rest/commentheaders/get';

  static const String ps_commentDetail_url = 'rest/commentdetails/get';

  static const String ps_commentHeaderPost_url =
      'rest/commentheaders/press/api_key/${PsConfig.ps_api_key}';

  static const String ps_commentDetailPost_url =
      'rest/commentdetails/press/api_key/${PsConfig.ps_api_key}';

  static const String ps_downloadProductPost_url =
      'rest/downloads/download_product/api_key/${PsConfig.ps_api_key}';

  static const String ps_noti_register_url =
      'rest/notis/register/api_key/${PsConfig.ps_api_key}';

  static const String ps_delete_user_url =
      'rest/users/user_delete/api_key/${PsConfig.ps_api_key}';

  static const String ps_chat_noti_url =
      'rest/notis/send_chat_noti/api_key/${PsConfig.ps_api_key}';

  static const String ps_noti_post_url =
      'rest/notis/is_read/api_key/${PsConfig.ps_api_key}';

  static const String ps_noti_unregister_url =
      'rest/notis/unregister/api_key/${PsConfig.ps_api_key}';

  static const String ps_ratingPost_url =
      'rest/rates/add_rating/api_key/${PsConfig.ps_api_key}';

  static const String ps_ratingList_url = 'rest/rates/rating_user';

  static const String ps_favouritePost_url =
      'rest/favourites/press/api_key/${PsConfig.ps_api_key}';

  static const String ps_favouriteList_url = 'rest/items/get_favourite';

  static const String ps_gallery_url = 'rest/images/get_item_gallery';

  static const String ps_couponDiscount_url =
      'rest/coupons/check/api_key/${PsConfig.ps_api_key}';

  static const String ps_token_url = 'rest/paypal/get_token';

  static const String ps_collection_product_url =
      'rest/products/all_collection_products';

  static const String ps_item_location_url = 'rest/itemlocations/search/';

  static const String ps_item_location_township_url =
      'rest/item_location_townships/search/';

  static const String ps_item_list_from_followers_url =
      'rest/items/get_item_by_followuser';

  static const String ps_paid_ad_item_list_url = 'rest/paid_items/get';

  static const String ps_item_entry_url =
      'rest/items/add/api_key/${PsConfig.ps_api_key}';

  static const String ps_item_type_url = 'rest/itemtypes/get';

  static const String ps_reported_item_url =
      'rest/items/get_reported_item_by_loginuser';

  static const String ps_item_condition_url = 'rest/conditions/get';

  static const String ps_item_price_type_url = 'rest/item_price_types/get';

  static const String ps_item_currency_type_url = 'rest/currencies/get';

  static const String ps_item_deal_option_url = 'rest/options/get';

  static const String ps_item_paid_history_entry_url =
      'rest/paid_items/add/api_key/${PsConfig.ps_api_key}';

  static const String ps_item_delete_url =
      'rest/items/item_delete/api_key/${PsConfig.ps_api_key}';

  static const String ps_user_logout_url =
      'rest/users/logout/api_key/${PsConfig.ps_api_key}';

  static const String ps_get_packages = 
      'rest/packages/get/api_key/${PsConfig.ps_api_key}';

  static const String ps_buy_post_packgage = 
      'rest/packages/is_package_bought/api_key/${PsConfig.ps_api_key}';  

  static const String ps_buy_post_packgage_transaction_detail = 
      'rest/buy_ad_post_transactions/search/api_key/${PsConfig.ps_api_key}'; 

  static const String ps_get_user_url = 'rest/users/search/';

    static const String ps_sold_out_item_url =
      'rest/items/get_sold_out_item_by_loginuser/api_key/${PsConfig.ps_api_key}';
}
