import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/offline_payment/offline_payment_method_provider.dart';
import 'package:flutteradhouse/provider/promotion/item_promotion_provider.dart';
import 'package:flutteradhouse/repository/offline_payment_method_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradhouse/ui/common/dialog/error_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/success_dialog.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget.dart';
import 'package:flutteradhouse/ui/common/ps_ui_widget.dart';
import 'package:flutteradhouse/ui/offline_payment/offline_payment_item.dart';
import 'package:flutteradhouse/utils/ps_progress_dialog.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/item_paid_history_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/item_paid_history.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:provider/provider.dart';

class OfflinePaymentView extends StatefulWidget {
  const OfflinePaymentView(
      {Key? key,
      required this.product,
      required this.amount,
      required this.howManyDay,
      required this.paymentMethod,
      required this.stripePublishableKey,
      required this.startDate,
      required this.startTimeStamp,
      required this.itemPaidHistoryProvider})
      : super(key: key);

  final Product product;
  final String amount;
  final String howManyDay;
  final String paymentMethod;
  final String stripePublishableKey;
  final String startDate;
  final String startTimeStamp;
  final ItemPromotionProvider itemPaidHistoryProvider;

  @override
  _OfflinePaymentViewState createState() {
    return _OfflinePaymentViewState();
  }
}

class _OfflinePaymentViewState extends State<OfflinePaymentView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  OfflinePaymentMethodProvider? _notiProvider;

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
        _notiProvider!.nextOfflinePaymentList();
      }
    });
  }

  OfflinePaymentMethodRepository? repo1;
  PsValueHolder? psValueHolder;
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

  dynamic callPaidAdSubmitApi(
    BuildContext context,
    Product product,
    String amount,
    String howManyDay,
    String paymentMethod,
    String stripePublishableKey,
    String startDate,
    String startTimeStamp,
    ItemPromotionProvider itemPaidHistoryProvider,
    // ProgressDialog progressDialog,
    String token,
  ) async {
    if (await Utils.checkInternetConnectivity()) {
      final ItemPaidHistoryParameterHolder itemPaidHistoryParameterHolder =
          ItemPaidHistoryParameterHolder(
              itemId: product.id,
              amount: amount,
              howManyDay: howManyDay,
              paymentMethod: paymentMethod,
              paymentMethodNounce: Platform.isIOS ? token : token,
              startDate: startDate,
              startTimeStamp: startTimeStamp,
              razorId: '',
              purchasedId: '',
              isPaystack: PsConst.ZERO);

      final PsResource<ItemPaidHistory> padiHistoryDataStatus =
          await itemPaidHistoryProvider
              .postItemHistoryEntry(itemPaidHistoryParameterHolder.toMap());
      PsProgressDialog.dismissDialog();

      if (padiHistoryDataStatus.data != null) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext contet) {
              return SuccessDialog(
                message: Utils.getString(context, 'item_promote__success'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              );
            });
      } else {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: padiHistoryDataStatus.message,
              );
            });
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && psValueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, false);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    timeDilation = 1.0;
    repo1 = Provider.of<OfflinePaymentMethodRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<OfflinePaymentMethodProvider>(
          appBarTitle:
              Utils.getString(context, 'item_promote__pay_offline'),
          initProvider: () {
            return OfflinePaymentMethodProvider(
                repo: repo1, psValueHolder: psValueHolder);
          },
          onProviderReady: (OfflinePaymentMethodProvider provider) {
            provider.getOfflinePaymentList();
            _notiProvider = provider;

            return provider;
          },
          builder: (BuildContext context, OfflinePaymentMethodProvider provider,
              Widget? child) {
            if (
                provider.offlinePaymentMethod.data != null) {
              return Stack(children: <Widget>[
                Container(
                    child: RefreshIndicator(
                  child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: Row(
                            children: <Widget>[
                              const SizedBox(width: PsDimens.space16),
                              Expanded(
                                child: Text(
                                    provider.offlinePaymentMethod.data!.message!,
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ),
                              const SizedBox(width: PsDimens.space16),
                            ],
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (provider.offlinePaymentMethod.data != null ||
                                  provider.offlinePaymentMethod.data!
                                      .offlinePayment!.isNotEmpty) {
                                final int count = provider.offlinePaymentMethod
                                    .data!.offlinePayment!.length;
                                return OfflinePaymenItem(
                                  animationController: animationController,
                                  animation: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: animationController!,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  offlinePayment: provider.offlinePaymentMethod
                                      .data!.offlinePayment![index],
                                  onTap: () {
                                    // Navigator.pushNamed(context,
                                    //     RoutePaths.transactionDetail,
                                    //     arguments: provider
                                    //         .offlinePaymentMethod.data.offlinePayment[index]);
                                  },
                                );
                              } else {
                                return null;
                              }
                            },
                            childCount: provider.offlinePaymentMethod.data!
                                .offlinePayment!.length,
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: PsDimens.space64,
                          ),
                        ),
                      ]),
                  onRefresh: () async {
                    return _notiProvider!.resetOfflinePaymentList();
                  },
                )),
                PSProgressIndicator(provider.offlinePaymentMethod.status),
                Positioned(
                    bottom: 5,
                    right: 5,
                    left: 5,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: PsDimens.space16,
                        ),
                        Container(
                            color: PsColors.transparent,
                            margin: const EdgeInsets.only(
                                left: PsDimens.space32,
                                right: PsDimens.space32),
                            child: PSButtonWidget(
                                hasShadow: true,
                                width: double.infinity,
                                titleText: Utils.getString(
                                    context, 'item_promote__pay_offline'),
                                onPressed: () async {
                                  await PsProgressDialog.showDialog(context);
                                  callPaidAdSubmitApi(
                                    context,
                                    widget.product,
                                    widget.amount,
                                    widget.howManyDay,
                                    widget.paymentMethod,
                                    widget.stripePublishableKey,
                                    widget.startDate,
                                    widget.startTimeStamp,
                                    widget.itemPaidHistoryProvider,
                                    '',
                                  );
                                })),
                        const SizedBox(
                          height: PsDimens.space16,
                        ),
                      ],
                    ))
              ]);
            } else {
              return Container();
            }
          }),
    );
  }
}
