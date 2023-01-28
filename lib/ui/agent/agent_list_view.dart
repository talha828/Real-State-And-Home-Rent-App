import 'package:flutter/material.dart';
import 'package:flutteradhouse/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/agent/agent_list_provider.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/ui/agent/agent_vertical_list_item.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/user_intent_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class AgentListView extends StatefulWidget {
  const AgentListView({Key? key, required this.animationController})
      : super(key: key);
  final AnimationController animationController;

  @override
  _AgentListViewListView createState() => _AgentListViewListView();
}

class _AgentListViewListView extends State<AgentListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  AgentListProvider? agentListProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // _paidAdItemProvider.nextProductList();
      }
    });

    super.initState();
  }

  UserRepository? repo1;
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
     repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    if (!isConnectedToInternet && psValueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }

   
    print(
        '............................Build UI Again ............................');

    return ChangeNotifierProvider<AgentListProvider>(
        lazy: false,
        create: (BuildContext context) {
          agentListProvider = AgentListProvider(
              repo: repo1, limit:psValueHolder!.agentLoadingLimit!);
          agentListProvider!.loadAgentList();

          return agentListProvider!;
        },
        child: Consumer<AgentListProvider>(
          builder: (BuildContext context, AgentListProvider userListProvider,
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
                                          maxCrossAxisExtent: 200.0,
                                          childAspectRatio: 0.8),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (
                                          userListProvider
                                              .agentList.data!.isNotEmpty) {
                                        final int count = userListProvider
                                            .agentList.data!.length;
                                        return AgentVerticalListItem(
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
                                                    curve:
                                                        Curves.fastOutSlowIn),
                                              ),
                                            ),
                                            user: userListProvider
                                                .agentList.data![index],
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  RoutePaths.userDetail,
                                                  arguments: UserIntentHolder(
                                                      userId: userListProvider
                                                          .agentList
                                                          .data![index]
                                                          .userId!,
                                                      userName: userListProvider
                                                          .agentList
                                                          .data![index]
                                                          .userName!));
                                            });
                                      } else {
                                        return null;
                                      }
                                    },
                                    childCount:
                                        userListProvider.agentList.data!.length,
                                  ),
                                ),
                              ]),
                          onRefresh: () {
                            return userListProvider.resetAgentList();
                          },
                        )),
                    PSProgressIndicator(userListProvider.agentList.status)
                  ]),
                )
              ],
            );
          },
        ));
  }
}
