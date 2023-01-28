import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:flutteradhouse/ui/sold_out/item/sold_out_search_list_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/product.dart';

class SoldOutSearchListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SoldOutSearchListViewState();
  }
}

class _SoldOutSearchListViewState extends State<SoldOutSearchListView>
    with TickerProviderStateMixin {

 // PostTypeProvider _postedByProvider;
  // final propertyTypeParameterHolder categoryIconList = propertyTypeParameterHolder();
  AnimationController? animationController;
  Animation<double>? animation;
  List<Product>? productSoldOutList;

  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _postedByProvider.nextPostTypeList();
    //   }
    // });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController!);
    super.initState();
  }

 // PostTypeRepository repo1;

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

  //  repo1 = Provider.of<PostTypeRepository>(context);
  productSoldOutList = <Product>[
      Product(isSoldOut: '0'),
      Product(isSoldOut: '1'),
    ];

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBarWithNoProvider(
          appBarTitle:
              Utils.getString(context, 'item_entry__sold_out'),

          child: Stack(children: <Widget>[
              ListView.builder(
                  itemCount: productSoldOutList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final int count = productSoldOutList!.length;
                      animationController!.forward();
                      return FadeTransition(
                          opacity: animation!,
                          child: SoldOutSearchListItem(
                            animationController: animationController!,
                            animation:
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn),
                              ),
                            ),
                            soldOutName: productSoldOutList![index].isSoldOut  == PsConst.ZERO ? 'Not Sold Yet' : 'Sold Out',
                            onTap: () {
                              final Product colorValue =
                                  productSoldOutList![index];
                              Navigator.pop(context, colorValue);
                            },
                          ));
                  }),
            ])
      ));
  }
}
