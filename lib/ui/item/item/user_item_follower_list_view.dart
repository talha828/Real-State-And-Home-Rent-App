import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/product/item_list_from_followers_provider.dart';
import 'package:flutteradhouse/repository/product_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/item/item/product_vertical_list_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:provider/provider.dart';

class UserItemFollowerListView extends StatefulWidget {
  const UserItemFollowerListView({required this.loginUserId});
  final String loginUserId;

  @override
  UserItemFollowerListViewState createState() {
    return UserItemFollowerListViewState();
  }
}

class UserItemFollowerListViewState extends State<UserItemFollowerListView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ItemListFromFollowersProvider? itemListFromFollowersProvider;

  AnimationController? animationController;

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        itemListFromFollowersProvider!
            .nextItemListFromFollowersList(
              itemListFromFollowersProvider!.followUserItemParameterHolder.toMap(),
              widget.loginUserId);
      }
    });
  }

  ProductRepository? repo1;
  PsValueHolder? psValueHolder;
  
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

    timeDilation = 1.0;
    repo1 = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

   

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ItemListFromFollowersProvider>(
          appBarTitle:
              Utils.getString(context, 'dashboard__item_list_from_followers') ,
          initProvider: () {
            return ItemListFromFollowersProvider(
                repo: repo1!, psValueHolder: psValueHolder!);
          },
          onProviderReady: (ItemListFromFollowersProvider provider) {
            final String loginUserId = Utils.checkUserLoginId(psValueHolder!);

            provider.followUserItemParameterHolder
                .itemLocationId = psValueHolder!.locationId;
            provider.followUserItemParameterHolder
                .itemLocationTownshipId = psValueHolder!.locationTownshipId;

            provider.loadItemListFromFollowersList( 
                provider.followUserItemParameterHolder.toMap(), 
                loginUserId);

            itemListFromFollowersProvider = provider;
          },
          builder: (BuildContext context,
              ItemListFromFollowersProvider provider, Widget? child) {
            return Stack(children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(
                      left: PsDimens.space8,
                      right: PsDimens.space8,
                      top: PsDimens.space8,
                      bottom: PsDimens.space8),
                  child: RefreshIndicator(
                    child: CustomScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 280.0,
                                    childAspectRatio: 0.55),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (provider.itemListFromFollowersList.data !=
                                        null ||
                                    provider.itemListFromFollowersList.data!
                                        .isNotEmpty) {
                                  final int count = provider
                                      .itemListFromFollowersList.data!.length;
                                  return ProductVeticalListItem(
                                    coreTagKey: provider.hashCode.toString() +
                                        provider.itemListFromFollowersList
                                            .data![index].id!,
                                    psValueHolder: psValueHolder,
                                    animationController: animationController,
                                    animation:
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(
                                      CurvedAnimation(
                                        parent: animationController!,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    ),
                                    product: provider
                                        .itemListFromFollowersList.data![index],
                                    onTap: () {
                                      print(provider.itemListFromFollowersList
                                          .data![index].defaultPhoto!.imgPath);
                                      final Product product = provider
                                          .itemListFromFollowersList
                                          .data!
                                          .reversed
                                          .toList()[index];
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                              productId: provider
                                                  .itemListFromFollowersList
                                                  .data![index]
                                                  .id!,
                                              heroTagImage:
                                                  provider.hashCode.toString() +
                                                      product.id! +
                                                      PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle:
                                                  provider.hashCode.toString() +
                                                      product.id! +
                                                      PsConst.HERO_TAG__TITLE);
                                      Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                    },
                                  );
                                } else {
                                  return null;
                                }
                              },
                              childCount: provider
                                  .itemListFromFollowersList.data!.length,
                            ),
                          ),
                        ]),
                    onRefresh: () async {
                      return itemListFromFollowersProvider!
                          .resetItemListFromFollowersList(
                              itemListFromFollowersProvider!.followUserItemParameterHolder.toMap(), 
                              widget.loginUserId);
                    },
                  )),
              PSProgressIndicator(provider.itemListFromFollowersList.status)
            ]);
          }),
    );
  }
}
