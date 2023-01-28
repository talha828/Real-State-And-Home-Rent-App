import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/product/sold_out_item_provider.dart';
import 'package:flutteradhouse/repository/sold_out_item_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/item/item/product_vertical_list_item_for_profile.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:provider/provider.dart';

class SoldOutProductListView extends StatefulWidget {


  @override
  _SoldOutProductListViewState createState() {
    return _SoldOutProductListViewState();
  }
}

class _SoldOutProductListViewState extends State<SoldOutProductListView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late SoldOutProductProvider soldOutProductProvider;

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
        final String? loginUserId = Utils.checkUserLoginId(psValueHolder!);
        soldOutProductProvider.nextProductList(
            loginUserId, soldOutProductProvider.addedUserParameterHolder);
      }
    });
  }

  SoldOutItemRepository? repo1;
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
    repo1 = Provider.of<SoldOutItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<SoldOutProductProvider>(
          appBarTitle:  Utils.getString(context, 'item_entry__sold_out'),
          initProvider: () {
            return SoldOutProductProvider(repo: repo1, psValueHolder: psValueHolder);
          },
          onProviderReady: (SoldOutProductProvider provider) {
            final String? loginUserId = Utils.checkUserLoginId(psValueHolder!);


            provider.loadSoldOutProductList(
                loginUserId, provider.addedUserParameterHolder);

            soldOutProductProvider = provider;
          },
          builder: (BuildContext context, SoldOutProductProvider provider,
              Widget? child) {
            return Container(
              color: PsColors.baseColor,
              child: Stack(children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(
                        left: PsDimens.space8,
                        right: PsDimens.space8,
                        top: PsDimens.space8,
                        bottom: PsDimens.space8),
                    child: RefreshIndicator(
                      child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 280.0,
                                      childAspectRatio: 0.70),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  if (provider.itemList.data != null ||
                                      provider.itemList.data!.isNotEmpty) {
                                    final int count =
                                        provider.itemList.data!.length;
                                if (provider
                                      .itemList.data![index].adType! ==
                                  PsConst.GOOGLE_AD_TYPE) {
                                return  Container();
                              } else {
                                    return ProductVeticalListItemForProfile(
                                      psValueHolder: psValueHolder,
                                      coreTagKey: provider.hashCode.toString() +
                                          provider.itemList.data![index].id!,
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
                                      product: provider.itemList.data![index],
                                      onTap: () {
                                        print(provider.itemList.data![index]
                                            .defaultPhoto!.imgPath);
                                        final Product product = provider
                                            .itemList.data!.reversed
                                            .toList()[index];
                                        final ProductDetailIntentHolder holder =
                                            ProductDetailIntentHolder(
                                                productId: provider
                                                    .itemList.data![index].id,
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
                              }
                                  } else {
                                    return null;
                                  }
                                },
                                childCount: provider.itemList.data!.length,
                              ),
                            ),
                          ]),
                      onRefresh: () async {
                        // soldOutProductProvider.addedUserParameterHolder
                        //     .addedUserId = widget.addedUserId;

                        return soldOutProductProvider.resetProductList(
                            provider.psValueHolder!.loginUserId,
                            provider.addedUserParameterHolder);
                      },
                    )),
                PSProgressIndicator(provider.itemList.status)
              ]),
            );
          }),
    );
  }
}
