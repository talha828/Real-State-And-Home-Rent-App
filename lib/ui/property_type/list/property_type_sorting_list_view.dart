import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:flutteradhouse/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/property_type/property_type_provider.dart';
import 'package:flutteradhouse/repository/property_type_repository.dart';
import 'package:flutteradhouse/ui/common/dialog/error_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/filter_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/success_dialog.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/common/search_bar_view.dart';
import 'package:flutteradhouse/ui/property_type/item/property_type_vertical_list_item.dart';
import 'package:flutteradhouse/utils/ps_progress_dialog.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/property_subscribe_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/property_type.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class PropertyTypeSortingListView extends StatefulWidget {
  @override
  _PropertyTypeSortingListViewState createState() {
    return _PropertyTypeSortingListViewState();
  }
}

class _PropertyTypeSortingListViewState extends State<PropertyTypeSortingListView>
    with SingleTickerProviderStateMixin {
      
  _PropertyTypeSortingListViewState() {
    searchBar = SearchBar(
        inBar: true,
        controller: searchTextController,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        closeOnSubmit: false,
        onCleared: () {
          print('cleared');
        },
        onClosed: () {
          _propertyTypeProvider!.propertyType.searchTerm = '';
          _propertyTypeProvider!.resetPropertyTypeList(
              _propertyTypeProvider!.propertyType.toMap(),psValueHolder!.loginUserId,);
        });
  }

  final ScrollController _scrollController = ScrollController();

  PropertyTypeProvider? _propertyTypeProvider;
  AnimationController? animationController;
  late SearchBar searchBar;
  late TextEditingController searchTextController = TextEditingController();
  bool propertyscribeNoti = false;
  List<String?> propertyscribeList = <String?>[];
  List<String?> unsubscribeListWithMB = <String?>[];
  List<String?> tempList = <String?>[];
  bool needToAdd = true;

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

    void onSubmitted(String value) {
    _propertyTypeProvider!.propertyType.searchTerm = value;
     _propertyTypeProvider!.resetPropertyTypeList(
             _propertyTypeProvider!.propertyType.toMap(),psValueHolder!.loginUserId);
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _propertyTypeProvider!.nextPropertyTypeList(
            _propertyTypeProvider!.propertyType.toMap(),psValueHolder!.loginUserId,);
      }
    });
  }

    AppBar buildAppBar(BuildContext context) {
    if (_propertyTypeProvider != null) {
      _propertyTypeProvider!.propertyType.searchTerm = '';
          _propertyTypeProvider!.resetPropertyTypeList(
              _propertyTypeProvider!.propertyType.toMap(),psValueHolder!.loginUserId,);
    }
    searchTextController.clear();
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
      ),
      backgroundColor: PsColors.baseColor,
      iconTheme: Theme.of(context).iconTheme.copyWith(
        color: PsColors.iconColor
      ),
          // color: Utils.isLightMode(context)
          //     ? PsColors.primary500
          //     : PsColors.primaryDarkWhite),
      title: Text(Utils.getString(context, 'dashboard__property_type_list'),
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontWeight: FontWeight.bold)
              .copyWith(
                color: PsColors.mainColor)
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
        if (psValueHolder!.isPropertySubscribe == PsConst.ONE && !propertyscribeNoti)
          IconButton(
            icon: Icon(Icons.notification_add, color: PsColors.mainColor),
            onPressed: () async{
                 if (await Utils.checkInternetConnectivity()) {
                Utils.navigateOnUserVerificationView( 
                  _propertyTypeProvider, context, () {
              setState(() {
                propertyscribeNoti = true;
              });
                 });
              }
            },
          ),
        if (psValueHolder!.isPropertySubscribe == PsConst.ONE && propertyscribeNoti)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () async {
                 if (propertyscribeList.isNotEmpty) {
                final List<String?> subscribeListWithMB = <String?>[];
                  for (String? temp in propertyscribeList) {
                    subscribeListWithMB.add(temp! + '_MB');
                  }
                final PropertySubscribeParameterHolder holder = PropertySubscribeParameterHolder(
                  
                  userId: psValueHolder!.loginUserId!,
                  selectedpropertyId: subscribeListWithMB,
                   );
                await PsProgressDialog.showDialog(context);
                final PsResource<ApiStatus> subscribeStatus =
                    await _propertyTypeProvider!.postPropertySubscribe(
                        holder.toMap());
                PsProgressDialog.dismissDialog();
                if (subscribeStatus.status == PsStatus.SUCCESS) {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext contet) {
                        return SuccessDialog(
                          message:Utils.getString(
                              context, 'Success'),
                          onPressed: () {},
                        );
                      });

                    Utils.subscribeToModelTopics(List<String>.from(
                        Set<String>.from(subscribeListWithMB)
                        .difference(Set<String>.from(unsubscribeListWithMB))
                    ));
                    Utils.unSubsribeFromModelTopics(unsubscribeListWithMB); 
                  setState(() {
                    propertyscribeNoti = false;
                    propertyscribeList.clear();
                    unsubscribeListWithMB.clear();
                  });    
                       _propertyTypeProvider!.resetPropertyTypeList(
             _propertyTypeProvider!.propertyType.toMap(),psValueHolder!.loginUserId,);
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext contet) {
                        return ErrorDialog(
                          message: Utils.getString(
                              context, 'subscribe failed.'),
                        );
                      });
                }
               } else {
                  setState(() {
                    propertyscribeNoti = false;
                });
                }   
              },
              child: Center(
                child: Text(Utils.getString(context, 'Done'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: PsColors.mainColor)),
              ),
            ),
          )
      ],
      elevation: 0,
    );
  }

  PropertyTypeRepository? repo1;
  PsValueHolder? psValueHolder;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && psValueHolder!.isShowAdmob!) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
        repo1 = Provider.of<PropertyTypeRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    if (!isConnectedToInternet && psValueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    timeDilation = 1.0;


        return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: searchBar.build(context),
        body: ChangeNotifierProvider<PropertyTypeProvider?>(
            lazy: false,
            create: (BuildContext context) {
              final PropertyTypeProvider provider = PropertyTypeProvider(
                  repo: repo1, psValueHolder: psValueHolder);
              _propertyTypeProvider = provider;
              _propertyTypeProvider!.loadPropertyTypeList(_propertyTypeProvider!.propertyType.toMap(),psValueHolder!.loginUserId,
               );

              return _propertyTypeProvider;
            },
            child: Consumer<PropertyTypeProvider>(builder: (BuildContext context,
                                            PropertyTypeProvider provider, Widget? child) {
              return Container(
              color: PsColors.baseColor,
              child: Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(
                    admobSize: AdSize.banner,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(
                        width: PsDimens.space1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: PsDimens.space20, top: PsDimens.space16),
                        child: InkWell(
                          onTap: () {
                          showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return FilterDialog(
                              onAscendingTap: () async {
                                _propertyTypeProvider!.propertyType.orderBy =
                                    PsConst.FILTERING_CAT_NAME;
                                _propertyTypeProvider!.propertyType.orderType =
                                    PsConst.FILTERING__ASC;
                                _propertyTypeProvider!.resetPropertyTypeList(
                                    _propertyTypeProvider!.propertyType.toMap(),psValueHolder!.loginUserId,
                                   );
                              },
                              onDescendingTap: () {
                                _propertyTypeProvider!.propertyType.orderBy =
                                    PsConst.FILTERING_CAT_NAME;
                                _propertyTypeProvider!.propertyType.orderType =
                                    PsConst.FILTERING__DESC;
                                _propertyTypeProvider!.resetPropertyTypeList(
                                    _propertyTypeProvider!.propertyType.toMap(),psValueHolder!.loginUserId,
                                    );
                              },
                            );
                          });
                          },
                          child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.sort_by_alpha_rounded,
                                  color: PsColors.textPrimaryColor,
                                  size: 12,
                                ),
                                const SizedBox(
                                  width: PsDimens.space4,
                                ),
                                Container(
                                   margin: const EdgeInsets.only(left: 20),
                                  child: Text(Utils.getString(context, 'Sort'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontSize: 16,
                                              // color: widget.searchProductProvider!
                                              //             .productParameterHolder.catId ==
                                              //         ''
                                              //     ? Utils.isLightMode(context)
                                              //         ? PsColors.secondary400
                                              //         : PsColors.primaryDarkWhite
                                              //     : PsColors.textColor1
                                                  )),
                                ),
                              ],
                            ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Stack(children: <Widget>[
                      Container(
                          margin: const EdgeInsets.all(PsDimens.space8),
                          child: RefreshIndicator(
                            child: CustomScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: false,
                                slivers: <Widget>[
                                  SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 300.0,
                                            childAspectRatio: 1),
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        if (provider.propertyTypeList.data != null ||
                                            provider
                                                .propertyTypeList.data!.isNotEmpty) {
                                          final int count =
                                              provider.propertyTypeList.data!.length;

                                                  final PropertyType? propertyType = provider.propertyTypeList.data![index];    

                                                  if (propertyType?.isSubscribed != null && propertyType!.isSubscribed == PsConst.ONE 
                                                          && !tempList.contains(propertyType.id) && needToAdd) {
                                                    tempList.add(propertyType.id);
                                                  }   
                                          return PropertyTypeVerticalListItem(
                                            propertyScribeNoti: propertyscribeNoti,
                                            tempList: tempList,
                                            animationController:
                                                animationController,
                                            animation: Tween<double>(
                                                    begin: 0.0, end: 1.0)
                                                .animate(CurvedAnimation(
                                              parent: animationController!,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            )),
                                            propertyType: provider
                                                .propertyTypeList.data![index],
                                            onTap: () {
                                              if (propertyscribeNoti) {
                                                setState(() {
                                                 if (tempList.contains(propertyType!.id)) {
                                                  tempList.remove(propertyType.id);
                                                  unsubscribeListWithMB.add(propertyType.id! + '_MB');
                                                }
                                                else {
                                                  tempList.add(propertyType.id);
                                                  unsubscribeListWithMB.remove(propertyType.id! + '_MB');
                                                }
                                                            

                                                if (propertyscribeList
                                                    .contains(propertyType.id))
                                                  propertyscribeList
                                                      .remove(propertyType.id);
                                                else
                                                  propertyscribeList
                                                      .add(propertyType.id);
                                                needToAdd = false;  
                                                 });
                                                  } else {
                                             final ProductParameterHolder
                                                  productParameterHolder =
                                                  ProductParameterHolder()
                                                      .getLatestParameterHolder();
                                              productParameterHolder.propertyById =
                                                  provider.propertyTypeList
                                                      .data![index].id;
                                              Navigator.pushNamed(context,
                                                  RoutePaths.filterProductList,
                                                  arguments:
                                                      ProductListIntentHolder(
                                                    appBarTitle: provider
                                                        .propertyTypeList
                                                        .data![index]
                                                        .name!,
                                                    productParameterHolder:
                                                        productParameterHolder,
                                                  ));
                                              }
                                            }
                                          );
                                        } else {
                                          return null;
                                        }
                                      },
                                      childCount:
                                          provider.propertyTypeList.data!.length,
                                    ),
                                  ),
                                ]),
                            onRefresh: () {
                              return provider.resetPropertyTypeList(
                                  _propertyTypeProvider!.propertyType
                                      .toMap(),psValueHolder!.loginUserId,
                                  );
                            },
                          )),
                      PSProgressIndicator(provider.propertyTypeList.status)
                    ]),
                  )
                ],
              ));
            }),
          ),
      ));
  }
}
