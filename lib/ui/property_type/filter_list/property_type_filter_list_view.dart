import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/provider/property_type/property_type_provider.dart';
import 'package:flutteradhouse/repository/property_type_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/rating/item/rating_list_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/property_type_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/property_type.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../item/property_type_search_list_item.dart';

class PropertyTypeFilterListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PropertyByFilterListViewState();
  }
}

class _PropertyByFilterListViewState extends State<PropertyTypeFilterListView>
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
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController!);
    super.initState();
  }

  PropertyTypeRepository? repo1;

  @override
  Widget build(BuildContext context) {
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

    repo1 = Provider.of<PropertyTypeRepository>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<PropertyTypeProvider>(
          appBarTitle:
              Utils.getString(context, 'dashboard__property_type_list') ,
          initProvider: () {
            return PropertyTypeProvider(
                repo: repo1,
                psValueHolder: Provider.of<PsValueHolder>(context));
          },
          onProviderReady: (PropertyTypeProvider provider) {
            provider.loadPropertyTypeList(provider.propertyType.toMap(),provider.psValueHolder!.loginUserId);
            _propertyByProvider = provider;
          },
          builder: (BuildContext context, PropertyTypeProvider provider,
              Widget? child) {
            return Stack(children: <Widget>[
              // Container(
              //     child:
              RefreshIndicator(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: provider.propertyTypeList.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.propertyTypeList.status ==
                          PsStatus.BLOCK_LOADING) {
                        return Shimmer.fromColors(
                            baseColor: PsColors.grey,
                            highlightColor: PsColors.white,
                            child: Column(children: const <Widget>[
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                            ]));
                      } else {
                        final int count = provider.propertyTypeList.data!.length;
                        animationController!.forward();
                        return FadeTransition(
                            opacity: animation!,
                            child: PropertyTypeFilterListItem(
                              animationController: animationController!,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              propertyType: provider.propertyTypeList.data![index],
                              onTap: () {
                                final PropertyType propertyType =
                                    provider.propertyTypeList.data![index];
                                Navigator.pop(context, propertyType);

                                print(provider.propertyTypeList.data![index].name);
                              },
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetPropertyTypeList(provider.propertyType.toMap(),provider.psValueHolder!.loginUserId);
                },
              ),
              // ),
              PSProgressIndicator(provider.propertyTypeList.status)
            ]);
          }
          ),
    );
  }
}
