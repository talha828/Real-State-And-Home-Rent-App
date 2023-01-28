import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/offer/offer_provider.dart';
import 'package:flutteradhouse/repository/offer_repository.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/offer/item/offer_sent_list_item.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import 'package:flutteradhouse/viewobject/holder/offer_parameter_holder.dart';
import 'package:provider/provider.dart';

class OfferSentListView extends StatefulWidget {
  const OfferSentListView({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;
  @override
  _OfferSentListViewState createState() => _OfferSentListViewState();
}

class _OfferSentListViewState extends State<OfferSentListView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  OfferListProvider? _offerListProvider;

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
        holder!.getOfferSentList().userId = psValueHolder!.loginUserId;
        _offerListProvider!.nextOfferList(holder!);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  OfferRepository? offerRepository;
  PsValueHolder? psValueHolder;
  OfferParameterHolder? holder;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);
    holder = OfferParameterHolder().getOfferSentList();
    holder!.getOfferSentList().userId = psValueHolder!.loginUserId;

    offerRepository = Provider.of<OfferRepository>(context);

    return ChangeNotifierProvider<OfferListProvider>(
      lazy: false,
      create: (BuildContext context) {
        final OfferListProvider provider =
            OfferListProvider(repo: offerRepository);
        provider.loadOfferList(holder!);
        return provider;
      },
      child: Consumer<OfferListProvider>(builder:
          (BuildContext context, OfferListProvider provider, Widget? child) {
        if (
            provider.offerList.data != null &&
            provider.offerList.data!.isNotEmpty &&
            psValueHolder!.loginUserId != null) {
          return Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: RefreshIndicator(
                          child: MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: provider.offerList.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final int count =
                                    provider.offerList.data!.length;
                                widget.animationController.forward();
                                return OfferSentListItem(
                                  animationController:
                                      widget.animationController,
                                  animation: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: widget.animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  offer: provider.offerList.data![index],
                                  onTap: () async {
                                    print(provider
                                        .offerList.data![index].item!.title);
                                    final dynamic returnData =
                                        await Navigator.pushNamed(
                                      context,
                                      RoutePaths.chatView,
                                      arguments: ChatHistoryIntentHolder(
                                          chatFlag: PsConst.CHAT_FROM_SELLER,
                                          itemId: provider
                                              .offerList.data![index].item!.id!,
                                          buyerUserId: provider.offerList
                                              .data![index].buyerUserId!,
                                          sellerUserId: provider.offerList
                                              .data![index].sellerUserId!),
                                    );
                                    if (returnData == null) {
                                      provider.loadOfferList(holder!);
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          onRefresh: () {
                            return provider.resetOfferList(holder!);
                          },
                        ),
                      ),
                      PSProgressIndicator(provider.offerList.status)
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          widget.animationController.forward();
          return Container();
        }
      }),
      // )
    );
  }
}
