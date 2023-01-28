import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/property_type/property_type_provider.dart';
import 'package:flutteradhouse/repository/property_type_repository.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/property_type/item/property_type_vertical_list_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/property_type_parameter_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class PropertyTypeListView extends StatefulWidget {
  @override
  _PropertyTypeListViewState createState() {
    return _PropertyTypeListViewState();
  }
}

class _PropertyTypeListViewState extends State<PropertyTypeListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  PropertyTypeProvider? _propertyByProvider;
  final PropertyTypeParameterHolder propertyByIconList =
      PropertyTypeParameterHolder();

  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _propertyByProvider!.nextPropertyTypeList(_propertyByProvider!.propertyType.toMap(),psValueHolder!.loginUserId);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  PropertyTypeRepository? repo1;
  PsValueHolder? psValueHolder;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
    bool propertyscribeNoti = false;
  List<String?> propertyscribeList = <String?>[];

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

 
    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child:
            // EasyLocalizationProvider(
            //     data: data,
            // child:
            ChangeNotifierProvider<PropertyTypeProvider>(
                lazy: false,
                create: (BuildContext context) {
                  final PropertyTypeProvider provider = PropertyTypeProvider(
                      repo: repo1, psValueHolder: psValueHolder);
                  provider.loadPropertyTypeList(provider.propertyType.toMap(),psValueHolder!.loginUserId);
                  _propertyByProvider = provider;
                  return _propertyByProvider!;
                },
                child: Consumer<PropertyTypeProvider>(builder:
                    (BuildContext context, PropertyTypeProvider provider,
                        Widget? child) {
                  return Column(
                    children: <Widget>[
                      const PsAdMobBannerWidget(
                        admobSize: AdSize.banner,
                      ),
                      Expanded(
                        child: Stack(children: <Widget>[
                          Container(
                              margin: const EdgeInsets.all(PsDimens.space8),
                              child: RefreshIndicator(
                                child: CustomScrollView(
                                    controller: _scrollController,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: false,
                                    slivers: <Widget>[
                                      SliverGrid(
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 300.0,
                                                childAspectRatio: 1),
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            if (provider.propertyTypeList.data !=
                                                    null ||
                                                provider.propertyTypeList.data!
                                                    .isNotEmpty) {
                                              final int count = provider
                                                  .propertyTypeList.data!.length;
                                              return PropertyTypeVerticalListItem(
                                                propertyScribeNoti: propertyscribeNoti,
                                                tempList: propertyscribeList,
                                                  animationController:
                                                      animationController,
                                                  animation: Tween<double>(
                                                          begin: 0.0, end: 1.0)
                                                      .animate(CurvedAnimation(
                                                    parent: animationController!,
                                                    curve: Interval(
                                                        (1 / count) * index,
                                                        1.0,
                                                        curve: Curves
                                                            .fastOutSlowIn),
                                                  )),
                                                  propertyType: provider
                                                      .propertyTypeList
                                                      .data![index],
                                                  onTap: () {
                                                    final ProductParameterHolder
                                                        productParameterHolder =
                                                        ProductParameterHolder()
                                                            .getLatestParameterHolder();
                                                    productParameterHolder
                                                            .propertyById =
                                                        provider.propertyTypeList
                                                            .data![index].id;
                                                    Navigator.pushNamed(
                                                        context,
                                                        RoutePaths
                                                            .filterProductList,
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
                                                );
                                            } else {
                                              return null;
                                            }
                                          },
                                          childCount: provider
                                              .propertyTypeList.data!.length,
                                        ),
                                      ),
                                    ]),
                                onRefresh: () {
                                  return provider.resetPropertyTypeList(provider.propertyType.toMap(),psValueHolder!.loginUserId);
                                },
                              )),
                          PSProgressIndicator(provider.propertyTypeList.status)
                        ]),
                      )
                    ],
                  );
                })
                ));
  }
}
