import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/product/reported_item_provider.dart';
import 'package:flutteradhouse/provider/user/user_provider.dart';
import 'package:flutteradhouse/repository/reported_item_repository.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutteradhouse/viewobject/reported_item.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'reported_item_vertical_list_item.dart';

class ReportedItemListView extends StatefulWidget {
  const ReportedItemListView({Key? key, required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _ReportedItemListViewState createState() {
    return _ReportedItemListViewState();
  }
}

class _ReportedItemListViewState extends State<ReportedItemListView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ReportedItemProvider? _userListProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _userListProvider!
            .nextReportedItemList(_userListProvider!.valueHolder!.loginUserId!);
      }
    });
  }

  ReportedItemRepository? repo1;
  PsValueHolder? psValueHolder;
  UserProvider? userProvider;
  UserRepository? userRepo;
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    repo1 = Provider.of<ReportedItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    userRepo = Provider.of<UserRepository>(context);

    return PsWidgetWithMultiProvider(
        child: MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<UserProvider>(
          lazy: false,
          create: (BuildContext context) {
            userProvider =
                UserProvider(repo: userRepo, psValueHolder: psValueHolder);
            return userProvider!;
          },
        ),
        ChangeNotifierProvider<ReportedItemProvider>(
            lazy: false,
            create: (BuildContext context) {
              final ReportedItemProvider provider =
                  ReportedItemProvider(repo: repo1, valueHolder: psValueHolder);
              provider.loadReportedItemList(provider.valueHolder!.loginUserId!);
              return provider;
            })
      ],
      child: Consumer<ReportedItemProvider>(builder:
          (BuildContext context, ReportedItemProvider provider, Widget? child) {
        return Stack(children: <Widget>[
          Container(
              margin: const EdgeInsets.only(
                  top: PsDimens.space8, bottom: PsDimens.space8),
              child: RefreshIndicator(
                child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (provider.reportedItem.data != null ||
                                provider.reportedItem.data!.isNotEmpty) {
                              final int count =
                                  provider.reportedItem.data!.length;
                              return ReportedItemVerticalListItem(
                                animationController: widget.animationController,
                                animation:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: widget.animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                ),
                                reportedItem: provider.reportedItem.data![index],
                                onTap: () {
                                  final ReportedItem product =
                                      provider.reportedItem.data![index];
                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                          productId: provider
                                              .reportedItem.data![index].id!,
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
                                // onUnblockTap :() async{
                                //   await PsProgressDialog.showDialog(context);

                                //   final UnblockUserHolder userBlockItemParameterHolder =
                                //   UnblockUserHolder(
                                //   fromBlockUserId: userProvider.psValueHolder.loginUserId,
                                //    toBlockUserId: provider.reportedItem.data[index].userId);

                                //   final PsResource<ApiStatus> _apiStatus = await userProvider
                                //   .postUnBlockUser(userBlockItemParameterHolder.toMap());

                                //    if(_apiStatus != null &&_apiStatus.status != null){
                                //      PsProgressDialog.dismissDialog();
                                //      provider.deleteUserFromDB(provider.reportedItem.data[index].id);
                                //    }
                                // }
                              );
                            } else {
                              return null;
                            }
                          },
                          childCount: provider.reportedItem.data!.length,
                        ),
                      ),
                    ]),
                onRefresh: () async {
                  return _userListProvider!
                      .resetReportedItemList(provider.valueHolder!.loginUserId!);
                },
              )),
          PSProgressIndicator(provider.reportedItem.status)
        ]);
      }),
    ));
  }
}
