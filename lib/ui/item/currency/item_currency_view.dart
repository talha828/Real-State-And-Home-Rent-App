import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/provider/product/item_currency_provider.dart';
import 'package:flutteradhouse/repository/item_currency_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'item_currency_list_view_item.dart';

class ItemCurrencyView extends StatefulWidget {
  // const ItemCurrencyView({@required this.categoryId});

  @override
  State<StatefulWidget> createState() {
    return ItemCurrencyViewState();
  }
}

class ItemCurrencyViewState extends State<ItemCurrencyView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ItemCurrencyProvider? _temCurrencyProvider;
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
        _temCurrencyProvider!.nextItemCurrencyList();
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

  ItemCurrencyRepository? repo1;

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

    repo1 = Provider.of<ItemCurrencyRepository>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ItemCurrencyProvider>(
          appBarTitle: Utils.getString(context, 'item_entry__currency') ,
          initProvider: () {
            return ItemCurrencyProvider(
              repo: repo1,
            );
          },
          onProviderReady: (ItemCurrencyProvider provider) {
            provider.loadItemCurrencyList();
            _temCurrencyProvider = provider;
          },
          builder: (BuildContext context, ItemCurrencyProvider provider,
              Widget? child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: provider.itemCurrencyList.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.itemCurrencyList.status ==
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
                        final int count = provider.itemCurrencyList.data!.length;
                        animationController!.forward();
                        return FadeTransition(
                            opacity: animation!,
                            child: ItemCurrencyListViewItem(
                              itemCurrency:
                                  provider.itemCurrencyList.data![index],
                              onTap: () {
                                Navigator.pop(context,
                                    provider.itemCurrencyList.data![index]);
                                print(provider.itemCurrencyList.data![index]
                                    .currencySymbol);
                              
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
                  return provider.resetItemCurrencyList();
                },
              )),
              PSProgressIndicator(provider.itemCurrencyList.status)
            ]);
          }),
    );
  }
}
