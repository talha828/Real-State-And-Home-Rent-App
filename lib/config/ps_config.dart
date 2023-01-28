// Copyright (c) 2019, the Panacea-Soft.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Panacea-Soft license that can be found in the LICENSE file.

import 'package:flutteradhouse/viewobject/common/language.dart';

class PsConfig {
  PsConfig._();

  ///
  /// AppVersion
  /// For your app, you need to change according based on your app version
  ///
  static const String app_version = '1.9';

  ///
  /// API Key
  /// If you change here, you need to update in server.
  ///
  static const String ps_api_key = 'teampsisthebest';

  ///
  /// API URL
  /// Change your backend url
  ///
  static const String ps_base_url ="https://realrent.online/admin/";
  //     'https://www.products.panacea-soft.co/adhouses-admin-demo';

  static const String ps_app_url = ps_base_url + '/index.php/';

  static const String ps_app_image_url = ps_base_url + '/uploads/';

  static const String ps_app_image_thumbs_url =
      ps_base_url + '/uploads/thumbnail/';

  static const String ps_app_image_thumbs_2x_url =
      ps_base_url + '/uploads/thumbnail2x/';

  static const String ps_app_image_thumbs_3x_url =
      ps_base_url + '/uploads/thumbnail3x/';     

  // static const String GOOGLE_PLAY_STORE_URL =
  //     'https://play.google.com/store/apps';

  // static const String APPLE_APP_STORE_URL = 'https://www.apple.com/app-store';

  ///
  /// Chat Setting
  ///
  static const String iosGoogleAppId =
      '1:000000000000:ios:0000000000000000000000';
  static const String iosGcmSenderId = '000000000000';
  static const String iosProjectId = 'flutter-buy-and-sell';
  static const String iosDatabaseUrl =
      'https://flutter-buy-and-sell.firebaseio.com';
  static const String iosApiKey = 'AI0000000000000000000000000000000000000';

  static const String androidGoogleAppId =
      '1:000000000000:android:0000000000000000000000';
  static const String androidGcmSenderId = '000000000000';
  static const String androidProjectId = 'flutter-buy-and-sell';
  static const String androidApiKey = 'AI00000000000000000000-0000000000000000';
  static const String androidDatabaseUrl =
      'https://flutter-buy-and-sell.firebaseio.com';


  ///
  /// Facebook Key
  ///
  ///static const String fbKey = '000000000000000';
  // static const String fbKey = '937880323779672';
  

  ///
  ///Admob Setting
  ///
  // static bool showAdMob = true;
  static String androidAdMobAdsIdKey = 'ca-app-pub-0000000000000000~0000000000';
  static String androidAdMobUnitIdApiKey =
      'ca-app-pub-0000000000000000/0000000000';
  static String androidAdMobInterstitial =
      'ca-app-pub-0000000000000000/0000000000';
  static String iosAdMobAdsIdKey = 'ca-app-pub-0000000000000000~0000000000';
  static String iosAdMobUnitIdApiKey = 'ca-app-pub-0000000000000000/0000000000';
  static String iosAdMobInterstitial = 'ca-app-pub-0000000000000000/0000000000';



  ///
  /// iOS App No
  ///
  // static const String iOSAppStoreId = '000000000';

  ///
  /// Animation Duration
  ///
  static const Duration animation_duration = Duration(milliseconds: 500);

  ///
  /// Fonts Family Config
  /// Before you declare you here,
  /// 1) You need to add font under assets/fonts/
  /// 2) Declare at pubspec.yaml
  /// 3) Update your font family name at below
  ///
  static const String ps_default_font_family = 'Product Sans';

  /// Default Language
// static const ps_default_language = 'en';

// static const ps_language_list = [Locale('en', 'US'), Locale('ar', 'DZ')];
  static const String ps_app_db_name = 'ps_db.db';

  ///
  /// For default language change, please check
  /// LanguageFragment for language code and country code
  /// ..............................................................
  /// Language             | Language Code     | Country Code
  /// ..............................................................
  /// "English"            | "en"              | "US"
  /// "Arabic"             | "ar"              | "DZ"
  /// "India (Hindi)"      | "hi"              | "IN"
  /// "German"             | "de"              | "DE"
  /// "Spainish"           | "es"              | "ES"
  /// "French"             | "fr"              | "FR"
  /// "Indonesian"         | "id"              | "ID"
  /// "Italian"            | "it"              | "IT"
  /// "Japanese"           | "ja"              | "JP"
  /// "Korean"             | "ko"              | "KR"
  /// "Malay"              | "ms"              | "MY"
  /// "Portuguese"         | "pt"              | "PT"
  /// "Russian"            | "ru"              | "RU"
  /// "Thai"               | "th"              | "TH"
  /// "Turkish"            | "tr"              | "TR"
  /// "Chinese"            | "zh"              | "CN"
  /// ..............................................................
  ///
  static final Language defaultLanguage =
      Language(languageCode: 'en', countryCode: 'US', name: 'English US');

  static final List<Language> psSupportedLanguageList = <Language>[
    Language(languageCode: 'en', countryCode: 'US', name: 'English'),
    Language(languageCode: 'ar', countryCode: 'DZ', name: 'Arabic'),
    Language(languageCode: 'hi', countryCode: 'IN', name: 'Hindi'),
    Language(languageCode: 'de', countryCode: 'DE', name: 'German'),
    Language(languageCode: 'es', countryCode: 'ES', name: 'Spainish'),
    Language(languageCode: 'fr', countryCode: 'FR', name: 'French'),
    Language(languageCode: 'id', countryCode: 'ID', name: 'Indonesian'),
    Language(languageCode: 'it', countryCode: 'IT', name: 'Italian'),
    Language(languageCode: 'ja', countryCode: 'JP', name: 'Japanese'),
    Language(languageCode: 'ko', countryCode: 'KR', name: 'Korean'),
    Language(languageCode: 'ms', countryCode: 'MY', name: 'Malay'),
    Language(languageCode: 'pt', countryCode: 'PT', name: 'Portuguese'),
    Language(languageCode: 'ru', countryCode: 'RU', name: 'Russian'),
    Language(languageCode: 'th', countryCode: 'TH', name: 'Thai'),
    Language(languageCode: 'tr', countryCode: 'TR', name: 'Turkish'),
    Language(languageCode: 'zh', countryCode: 'CN', name: 'Chinese'),
  ];

  ///
  /// Price Format
  /// Need to change according to your format that you need
  /// E.g.
  /// ",##0.00"   => 2,555.00
  /// "##0.00"    => 2555.00
  /// ".00"       => 2555.00
  /// ",##0"      => 2555
  /// ",##0.0"    => 2555.0
  ///
  // static const String priceFormat = ',##0.00';

  ///
  /// Date Time Format
  ///
  // static const String dateFormat = 'dd-MM-yyyy hh:mm:ss';

  ///
  /// Tmp Image Folder Name
  ///
  static const String tmpImageFolderName = 'FlutterAdhouses';

  ///
  /// Image Loading
  ///
  /// - If you set "true", it will load thumbnail image first and later it will
  ///   load full image
  /// - If you set "false", it will load full image directly and for the
  ///   placeholder image it will use default placeholder Image.
  ///
  // static const bool USE_THUMBNAIL_AS_PLACEHOLDER = false;

  ///
  /// Token Id
  ///
  /// "true" = it will show token id under setting
  // static const bool isShowTokenId = true;

  ///
  /// ShowSubCategory
  ///
  // static const bool isShowSubCategory = true;

  ///
  /// GoogleMap, default map is Flutter Map
  ///
  // static const bool isUseGoogleMap = true;

  ///
  /// Promote Item
  ///
  // static const String PROMOTE_FIRST_CHOICE_DAY_OR_DEFAULT_DAY = '7 ';
  // static const String PROMOTE_SECOND_CHOICE_DAY = '14 ';
  // static const String PROMOTE_THIRD_CHOICE_DAY = '30 ';
  // static const String PROMOTE_FOURTH_CHOICE_DAY = '60 ';

  ///
  /// Image Size
  ///
  // static const int uploadImageSize = 1024;
  // static const int profileImageSize = 512;
  // static const int chatImageSize = 650;

  ///
  /// Blue Mark Size
  ///
  // static const double blueMarkSize = 15;

  ///
  /// Default Limit
  ///
  // static const int DEFAULT_LOADING_LIMIT = 40;
  // static const int CATEGORY_LOADING_LIMIT = 10;
  // static const int POSTED_BY_LOADING_LIMIT = 10;
  // static const int RECENT_ITEM_LOADING_LIMIT = 10;
  // static const int POPULAR_ITEM_LOADING_LIMIT = 10;
  // static const int FEATURE_ITEM_LOADING_LIMIT = 10;
  // static const int BLOCK_SLIDER_LOADING_LIMIT = 10;
  // static const int FOLLOWER_ITEM_LOADING_LIMIT = 10;
  // static const int DISCOUNT_ITEM_LOADING_LIMIT = 30;
  // static const int AGENT_LOADING_LIMIT = 10;
  // static const int AMENITIES_LOADING_LIMIT = 10;
  // static const int BLOCK_ITEM_LOADING_LIMIT = 5;

  ///
  ///Login Setting
  ///
  // static bool showFacebookLogin = true;
  // static bool showGoogleLogin = true;
  // static bool showPhoneLogin = true;

  ///
  /// Mile Range for nearest item
  ///
  // static const String mile = '8';

  ///
  /// Map Filter Setting
  ///
  // static bool noFilterWithLocationOnMap = false;

  ///
  /// Show AdMob inside List
  ///
  // static bool isShowAdMobInsideList = true;

  ///
  /// one Admob will show after item count (eg 5) in vertical list
  ///
  // static int afterItemCountAdmobOnce = 5;

  ///
  /// Admob in item detail
  ///
  // static bool isShowAdsInItemDetail = true;

  ///
  /// full Admob show in item detail after seeing item 10 times
  ///
  // static int itemDetailViewCountForAds = 5;

  ///
  /// Razor Currency
  ///
  /// If you set true, your razor account must support multi-currency.
  // static bool isRazorSupportMultiCurrency = false;
  // static String defaultRazorCurrency = 'INR'; // Don't change

  ///
  /// Cannot upload video > this duration
  ///
  // static const double videoDuration = 60000; //millisecond

  ///
  /// Video Setting
  ///
  // static const bool showVideo = true;

  ///
  /// Owner Info Setting
  ///
  // static bool isShowOnwnerInfo = true;

  static bool isDemo = true;
}
