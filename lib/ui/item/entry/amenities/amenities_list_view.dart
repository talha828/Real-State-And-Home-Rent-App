import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/amenities/amenities_provider.dart';
import 'package:flutteradhouse/repository/amenities_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/amenities.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ItemEntryAmenitiesListView extends StatefulWidget {
  const ItemEntryAmenitiesListView({ 
      required this.amenityId,
      required this.selectedAmenitiesList});
  
  final String amenityId;
  final Map<Amenities, bool> selectedAmenitiesList;

  @override
  State<StatefulWidget> createState() {
    return ItemEntryAmenitiesListViewState();
  }
}

class ItemEntryAmenitiesListViewState extends State<ItemEntryAmenitiesListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  AmenitiesProvider? _amenitiesProvider;
  AnimationController? animationController;
  Animation<double>? animation;
  PsValueHolder? valueHolder;

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
        _amenitiesProvider!.nextAmenitiesList();
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

  void onAmenitiesClick(AmenitiesProvider provider) {
    Navigator.pop(
        context, widget.selectedAmenitiesList);
  }

  AmenitiesRepository? repo1;

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
    repo1 = Provider.of<AmenitiesRepository>(context);

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
        child: PsWidgetWithAppBar<AmenitiesProvider>(
            appBarTitle:
                Utils.getString(context, 'item_entry__amenities'),
            initProvider: () {
              return AmenitiesProvider(repo: repo1!);
            },
            onProviderReady: (AmenitiesProvider provider) {
              provider.loadAmenitiesList();
              _amenitiesProvider = provider;
            },
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.playlist_add_check, color: PsColors.mainColor),
                onPressed: () {
                  onAmenitiesClick(_amenitiesProvider!);
                },
              )
            ],
            builder: (BuildContext context, AmenitiesProvider provider,
                Widget? child) {
              return Stack(children: <Widget>[
                Container(
                    child: RefreshIndicator(
                  child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: provider.amenitiesList.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (provider.amenitiesList.status ==
                            PsStatus.BLOCK_LOADING) {
                          return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.white,
                              child: Column(children: const <Widget>[
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                              ]));
                        } else {
                          // final int count = provider.amenitiesList.data.length;
                          animationController!.forward();
                          return FadeTransition(
                              opacity: animation!,
                              child: InkWell(
                                  onTap: () {
                                    setState(() {});
                                    if (widget.selectedAmenitiesList[provider
                                            .amenitiesList.data![index]] ==
                                        true)
                                      widget.selectedAmenitiesList[provider
                                          .amenitiesList.data![index]] = false;
                                    else
                                      widget.selectedAmenitiesList[provider
                                          .amenitiesList.data![index]] = true;
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: PsDimens.space52,
                                    margin: const EdgeInsets.only(
                                        bottom: PsDimens.space4),
                                    child: Ink(
                                      color: PsColors.backgroundColor,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.all(
                                                  PsDimens.space16),
                                              child: Text(
                                                provider.amenitiesList
                                                    .data![index].name!,
                                                textAlign: TextAlign.start,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              )),
                                          Container(
                                              child: widget.selectedAmenitiesList
                                                      .containsKey(provider
                                                          .amenitiesList
                                                          .data![index]) 
                                                          ==
                                                      widget.selectedAmenitiesList[
                                                          provider.amenitiesList
                                                              .data![index]]
                                                  ? IconButton(
                                                      icon: Icon(Icons.check_circle,
                                                          color: Theme.of(context)
                                                              .iconTheme
                                                              .copyWith(
                                                                  color: PsColors.mainColor)
                                                              .color),
                                                      onPressed: () {
                                                        setState(() {});
                                                        if (widget.selectedAmenitiesList[provider
                                                                .amenitiesList.data![index]] ==
                                                            true)
                                                          widget.selectedAmenitiesList[provider
                                                              .amenitiesList.data![index]] = false;
                                                        else
                                                          widget.selectedAmenitiesList[provider
                                                              .amenitiesList.data![index]] = true;
                                                    })
                                                  : IconButton(icon: Icon(Icons.check_circle, color: PsColors.baseLightColor), 
                                                      onPressed: () {
                                                        setState(() {});
                                                        if (widget.selectedAmenitiesList[provider
                                                                .amenitiesList.data![index]] ==
                                                            true)
                                                          widget.selectedAmenitiesList[provider
                                                              .amenitiesList.data![index]] = false;
                                                        else
                                                          widget.selectedAmenitiesList[provider
                                                              .amenitiesList.data![index]] = true;
                                                      }),
                                                    )],
                                                ),
                                              ),
                                          ))
                                      );
                              }
                            }),
                        onRefresh: () {
                          return provider.resetAmenitiesList();
                        },
                      )),
                      PSProgressIndicator(provider.amenitiesList.status)
                    ]);
                  }));
  }
}
