import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/package_bought/package_bought_provider.dart';
import 'package:flutteradhouse/provider/package_bought/package_bought_transaction_provider.dart';
import 'package:flutteradhouse/repository/package_bought_repository.dart';
import 'package:flutteradhouse/repository/package_bought_transaction_history_repository.dart';
import 'package:flutteradhouse/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradhouse/ui/common/ps_header_widget.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/package/package_recommended_shop_widget.dart';
import 'package:flutteradhouse/ui/user/buy_adpost_transaction/buy_adpost_transaction_history_horizontal_item.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/package_transaction_holder.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BuyAdTransactionListView extends StatefulWidget {
  

  // const BuyAdTransactionListView({Key? key,  required this.animationController})
  //     : super(key: key);
  // final AnimationController animationController;
  @override
  _BuyAdTransactionListViewState createState() =>
      _BuyAdTransactionListViewState();
}

class _BuyAdTransactionListViewState extends State<BuyAdTransactionListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late PsValueHolder valueHolder;
  late PackageTranscationHistoryProvider _historyProvider;
  late Animation<double>? animation;
  late AnimationController? animationController;
  PackageBoughtRepository? repo2;
  PackageBoughtProvider? packageBoughtProvider;

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
    super.initState();
    
  }

  late PackageTranscationHistoryRepository repo1;
  late PackgageBoughtTransactionParameterHolder packgageBoughtParameterHolder;
  bool isFirstTime = true;

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<PackageTranscationHistoryRepository>(context);
    repo2 = Provider.of<PackageBoughtRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    packgageBoughtParameterHolder = PackgageBoughtTransactionParameterHolder(
              userId: Utils.checkUserLoginId(valueHolder),);

    print(
        '............................Build UI Again ............................');

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<PackageTranscationHistoryProvider>(
          lazy: false,
          create: (BuildContext context) {
            _historyProvider = PackageTranscationHistoryProvider(
                repo: repo1, psValueHolder: valueHolder);
            _historyProvider.loadBuyAdTransactionList(
              packgageBoughtParameterHolder,
            );
            return _historyProvider;
          },
        ),
        ChangeNotifierProvider<PackageBoughtProvider?>(
          lazy: false,
          create: (BuildContext context) {
            packageBoughtProvider = PackageBoughtProvider(repo: repo2);
            packageBoughtProvider!.getAllPackages();
            return packageBoughtProvider;
          },
        ),
      ],
      child: VisibilityDetector(
        key: const Key('my-widget-key'),
        onVisibilityChanged: (VisibilityInfo visibilityInfo) { 
          // ignore: always_specify_types
          final double visiblePercentage = visibilityInfo.visibleFraction * 100;
          if (visiblePercentage == 100) {
            if (!isFirstTime) {
            _historyProvider.resetPackageTransactionDetailList(
              packgageBoughtParameterHolder,
            );
            }
            isFirstTime = false;
          }
         },
        child: Consumer<PackageTranscationHistoryProvider>(
          builder: (BuildContext context,
              PackageTranscationHistoryProvider provider, Widget? child) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(
                            //  left: PsDimens.space12,
                              right: PsDimens.space10,
                            //  top: PsDimens.space8,
                              bottom: PsDimens.space8),
                          child: RefreshIndicator(
                            child: CustomScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                slivers: <Widget>[
                                  SliverToBoxAdapter(
                                    child: PsHeaderWidget(
                                      headerName: Utils.getString(context, 'package__purchased'),
                                      viewAllClicked: () {},
                                      showViewAll: false,
                                    ),
                                  ),
                                  if (provider.transactionList.data !=
                                                null &&
                                            provider.transactionList.data!
                                                .isNotEmpty) 
                                  SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 220.0,
                                            childAspectRatio: 1.5),
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                          if (provider
                                                  .transactionList.status ==
                                              PsStatus.BLOCK_LOADING) {
                                            return Shimmer.fromColors(
                                                baseColor: PsColors.grey,
                                                highlightColor:
                                                    PsColors.white,
                                                child: Row(
                                                    children: const <Widget>[
                                                      PsFrameUIForLoading(),
                                                    ]));
                                          } else {
                                            return BuyAdTransactionHorizontalListItem(
                                              transaction: provider
                                                  .transactionList
                                                  .data![index],
                                              onTap: () {
                                            
                                              },
                                            );
                                          }
                                      },
                                      childCount: provider
                                          .transactionList.data!.length,
                                    ),
                                  ) else 
                                  SliverToBoxAdapter(
                                    child: Container(
                                      height: 120,
                                      child: Center(
                                        child: Text(
                                                    Utils.getString(context,
                                                        'You have no active package. \n Buy and create post'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2!
                                                        .copyWith(
                                                          color: PsColors.textPrimaryLightColor
                                                        ),
                                                    textAlign: TextAlign.center,    ),
                                      ),
                                    ),
                                  ),
                                  PackageRecommendedWidget(
                                     androidKeyList: valueHolder.packageAndroidKeyList,
                                    iosKeyList: valueHolder.packageIOSKeyList,
                                    callToRefresh: () {
                                      provider.resetPackageTransactionDetailList(packgageBoughtParameterHolder);
                                    },
                                  )
                                ]),
                            onRefresh: () {
                              return provider
                                  .resetPackageTransactionDetailList(
                                packgageBoughtParameterHolder,
                              );
                            },
                          )),
                      PSProgressIndicator(provider.transactionList.status)
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
