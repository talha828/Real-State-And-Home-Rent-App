import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutteradhouse/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/agent/agent_list_provider.dart';
import 'package:flutteradhouse/provider/blog/blog_provider.dart';
import 'package:flutteradhouse/provider/chat/user_unread_message_provider.dart';
import 'package:flutteradhouse/provider/post_type/post_type_provider.dart';
import 'package:flutteradhouse/provider/product/discount_product_provider.dart';
import 'package:flutteradhouse/provider/product/item_list_from_followers_provider.dart';
import 'package:flutteradhouse/provider/product/nearest_product_provider.dart';
import 'package:flutteradhouse/provider/product/paid_ad_product_provider%20copy.dart';
import 'package:flutteradhouse/provider/product/popular_product_provider.dart';
import 'package:flutteradhouse/provider/product/recent_product_provider.dart';
import 'package:flutteradhouse/provider/product/search_product_provider.dart';
import 'package:flutteradhouse/provider/property_type/property_type_provider.dart';
import 'package:flutteradhouse/repository/Common/notification_repository.dart';
import 'package:flutteradhouse/repository/blog_repository.dart';
import 'package:flutteradhouse/repository/item_location_city_repository.dart';
import 'package:flutteradhouse/repository/paid_ad_item_repository.dart';
import 'package:flutteradhouse/repository/post_type_repository.dart';
import 'package:flutteradhouse/repository/product_repository.dart';
import 'package:flutteradhouse/repository/property_type_repository.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/repository/user_unread_message_repository.dart';
import 'package:flutteradhouse/ui/agent/agent_horizontal_list_item.dart';
//import 'package:rate_my_app/rate_my_app.dart';
import 'package:flutteradhouse/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutteradhouse/ui/common/dialog/rating_dialog/core.dart';
import 'package:flutteradhouse/ui/common/dialog/rating_dialog/style.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget_with_round_corner.dart';
import 'package:flutteradhouse/ui/common/ps_dropdown_base_with_icon_controller.widget.dart';
import 'package:flutteradhouse/ui/common/ps_expansion_tile.dart';
import 'package:flutteradhouse/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradhouse/ui/common/ps_textfield_widget_with_price_icon.dart';
import 'package:flutteradhouse/ui/common/ps_textfield_widget_with_search_icon.dart';
import 'package:flutteradhouse/ui/item/item/product_horizontal_list_item.dart';
import 'package:flutteradhouse/ui/post_type/item/post_type_horizontal_list_item.dart';
import 'package:flutteradhouse/ui/property_type/item/property_type_horizontal_list_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/blog.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/user_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/property_type_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/user_unread_message_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/post_type.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:flutteradhouse/viewobject/property_type.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';

import 'blog_product_slider.dart';

class HomeDashboardViewWidget extends StatefulWidget {
  const HomeDashboardViewWidget(
    this.scrollController,
    this.animationController,
    this.animationControllerForFab,
    this.context,
  );

  final ScrollController scrollController;
  final AnimationController animationController;
  final AnimationController animationControllerForFab;

  final BuildContext context;

  @override
  _HomeDashboardViewWidgetState createState() =>
      _HomeDashboardViewWidgetState();
}

class _HomeDashboardViewWidgetState extends State<HomeDashboardViewWidget> {
  PsValueHolder? valueHolder;
  PropertyTypeRepository? repo1;
  ProductRepository? repo2;
  BlogRepository? repo3;
  ItemLocationCityRepository? repo4;
  PostTypeRepository? repo5;
  UserRepository? repo6;
  NotificationRepository ?notificationRepository;
  PropertyTypeProvider? _propertyByProvider;
  PostTypeProvider? _postedByProvider;
  SearchProductProvider? _searchProductProvider;
  AgentListProvider? _agentListProvider;
  RecentProductProvider? _recentProductProvider;
  NearestProductProvider? _nearestProductProvider;
  PopularProductProvider? _popularProductProvider;
  PaidAdProductProvider? _paidAdItemProvider;
  DiscountProductProvider? _discountProductProvider;
  BlogProvider? _blogProvider;
  UserUnreadMessageProvider? _userUnreadMessageProvider;
  ItemListFromFollowersProvider? _itemListFromFollowersProvider;
  UserUnreadMessageRepository ?userUnreadMessageRepository;
  PaidAdItemRepository? paidAdItemRepository;

  final int count = 8;
  final PropertyTypeParameterHolder trendingCategory =
      PropertyTypeParameterHolder();
  final PropertyTypeParameterHolder categoryIconList =
      PropertyTypeParameterHolder();
  // final FirebaseMessaging _fcm = FirebaseMessaging();
  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();
  final TextEditingController userInputFromPriceEditingController =
      TextEditingController();
  final TextEditingController userInputToPriceEditingController =
      TextEditingController();
  final TextEditingController propertyTypeController =
      TextEditingController();
  final TextEditingController postTypeController =
      TextEditingController();
  Position? _currentPosition;
  bool androidFusedLocation = true;     

  @override
  void dispose() {
    super.dispose();
  }

  final RateMyApp _rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 0,
      minLaunches: 1,
      remindDays: 5,
      remindLaunches: 1);

  @override
  void initState() {
    super.initState();

   if (Platform.isAndroid) {
    _rateMyApp.init().then((_) {
      if (_rateMyApp.shouldOpenDialog) {
        _rateMyApp.showStarRateDialog(
          context,
          title: Utils.getString(context, 'home__menu_drawer_rate_this_app'),
          message: Utils.getString(context, 'rating_popup_dialog_message'),
          ignoreNativeDialog: true,
          actionsBuilder: (BuildContext context, double? stars) {
            return <Widget>[
              TextButton(
                child: Text(
                  Utils.getString(context, 'dialog__ok'),
                ),
                onPressed: () async {
                  if (stars != null) {
                    // _rateMyApp.save().then((void v) => Navigator.pop(context));
                    Navigator.pop(context);
                    if (stars < 1) {
                    } else if (stars >= 1 && stars <= 3) {
                      await _rateMyApp
                          .callEvent(RateMyAppEventType.laterButtonPressed);
                      await showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmDialogView(
                              description: Utils.getString(
                                  context, 'rating_confirm_message'),
                              leftButtonText:
                                  Utils.getString(context, 'dialog__cancel'),
                              rightButtonText: Utils.getString(
                                  context, 'home__menu_drawer_contact_us'),
                              onAgreeTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  RoutePaths.contactUs,
                                );
                              },
                            );
                          });
                    } else if (stars >= 4) {
                      await _rateMyApp
                          .callEvent(RateMyAppEventType.rateButtonPressed);
                      if (Platform.isIOS) {
                        Utils.launchAppStoreURL(
                            iOSAppId: valueHolder!.iosAppStoreId,
                            writeReview: true);
                      } else {
                        Utils.launchURL();
                      }
                    }
                  } else {
                    Navigator.pop(context);
                  }
                },
              )
            ];
          },
          onDismissed: () =>
              _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
          dialogStyle: const DialogStyle(
            titleAlign: TextAlign.center,
            messageAlign: TextAlign.center,
            messagePadding: EdgeInsets.only(bottom: 16.0),
          ),
          starRatingOptions: const StarRatingOptions(),
        );
      }
    });
   }

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        // setState(() {
        //   _isVisible = false;
        //   //print('**** $_isVisible up');
        // });
        //if (widget.animationControllerForFab != null) {
          widget.animationControllerForFab.reverse();
        //}
      }
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // setState(() {
        //   _isVisible = true;
        //   //print('**** $_isVisible down');
        // });
       // if (widget.animationControllerForFab != null) {
          widget.animationControllerForFab.forward();
       // }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<PropertyTypeRepository>(context);
    repo2 = Provider.of<ProductRepository>(context);
    repo3 = Provider.of<BlogRepository>(context);
    repo4 = Provider.of<ItemLocationCityRepository>(context);
    repo5 = Provider.of<PostTypeRepository>(context);
    repo6 = Provider.of<UserRepository>(context);

    paidAdItemRepository = Provider.of<PaidAdItemRepository>(context);
    userUnreadMessageRepository =
        Provider.of<UserUnreadMessageRepository>(context);

    notificationRepository = Provider.of<NotificationRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<NearestProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _nearestProductProvider = NearestProductProvider(
                    repo: repo2, limit: valueHolder!.recentItemLoadingLimit!);
                final String loginUserId = Utils.checkUserLoginId(valueHolder!);
                Geolocator.checkPermission().then((LocationPermission permission) {
                if (permission == LocationPermission.denied) {
                  Geolocator.requestPermission().then((LocationPermission permission) {
                      if (permission == LocationPermission.denied) {
                        //permission denied, do nothing
                      } else {
                      Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.medium,
                        forceAndroidLocationManager: !androidFusedLocation)
                    .then((Position position) {
                  if (mounted) {
                    setState(() {
                      _currentPosition = position;
                    });
                    _nearestProductProvider?.productNearestParameterHolder.lat =
                        _currentPosition?.latitude.toString();
                    _nearestProductProvider?.productNearestParameterHolder.lng =
                        _currentPosition?.longitude.toString();
                    _nearestProductProvider
                        ?.productNearestParameterHolder.mile = valueHolder!.mile;
                    _nearestProductProvider?.resetProductList(loginUserId,
                      _nearestProductProvider!.productNearestParameterHolder,
                    );
                  }
                }).catchError((Object e) {
                  //
                });
                      }
                  });
                } else {
                  Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.medium,
                        forceAndroidLocationManager: !androidFusedLocation)
                    .then((Position position) {
                  if (mounted) {
                    setState(() {
                      _currentPosition = position;
                    });
                    _nearestProductProvider?.productNearestParameterHolder.lat =
                        _currentPosition?.latitude.toString();
                    _nearestProductProvider?.productNearestParameterHolder.lng =
                        _currentPosition?.longitude.toString();
                    _nearestProductProvider
                        ?.productNearestParameterHolder.mile = valueHolder!.mile;
                    _nearestProductProvider?.resetProductList(loginUserId,
                      _nearestProductProvider!.productNearestParameterHolder,
                    );
                  }
                }).catchError((Object e) {
                  //
                });
                }
              });
                return _nearestProductProvider!;
              }),
          ChangeNotifierProvider<PropertyTypeProvider>(
              lazy: false,
              create: (BuildContext context) {
                _propertyByProvider ??= PropertyTypeProvider(
                    repo: repo1,
                    psValueHolder: valueHolder,
                    limit: valueHolder!.categoryLoadingLimit!);
                _propertyByProvider!.loadPropertyTypeList(_propertyByProvider!.propertyType.toMap(),valueHolder!.loginUserId).then((dynamic value) {
                  // Utils.psPrint("Is Has Internet " + value);
                  final bool isConnectedToIntenet = value ?? bool;
                  if (!isConnectedToIntenet) {
                    Fluttertoast.showToast(
                        msg: 'No Internet Connectiion. Please try again !',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);
                  }
                });
                return _propertyByProvider!;
              }),
          ChangeNotifierProvider<PostTypeProvider>(
              lazy: false,
              create: (BuildContext context) {
                _postedByProvider ??= PostTypeProvider(
                    repo: repo5, limit: valueHolder!.postedByLoadingLimit!);
                _postedByProvider!.loadPostTypeList();

                return _postedByProvider!;
              }),
          ChangeNotifierProvider<AgentListProvider>(
              lazy: false,
              create: (BuildContext context) {
                _agentListProvider ??= AgentListProvider(
                    repo: repo6, limit: valueHolder!.agentLoadingLimit!);
                _agentListProvider!.loadAgentList();

                return _agentListProvider!;
              }),
          ChangeNotifierProvider<SearchProductProvider>(
            lazy: false,
            create: (BuildContext content) {
              _searchProductProvider = SearchProductProvider(
                  repo: repo2, psValueHolder: valueHolder);
              _searchProductProvider!.productParameterHolder =
                  productParameterHolder;
              final String loginUserId =
                      Utils.checkUserLoginId(valueHolder!);
              _searchProductProvider!.loadProductListByKey(
                  loginUserId,
                  _searchProductProvider!.productParameterHolder);

              return _searchProductProvider!;
            }),
          ChangeNotifierProvider<RecentProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _recentProductProvider = RecentProductProvider(
                    repo: repo2, limit: valueHolder!.recentItemLoadingLimit!);
                _recentProductProvider!.productRecentParameterHolder
                    .itemLocationCityId = valueHolder!.locationId;
                _recentProductProvider!.productRecentParameterHolder
                    .itemLocationName = valueHolder!.locactionName;
                if (valueHolder!.isSubLocation == PsConst.ONE) {
                  _recentProductProvider!.productRecentParameterHolder
                      .itemLocationTownshipId = valueHolder!.locationTownshipId;
                  _recentProductProvider!.productRecentParameterHolder
                      .itemLocationTownshipName = valueHolder!.locationTownshipName;
                }
                final String loginUserId = Utils.checkUserLoginId(valueHolder!);
                _recentProductProvider!.loadProductList(loginUserId,
                    _recentProductProvider!.productRecentParameterHolder);
                return _recentProductProvider!;
              }),
          ChangeNotifierProvider<PopularProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _popularProductProvider = PopularProductProvider(
                    repo: repo2, limit: valueHolder!.populartItemLoadingLimit!);
                _popularProductProvider!.productPopularParameterHolder
                    .itemLocationCityId = valueHolder!.locationId;
                 _popularProductProvider!.productPopularParameterHolder
                    .itemLocationName = valueHolder!.locactionName;
                if (valueHolder!.isSubLocation == PsConst.ONE) {
                  _popularProductProvider!.productPopularParameterHolder
                    .itemLocationTownshipId = valueHolder!.locationTownshipId;
                  _popularProductProvider!.productPopularParameterHolder
                          .itemLocationTownshipName =
                      valueHolder!.locationTownshipName;
                }
                final String loginUserId = Utils.checkUserLoginId(valueHolder!);
                _popularProductProvider!.loadProductList(loginUserId,
                    _popularProductProvider!.productPopularParameterHolder);
                return _popularProductProvider!;
              }),
          ChangeNotifierProvider<PaidAdProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _paidAdItemProvider = PaidAdProductProvider(
                    repo: repo2, limit: valueHolder!.featuredItemLoadingLimit!);
                _paidAdItemProvider!.productPaidAdParameterHolder
                    .itemLocationCityId = valueHolder!.locationId;
                 _paidAdItemProvider!.productPaidAdParameterHolder
                    .itemLocationName = valueHolder!.locactionName;
                if (valueHolder!.isSubLocation == PsConst.ONE) {
                  _paidAdItemProvider!.productPaidAdParameterHolder
                    .itemLocationTownshipId = valueHolder!.locationTownshipId;
                 _paidAdItemProvider!.productPaidAdParameterHolder
                          .itemLocationTownshipName =
                      valueHolder!.locationTownshipName;
                }
                final String loginUserId = Utils.checkUserLoginId(valueHolder!);
                _paidAdItemProvider!.loadProductList(loginUserId,
                    _paidAdItemProvider!.productPaidAdParameterHolder);
                return _paidAdItemProvider!;
              }),
            ChangeNotifierProvider<DiscountProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _discountProductProvider = DiscountProductProvider(
                    repo: repo2!, limit: valueHolder!.discountItemLoadingLimit!);
                _discountProductProvider!.productDiscountParameterHolder
                    .itemLocationCityId = valueHolder!.locationId;
                _discountProductProvider!.productDiscountParameterHolder
                    .itemLocationName = valueHolder!.locactionName;
                if (valueHolder!.isSubLocation == PsConst.ONE) {
                  _discountProductProvider!.productDiscountParameterHolder
                      .itemLocationTownshipId = valueHolder!.locationTownshipId;
                  _discountProductProvider!.productDiscountParameterHolder
                          .itemLocationTownshipName =
                      valueHolder!.locationTownshipName;
                }
                final String? loginUserId =
                    Utils.checkUserLoginId(valueHolder!);
                _discountProductProvider!.loadProductList(loginUserId,
                    _discountProductProvider!.productDiscountParameterHolder);
                return _discountProductProvider!;
              }),  
          ChangeNotifierProvider<BlogProvider>(
              lazy: false,
              create: (BuildContext context) {
                _blogProvider = BlogProvider(
                    repo: repo3, limit: valueHolder!.blockSliderLoadingLimit!);
                _blogProvider!.blogParameterHolder.cityId =
                    valueHolder!.locationId;
                final String loginUserId = Utils.checkUserLoginId(valueHolder!);
                _blogProvider!.loadBlogList(
                    loginUserId, _blogProvider!.blogParameterHolder);
                return _blogProvider!;
              }),
          ChangeNotifierProvider<UserUnreadMessageProvider>(
              lazy: false,
              create: (BuildContext context) {
                _userUnreadMessageProvider = UserUnreadMessageProvider(
                    repo: userUnreadMessageRepository);

                if (valueHolder!.loginUserId != null &&
                    valueHolder!.loginUserId != '') {
                  _userUnreadMessageProvider!.userUnreadMessageHolder =
                      UserUnreadMessageParameterHolder(
                          userId: valueHolder!.loginUserId,
                          deviceToken: valueHolder!.deviceToken);
                  _userUnreadMessageProvider!.userUnreadMessageCount(
                      _userUnreadMessageProvider!.userUnreadMessageHolder);
                }
                return _userUnreadMessageProvider!;
              }),
          ChangeNotifierProvider<ItemListFromFollowersProvider>(
              lazy: false,
              create: (BuildContext context) {
                _itemListFromFollowersProvider = ItemListFromFollowersProvider(
                    repo: repo2!,
                    psValueHolder: valueHolder!,
                    limit: valueHolder!.followerItemLoadingLimit!);
                  _itemListFromFollowersProvider!.followUserItemParameterHolder
                      .itemLocationId = valueHolder!.locationId;
                  _itemListFromFollowersProvider!.followUserItemParameterHolder
                      .itemLocationTownshipId = valueHolder!.locationTownshipId;
                _itemListFromFollowersProvider!.loadItemListFromFollowersList(
                    _itemListFromFollowersProvider!.followUserItemParameterHolder.toMap(),
                    Utils.checkUserLoginId(
                        _itemListFromFollowersProvider!.psValueHolder));
                return _itemListFromFollowersProvider!;
              }
            ),    
          ],
        child: Scaffold(
          body: Container(
            color: PsColors.coreBackgroundColor,
            child: RefreshIndicator(
                onRefresh: () {
                  final String loginUserId =
                      Utils.checkUserLoginId(valueHolder!);
                  _recentProductProvider!.resetProductList(loginUserId,
                      _recentProductProvider!.productRecentParameterHolder);

                  _nearestProductProvider!.resetProductList(loginUserId,
                       _nearestProductProvider!.productNearestParameterHolder);    

                  _popularProductProvider!.resetProductList(loginUserId,
                      _popularProductProvider!.productPopularParameterHolder);

                  _paidAdItemProvider!.resetProductList(loginUserId,
                      _paidAdItemProvider!.productPaidAdParameterHolder);

                  _discountProductProvider!.resetProductList(loginUserId,
                      _discountProductProvider!.productDiscountParameterHolder);  

                  _blogProvider!.resetBlogList(
                      loginUserId, _blogProvider!.blogParameterHolder);

                  if (valueHolder!.loginUserId != null &&
                      valueHolder!.loginUserId != '') {
                    _userUnreadMessageProvider!.userUnreadMessageCount(
                        _userUnreadMessageProvider!.userUnreadMessageHolder);
                  }

                  _itemListFromFollowersProvider!.followUserItemParameterHolder
                      .itemLocationId = valueHolder!.locationId;
                  _itemListFromFollowersProvider!.followUserItemParameterHolder
                      .itemLocationTownshipId = valueHolder!.locationTownshipId;

                  _itemListFromFollowersProvider!.resetItemListFromFollowersList(
                      _itemListFromFollowersProvider!.followUserItemParameterHolder.toMap(),
                      Utils.checkUserLoginId(
                          _itemListFromFollowersProvider!.psValueHolder));

                  return _propertyByProvider!
                      .resetPropertyTypeList(_propertyByProvider!.propertyType.toMap(),valueHolder!.loginUserId)
                      .then((dynamic value) {
                    // Utils.psPrint("Is Has Internet " + value);
                    final bool isConnectedToIntenet = value ?? bool;
                    if (!isConnectedToIntenet) {
                      Fluttertoast.showToast(
                          msg: 'No Internet Connectiion. Please try again !',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueGrey,
                          textColor: Colors.white);
                    }
                  });
                },
                child: CustomScrollView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  controller: widget.scrollController,
                  slivers: <Widget>[
                    _HomeHeaderWidget(
                      searchProductProvider: _searchProductProvider,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 1, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                      psValueHolder: valueHolder!,
                      itemNameTextEditingController:
                          userInputItemNameTextEditingController,
                      fromPriceTextEditingController: userInputFromPriceEditingController,
                      toPriceTextEditingController: userInputToPriceEditingController,
                      propertyTypeController: propertyTypeController,
                      postTypeController: postTypeController,
                    ),
                    _HomePropertyHorizontalListWidget(
                      psValueHolder: valueHolder!,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 2, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _NearestProductHorizontalListWidget(
                      psValueHolder: valueHolder!,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 3, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    HomeDiscountProductHorizontalListWidget(
                      psValueHolder: valueHolder,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _HomePaidAdProductHorizontalListWidget(
                      psValueHolder: valueHolder!,
                      animationController: widget.animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                    ),
                    _HomePostedByListWidget(
                      psValueHolder: valueHolder!,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 2, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _HomeAgentListWidget(
                      psValueHolder: valueHolder!,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 2, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                    ),
                    _HomePopularProductHorizontalListWidget(
                      psValueHolder: valueHolder!,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _HomeItemListFromFollowersHorizontalListWidget(
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _RecentProductHorizontalListWidget(
                      psValueHolder: valueHolder!,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 3, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _HomeBlogProductSliderListWidget(
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 5, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                  ],
                )),
          ),
        ));
  }
}

class _HomePopularProductHorizontalListWidget extends StatelessWidget {
  const _HomePopularProductHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<PopularProductProvider>(
        builder: (BuildContext context, PopularProductProvider productProvider,
            Widget? child) {
          return AnimatedBuilder(
            animation: animationController,
            child: (productProvider.productList.data != null &&
                    productProvider.productList.data!.isNotEmpty)
                ? Column(
                    children: <Widget>[
                    Container(
                       margin: const EdgeInsets.only(
                        top: PsDimens.space12),
                      color: PsColors.backgroundColor,
                      child: _MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'home__drawer_menu_popular_item'),
                        headerDescription: Utils.getString(
                            context, 'dashboard_popular_item_desc'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                              context, RoutePaths.filterProductList,
                              arguments: ProductListIntentHolder(
                                  appBarTitle: Utils.getString(context,
                                      'home__drawer_menu_popular_item'),
                                  productParameterHolder:
                                      productProvider.productPopularParameterHolder));
                          },
                        ),
                      ),
                      Container(
                        color: PsColors.backgroundColor,
                        height: PsDimens.space340,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                productProvider.productList.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (productProvider.productList.status ==
                                  PsStatus.BLOCK_LOADING) {
                                return Shimmer.fromColors(
                                    baseColor: PsColors.grey,
                                    highlightColor: PsColors.white,
                                    child: Row(children: const <Widget>[
                                      PsFrameUIForLoading(),
                                    ]));
                              } else {
                                final Product product =
                                    productProvider.productList.data![index];
                              if (productProvider
                                      .productList.data![index].adType! ==
                                  PsConst.GOOGLE_AD_TYPE) {
                                return  Container();
                              } else {
                                return ProductHorizontalListItem(
                                  coreTagKey:
                                      productProvider.hashCode.toString() +
                                          product.id!,
                                  product:
                                      productProvider.productList.data![index],
                                  psValueHolder: psValueHolder,
                                  onTap: () {
                                    // print(productProvider.productList
                                    //     .data[index].defaultPhoto.imgPath);
                                    final ProductDetailIntentHolder holder =
                                        ProductDetailIntentHolder(
                                            productId: productProvider
                                                .productList.data![index].id!,
                                            heroTagImage: productProvider
                                                    .hashCode
                                                    .toString() +
                                                product.id! +
                                                PsConst.HERO_TAG__IMAGE,
                                            heroTagTitle: productProvider
                                                    .hashCode
                                                    .toString() +
                                                product.id! +
                                                PsConst.HERO_TAG__TITLE);
 
                                    Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: holder);
                                  },
                                );
                              }
                              }
                          }))
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _HomePaidAdProductHorizontalListWidget extends StatelessWidget {
  const _HomePaidAdProductHorizontalListWidget({
    Key? key,
    required this.animationController,
    required this.animation,
    required this.psValueHolder,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<PaidAdProductProvider>(
        builder: (BuildContext context,
            PaidAdProductProvider paidAdItemProvider, Widget? child) {
          return AnimatedBuilder(
            animation: animationController,
            child: (paidAdItemProvider.productList.data != null &&
                    paidAdItemProvider.productList.data!.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                          top: PsDimens.space12),
                        color: PsColors.backgroundColor,
                        child: _MyHeaderWidget(
                          headerName: Utils.getString(
                              context, 'home__drawer_menu_feature_item'),
                          headerDescription: Utils.getString(
                              context, 'dashboard_follow_item_desc'),
                          viewAllClicked: () {
                            Navigator.pushNamed(
                                context, RoutePaths.paidAdProductList);
                          },
                        ),
                      ),
                      Container(
                          color: PsColors.backgroundColor,
                          height: PsDimens.space340,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  paidAdItemProvider.productList.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (paidAdItemProvider.productList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: Row(children: const <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  final Product product = paidAdItemProvider
                                      .productList.data![index];
                                  return ProductHorizontalListItem(
                                    coreTagKey:
                                        paidAdItemProvider.hashCode.toString() +
                                            product.id!,
                                    product: paidAdItemProvider
                                        .productList.data![index],
                                    psValueHolder: psValueHolder,
                                    onTap: () {
                                      // print(paidAdItemProvider.productList
                                      //     .data[index].defaultPhoto.imgPath);
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                              productId: paidAdItemProvider
                                                  .productList.data![index].id!,
                                              heroTagImage: paidAdItemProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle: paidAdItemProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__TITLE);
                                      Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                    },
                                  );
                                }
                              }))
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _HomeBlogProductSliderListWidget extends StatelessWidget {
  const _HomeBlogProductSliderListWidget({
    Key? key,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const int count = 6;
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval((1 / count) * 1, 1.0,
                curve: Curves.fastOutSlowIn)));

    return SliverToBoxAdapter(
      child: Consumer<BlogProvider>(builder:
          (BuildContext context, BlogProvider blogProvider, Widget? child) {
        return AnimatedBuilder(
            animation: animationController,
            child: (
                    blogProvider.blogList.data!.isNotEmpty)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName:
                            Utils.getString(context, 'home__menu_drawer_blog'),
                        headerDescription: Utils.getString(context, ''),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                            context,
                            RoutePaths.blogList,
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: PsColors.mainLightShadowColor,
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 20.0),
                          ],
                        ),
                        margin: const EdgeInsets.only(
                            top: PsDimens.space8, bottom: PsDimens.space20),
                        width: double.infinity,
                        child: BlogSliderView(
                          blogList: blogProvider.blogList.data!,
                          onTap: (Blog blog) {
                            Navigator.pushNamed(context, RoutePaths.blogDetail,
                                arguments: blog);
                          },
                        ),
                      )
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: child));
            });
      }),
    );
  }
}

class _RecentProductHorizontalListWidget extends StatefulWidget {
  const _RecentProductHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __RecentProductHorizontalListWidgetState createState() =>
      __RecentProductHorizontalListWidgetState();
}

class __RecentProductHorizontalListWidgetState
    extends State<_RecentProductHorizontalListWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && widget.psValueHolder.isShowAdmob!) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && widget.psValueHolder.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }

    return SliverToBoxAdapter(
        // fdfdf
        child: Consumer<RecentProductProvider>(builder: (BuildContext context,
            RecentProductProvider productProvider, Widget? child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          child: (productProvider.productList.data != null &&
                  productProvider.productList.data!.isNotEmpty)
              ? Column(children: <Widget>[
                  Container(
                  margin: const EdgeInsets.only(
                    top: PsDimens.space12),
                    color: PsColors.backgroundColor,
                    child: _MyHeaderWidget(
                      headerName:
                          Utils.getString(context, 'dashboard_recent_product'),
                      headerDescription:
                          Utils.getString(context, 'dashboard_recent_item_desc'),
                      viewAllClicked: () {
                        Navigator.pushNamed(context, RoutePaths.filterProductList,
                            arguments: ProductListIntentHolder(
                                appBarTitle: Utils.getString(
                                    context, 'dashboard_recent_product'),
                                productParameterHolder: productProvider.productRecentParameterHolder));
                      
                      },
                    ),
                  ),
                  Container(
                      color: PsColors.backgroundColor,
                      height: PsDimens.space340,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productProvider.productList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (productProvider.productList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey,
                                  highlightColor: PsColors.white,
                                  child: Row(children: const <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              final Product product =
                                  productProvider.productList.data![index];
                              if (productProvider
                                      .productList.data![index].adType! ==
                                  PsConst.GOOGLE_AD_TYPE) {
                                return  Container();
                              } else {
                              return ProductHorizontalListItem(
                                coreTagKey:
                                    productProvider.hashCode.toString() +
                                        product.id!,
                                product:
                                    productProvider.productList.data![index],
                                psValueHolder: widget.psValueHolder,
                                onTap: () {
                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                          productId: productProvider
                                              .productList.data![index].id!,
                                          heroTagImage: productProvider.hashCode
                                                  .toString() +
                                              product.id! +
                                              PsConst.HERO_TAG__IMAGE,
                                          heroTagTitle: productProvider.hashCode
                                                  .toString() +
                                              product.id! +
                                              PsConst.HERO_TAG__TITLE);
                                  Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: holder);
                                },
                              );
                            }
                            }
                          })),
                  const PsAdMobBannerWidget(
                    admobSize: AdSize.mediumRectangle,
                  ),
                ])
              : Container(),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: child));
          });
    }));
  }
}


class HomeDiscountProductHorizontalListWidget extends StatelessWidget {
  const HomeDiscountProductHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController? animationController;
  final Animation<double> animation;
  final PsValueHolder? psValueHolder;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<DiscountProductProvider>(
        builder: (BuildContext context, DiscountProductProvider productProvider,
            Widget? child) {
          return AnimatedBuilder(
            animation: animationController!,
            child: (productProvider.productList.data != null &&
                    productProvider.productList.data!.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      Container(
                       margin: const EdgeInsets.only(
                          top: PsDimens.space12),
                        color: PsColors.backgroundColor,
                        child: _MyHeaderWidget(
                          headerName: Utils.getString(
                              context, 'home__drawer_menu_discount_product'),
                          headerDescription: '',
                          viewAllClicked: () {
                           final PsValueHolder valueHolder =
                            Provider.of<PsValueHolder>(context, listen: false);
                         final ProductParameterHolder holder =
                            ProductParameterHolder().getDiscountParameterHolder();
                            holder.itemLocationCityId = valueHolder.locationId;
                            Navigator.pushNamed(
                                context, RoutePaths.filterProductList,
                                arguments: ProductListIntentHolder(
                                    appBarTitle: Utils.getString(context,
                                        'home__drawer_menu_discount_product'),
                                    productParameterHolder: holder));
                          },
                        ),
                      ),
                      Container(
                        color: PsColors.backgroundColor,
                          height: PsDimens.space340,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  productProvider.productList.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (productProvider.productList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: Row(children: const <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  final Product product =
                                      productProvider.productList.data![index];
                                if (productProvider
                                      .productList.data![index].adType! ==
                                  PsConst.GOOGLE_AD_TYPE) {
                                return  Container();
                              } else {
                                  return ProductHorizontalListItem(
                                    psValueHolder: psValueHolder!,
                                    coreTagKey:
                                        productProvider.hashCode.toString() +
                                            product.id!,
                                    product: productProvider
                                        .productList.data![index],
                                    onTap: () {
                                      print(productProvider.productList
                                          .data![index].defaultPhoto!.imgPath);
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                              productId: productProvider
                                                  .productList.data![index].id,
                                              heroTagImage: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__TITLE);
                                      Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                    },
                                  );
                                }
                                }
                              }))
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _NearestProductHorizontalListWidget extends StatefulWidget {
  const _NearestProductHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __NearestProductHorizontalListWidgetState createState() =>
      __NearestProductHorizontalListWidgetState();
}

class __NearestProductHorizontalListWidgetState
    extends State<_NearestProductHorizontalListWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && widget.psValueHolder.isShowAdmob!) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && widget.psValueHolder.isShowAdmob!) {
      print('loading ads....');
      // checkConnection();
    }

    return SliverToBoxAdapter(
        // fdfdf
        child: Consumer<NearestProductProvider>(builder: (BuildContext context,
            NearestProductProvider productProvider, Widget? child) {
      return RefreshIndicator(
        child: AnimatedBuilder(
            animation: widget.animationController,
            child: ((productProvider.productList.data != null &&
                    productProvider.productList.data!.isNotEmpty) && 
                    (productProvider.productNearestParameterHolder.lat != '' && productProvider.productNearestParameterHolder.lng != '')
                    )
                ? Column(children: <Widget>[
                    Container(
                    margin: const EdgeInsets.only(
                    top: PsDimens.space12),
                    color: PsColors.backgroundColor,
                      child: _MyHeaderWidget(
                        headerName:
                            Utils.getString(context, 'dashboard_nearest_product'),
                        headerDescription:
                            Utils.getString(context, 'dashboard_nearest_item_desc'),
                        viewAllClicked: () {
                                 final ProductParameterHolder holder =
                          ProductParameterHolder().getNearestParameterHolder();
                          holder.mile = widget.psValueHolder.mile;
                          holder.lat = productProvider.productNearestParameterHolder.lat;
                          holder.lng = productProvider.productNearestParameterHolder.lng;
                          Navigator.pushNamed(context, RoutePaths.nearestProductList,
                              arguments: ProductListIntentHolder(
                                  appBarTitle: Utils.getString(
                                      context, 'dashboard_nearest_product'),
                                  productParameterHolder: holder));
                        },
                      ),
                    ),
                    Container(
                        color: PsColors.backgroundColor,
                        height: PsDimens.space340,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productProvider.productList.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (productProvider.productList.status ==
                                  PsStatus.BLOCK_LOADING) {
                                return Shimmer.fromColors(
                                    baseColor: PsColors.grey,
                                    highlightColor: PsColors.white,
                                    child: Row(children: const <Widget>[
                                      PsFrameUIForLoading(),
                                    ]));
                              } else {
                                final Product product =
                                    productProvider.productList.data![index];
                                return ProductHorizontalListItem(
                                  coreTagKey:
                                      productProvider.hashCode.toString() +
                                          product.id!,
                                  psValueHolder: widget.psValueHolder,        
                                  product:
                                      productProvider.productList.data![index],
                                  onTap: () {
                                    print(productProvider.productList.data![index]
                                        .defaultPhoto!.imgPath);

                                    final ProductDetailIntentHolder holder =
                                        ProductDetailIntentHolder(
                                            productId: productProvider
                                                .productList.data![index].id!,
                                            heroTagImage: productProvider.hashCode
                                                    .toString() +
                                                product.id! +
                                                PsConst.HERO_TAG__IMAGE,
                                            heroTagTitle: productProvider.hashCode
                                                    .toString() +
                                                product.id! +
                                                PsConst.HERO_TAG__TITLE);
                                    Navigator.pushNamed(
                                        context, RoutePaths.productDetail,
                                        arguments: holder);
                                  },
                                );
                              }
                            })),
                    const PsAdMobBannerWidget(
                      admobSize: AdSize.mediumRectangle,
                    ),
                  ])
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            }
            ),
              onRefresh: () {
                            return productProvider.resetProductList(widget.psValueHolder.loginUserId!,productProvider.productNearestParameterHolder);
                          },
      );
    }));
  }
}
class _HomePropertyHorizontalListWidget extends StatefulWidget {
  const _HomePropertyHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __HomeCategoryHorizontalListWidgetState createState() =>
      __HomeCategoryHorizontalListWidgetState();
}

class __HomeCategoryHorizontalListWidgetState
    extends State<_HomePropertyHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<PropertyTypeProvider>(
      builder: (BuildContext context, PropertyTypeProvider propertyTypeProvider,
          Widget? child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            child: (propertyTypeProvider.propertyTypeList.data != null &&
                    propertyTypeProvider.propertyTypeList.data!.isNotEmpty)
                ? Column(children: <Widget>[
                    Container(
                      color: PsColors.backgroundColor,
                      child: _MyHeaderWidget(
                        headerName:
                            Utils.getString(context, 'dashboard__properties'),
                        headerDescription:
                            Utils.getString(context, 'dashboard__category_desc'),
                        viewAllClicked: () {
                          Navigator.pushNamed(context, RoutePaths.propertyTypeList);
                        },
                      ),
                    ),
                    Container(
                      color: PsColors.backgroundColor,
                      height: PsDimens.space140,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.only(left: PsDimens.space16),
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              propertyTypeProvider.propertyTypeList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (propertyTypeProvider.propertyTypeList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey,
                                  highlightColor: PsColors.white,
                                  child: Row(children: const <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              return PropertyTypeHorizontalListItem(
                                  propertyType: propertyTypeProvider
                                      .propertyTypeList.data![index],
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final ProductParameterHolder
                                        productParameterHolder =
                                        ProductParameterHolder()
                                            .getLatestParameterHolder();
                                    productParameterHolder.propertyById =
                                        propertyTypeProvider
                                            .propertyTypeList.data![index].id;
                                      productParameterHolder.itemLocationCityId =
                                               widget.psValueHolder.locationId;
                                           productParameterHolder.itemLocationName =
                                               widget.psValueHolder.locactionName;
                                           if (widget.psValueHolder.isSubLocation ==
                                               PsConst.ONE) {
                                             productParameterHolder
                                                     .itemLocationTownshipId =
                                                 widget
                                                     .psValueHolder.locationTownshipId;
                                             productParameterHolder
                                                     .itemLocationTownshipName =
                                                 widget.psValueHolder
                                                     .locationTownshipName;
                                           }
                                    Navigator.pushNamed(context,
                                        RoutePaths.filterProductList,
                                        arguments: ProductListIntentHolder(
                                          appBarTitle: propertyTypeProvider
                                              .propertyTypeList.data![index].name!,
                                          productParameterHolder:
                                              productParameterHolder,
                                        ));
                                        
                                  });
                            }
                          }),
                    )
                  ])
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            });
      },
    ));
  }
}

class _HomePostedByListWidget extends StatefulWidget {
  const _HomePostedByListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __HomePostedByListWidgetState createState() =>
      __HomePostedByListWidgetState();
}

class __HomePostedByListWidgetState extends State<_HomePostedByListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<PostTypeProvider>(
      builder: (BuildContext context, PostTypeProvider postTypeProvider,
          Widget? child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            child: (postTypeProvider.postTypeList.data != null &&
                    postTypeProvider.postTypeList.data!.isNotEmpty)
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                     top: PsDimens.space12),
                    color: PsColors.backgroundColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: PsDimens.space16, top: PsDimens.space12),
                            child: Text(
                            Utils.getString(context, 'dashboard__looking_for'),
                              style: Theme.of(context).textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: PsColors.textPrimaryDarkColor)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: PsColors.backgroundColor,
                      padding: const EdgeInsets.only(
                          top: PsDimens.space12, left: PsDimens.space16),
                      child: Text(
                        Utils.getString(context, 'dashboard__category_desc'),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: PsColors.textPrimaryLightColor),
                      ),
                    ),
                    Container(
                      color: PsColors.backgroundColor,
                      height: PsDimens.space60,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.only(left: PsDimens.space16),
                          scrollDirection: Axis.horizontal,
                          itemCount: postTypeProvider.postTypeList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (postTypeProvider.postTypeList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey,
                                  highlightColor: PsColors.white,
                                  child: Row(children: const <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              return PostTypeHorizontalListItem(
                                  postType:
                                      postTypeProvider.postTypeList.data![index],
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final ProductParameterHolder
                                        productParameterHolder =
                                        ProductParameterHolder()
                                            .getLatestParameterHolder();
                                    productParameterHolder.postedById =
                                        postTypeProvider
                                            .postTypeList.data![index].id;
                                    Navigator.pushNamed(context,
                                        RoutePaths.postedFilterProductList,
                                        arguments: ProductListIntentHolder(
                                          appBarTitle: postTypeProvider
                                              .postTypeList.data![index].name!,
                                          productParameterHolder:
                                              productParameterHolder,
                                        ));
                                  });
                            }
                          }),
                    )
                  ])
                // )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            });
      },
    ));
  }
}

class _HomeAgentListWidget extends StatefulWidget {
  const _HomeAgentListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __HomeAgentListWidgetState createState() => __HomeAgentListWidgetState();
}

class __HomeAgentListWidgetState extends State<_HomeAgentListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<AgentListProvider>(
      builder: (BuildContext context, AgentListProvider agentListProvider,
          Widget? child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            child: (agentListProvider.agentList.data != null &&
                    agentListProvider.agentList.data!.isNotEmpty)
                ? Column(children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                        top: PsDimens.space12),
                      color: PsColors.backgroundColor,
                      child: _MyHeaderWidget(
                        headerName: Utils.getString(context, 'dashboard__agents'),
                        headerDescription:
                            Utils.getString(context, 'dashboard__category_desc'),
                        viewAllClicked: () {
                          Navigator.pushNamed(context, RoutePaths.agentList);
                        },
                      ),
                    ),
                    Container(
                      color: PsColors.backgroundColor,
                      height: PsDimens.space170,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.only(left: PsDimens.space16),
                          scrollDirection: Axis.horizontal,
                          itemCount: agentListProvider.agentList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (agentListProvider.agentList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey,
                                  highlightColor: PsColors.white,
                                  child: Row(children: const <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              return AgentHorizontalListItem(
                                  user: agentListProvider.agentList.data![index],
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RoutePaths.userDetail,
                                        arguments: UserIntentHolder(
                                            userId: agentListProvider
                                                .agentList.data![index].userId!,
                                            userName: agentListProvider
                                                .agentList
                                                .data![index]
                                                .userName!));
                                  });
                            }
                          }),
                    )
                  ])
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            });
      },
    ));
  }
}

class _HomeItemListFromFollowersHorizontalListWidget extends StatelessWidget {
  const _HomeItemListFromFollowersHorizontalListWidget({
    Key? key,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<ItemListFromFollowersProvider>(
        builder: (BuildContext context,
            ItemListFromFollowersProvider itemListFromFollowersProvider,
            Widget? child) {
          return AnimatedBuilder(
            animation: animationController,
            child: (itemListFromFollowersProvider.psValueHolder.loginUserId !=
                        '' &&
                    itemListFromFollowersProvider
                            .itemListFromFollowersList.data !=
                        null &&
                    itemListFromFollowersProvider
                        .itemListFromFollowersList.data!.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                          top: PsDimens.space12),
                        color: PsColors.backgroundColor,
                        child: _MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'dashboard__item_list_from_followers'),
                        headerDescription: Utils.getString(
                            context, 'dashboard_follow_item_desc'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                              context, RoutePaths.itemListFromFollower,
                              arguments: itemListFromFollowersProvider
                                  .psValueHolder.loginUserId);
                          },
                        ),
                      ),
                      Container(
                          color: PsColors.backgroundColor,
                          height: PsDimens.space340,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: itemListFromFollowersProvider
                                  .itemListFromFollowersList.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (itemListFromFollowersProvider
                                        .itemListFromFollowersList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: Row(children: const <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  return ProductHorizontalListItem(
                                    coreTagKey: itemListFromFollowersProvider
                                            .hashCode
                                            .toString() +
                                        itemListFromFollowersProvider
                                            .itemListFromFollowersList
                                            .data![index]
                                            .id!,
                                    product: itemListFromFollowersProvider
                                        .itemListFromFollowersList.data![index],
                                    psValueHolder: itemListFromFollowersProvider.psValueHolder,
                                    onTap: () {
                                      final Product product =
                                          itemListFromFollowersProvider
                                              .itemListFromFollowersList
                                              .data!
                                              .reversed
                                              .toList()[index];
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                              productId:
                                                  itemListFromFollowersProvider
                                                      .itemListFromFollowersList
                                                      .data![index]
                                                      .id!,
                                              heroTagImage:
                                                  itemListFromFollowersProvider
                                                          .hashCode
                                                          .toString() +
                                                      product.id! +
                                                      PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle:
                                                  itemListFromFollowersProvider
                                                          .hashCode
                                                          .toString() +
                                                      product.id! +
                                                      PsConst.HERO_TAG__TITLE);
                                      Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                    },
                                  );
                                }
                              }))
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _MyHeaderWidget extends StatefulWidget {
  const _MyHeaderWidget({
    Key? key,
    required this.headerName,
    this.headerDescription,
    required this.viewAllClicked,
  }) : super(key: key);

  final String headerName;
  final String? headerDescription;
  final Function?viewAllClicked;

  @override
  __MyHeaderWidgetState createState() => __MyHeaderWidgetState();
}

class __MyHeaderWidgetState extends State<_MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.viewAllClicked as void Function()?,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  //   fit: FlexFit.loose,
                  child: Text(widget.headerName,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: PsColors.textPrimaryDarkColor)),
                ),
                Text(
                  Utils.getString(context, 'dashboard__view_all'),
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: PsColors.mainColor),
                ),
              ],
            ),
            if (widget.headerDescription == '')
              Container()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: PsDimens.space10),
                      child: Text(
                        widget.headerDescription!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: PsColors.textPrimaryLightColor),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeaderWidget extends StatefulWidget {
  const _HomeHeaderWidget(
      {Key? key,
      required this.searchProductProvider,
      required this.animationController,
      required this.animation,
      required this.psValueHolder,
      required this.itemNameTextEditingController,
      required this.fromPriceTextEditingController,
      required this.toPriceTextEditingController,
      required this.propertyTypeController,
      required this.postTypeController})
      : super(key: key);

  final SearchProductProvider? searchProductProvider;
  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;
  final TextEditingController itemNameTextEditingController;
  final TextEditingController fromPriceTextEditingController;
  final TextEditingController toPriceTextEditingController;
  final TextEditingController propertyTypeController;
  final TextEditingController postTypeController;

  @override
  __HomeHeaderWidgetState createState() => __HomeHeaderWidgetState();
}

class __HomeHeaderWidgetState extends State<_HomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
          animation: widget.animationController,
          child: Container(
            color: PsColors.baseColor,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  color: PsColors.backgroundColor,
                  child: _MyHomeHeaderWidget(
                  locationName: widget.psValueHolder.isSubLocation == PsConst.ONE
                      ? (widget.psValueHolder.locationTownshipName.isEmpty ||
                              widget.psValueHolder.locationTownshipName ==
                                  Utils.getString(
                                      context, 'product_list__category_all'))
                          ? widget.psValueHolder.locactionName ?? ''
                          : widget.psValueHolder.locationTownshipName
                      : widget.psValueHolder.locactionName ?? '',
                  ),
                ),
                SearchTileView(
                searchProductProvider: widget.searchProductProvider,
                animationController: widget.animationController,
                psValueHolder: widget.psValueHolder,
                userInputItemNameTextEditingController:
                      widget.itemNameTextEditingController,
                userInputFromPriceEditingController: widget.fromPriceTextEditingController,
                userInputToPriceEditingController: widget.toPriceTextEditingController,
                propertyTypeController: widget.propertyTypeController,
                postTypeController: widget.postTypeController,
                ),
              ],
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 30 * (1.0 - widget.animation.value), 0.0),
                    child: child));
          })
    );
  }
}

class _MyHomeHeaderWidget extends StatefulWidget {
  const _MyHomeHeaderWidget(
      {Key? key,
      required this.locationName,})
      : super(key: key);

  final String locationName;
 
  @override
  __MyHomeHeaderWidgetState createState() => __MyHomeHeaderWidgetState();
}

 ProductParameterHolder productParameterHolder =
    ProductParameterHolder().getLatestParameterHolder();

class __MyHomeHeaderWidgetState extends State<_MyHomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(
                left: PsDimens.space12,
                right: PsDimens.space12,
                bottom: PsDimens.space4),
          //  child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: PsDimens.space140,
                    padding: const EdgeInsets.only(left: PsDimens.space12),
                  child: MaterialButton(
                      color: PsColors.white,
                      height: PsDimens.space35,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: PsColors.mainColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18.0))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: PsColors.mainColor,
                              size: 20,
                            ),
                            Expanded( child: 
                            Text(
                              widget.locationName,
                              maxLines : 1,
                              overflow : TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(color: PsColors.mainColor),
                            ),),
                          ]),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RoutePaths.itemLocationList);
                      }),
                  ),
                  Container(
                    width: PsDimens.space130,
                    padding: const EdgeInsets.only(left: PsDimens.space12),
                    child: MaterialButton(
                        color: PsColors.white,
                        height: PsDimens.space35,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: PsColors.mainColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(18.0))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.favorite_border,
                                color: PsColors.mainColor,
                                size: 20,
                              ),
                              Text(
                                Utils.getString(
                                    context, 'home__menu_drawer_favourite'),
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(color: PsColors.mainColor),
                              ),
                            ]),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RoutePaths.favouriteProductList);
                        }),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: PsDimens.space12),
                    child: MaterialButton(
                        color: PsColors.white,
                        height: PsDimens.space35,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: PsColors.mainColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(18.0))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.swap_horiz,
                                color: PsColors.mainColor,
                                size: 22,
                              ),
                              Text(
                                Utils.getString(
                                    context, 'more__paid_ads_title'),
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(color: PsColors.mainColor),
                              ),
                            ]),
                        onPressed: () {
                            Navigator.pushNamed(context, RoutePaths.paidAdItemList);
                        }),
                  ),
                Container(
                    width: PsDimens.space130,
                    padding: const EdgeInsets.only(left: PsDimens.space12),
                    child: MaterialButton(
                        color: PsColors.white,
                        height: PsDimens.space35,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: PsColors.mainColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(18.0))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.book,
                                color: PsColors.mainColor,
                                size: 18,
                              ),
                              Text(
                                Utils.getString(context, 'more__history_title'),
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(color: PsColors.mainColor),
                              ),
                            ]),
                        onPressed: () {
                          Navigator.pushNamed(context, RoutePaths.historyList);
                        }),
                  ),
                  Container(
                    width: PsDimens.space140,
                    padding: const EdgeInsets.only(left: PsDimens.space12),
                    child: MaterialButton(
                        color: PsColors.white,
                        height: PsDimens.space35,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: PsColors.mainColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(18.0))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.chat_bubble,
                                color: PsColors.mainColor,
                                size: 20,
                              ),
                              Text(
                                Utils.getString(
                                    context, 'home__menu_drawer_user_offers'),
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(color: PsColors.mainColor),
                              ),
                            ]),
                        onPressed: () {
                          Navigator.pushNamed(context, RoutePaths.offerList);
                        }),
                  ),
                  if (Utils.showUI(valueHolder.blockedFeatureDisabled))
                  Padding(
                    padding: const EdgeInsets.only(left: PsDimens.space12),
                    child: MaterialButton(
                        color: PsColors.white,
                        height: PsDimens.space35,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: PsColors.mainColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(18.0))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                FontAwesome
                              .user_times,
                                color: PsColors.mainColor,
                                size: 16,
                              ),
                              Text(
                                Utils.getString(context, 'home__menu_drawer_user_blocked'),
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(color: PsColors.mainColor),
                              ),
                            ]),
                        onPressed: () {
                          Navigator.pushNamed(context, RoutePaths.blockUserList);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: PsDimens.space12),
                    child: MaterialButton(
                        color: PsColors.white,
                        height: PsDimens.space35,
                       shape: RoundedRectangleBorder(
                            side: BorderSide(color: PsColors.mainColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(18.0))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                FontAwesome5
                              .times,
                                color: PsColors.mainColor,
                                size: 20,
                              ),
                              Text(
                                Utils.getString(context, 'home__menu_drawer_reported_item'),
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(color: PsColors.mainColor),
                              ),
                            ]),
                        onPressed: () {
                          Navigator.pushNamed(context, RoutePaths.reportItemList);
                        }),
                    ), 
                ],
              ),
            //),
          ),
        ),
     ]);
  }
}

class SearchTileView extends StatefulWidget {
  const SearchTileView({
    Key? key,
    required this.searchProductProvider,
    required this.animationController,
    required this.psValueHolder,
    required this.userInputItemNameTextEditingController,
    required this.userInputFromPriceEditingController,
    required this.userInputToPriceEditingController,
    required this.propertyTypeController,
    required this.postTypeController,
  }) : super(key: key);
  final SearchProductProvider? searchProductProvider;
  final AnimationController animationController;
  final PsValueHolder psValueHolder;
  final TextEditingController userInputItemNameTextEditingController;
  final TextEditingController userInputFromPriceEditingController;
  final TextEditingController userInputToPriceEditingController;
  final TextEditingController propertyTypeController;
  final TextEditingController postTypeController;

  @override
  _SearchTileViewState createState() => _SearchTileViewState();
}

class _SearchTileViewState extends State<SearchTileView> {
  @override
  void dispose() {
    super.dispose();
  }

  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  @override
  Widget build(BuildContext context) {
    final Widget _searchTileTitleWidget = PsTextFieldWidgetWithSearchIcon(
        hintText: Utils.getString(context, 'home__bottom_app_bar_search'),
         textEditingController:
                      widget.userInputItemNameTextEditingController,
                  psValueHolder: widget.psValueHolder,
                  clickSearchButton: () {
                    productParameterHolder.itemLocationCityId =
                    widget.psValueHolder.locationId;
                productParameterHolder.itemLocationName =
                    widget.psValueHolder.locactionName;
                if (widget.psValueHolder.isSubLocation == PsConst.ONE) {
                  productParameterHolder.itemLocationTownshipId =
                      widget.psValueHolder.locationTownshipId;
                  productParameterHolder.itemLocationTownshipName =
                      widget.psValueHolder.locationTownshipName;
                   }
                    productParameterHolder.searchTerm =
                        widget.userInputItemNameTextEditingController.text;
                    Navigator.pushNamed(context, RoutePaths.filterProductList,
                        arguments: ProductListIntentHolder(
                            appBarTitle: Utils.getString(
                                context, 'home_search__app_bar_title'),
                            productParameterHolder: productParameterHolder));
                  },
                  clickEnterFunction: () {
                    productParameterHolder.itemLocationCityId =
                    widget.psValueHolder.locationId;
                productParameterHolder.itemLocationName =
                    widget.psValueHolder.locactionName;
                if (widget.psValueHolder.isSubLocation == PsConst.ONE) {
                  productParameterHolder.itemLocationTownshipId =
                      widget.psValueHolder.locationTownshipId;
                  productParameterHolder.itemLocationTownshipName =
                      widget.psValueHolder.locationTownshipName;
                   }
                    productParameterHolder.searchTerm =
                        widget.userInputItemNameTextEditingController.text;
                    Navigator.pushNamed(context, RoutePaths.filterProductList,
                        arguments: ProductListIntentHolder(
                            appBarTitle: Utils.getString(
                                context, 'home_search__app_bar_title'),
                            productParameterHolder: productParameterHolder));
                  }
        );

    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space16,
    );
    return Container(
      margin: const EdgeInsets.only(
          // left: PsDimens.space12,
          // right: PsDimens.space12,
          bottom: PsDimens.space12),
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(PsDimens.space8)),
      ),
      child: PsExpansionTile(
        initiallyExpanded: false,
        title: _searchTileTitleWidget,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Divider(
                height: PsDimens.space1,
              ),
              _spacingWidget,
                _IconAndTextWidget(
                  searchProductProvider: widget.searchProductProvider,
                  userInputItemNameTextEditingController: widget.userInputItemNameTextEditingController,
                  userInputFromPriceEditingController: widget.userInputFromPriceEditingController,
                  userInputToPriceEditingController: widget.userInputToPriceEditingController,
                  propertyTypeController: widget.propertyTypeController,
                  postTypeController: widget.postTypeController,
                ),
              _spacingWidget,
            ],
          )
        ],
      ),
    );
  }
}

class _IconAndTextWidget extends StatelessWidget {
   const _IconAndTextWidget({
    Key? key,
    required this.searchProductProvider,
    required this.userInputItemNameTextEditingController,
    required this.userInputFromPriceEditingController,
    required this.userInputToPriceEditingController,
    required this.propertyTypeController,
    required this.postTypeController,
  }) : super(key: key);

  final SearchProductProvider? searchProductProvider;
  final TextEditingController userInputItemNameTextEditingController;
  final TextEditingController userInputFromPriceEditingController;
  final TextEditingController userInputToPriceEditingController;
  final TextEditingController propertyTypeController;
  final TextEditingController postTypeController;
  
  @override
  Widget build(BuildContext context) {     
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
                  left: PsDimens.space20,
                  right: PsDimens.space24),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: PsDropdownBaseWithIconControllerWidget(
                      icon: Icons.filter_list,
                      textEditingController: postTypeController,
                      hintText: Utils.getString(
                          context, 'dashboard__search_looking_for'),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
          
                        final dynamic postedResult = await Navigator.pushNamed(
                          context, RoutePaths.searchPostType);
                        if (postedResult != null && postedResult is PostType) {
                            searchProductProvider!.postedById = postedResult.id!;
                            postTypeController.text = postedResult.name!;
                        }
                      },
                    ),
                  ),
                  Expanded(
                      flex: 1,   
                      child: PsDropdownBaseWithIconControllerWidget(
                          icon: LineariconsFree.plus_circle_1,
                          textEditingController: propertyTypeController,
                          hintText: Utils.getString(
                              context, 'dashboard__search_property'),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
              
                            final dynamic propertyResult =
                                await Navigator.pushNamed(context, RoutePaths.searchPropertyBy);

                            if (propertyResult != null && propertyResult is PropertyType) {
                              searchProductProvider!.propertyById = propertyResult.id!;
                              propertyTypeController.text = propertyResult.name!;
                        
                          }
                        },
                      ),
                    ),
                  ]),
              ), 
              Container(
                margin: const EdgeInsets.only(
                    top: PsDimens.space8,
                    left: PsDimens.space20,
                    right: PsDimens.space24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: PsTextFieldWidgetWithPriceIcon(
                        hintText: Utils.getString(
                            context, 'dashboard__search_from_price'),
                        textEditingController: userInputFromPriceEditingController,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: PsTextFieldWidgetWithPriceIcon(
                        hintText: Utils.getString(
                            context, 'dashboard__search_to_price'),
                        textEditingController: userInputToPriceEditingController,
                  ),
                ),
              ])
            ),
            Container(
               margin: Directionality.of(context) == TextDirection.ltr
              ? const EdgeInsets.only(
                  top: PsDimens.space12,
                  left: PsDimens.space24,
                  right: PsDimens.space26)
              : const EdgeInsets.only(
                  top: PsDimens.space12,
                  left: PsDimens.space28,
                  right: PsDimens.space20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(
                    left: PsDimens.space6,
                    right: PsDimens.space6),
                height: PsDimens.space36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PsColors.baseDarkColor,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(color: PsColors.mainDividerColor),
              ),
              child: InkWell(
                child: Container(
                  height: double.infinity,
                  width: PsDimens.space36,
                  child: Icon(
                    Icons.clear,
                    color: PsColors.iconColor,
                    size: PsDimens.space22,
                  ),
                ),
                onTap: () {
                    productParameterHolder.propertyById = '';
                    productParameterHolder.postedById = '';
                    productParameterHolder.maxPrice = '';
                    productParameterHolder.minPrice = '';
                    }
                  )
                ),
              ),
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: PsDimens.space36,
                  child: PSButtonWidgetRoundCorner(
                  hasShadow: false,
                  colorData: PsColors.mainColor,
                  titleText:
                      Utils.getString(context, 'home__bottom_app_bar_search'),
                  onPressed: () async {
                  productParameterHolder.isPaid = PsConst.PAID_ITEM_FIRST;

                if (
                  //userInputItemNameTextEditingController.text != null &&
                    userInputItemNameTextEditingController.text != '') {
                  productParameterHolder.searchTerm =
                      userInputItemNameTextEditingController.text;
                } else {
                  productParameterHolder.searchTerm = '';
                }
                // ignore: unnecessary_null_comparison
                if (userInputFromPriceEditingController.text != null) {
                    productParameterHolder.minPrice =
                      userInputFromPriceEditingController.text;
                } else {
                  productParameterHolder.minPrice = '';
                }
                // ignore: unnecessary_null_comparison
                if (userInputToPriceEditingController.text != null) {
                    productParameterHolder.maxPrice =
                      userInputToPriceEditingController.text;
                } else {
                  productParameterHolder.maxPrice = '';
                }
                // ignore: unnecessary_null_comparison
                if (searchProductProvider!.propertyById != null) {
                    productParameterHolder.propertyById =
                      searchProductProvider!.propertyById;
                }
                // ignore: unnecessary_null_comparison
                if (searchProductProvider!.postedById != null) {
                    productParameterHolder.postedById =
                      searchProductProvider!.postedById;
                }
                final dynamic result =
                  await Navigator.pushNamed(context, RoutePaths.filterProductList,
                      arguments: ProductListIntentHolder(
                        appBarTitle:
                            Utils.getString(context, 'home_search__app_bar_title'),
                        productParameterHolder: productParameterHolder,
                      ));
                if (result != null && result is ProductParameterHolder) {
                  productParameterHolder = result;
                  }
                },
              ),
            ),
          ),
        ]),
        ),
      ]
    );
  }
}



