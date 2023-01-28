import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/provider/product/item_condition_provider.dart';
import 'package:flutteradhouse/repository/item_condition_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/item/condition/item_condition_list_view_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ItemConditionView extends StatefulWidget {
  // const ItemConditionView({@required this.categoryId});

  @override
  State<StatefulWidget> createState() {
    return ItemConditionViewState();
  }
}

class ItemConditionViewState extends State<ItemConditionView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ItemConditionProvider? _itemConditionProvider;
  AnimationController? animationController;
  Animation<double> ?animation;

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
        _itemConditionProvider!.nextItemConditionList();
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

  ItemConditionRepository? repo1;

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

    repo1 = Provider.of<ItemConditionRepository>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ItemConditionProvider>(
          appBarTitle:
              Utils.getString(context, 'item_entry__item_condition'),
          initProvider: () {
            return ItemConditionProvider(
              repo: repo1,
            );
          },
          onProviderReady: (ItemConditionProvider provider) {
            provider.loadItemConditionList();
            _itemConditionProvider = provider;
          },
          builder: (BuildContext context, ItemConditionProvider provider,
              Widget? child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: provider.itemConditionList.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.itemConditionList.status ==
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
                        final int count =
                            provider.itemConditionList.data!.length;
                        animationController!.forward();
                        return FadeTransition(
                            opacity: animation!,
                            child: ItemConditionListViewItem(
                              itemCondition:
                                  provider.itemConditionList.data![index],
                              onTap: () {
                                Navigator.pop(context,
                                    provider.itemConditionList.data![index]);
                                print(provider
                                    .itemConditionList.data![index].name);
                                
                              },
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetItemConditionList();
                },
              )),
              PSProgressIndicator(provider.itemConditionList.status)
            ]);
          }),
    );
  }
}
