import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/product/favourite_item_provider.dart';
import 'package:flutteradhouse/repository/product_repository.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/item/item/product_vertical_list_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class FavouriteProductListView extends StatefulWidget {
  const FavouriteProductListView({Key? key, required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _FavouriteProductListView createState() => _FavouriteProductListView();
}

class _FavouriteProductListView extends State<FavouriteProductListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  FavouriteItemProvider? _favouriteItemProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _favouriteItemProvider!.nextFavouriteItemList();
      }
    });

    super.initState();
  }

  ProductRepository? repo1;
  PsValueHolder? psValueHolder;
  dynamic data;
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
     repo1 = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    if (!isConnectedToInternet && psValueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
    // data = EasyLocalizationProvider.of(context).data;
   
    print(
        '............................Build UI Again ............................');
    // return EasyLocalizationProvider(
    //     data: data,
    //     child:
    return ChangeNotifierProvider<FavouriteItemProvider>(
        lazy: false,
        create: (BuildContext context) {
          final FavouriteItemProvider provider =
              FavouriteItemProvider(repo: repo1, psValueHolder: psValueHolder);
          provider.loadFavouriteItemList();
          _favouriteItemProvider = provider;
          return _favouriteItemProvider!;
        },
        child: Consumer<FavouriteItemProvider>(
          builder: (BuildContext context, FavouriteItemProvider provider,
              Widget? child) {
            return Column(
              children: <Widget>[
                const PsAdMobBannerWidget(
                  admobSize: AdSize.banner,
                ),
                Expanded(
                  child: Stack(children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space4,
                            right: PsDimens.space4,
                            top: PsDimens.space4,
                            bottom: PsDimens.space4),
                        child: RefreshIndicator(
                          child: CustomScrollView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              slivers: <Widget>[
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 220.0,
                                          childAspectRatio: 0.6),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (provider.favouriteItemList.data !=
                                              null ||
                                          provider.favouriteItemList.data!
                                              .isNotEmpty) {
                                        final int count = provider
                                            .favouriteItemList.data!.length;
                                        return ProductVeticalListItem(
                                          coreTagKey:
                                              provider.hashCode.toString() +
                                                  provider.favouriteItemList
                                                      .data![index].id!,
                                          psValueHolder: psValueHolder!,
                                          animationController:
                                              widget.animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent:
                                                  widget.animationController,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          product: provider
                                              .favouriteItemList.data![index],
                                          onTap: () async {
                                            final Product product = provider
                                                .favouriteItemList.data!.reversed
                                                .toList()[index];
                                            final ProductDetailIntentHolder
                                                holder =
                                                ProductDetailIntentHolder(
                                                    productId: provider
                                                        .favouriteItemList
                                                        .data![index]
                                                        .id!,
                                                    heroTagImage: provider
                                                            .hashCode
                                                            .toString() +
                                                        product.id! +
                                                        PsConst.HERO_TAG__IMAGE,
                                                    heroTagTitle: provider
                                                            .hashCode
                                                            .toString() +
                                                        product.id! +
                                                        PsConst
                                                            .HERO_TAG__TITLE);
                                            await Navigator.pushNamed(context,
                                                RoutePaths.productDetail,
                                                arguments: holder);

                                            await provider
                                                .resetFavouriteItemList();
                                          },
                                        );
                                      } else {
                                        return null;
                                      }
                                    },
                                    childCount:
                                        provider.favouriteItemList.data!.length,
                                  ),
                                ),
                              ]),
                          onRefresh: () {
                            return provider.resetFavouriteItemList();
                          },
                        )),
                    PSProgressIndicator(provider.favouriteItemList.status)
                  ]),
                )
              ],
            );
          },
          // ),
        ));
  }
}
