// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutteradhouse/config/ps_colors.dart';
// import 'package:flutteradhouse/config/ps_config.dart';
// import 'package:flutteradhouse/ui/item/list_with_filter/filter/property_type/product_list_with_filter_view.dart';
// import 'package:flutteradhouse/utils/utils.dart';
// import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';

// class ProductListWithFilterContainerView extends StatefulWidget {
//   const ProductListWithFilterContainerView(
//       {required this.productParameterHolder, required this.appBarTitle});
//   final ProductParameterHolder productParameterHolder;
//   final String appBarTitle;
//   @override
//   _ProductListWithFilterContainerViewState createState() =>
//       _ProductListWithFilterContainerViewState();
// }

// class _ProductListWithFilterContainerViewState
//     extends State<ProductListWithFilterContainerView>
//     with SingleTickerProviderStateMixin {
//   AnimationController? animationController;
//   String? appBarTitleName;
//   @override
//   void initState() {
//     animationController =
//         AnimationController(duration: PsConfig.animation_duration, vsync: this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     animationController!.dispose();
//     super.dispose();
//   }

//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//   void changeAppBarTitle(String categoryName) {
//     appBarTitleName = categoryName;
//   }

//   @override
//   Widget build(BuildContext context) {
//     Future<bool> _requestPop() {
//       animationController!.reverse().then<dynamic>(
//         (void data) {
//           if (!mounted) {
//             return Future<bool>.value(false);
//           }
//           Navigator.pop(context, true);
//           return Future<bool>.value(true);
//         },
//       );
//       return Future<bool>.value(false);
//     }

//     print(
//         '............................Build UI Again ............................');
//     return WillPopScope(
//       onWillPop: _requestPop,
//       child: Scaffold(
//         appBar: AppBar(
//         systemOverlayStyle:  SystemUiOverlayStyle(
//            statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
//          ),
//           iconTheme: Theme.of(context)
//               .iconTheme
//               .copyWith(color: PsColors.mainColorWithWhite),
//           title: Text(
//             appBarTitleName ?? widget.appBarTitle,
//             textAlign: TextAlign.center,
//             style: Theme.of(context)
//                 .textTheme
//                 .headline6!
//                 .copyWith(fontWeight: FontWeight.bold)
//                 .copyWith(color: PsColors.mainColorWithWhite),
//           ),
//           elevation: 1,
//         ),
//         body: ProductListWithFilterView(
//           animationController: animationController!,
//           productParameterHolder: widget.productParameterHolder,
//           changeAppBarTitle: changeAppBarTitle,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteradhouse/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradhouse/api/common/ps_admob_native_widget.dart';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/product/search_product_provider.dart';
import 'package:flutteradhouse/provider/user/search_user_provider.dart';
import 'package:flutteradhouse/provider/user/user_provider.dart';
import 'package:flutteradhouse/repository/product_repository.dart';
import 'package:flutteradhouse/repository/search_user_repository.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/ui/common/dialog/error_dialog.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/common/search_bar_view.dart';
import 'package:flutteradhouse/ui/item/item/product_vertical_list_item.dart';
import 'package:flutteradhouse/ui/item/list_with_filter/filter/property_type/product_filter_widget.dart';
import 'package:flutteradhouse/ui/user/search_user/search_user_list_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/user_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/user_follow_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:flutteradhouse/viewobject/user.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProductListWithFilterContainerView extends StatefulWidget {
  const ProductListWithFilterContainerView({
    required this.productParameterHolder, 
    required this.appBarTitle,
    required this.tabTitleItem,
    required this.tabTitleAccount});
  final ProductParameterHolder productParameterHolder;
  final String? appBarTitle;
  final String? tabTitleItem;
  final String? tabTitleAccount;
  @override
  _ProductListWithFilterContainerViewState createState() =>
      _ProductListWithFilterContainerViewState(tabTitleItem, tabTitleAccount);
}

class _ProductListWithFilterContainerViewState
    extends State<ProductListWithFilterContainerView>
    with TickerProviderStateMixin {

    _ProductListWithFilterContainerViewState(this.tabTitleItem, this.tabTitleAccount) {
    tabBar = TabBar(
      labelStyle: const TextStyle(fontSize: 16),
      labelColor: PsColors.mainColor,
      unselectedLabelColor: PsColors.grey,
      indicatorColor: PsColors.mainColor,
      tabs: <Tab>[
        Tab(
          text: tabTitleItem
        ),
        Tab(
          text: tabTitleAccount
        ),
      ],
    );
    searchBar = SearchBar(
        inBar: true,
        controller: searchTextController,
        buildDefaultAppBar: buildAppBar,
        tabBar: tabBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print('cleared');
        },
        closeOnSubmit: false,
        onClosed: () {
          if (tabController!.index == 0 && _searchProductProvider != null) {
            widget.productParameterHolder.searchTerm = '';
            _searchProductProvider!.resetLatestProductList(
                Utils.checkUserLoginId(valueHolder!),
                widget.productParameterHolder);
          } else if (_searchUserProvider != null) {
            _searchUserProvider!.searchUserParameterHolder.keyword = '';
            _searchUserProvider!.resetSearchUserList(
                _searchUserProvider!.searchUserParameterHolder.toMap(),
                Utils.checkUserLoginId(valueHolder!));
          }
        });
  }  

  String? tabTitleItem, tabTitleAccount;  

  AnimationController? animationController;
  late TextEditingController searchTextController = TextEditingController();
  late SearchBar searchBar; late TabBar tabBar;
  PsValueHolder? valueHolder;
  SearchProductProvider? _searchProductProvider;
  SearchUserProvider? _searchUserProvider;
  UserProvider? _userProvider;
  UserRepository? userRepository;
  ProductRepository? repo1;
  SearchUserRepository? repo2;

  final ScrollController _scrollController = ScrollController();
  TabController? tabController;
  

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (tabController!.index == 0 && _searchProductProvider != null) {
          _searchProductProvider!.nextProductListByKey(
              Utils.checkUserLoginId(valueHolder!),
              widget.productParameterHolder);
        } else if (_searchUserProvider != null) {
          _searchUserProvider!.nextSearchUserList(
              _searchUserProvider!.searchUserParameterHolder.toMap(),
              Utils.checkUserLoginId(valueHolder!));
        }
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  AppBar buildAppBar(BuildContext context) {
    
    if ( _searchProductProvider != null && _searchProductProvider!.needReset) {
      widget.productParameterHolder.searchTerm = '';
     _searchUserProvider!.searchUserParameterHolder.keyword = '';
      _searchProductProvider!.resetLatestProductList(
          Utils.checkUserLoginId(valueHolder!), widget.productParameterHolder);
    } 

    if (!_searchProductProvider!.needReset) {
      _searchProductProvider!.needReset = true;
    }

    if (_searchUserProvider != null) {
      _searchUserProvider!.resetSearchUserList(
          _searchUserProvider!.searchUserParameterHolder.toMap(),
          Utils.checkUserLoginId(valueHolder!));
    }
    searchTextController.clear();
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
      ),
      backgroundColor: PsColors.baseColor,
      iconTheme:
          Theme.of(context).iconTheme.copyWith(color: PsColors.iconColor),
      bottom: tabBar,
      // color: Utils.isLightMode(context)
      //     ? PsColors.primary500
      //     : PsColors.primaryDarkWhite),
      title: Text(widget.appBarTitle ?? '',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontWeight: FontWeight.bold)
              .copyWith(color: PsColors.textPrimaryColor)
          // color: Utils.isLightMode(context)
          //     ? PsColors.primary500
          //     : PsColors.primaryDarkWhite)
          ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search, color: PsColors.iconColor),
          onPressed: () {
            searchBar.beginSearch(context);
          },
        ),
      ],
      elevation: 0,
    );
  }

  void onSubmitted(String value) {
    if (tabController!.index == 0) {
      widget.productParameterHolder.searchTerm = value;
      _searchProductProvider!.resetLatestProductList(
          Utils.checkUserLoginId(valueHolder!), widget.productParameterHolder);
    } else {
      _searchUserProvider!.searchUserParameterHolder.keyword = value;
      _searchUserProvider!.resetSearchUserList(
          _searchUserProvider!.searchUserParameterHolder.toMap(),
          Utils.checkUserLoginId(valueHolder!));
    }
  }


  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);

    repo1 = Provider.of<ProductRepository>(context);
    repo2 = Provider.of<SearchUserRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    _userProvider =
        UserProvider(repo: userRepository, psValueHolder: valueHolder);

    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (tabController!.index == 0 && _searchProductProvider != null) {
            widget.productParameterHolder.searchTerm = '';
            _searchProductProvider?.resetLatestProductList(
                Utils.checkUserLoginId(valueHolder!), widget.productParameterHolder);
          } else if (_searchUserProvider != null) {
            _searchUserProvider!.searchUserParameterHolder.keyword = '';
            _searchUserProvider!.resetSearchUserList(
                _searchUserProvider!.searchUserParameterHolder.toMap(),
                Utils.checkUserLoginId(valueHolder!));
          }
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: _requestPop,
      child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<SearchProductProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  final SearchProductProvider provider = SearchProductProvider(
                      repo: repo1, psValueHolder: valueHolder);
                  if (valueHolder!.isSubLocation == PsConst.ONE) {
                    widget.productParameterHolder.itemLocationTownshipId =
                        valueHolder!.locationTownshipId;
                  }
                  final String? loginUserId =
                      Utils.checkUserLoginId(valueHolder!);
                  provider.loadProductListByKey(
                      loginUserId!, widget.productParameterHolder);
                  _searchProductProvider = provider;
                  _searchProductProvider!.productParameterHolder =
                      widget.productParameterHolder;

                  if (widget.appBarTitle == Utils.getString(
                                context, 'home_search__app_bar_title'))    
                    _searchProductProvider!.needReset = false;            

                  return _searchProductProvider;
                }),
            ChangeNotifierProvider<SearchUserProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  final SearchUserProvider provider = SearchUserProvider(
                      repo: repo2, psValueHolder: valueHolder);
                  _searchUserProvider = provider;
                  _searchUserProvider!.loadSearchUserList(
                      _searchUserProvider!.searchUserParameterHolder.toMap(),
                      Utils.checkUserLoginId(
                          valueHolder!));
                  return _searchUserProvider;
                }),
            ChangeNotifierProvider<UserProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  _userProvider!.userParameterHolder.loginUserId =
                      Utils.checkUserLoginId(valueHolder!);

                  return _userProvider;
                }),
          ],
          child: DefaultTabController(
            length: 2,
            child: Builder(builder: (BuildContext context) {
              tabController =
                  DefaultTabController.of(context)!;
              // tabController!.addListener(() {
              //   if (!tabController!.indexIsChanging) {
              //     setState(() {
              //       selectedTabIndex = tabController!.index;
              //     });
              //   }
              // });
              return Scaffold(
                appBar: searchBar.build(context),
                body: TabBarView(
                  children: <Widget>[
                    Consumer<SearchProductProvider>(
                      builder: (BuildContext context,
                          SearchProductProvider provider, Widget? child) {
                        return Column(
                          children: <Widget>[
                            ProductFilterWidget(
                              searchProductProvider: provider,
                            ),
                            Expanded(
                              child: Container(
                                color: PsColors.baseColor,
                                // color: Utils.isLightMode(context)
                                //     ? PsColors.white
                                //     : PsColors.black,
                                child: Stack(children: <Widget>[
                                  if (provider.productList.data!.isNotEmpty &&
                                      provider.productList.data != null)
                                    Container(
                                        color: PsColors.baseColor,
                                        // color: Utils.isLightMode(context)
                                        //     ? PsColors.white
                                        //     : PsColors.black,
                                        margin: const EdgeInsets.only(
                                            left: PsDimens.space8,
                                            right: PsDimens.space8,
                                            top: PsDimens.space4,
                                            bottom: PsDimens.space4),
                                        child: RefreshIndicator(
                                          child: CustomScrollView(
                                              controller: _scrollController,
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              slivers: <Widget>[
                                                SliverGrid(
                                                  gridDelegate:
                                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent:
                                                              280.0,
                                                          childAspectRatio:
                                                              0.55),
                                                  delegate:
                                                      SliverChildBuilderDelegate(
                                                    (BuildContext context,
                                                        int index) {
                                                      if (provider.productList
                                                                  .data !=
                                                              null ||
                                                          provider
                                                              .productList
                                                              .data!
                                                              .isNotEmpty) {
                                                        final int count =
                                                            provider.productList
                                                                .data!.length;
                                                        if (provider.productList
                                                            .data![index].id!
                                                            .contains(PsConst
                                                                .ADMOB_FLAG)) {
                                                          return const PsAdMobNativeWidget();
                                                        } else {
                                                          return ProductVeticalListItem(
                                                            psValueHolder:valueHolder,
                                                            coreTagKey: provider
                                                                    .hashCode
                                                                    .toString() +
                                                                provider
                                                                    .productList
                                                                    .data![
                                                                        index]
                                                                    .id!,
                                                            animationController:
                                                                animationController,
                                                            animation: Tween<
                                                                        double>(
                                                                    begin: 0.0,
                                                                    end: 1.0)
                                                                .animate(
                                                              CurvedAnimation(
                                                                parent:
                                                                    animationController!,
                                                                curve: Interval(
                                                                    (1 / count) *
                                                                        index,
                                                                    1.0,
                                                                    curve: Curves
                                                                        .fastOutSlowIn),
                                                              ),
                                                            ),
                                                            product: provider
                                                                .productList
                                                                .data![index],
                                                            onTap: () {
                                                              final Product
                                                                  product =
                                                                  provider
                                                                      .productList
                                                                      .data!
                                                                      .reversed
                                                                      .toList()[index];
                                                              final ProductDetailIntentHolder holder = ProductDetailIntentHolder(
                                                                  productId: provider
                                                                      .productList
                                                                      .data![
                                                                          index]
                                                                      .id,
                                                                  heroTagImage: provider
                                                                          .hashCode
                                                                          .toString() +
                                                                      product
                                                                          .id! +
                                                                      PsConst
                                                                          .HERO_TAG__IMAGE,
                                                                  heroTagTitle: provider
                                                                          .hashCode
                                                                          .toString() +
                                                                      product
                                                                          .id! +
                                                                      PsConst
                                                                          .HERO_TAG__TITLE);
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  RoutePaths
                                                                      .productDetail,
                                                                  arguments:
                                                                      holder);
                                                            },
                                                          );
                                                        }
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    childCount: provider
                                                        .productList
                                                        .data!
                                                        .length,
                                                  ),
                                                ),
                                              ]),
                                          onRefresh: () {
                                            final String? loginUserId =
                                                Utils.checkUserLoginId(
                                                    valueHolder!);
                                            return provider
                                                .resetLatestProductList(
                                                    loginUserId!,
                                                    _searchProductProvider!
                                                        .productParameterHolder);
                                          },
                                        ))
                                  else if (provider.productList.status !=
                                          PsStatus.PROGRESS_LOADING &&
                                      provider.productList.status !=
                                          PsStatus.BLOCK_LOADING &&
                                      provider.productList.status !=
                                          PsStatus.NOACTION)
                                    Align(
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/images/baseline_empty_item_grey_24.png',
                                              height: 100,
                                              width: 150,
                                              fit: BoxFit.contain,
                                            ),
                                            const SizedBox(
                                              height: PsDimens.space32,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: PsDimens.space20,
                                                  right: PsDimens.space20),
                                              child: Text(
                                                Utils.getString(context,
                                                    'procuct_list__no_result_data'),
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: PsDimens.space20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  PSProgressIndicator(
                                      provider.productList.status),
                                ]),
                              ),
                            ),
                            const PsAdMobBannerWidget(
                              admobSize: AdSize.banner,
                            ),
                          ],
                        );
                      },
                    ),
                    Consumer<SearchUserProvider>(
                      builder: (BuildContext context,
                          SearchUserProvider provider, Widget? child) {
                        return Container(
                            color: PsColors.baseColor,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Stack(children: <Widget>[
                                    Container(
                                        margin: const EdgeInsets.only(
                                            top: PsDimens.space18),
                                        child: RefreshIndicator(
                                          child: CustomScrollView(
                                              controller: _scrollController,
                                              scrollDirection: Axis.vertical,
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              shrinkWrap: false,
                                              slivers: <Widget>[
                                                SliverList(
                                                  delegate:
                                                      SliverChildBuilderDelegate(
                                                    (BuildContext context,
                                                        int index) {
                                                      if (provider.searchUserList
                                                                  .data !=
                                                              null ||
                                                          provider
                                                              .searchUserList
                                                              .data!
                                                              .isNotEmpty) {
                                                        final int count =
                                                            provider
                                                                .searchUserList
                                                                .data!
                                                                .length;
                                                        return SearchUserVerticalListItem(
                                                          animationController:
                                                              animationController,
                                                          animation:
                                                              Tween<double>(
                                                                      begin:
                                                                          0.0,
                                                                      end: 1.0)
                                                                  .animate(
                                                            CurvedAnimation(
                                                              parent:
                                                                  animationController!,
                                                              curve: Interval(
                                                                  (1 / count) *
                                                                      index,
                                                                  1.0,
                                                                  curve: Curves
                                                                      .fastOutSlowIn),
                                                            ),
                                                          ),
                                                          user: provider
                                                              .searchUserList
                                                              .data![index],
                                                          currentUser: Utils.checkUserLoginId(valueHolder!),    
                                                          onTap: () {
                                                            Navigator.pushNamed(
                                                                    context,
                                                                    RoutePaths
                                                                        .userDetail,
                                                                    arguments: UserIntentHolder(
                                                                        userId: provider
                                                                            .searchUserList
                                                                            .data![
                                                                                index]
                                                                            .userId!,
                                                                        userName: provider
                                                                            .searchUserList
                                                                            .data![
                                                                                index]
                                                                            .userName!))
                                                                .then((Object?
                                                                    value) {
                                                              // provider.resetSearchUserList(
                                                              //   _searchUserProvider!.searchUserParameterHolder
                                                              //       .toMap(),
                                                              //   Utils.checkUserLoginId(
                                                              //     _searchUserProvider!.psValueHolder!));
                                                            });
                                                          },
                                                          onFollowBtnTap:
                                                              () async {
                                                            if (await Utils
                                                                .checkInternetConnectivity()) {
                                                              Utils.navigateOnUserVerificationView(
                                                                  _userProvider,
                                                                  context,
                                                                  () async {
                                                                if (provider .searchUserList.data![index]
                                                                        .isFollowed ==
                                                                    PsConst
                                                                        .ZERO) {
                                                                  setState(() {
                                                                    provider
                                                                        .searchUserList
                                                                        .data![
                                                                            index]
                                                                        .isFollowed = PsConst.ONE;
                                                                  });
                                final UserFollowHolder userFollowHolder = UserFollowHolder(
                                                                    userId: Utils.checkUserLoginId(valueHolder!),
                                                                    followedUserId: provider
                                                                        .searchUserList
                                                                        .data![
                                                                            index]
                                                                        .userId);

                                                                final PsResource<
                                                                        User> _user =  await _userProvider!.postUserFollow(
                                                                            userFollowHolder.toMap());
                                                                            if (_user
                                                                        .data != null) {
                                                                  if (_user
                                                                          .data!
                                                                          .isFollowed ==
                                                                      PsConst
                                                                          .ONE) {
                                                                    _userProvider!
                                                                            .user
                                                                            .data!
                                                                            .isFollowed =
                                                                        PsConst
                                                                            .ONE;
                                                                  }
                                                                  }

                                                                } 
                                                              });
                                                            } else {
                                                              showDialog<
                                                                      dynamic>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return ErrorDialog(
                                                                      message: Utils.getString(
                                                                          context,
                                                                          'error_dialog__no_internet'),
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                        );
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    childCount: provider
                                                        .searchUserList
                                                        .data!
                                                        .length,
                                                  ),
                                                ),
                                              ]),
                                          onRefresh: () {
                                            return provider.resetSearchUserList(
                                                _searchUserProvider!
                                                    .searchUserParameterHolder
                                                    .toMap(),
                                                Utils.checkUserLoginId(
                                                    valueHolder!));
                                          },
                                        )),
                                    PSProgressIndicator(
                                        provider.searchUserList.status)
                                  ]),
                                )
                              ],
                            ));
                      },
                    )
                  ],
                ),
              );
            }),
          )),
      // ),
    );
  }
}
