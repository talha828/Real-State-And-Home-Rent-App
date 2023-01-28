// Copyright (c) 2019, the PS Project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// PS license that can be found in the LICENSE file.


import 'package:flutter/material.dart';
import 'package:flutteradhouse/utils/utils.dart';

/// Colors Config For the whole App
/// Please change the color based on your brand need.

///
/// Dark Theme
///
// const Color ps_wtheme_color_primary = Color(0xFFFFFFFF);
// const Color ps_wtheme_color_primary_dark = Color(0xfFC7D180);
// const Color ps_wtheme_color_primary_light = Color(0xfEFAD670);

// const Color ps_wtheme_text__primary_color = Color(0xFF656565);
// const Color ps_wtheme_text__primary_light_color = Color(0xFFadadad);
// const Color ps_wtheme_text__primary_dark_color = Color(0xFF424242);

// const Color ps_wtheme_icon_color = Color(0xFF757575);
// const Color ps_wtheme_white_color = Colors.white;

// ///
// /// White Theme
// ///
// const Color ps_dtheme_color_primary = Color(0xFF303030);
// const Color ps_dtheme_color_primary_dark = Color(0xFF555555);
// const Color ps_dtheme_color_primary_light = Color(0xFF555555);

// const Color ps_dtheme_text__primary_color = Color(0xFFFFFFFF);
// const Color ps_dtheme_text__primary_light_color = Color(0xFFFFFFFF);
// const Color ps_dtheme_text__primary_dark_color = Color(0xFFFFFFFF);

// const Color ps_dtheme_icon_color = Colors.white;
// const Color ps_dtheme_white_color = Color(0xFF757575);

// ///
// /// Common Theme
// ///
// const Color ps_ctheme_text__category_title = Color(0xFFffcc00);
// const Color ps_ctheme_button__category_title = Color(0xFFffcc00);
// const Color ps_ctheme_text__color_gery = Color(0xFF757575);
// const Color ps_ctheme_text__color_primary_light = Color(0xFFbdbdbd);
// const Color ps_ctheme__color_speical = Color(0xFFD2232A);
// const Color ps_ctheme__color_about_us = Colors.cyan;
// const Color ps_ctheme__color_application = Colors.blue;
// const Color ps_ctheme__color_line = Color(0xFFbdbdbd);
// const Color ps_ctheme__sold_out = Color(0x80D2232A);
// const Color ps_ctheme__global_primary = Color(0xFFD2232A);

// Copyright (c) 2019, the PS Project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// PS license that can be found in the LICENSE file.

// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutterbuyandsell/utils/utils.dart';

class PsColors {
  PsColors._();

  ///
  /// Main Color
  ///
  static Color mainColor = _c_main_color;
  static Color mainColorWithWhite = Colors.white;
  static Color mainColorWithBlack  = Colors.black;
  static Color mainDarkColor = _c_main_dark_color;
  static Color mainLightColor = _c_main_light_color;
  static Color mainLightColorWithBlack = _d_base_color;
  static Color mainLightColorWithWhite = Colors.white;
  static Color mainShadowColor = Colors.black.withOpacity(0.5);
  static Color mainLightShadowColor = Colors.black.withOpacity(0.5);
  static Color mainDividerColor  = _d_divider_color;
  static Color whiteColorWithBlack = Colors.black;
  static Color saleColor = _c_sale_color;
  static Color rentColor = _c_rent_color;
  static Color homeColor = _c_home_color;

  ///
  /// Base Color
  ///
  static Color baseColor = _d_base_color;
  static Color baseDarkColor = _d_base_dark_color;
  static Color baseLightColor = _d_base_light_color;

  ///
  /// Text Color
  ///
  static Color textPrimaryColor = _d_text_primary_color;
  static Color textPrimaryDarkColor = _d_text_primary_dark_color;
  static Color textPrimaryLightColor = _d_text_primary_light_color;

  static Color textPrimaryColorForLight = _l_text_primary_color;
  static Color textPrimaryDarkColorForLight  = _l_text_primary_dark_color;
  static Color textPrimaryLightColorForLight = _l_text_primary_light_color;

  ///
  /// Icon Color
  ///
  static Color iconColor = _l_icon_color;

  ///
  /// Background Color
  ///
  static Color coreBackgroundColor = _l_base_color;
  static Color backgroundColor = _l_base_dark_color;


  ///
  /// General
  ///
  static Color white = _c_white_color;
  static Color black =  _c_black_color;
  static Color grey = _c_grey_color;
  static Color transparent = _c_transparent_color;

  ///
  /// Customs
  ///
  static Color facebookLoginButtonColor = _c_facebook_login_color;
  static Color googleLoginButtonColor = _c_google_login_color;
  static Color appleLoginButtonColor = _c_apple_login_color;
  static Color phoneLoginButtonColor  = _c_phone_login_color;
  static Color disabledFacebookLoginButtonColor = _c_grey_color;
  static Color disabledGoogleLoginButtonColor = _c_grey_color;
  static Color disabledAppleLoginButtonColor = _c_grey_color;
  static Color disabledPhoneLoginButtonColor = _c_grey_color;

  static Color paypalColor = _c_paypal_color;
  static Color stripeColor = _c_stripe_color;

  static Color categoryBackgroundColor = _d_base_light_color;
  static Color loadingCircleColor  = _c_blue_color;
  static Color ratingColor = _c_rating_color;

  static Color soldOutUIColor = _c_sold_out;
  static Color itemTypeColor  = _c_item_type_color;

  static Color paidAdsColor  = _c_paid_ads_color;

  static Color bluemarkColor = _c_blue_color;

  /// Colors Config For the whole App
  /// Please change the color based on your brand need.

  ///
  /// Light Theme
  ///
  static const Color _l_base_color = Color(0xFEF7F7F7);
  static const Color _l_base_dark_color = Color(0xFFFFFFFF);
  static const Color _l_base_light_color = Color(0xFFEFEFEF);

  static const Color _l_text_primary_color = Color(0xFF445E76);
  static const Color _l_text_primary_light_color = Color(0xFFadadad);
  static const Color _l_text_primary_dark_color = Color(0xFF25425D);

  static const Color _l_icon_color = Color(0xFF445E76);

  static const Color _l_divider_color = Color(0x15505050);

  ///
  /// Dark Theme
  ///
  static const Color _d_base_color = Color(0xFF212121);
  static const Color _d_base_dark_color = Color(0xFF303030);
  static const Color _d_base_light_color = Color(0xFF454545);

  static const Color _d_text_primary_color = Color(0xFFFFFFFF);
  static const Color _d_text_primary_light_color = Color(0xFFFFFFFF);
  static const Color _d_text_primary_dark_color = Color(0xFFFFFFFF);

  static const Color _d_icon_color = Colors.white;

  static const Color _d_divider_color = Color(0x1FFFFFFF);

  ///
  /// Common Theme
  ///
  // static const Color _c_main_color = Color(0xFFD31A20);
  // static const Color _c_main_light_color = Color(0xFFFFF0F1);
  // static const Color _c_main_dark_color = Color(0xFF95292C);
  static const Color _c_main_color = Color(0xFF5B45CE);
  static const Color _c_main_light_color = Color(0xFFE9E5FF);
  static const Color _c_main_dark_color = Color(0xFF221660);

  static const Color _c_sale_color = Color(0xFFE60C0C);
  static const Color _c_rent_color = Color(0xFFE67D10);
  static const Color _c_home_color = Color(0xFF1F21EE);

  static const Color _c_white_color = Colors.white;
  static const Color _c_black_color = Colors.black;
  static const Color _c_grey_color = Colors.grey;
  static const Color _c_blue_color = Colors.blue;
  static const Color _c_transparent_color = Colors.transparent;
  static const Color _c_paid_ads_color = Colors.lightGreen;

  static const Color _c_facebook_login_color = Color(0xFF2153B2);
  static const Color _c_google_login_color = Color(0xFFFF4D4D);
  static const Color _c_phone_login_color = Color(0xFF9F7A2A);
  static const Color _c_apple_login_color = Color(0xFF111111);

  static const Color _c_paypal_color = Color(0xFF3b7bbf);
  static const Color _c_stripe_color = Color(0xFF008cdd);

  static const Color _c_rating_color = Colors.yellow;
  static const Color _c_sold_out = Color(0x80D2232A);
  static const Color _c_item_type_color = Color(0xFFBDBDBD);

  // static const Color ps_ctheme__color_about_us = Colors.cyan;
  // static const Color ps_ctheme__color_application = Colors.blue;
  // static const Color ps_ctheme__color_line = Color(0xFFbdbdbd);

  static void loadColor(BuildContext context) {
    if (Utils.isLightMode(context)) {
      _loadLightColors();
    } else {
      _loadDarkColors();
    }
  }

  static void loadColor2(bool isLightMode) {
    if (isLightMode) {
      _loadLightColors();
    } else {
      _loadDarkColors();
    }
  }

  static void _loadDarkColors() {
    ///
    /// Main Color
    ///
    mainColor = _c_main_color;
    mainColorWithWhite = Colors.white;
    mainColorWithBlack = Colors.black;
    mainDarkColor = _c_main_dark_color;
    mainLightColor = _c_main_light_color;
    mainLightColorWithBlack = _d_base_color;
    mainLightColorWithWhite = Colors.white;
    mainShadowColor = Colors.black.withOpacity(0.5);
    mainLightShadowColor = Colors.black.withOpacity(0.5);
    mainDividerColor = _d_divider_color;
    whiteColorWithBlack = Colors.black;
    saleColor = _c_sale_color;
    rentColor = _c_rent_color;
    homeColor = _c_home_color;

    ///
    /// Base Color
    ///
    baseColor = _d_base_color;
    baseDarkColor = _d_base_dark_color;
    baseLightColor = _d_base_light_color;

    ///
    /// Text Color
    ///
    textPrimaryColor = _d_text_primary_color;
    textPrimaryDarkColor = _d_text_primary_dark_color;
    textPrimaryLightColor = _d_text_primary_light_color;

    textPrimaryColorForLight = _l_text_primary_color;
    textPrimaryDarkColorForLight = _l_text_primary_dark_color;
    textPrimaryLightColorForLight = _l_text_primary_light_color;

    ///
    /// Icon Color
    ///
    iconColor = _d_icon_color;

    ///
    /// Background Color
    ///
    coreBackgroundColor = _d_base_color;
    backgroundColor = _d_base_dark_color;

    ///
    /// General
    ///
    white = _c_white_color;
    black = _c_black_color;
    grey = _c_grey_color;
    transparent = _c_transparent_color;

    ///
    /// Custom
    ///
    facebookLoginButtonColor = _c_facebook_login_color;
    googleLoginButtonColor = _c_google_login_color;
    appleLoginButtonColor = _c_apple_login_color;
    phoneLoginButtonColor = _c_phone_login_color;
    disabledFacebookLoginButtonColor = _c_grey_color;
    disabledGoogleLoginButtonColor = _c_grey_color;
    disabledAppleLoginButtonColor = _c_grey_color;
    disabledPhoneLoginButtonColor = _c_grey_color;
    paypalColor = _c_paypal_color;
    stripeColor = _c_stripe_color;
    categoryBackgroundColor = _d_base_light_color;
    loadingCircleColor = _c_blue_color;
    ratingColor = _c_rating_color;
    soldOutUIColor = _c_sold_out;
    itemTypeColor = _c_item_type_color;
    paidAdsColor = _c_paid_ads_color;
    bluemarkColor = _c_blue_color;
  }

  static void _loadLightColors() {
    ///
    /// Main Color
    ///
    mainColor = _c_main_color;
    mainColorWithWhite = _c_main_color;
    mainColorWithBlack = _c_main_color;
    mainDarkColor = _c_main_dark_color;
    mainLightColor = _c_main_light_color;
    mainLightColorWithBlack = _c_main_light_color;
    mainLightColorWithWhite = _c_main_light_color;
    mainShadowColor = _c_main_color.withOpacity(0.6);
    mainLightShadowColor = _c_main_light_color;
    mainDividerColor = _l_divider_color;
    whiteColorWithBlack = _c_white_color;

    ///
    /// Base Color
    ///
    baseColor = _l_base_color;
    baseDarkColor = _l_base_dark_color;
    baseLightColor = _l_base_light_color;

    ///
    /// Text Color
    ///
    textPrimaryColor = _l_text_primary_color;
    textPrimaryDarkColor = _l_text_primary_dark_color;
    textPrimaryLightColor = _l_text_primary_light_color;

    textPrimaryColorForLight = _l_text_primary_color;
    textPrimaryDarkColorForLight = _l_text_primary_dark_color;
    textPrimaryLightColorForLight = _l_text_primary_light_color;

    ///
    /// Icon Color
    ///
    iconColor = _l_icon_color;

    ///
    /// Background Color
    ///
    coreBackgroundColor = _l_base_color;
    backgroundColor = _l_base_dark_color;

    ///
    /// General
    ///
    white = _c_white_color;
    black = _c_black_color;
    grey = _c_grey_color;
    transparent = _c_transparent_color;

    ///
    /// Custom
    ///
    facebookLoginButtonColor = _c_facebook_login_color;
    googleLoginButtonColor = _c_google_login_color;
    appleLoginButtonColor = _c_apple_login_color;
    phoneLoginButtonColor = _c_phone_login_color;
    disabledFacebookLoginButtonColor = _c_grey_color;
    disabledGoogleLoginButtonColor = _c_grey_color;
    disabledAppleLoginButtonColor = _c_grey_color;
    disabledPhoneLoginButtonColor = _c_grey_color;
    paypalColor = _c_paypal_color;
    stripeColor = _c_stripe_color;
    categoryBackgroundColor = _c_main_light_color;
    loadingCircleColor = _c_blue_color;
    ratingColor = _c_rating_color;
    soldOutUIColor = _c_sold_out;
    itemTypeColor = _c_item_type_color;
    paidAdsColor = _c_paid_ads_color;
    bluemarkColor = _c_blue_color;
  }
}
