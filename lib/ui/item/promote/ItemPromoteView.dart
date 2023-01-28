
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/constant/route_paths.dart';
import 'package:flutteradhouse/provider/app_info/app_info_provider.dart';
import 'package:flutteradhouse/provider/promotion/item_promotion_provider.dart';
import 'package:flutteradhouse/provider/token/token_provider.dart';
import 'package:flutteradhouse/provider/user/user_provider.dart';
import 'package:flutteradhouse/repository/app_info_repository.dart';
import 'package:flutteradhouse/repository/item_paid_history_repository.dart';
import 'package:flutteradhouse/repository/token_repository.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutteradhouse/ui/common/dialog/demo_warning_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/error_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/success_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget.dart';
import 'package:flutteradhouse/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:flutteradhouse/utils/ps_progress_dialog.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/item_paid_history_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/paid_history_holder.dart';
import 'package:flutteradhouse/viewobject/holder/paystack_intent_holder.dart';
import 'package:flutteradhouse/viewobject/item_paid_history.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class ItemPromoteView extends StatefulWidget {
  const ItemPromoteView({Key? key, required this.product}) : super(key: key);

  final Product product;
  @override
  _ItemPromoteViewState createState() => _ItemPromoteViewState();
}

class _ItemPromoteViewState extends State<ItemPromoteView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  ItemPaidHistoryRepository ?itemPaidHistoryRepository;
  ItemPromotionProvider? itemPaidHistoryProvider;
  PsValueHolder? psValueHolder;
  AppInfoRepository? appInfoRepository;
  AppInfoProvider? appInfoProvider;
  TokenProvider? tokenProvider;
  PsApiService? psApiService;
  TokenRepository? tokenRepository;
  UserProvider? userProvider;
  UserRepository? userRepository;

  final TextEditingController priceTypeController = TextEditingController();
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    psValueHolder = Provider.of<PsValueHolder>(context);
    appInfoRepository = Provider.of<AppInfoRepository>(context);
    itemPaidHistoryRepository = Provider.of<ItemPaidHistoryRepository>(context);
    psApiService = Provider.of<PsApiService>(context);
    tokenRepository = Provider.of<TokenRepository>(context);
    userRepository = Provider.of<UserRepository>(context);

    return PsWidgetWithMultiProvider(
      child: MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<ItemPromotionProvider>(
            lazy: false,
            create: (BuildContext context) {
              itemPaidHistoryProvider = ItemPromotionProvider(
                  itemPaidHistoryRepository: itemPaidHistoryRepository);

              return itemPaidHistoryProvider!;
            },
          ),
          ChangeNotifierProvider<UserProvider>(
            lazy: false,
            create: (BuildContext context) {
              userProvider = UserProvider(
                  repo: userRepository, psValueHolder: psValueHolder);
              userProvider!.getUser(psValueHolder!.loginUserId!);
              return userProvider!;
            },
          ),
          ChangeNotifierProvider<AppInfoProvider>(
              lazy: false,
              create: (BuildContext context) {
                appInfoProvider = AppInfoProvider(
                    repo: appInfoRepository, psValueHolder: psValueHolder);

                appInfoProvider!.loadDeleteHistorywithNotifier();

                return appInfoProvider!;
              }),
          ChangeNotifierProvider<TokenProvider>(
              lazy: false,
              create: (BuildContext context) {
                tokenProvider = TokenProvider(repo: tokenRepository);
                // tokenProvider.loadToken();
                return tokenProvider!;
                // return TokenProvider(repo: tokenRepository);
              }),
        ],
        child: Scaffold(
          appBar: AppBar(
          systemOverlayStyle:  SystemUiOverlayStyle(
           statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
         ),
            iconTheme: IconThemeData(color: PsColors.mainColorWithWhite),
            title: Text(
              Utils.getString(context, 'item_promote__entry'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: PsColors.mainColorWithWhite),
            ),
          ),
          body: SingleChildScrollView(
            child: AnimatedBuilder(
                animation: animationController!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AdsStartDateDropDownWidget(),
                    AdsHowManyDayWidget(
                      product: widget.product,
                      tokenProvider: tokenProvider,
                    ),
                  ],
                ),
                builder: (BuildContext context, Widget? child) {
                  return child!;
                }),
          ),
        ),
      ),
    );
  }
}

class AdsStartDateDropDownWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdsStartDateDropDownWidgetState();
  }
}

class AdsStartDateDropDownWidgetState
    extends State<AdsStartDateDropDownWidget> {
  TextEditingController startDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemPromotionProvider>(
      builder: (BuildContext context,
          ItemPromotionProvider itemPaidHistoryProvider, Widget? child) {
        // ignore: unnecessary_null_comparison
        if (itemPaidHistoryProvider == null) {
          return Container();
        } else {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: PsDimens.space12),
                child: PsDropdownBaseWithControllerWidget(
                    title: Utils.getString(
                        context, 'item_promote__ads_start_date'),
                    textEditingController: startDateController,
                    isStar: true,
                    onTap: () async {
                      final DateTime today = DateTime.now();
                      Utils.psPrint('Today is ' + today.toString());
                      // final DateTime oneDaysAgo =
                      //     today.subtract(const Duration(days: 1));
                      await DatePicker.showDateTimePicker(context,
                          minTime: DateTime.now(), onConfirm: (DateTime date) {
                        itemPaidHistoryProvider.selectedDateTime = date;
                      }, locale: LocaleType.en);

                      if (itemPaidHistoryProvider.selectedDateTime != null) {
                        itemPaidHistoryProvider.selectedDate =
                            DateFormat.yMMMMd('en_US').format(
                                    itemPaidHistoryProvider.selectedDateTime!) +
                                ' ' +
                                DateFormat.Hms('en_US').format(
                                    itemPaidHistoryProvider.selectedDateTime!);
                      }
                      setState(() {
                        startDateController.text =
                            itemPaidHistoryProvider.selectedDate!;
                      });
                    }),
              ),
            ],
          );
        }
      },
    );
  }
}

class AdsHowManyDayWidget extends StatefulWidget {
  const AdsHowManyDayWidget(
      {Key? key, required this.product, required this.tokenProvider})
      : super(key: key);

  final Product product;
  final TokenProvider? tokenProvider;
  @override
  State<StatefulWidget> createState() {
    return AdsHowManyDayWidgetState();
  }
}

class AdsHowManyDayWidgetState extends State<AdsHowManyDayWidget> {
  TextEditingController getEnterDateCountController = TextEditingController();
  bool getDefaultChoiceDate = true;
  bool getFirstChoiceDate = false;
  bool getSecondChoiceDate = false;
  bool getThirdChoiceDate = false;
  bool getFourthChoiceDate = false;
  bool getFifthChoiceDate = false;
  String? amount;
  String? howManyDay;
  String? startDate;
  String? stripePublishableKey;
  String? payStackKey;
  // static String text = getEnterDateCountController.text;
  @override
  Widget build(BuildContext context) {
            final PsValueHolder valueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    final Widget payStackButtonWidget = Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
      width: double.infinity,
      height: PsDimens.space44,
      child: PSButtonWithIconWidget(
          hasShadow: true,
          width: double.infinity,
          icon: FontAwesome.credit_card,
          titleText: Utils.getString(context, 'item_promote__pay_stack'),
          colorData: PsColors.stripeColor,
          onPressed: () async {
            if (double.parse(amount!) <= 0) {
              return;
            }
            final ItemPromotionProvider provider =
                Provider.of<ItemPromotionProvider>(context, listen: false);

            if (provider.selectedDate == '' || provider.selectedDate == null) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_promote__choose_start_date'),
                      onPressed: () {},
                    );
                  });
            } else {
              if (PsConfig.isDemo) {
                await callDemoWarningDialog(context);
              }
              final AppInfoProvider appProvider =
                  Provider.of<AppInfoProvider>(context, listen: false);
              final UserProvider userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              payStackKey = appProvider.appInfo.data!.payStackKey;

              if (provider.selectedDate != null) {
                startDate = provider.selectedDate;
              }
              if (getEnterDateCountController.text != '') {
                howManyDay = getEnterDateCountController.text;

                final AppInfoProvider provider =
                    Provider.of<AppInfoProvider>(context, listen: false);
                final double amountByEnterDay = double.parse(howManyDay!) *
                    double.parse(provider.appInfo.data!.oneDay!);
                amount = amountByEnterDay.toString();
                payStackKey = provider.appInfo.data!.payStackKey;
              }

              final int resultStartTimeStamp =
                  Utils.getTimeStampDividedByOneThousand(
                      provider.selectedDateTime!);

              // ignore: unnecessary_null_comparison
              if (provider != null) {
                final dynamic returnData = await Navigator.pushNamed(
                    context, RoutePaths.payStackPayment,
                    arguments: PayStackInterntHolder(
                        product: widget.product,
                        amount: amount!,
                        howManyDay: howManyDay!,
                        paymentMethod: PsConst.PAYMENT_PAY_STACK_METHOD,
                        stripePublishableKey: stripePublishableKey,
                        startDate: startDate!,
                        startTimeStamp: resultStartTimeStamp.toString(),
                        itemPaidHistoryProvider: provider,
                        userProvider: userProvider,
                        payStackKey: payStackKey!));

                if (returnData == null || returnData) {
                  Navigator.pop(context, true);
                }
              }
            }
          }),
      // child: PSButtonWithIconWidget(
      //     hasShadow: true,
      //     width: double.infinity,
      //     icon: FontAwesome.credit_card,
      //     titleText: Utils.getString(context, 'item_promote__pay_stack'),
      //     colorData: PsColors.stripeColor,
      //     onPressed: () async {
      //       if (double.parse(amount!) <= 0) {
      //         return;
      //       }
      //       final ItemPromotionProvider provider =
      //           Provider.of<ItemPromotionProvider>(context, listen: false);

      //       if (provider.selectedDate == null) {
      //         showDialog<dynamic>(
      //             context: context,
      //             builder: (BuildContext context) {
      //               return WarningDialog(
      //                 message: Utils.getString(
      //                     context, 'item_promote__choose_start_date'),
      //                 onPressed: () {},
      //               );
      //             });
      //       } else {
      //         final AppInfoProvider appProvider =
      //             Provider.of<AppInfoProvider>(context, listen: false);
      //         final UserProvider userProvider =
      //             Provider.of<UserProvider>(context, listen: false);
      //         payStackKey = appProvider.appInfo.data!.payStackKey;

      //         if (provider.selectedDate != null) {
      //           startDate = provider.selectedDate;
      //         }
      //         if (getEnterDateCountController.text != '') {
      //           howManyDay = getEnterDateCountController.text;

      //           final AppInfoProvider provider =
      //               Provider.of<AppInfoProvider>(context, listen: false);
      //           final double amountByEnterDay = double.parse(howManyDay!) *
      //               double.parse(provider.appInfo.data!.oneDay!);
      //           amount = amountByEnterDay.toString();
      //           payStackKey = provider.appInfo.data!.payStackKey;
      //         }

      //         final int resultStartTimeStamp =
      //             Utils.getTimeStampDividedByOneThousand(provider.selectedDateTime!);

      //         // ignore: unnecessary_null_comparison
      //         if (provider != null) {
      //           final dynamic returnData = await Navigator.pushNamed(
      //               context, RoutePaths.payStackPayment,
      //               arguments: PayStackInterntHolder(
      //                   product: widget.product,
      //                   amount: amount!,
      //                   howManyDay: howManyDay!,
      //                   paymentMethod: PsConst.PAYMENT_PAY_STACK_METHOD,
      //                   stripePublishableKey: stripePublishableKey!,
      //                   startDate: startDate!,
      //                   startTimeStamp: resultStartTimeStamp.toString(),
      //                   itemPaidHistoryProvider: provider,
      //                   userProvider: userProvider,
      //                   payStackKey: payStackKey!));

      //           if (returnData == null || returnData) {
      //             Navigator.pop(context, true);
      //           }
      //         }
      //       }
      //     }),
    );
    final Widget offlinePaymentButtonWidget = Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
      width: double.infinity,
      height: PsDimens.space44,
      child: PSButtonWithIconWidget(
          hasShadow: true,
          width: double.infinity,
          icon: FontAwesome.money,
          titleText: Utils.getString(context, 'item_promote__pay_offline'),
          colorData: PsColors.stripeColor,
          onPressed: () async {
            if (double.parse(amount!) <= 0) {
              return;
            }
            final ItemPromotionProvider provider =
                Provider.of<ItemPromotionProvider>(context, listen: false);

            if (provider.selectedDate == null) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_promote__choose_start_date'),
                      onPressed: () {},
                    );
                  });
            } else {
              final AppInfoProvider appProvider =
                  Provider.of<AppInfoProvider>(context, listen: false);
              stripePublishableKey =
                  appProvider.appInfo.data!.stripePublishableKey;

              if (provider.selectedDate != null) {
                startDate = provider.selectedDate;
              }
              if (getEnterDateCountController.text != '') {
                howManyDay = getEnterDateCountController.text;

                final AppInfoProvider provider =
                    Provider.of<AppInfoProvider>(context, listen: false);
                final double amountByEnterDay = double.parse(howManyDay!) *
                    double.parse(provider.appInfo.data!.oneDay!);
                amount = amountByEnterDay.toString();
                stripePublishableKey =
                    provider.appInfo.data!.stripePublishableKey;
              }

              final int resultStartTimeStamp =
                  Utils.getTimeStampDividedByOneThousand(provider.selectedDateTime!);

              // ignore: unnecessary_null_comparison
              if (provider != null) {
                final dynamic returnData = await Navigator.pushNamed(
                    context, RoutePaths.offlinePayment,
                    arguments: PaidHistoryHolder(
                        product: widget.product,
                        amount: amount!,
                        howManyDay: howManyDay!,
                        paymentMethod: PsConst.PAYMENT_OFFLINE_METHOD,
                        stripePublishableKey: stripePublishableKey!,
                        startDate: startDate!,
                        startTimeStamp: resultStartTimeStamp.toString(),
                        itemPaidHistoryProvider: provider,
                        payStackKey: ''));

                if (returnData == null || returnData) {
                  Navigator.pop(context, true);
                }
              }
            }
          }),
    );
    final Widget paypalButtonWidget = Container(
      margin: const EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
        bottom: PsDimens.space16,
      ),
      width: double.infinity,
      height: PsDimens.space44,
      child: PSButtonWithIconWidget(
          hasShadow: true,
          icon: FontAwesome.paypal,
          width: double.infinity,
          colorData: PsColors.paypalColor,
          titleText: Utils.getString(context, 'item_promote__paypal'),
          onPressed: () async {
            final UserProvider userProvider =
                Provider.of<UserProvider>(context, listen: false);

            final AppInfoProvider appInfoProvider =
                Provider.of<AppInfoProvider>(context, listen: false);
          
            final TokenProvider tokenProvider =
                Provider.of<TokenProvider>(context, listen: false);

            if (double.parse(amount!) <= 0) {
              return;
            }

            final PsResource<ApiStatus> tokenResource =
                await tokenProvider.loadToken();

            final ItemPromotionProvider provider =
                Provider.of<ItemPromotionProvider>(context, listen: false);
            if (provider.selectedDate == '' || provider.selectedDate == null) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_promote__choose_start_date'),
                      onPressed: () {},
                    );
                  });
            } else {
              if (PsConfig.isDemo) {
                await callDemoWarningDialog(context);
              }
              final String message = tokenResource.data!.message!;
              // final BraintreePayment braintreePayment = BraintreePayment();
              // final dynamic data = await braintreePayment.showDropIn(
              //     nonce: message, amount: amount, enableGooglePay: true);
              // print(
              //     '${Utils.getString(context, 'checkout__payment_response')} $data');

              final BraintreeDropInRequest request = BraintreeDropInRequest(
                clientToken: message,
                collectDeviceData: true,
                googlePaymentRequest: BraintreeGooglePaymentRequest(
                  totalPrice: amount!,
                  currencyCode: appInfoProvider.appInfo.data!.currencyShortForm!,
                  billingAddressRequired: false,
                ),
                paypalRequest: BraintreePayPalRequest(
                  amount: amount,
                  displayName: userProvider.user.data!.userName,
                ),
              );

              final BraintreeDropInResult? result = await BraintreeDropIn.start(request);
              if (result != null) {
                print('Nonce: ${result.paymentMethodNonce.nonce}');
              } else {
                print('Selection was canceled.');
              }
                           
              Utils.psPrint(message);
              if (provider.selectedDate != null) {
                startDate = provider.selectedDate;
              }
              if (getEnterDateCountController.text != '') {
                howManyDay = getEnterDateCountController.text;
                final AppInfoProvider provider =
                    Provider.of<AppInfoProvider>(context, listen: false);
                final double amountByEnterDay = double.parse(howManyDay!) *
                    double.parse(provider.appInfo.data!.oneDay!);
                amount = amountByEnterDay.toString();
              }

              final int reultStartTimeStamp =
                  Utils.getTimeStampDividedByOneThousand(provider.selectedDateTime!);

              // ignore: unnecessary_null_comparison
              if (provider != null) {
                final ItemPaidHistoryParameterHolder
                    itemPaidHistoryParameterHolder =
                    ItemPaidHistoryParameterHolder(
                        itemId: widget.product.id,
                        amount: amount,
                        howManyDay: howManyDay,
                        paymentMethod: PsConst.PAYMENT_PAYPAL_METHOD,
                        paymentMethodNounce:result!.paymentMethodNonce.nonce,
                        startDate: startDate,
                        startTimeStamp: reultStartTimeStamp.toString(),
                        razorId: '',
                        purchasedId: '',
                        isPaystack: PsConst.ZERO);

                await PsProgressDialog.showDialog(context);

                final PsResource<ItemPaidHistory> paidHistoryData =
                    await provider.postItemHistoryEntry(
                        itemPaidHistoryParameterHolder.toMap());

                PsProgressDialog.dismissDialog();

                if (paidHistoryData.data != null) {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext contet) {
                        return SuccessDialog(
                          message:
                              Utils.getString(context, 'item_promote__success'),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        );
                      });
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: paidHistoryData.message,
                        );
                      });
                }
              } else {
                Utils.psPrint(
                    'Item paid history provider is null , please check!!!');
              }
            }
          }),
    );
    final Widget stripeButtonWidget = Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
      width: double.infinity,
      height: PsDimens.space44,
      child: PSButtonWithIconWidget(
          hasShadow: true,
          width: double.infinity,
          icon: FontAwesome.cc_stripe,
          titleText: Utils.getString(context, 'item_promote__stripe'),
          colorData: PsColors.stripeColor,
          onPressed: () async {
            if (double.parse(amount!) <= 0) {
              return;
            }
            final ItemPromotionProvider provider =
                Provider.of<ItemPromotionProvider>(context, listen: false);

            if (provider.selectedDate == '' || provider.selectedDate == null) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_promote__choose_start_date'),
                      onPressed: () {},
                    );
                  });
            } else {
              if (PsConfig.isDemo) {
                await callDemoWarningDialog(context);
              }
              final AppInfoProvider appProvider =
                  Provider.of<AppInfoProvider>(context, listen: false);
              stripePublishableKey =
                  appProvider.appInfo.data!.stripePublishableKey;

              if (provider.selectedDate != null) {
                startDate = provider.selectedDate;
              }
              if (getEnterDateCountController.text != '') {
                howManyDay = getEnterDateCountController.text;

                final AppInfoProvider provider =
                    Provider.of<AppInfoProvider>(context, listen: false);
                final double amountByEnterDay = double.parse(howManyDay!) *
                    double.parse(provider.appInfo.data!.oneDay!);
                amount = amountByEnterDay.toString();
                stripePublishableKey =
                    provider.appInfo.data!.stripePublishableKey;
              }

              final int resultStartTimeStamp =
                  Utils.getTimeStampDividedByOneThousand(provider.selectedDateTime!);

              // ignore: unnecessary_null_comparison
              if (provider != null) {
                final dynamic returnData = await Navigator.pushNamed(
                    context, RoutePaths.creditCard,
                    arguments: PaidHistoryHolder(
                        product: widget.product,
                        amount: amount!,
                        howManyDay: howManyDay!,
                        paymentMethod: PsConst.PAYMENT_STRIPE_METHOD,
                        stripePublishableKey: stripePublishableKey!,
                        startDate: startDate!,
                        startTimeStamp: resultStartTimeStamp.toString(),
                        itemPaidHistoryProvider: provider,
                        payStackKey: ''));

                if (returnData == null || returnData) {
                  Navigator.pop(context, true);
                }
              }
            }
          }),
    );

    final Widget razorButtonWidget = Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
      width: double.infinity,
      height: PsDimens.space44,
      child: PSButtonWithIconWidget(
          hasShadow: true,
          icon: FontAwesome.credit_card,
          width: double.infinity,
          colorData: PsColors.paypalColor,
          titleText: Utils.getString(context, 'item_promote__razor'),
          onPressed: () async {
            // if(widget.tokenProvider != null)

            if (double.parse(amount!) <= 0) {
              return;
            }

            // final PsResource<ApiStatus> tokenResource =
            //     await widget.tokenProvider.loadToken();

            final ItemPromotionProvider provider =
                Provider.of<ItemPromotionProvider>(context, listen: false);
            final UserProvider userProvider =
                Provider.of<UserProvider>(context, listen: false);
            final AppInfoProvider appInfoProvider =
                Provider.of<AppInfoProvider>(context, listen: false);
            if (provider.selectedDate == '' || provider.selectedDate == null) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_promote__choose_start_date'),
                      onPressed: () {},
                    );
                  });
            } else {
              if (PsConfig.isDemo) {
                await callDemoWarningDialog(context);
              }
              if (provider.selectedDate != null) {
                startDate = provider.selectedDate;
              }
              if (getEnterDateCountController.text != '') {
                howManyDay = getEnterDateCountController.text;

                final double amountByEnterDay = double.parse(howManyDay!) *
                    double.parse(appInfoProvider.appInfo.data!.oneDay!);
                amount = amountByEnterDay.toString();
              }

              final int reultStartTimeStamp =
                  Utils.getTimeStampDividedByOneThousand(provider.selectedDateTime!);
              Future<void> _handlePaymentSuccess(
                  PaymentSuccessResponse response) async {
                // Do something when payment succeeds
                print('success');

                print(response);

                final ItemPaidHistoryParameterHolder
                    itemPaidHistoryParameterHolder =
                    ItemPaidHistoryParameterHolder(
                        itemId: widget.product.id,
                        amount: Utils.getPriceFormat(amount!,valueHolder.priceFormat!),
                        howManyDay: howManyDay,
                        paymentMethod: PsConst.PAYMENT_RAZOR_METHOD,
                        paymentMethodNounce: '',
                        startDate: startDate,
                        startTimeStamp: reultStartTimeStamp.toString(),
                        razorId: response.paymentId,
                        purchasedId: '',
                        isPaystack: PsConst.ZERO);

                await PsProgressDialog.showDialog(context);

                final PsResource<ItemPaidHistory> paidHistoryData =
                    await provider.postItemHistoryEntry(
                        itemPaidHistoryParameterHolder.toMap());

                PsProgressDialog.dismissDialog();

                if (paidHistoryData.data != null) {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext contet) {
                        return SuccessDialog(
                          message:
                              Utils.getString(context, 'item_promote__success'),
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
                          message: paidHistoryData.message,
                        );
                      });
                }
              }

              void _handlePaymentError(PaymentFailureResponse response) {
                // Do something when payment fails
                print('error');
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message:
                            Utils.getString(context, 'checkout__payment_fail'),
                      );
                    });
              }

              void _handleExternalWallet(ExternalWalletResponse response) {
                // Do something when an external wallet is selected
                print('external wallet');
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'checkout__payment_not_supported'),
                      );
                    });
              }

             // ignore: unnecessary_null_comparison
              if (provider != null) {
                // Start Razor Payment
                final Razorpay _razorpay = Razorpay();
                _razorpay.on(
                    Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                _razorpay.on(
                    Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

                final Map<String, Object> options = <String, Object>{
                  'key': appInfoProvider.appInfo.data!.razorKey!,
                  'amount':
                      (double.parse(Utils.getPriceTwoDecimal(amount!)) * 100)
                          .round(),
                  'name': userProvider.user.data!.userName!,
                  'currency': valueHolder.isRazorSupportMultiCurrency!
                      ? appInfoProvider.appInfo.data!.currencyShortForm!
                      : valueHolder.defaultRazorCurrency!,
                  'description': '',
                  'prefill': <String, String>{
                    'contact': userProvider.user.data!.userPhone!,
                    'email': userProvider.user.data!.userEmail!
                  }
                };

                if (await Utils.checkInternetConnectivity()) {
                  _razorpay.open(options);
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: Utils.getString(
                              context, 'error_dialog__no_internet'),
                        );
                      });
                }
              } else {
                Utils.psPrint(
                    'Item paid history provider is null , please check!!!');
              }
            }
          }),
    );

    return Consumer<AppInfoProvider>(builder:
        (BuildContext context, AppInfoProvider appInfoprovider, Widget? child) {
      return Consumer<UserProvider>(builder:
          (BuildContext context, UserProvider userProvider, Widget? child) {
        if (appInfoprovider.appInfo.data == null) {
          return Container();
        } else {
          final String oneDay = appInfoprovider.appInfo.data!.oneDay!;
          final String currencySymbol =
              appInfoprovider.appInfo.data!.currencySymbol!;

          final double amountByFirstChoice = double.parse(oneDay) *
              double.parse(valueHolder.promoteFirstChoiceDay!);
          final double amountBySecondChoice = double.parse(oneDay) *
              double.parse(valueHolder.promoteSecondChoiceDay!);
          final double amountByThirdChoice = double.parse(oneDay) *
              double.parse(valueHolder.promoteThirdChoiceDay!);
          final double amountByFourthChoice = double.parse(oneDay) *
              double.parse(valueHolder.promoteFourthChoiceDay!);

          if (getDefaultChoiceDate) {
            amount = amountByFirstChoice.toString();
            howManyDay = valueHolder.promoteFirstChoiceDay;
          }

          return Column(
            children: <Widget>[
              //First Choice or Default
              InkWell(
                onTap: () {
                  getFirstChoiceDate = true;
                  setState(() {
                    getFirstChoiceDate = true;
                    getDefaultChoiceDate = true;
                    getSecondChoiceDate = false;
                    getThirdChoiceDate = false;
                    getFourthChoiceDate = false;
                    getFifthChoiceDate = false;
                    getEnterDateCountController.clear();
                    amount = amountByFirstChoice.toString();
                    howManyDay =
                        valueHolder.promoteFirstChoiceDay;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: PsDimens.space72,
                  margin: const EdgeInsets.only(
                      left: PsDimens.space12, right: PsDimens.space12),
                  decoration: BoxDecoration(
                    color: Utils.isLightMode(context)
                        ? Colors.white60
                        : Colors.black54,
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    border: Border.all(
                        color: Utils.isLightMode(context)
                            ? Colors.grey[200]!
                            : Colors.black87),
                  ),
                  child: Row(
                    children: <Widget>[
                      if (getFirstChoiceDate || getDefaultChoiceDate)
                        Container(
                          width: PsDimens.space4,
                          height: double.infinity,
                          color: PsColors.mainColor,
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(PsDimens.space8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(Utils.getString(context,
                                          'item_promote__promote_for') +
                                      valueHolder.promoteFirstChoiceDay! +
                                      Utils.getString(context,
                                          'item_promote__promote_for_days')),
                                  Text(
                                      Utils.getString(context, currencySymbol) +
                                          Utils.getPriceFormat(
                                              amountByFirstChoice.toString(),valueHolder.priceFormat!)),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: PsDimens.space12),
                                child: Text(valueHolder.promoteFirstChoiceDay! +
                                    Utils.getString(
                                        context, 'item_promote__days')),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //Second Choice
              InkWell(
                onTap: () {
                  getSecondChoiceDate = true;
                  setState(() {
                    getSecondChoiceDate = true;
                    getFirstChoiceDate = false;
                    getThirdChoiceDate = false;
                    getFourthChoiceDate = false;
                    getFifthChoiceDate = false;
                    getDefaultChoiceDate = false;
                    getEnterDateCountController.clear();
                    amount = amountBySecondChoice.toString();
                    howManyDay =valueHolder.promoteSecondChoiceDay;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: PsDimens.space72,
                  margin: const EdgeInsets.only(
                      left: PsDimens.space12, right: PsDimens.space12),
                  decoration: BoxDecoration(
                    color: Utils.isLightMode(context)
                        ? Colors.white60
                        : Colors.black54,
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    border: Border.all(
                        color: Utils.isLightMode(context)
                            ? Colors.grey[200]!
                            : Colors.black87),
                  ),
                  child: Ink(
                    color: PsColors.backgroundColor,
                    child: Row(
                      children: <Widget>[
                        if (getSecondChoiceDate)
                          Container(
                            width: PsDimens.space4,
                            height: double.infinity,
                            color: PsColors.mainColor,
                          ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(PsDimens.space8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(Utils.getString(context,
                                            'item_promote__promote_for') +
                                        valueHolder.promoteSecondChoiceDay! +
                                        Utils.getString(context,
                                            'item_promote__promote_for_days')),
                                    Text(Utils.getString(
                                            context, currencySymbol) +
                                        Utils.getPriceFormat(
                                            amountBySecondChoice.toString(),valueHolder.priceFormat!)),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: PsDimens.space12),
                                  child: Text(
                                      valueHolder.promoteSecondChoiceDay! +
                                          Utils.getString(
                                              context, 'item_promote__days')),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //Third Choice
              InkWell(
                onTap: () {
                  getThirdChoiceDate = true;
                  setState(() {
                    getThirdChoiceDate = true;
                    getFirstChoiceDate = false;
                    getSecondChoiceDate = false;
                    getFourthChoiceDate = false;
                    getFifthChoiceDate = false;
                    getDefaultChoiceDate = false;
                    getEnterDateCountController.clear();
                    amount = amountByThirdChoice.toString();
                    howManyDay = valueHolder.promoteThirdChoiceDay;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: PsDimens.space72,
                  margin: const EdgeInsets.only(
                      left: PsDimens.space12, right: PsDimens.space12),
                  decoration: BoxDecoration(
                    color: Utils.isLightMode(context)
                        ? Colors.white60
                        : Colors.black54,
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    border: Border.all(
                        color: Utils.isLightMode(context)
                            ? Colors.grey[200]!
                            : Colors.black87),
                  ),
                  child: Row(
                    children: <Widget>[
                      if (getThirdChoiceDate)
                        Container(
                          width: PsDimens.space4,
                          height: double.infinity,
                          color: PsColors.mainColor,
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(PsDimens.space8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(Utils.getString(context,
                                          'item_promote__promote_for') +
                                      valueHolder.promoteThirdChoiceDay! +
                                      Utils.getString(context,
                                          'item_promote__promote_for_days')),
                                  Text(
                                      Utils.getString(context, currencySymbol) +
                                          Utils.getPriceFormat(
                                              amountByThirdChoice.toString(),valueHolder.priceFormat!)),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: PsDimens.space12),
                                child: Text(valueHolder.promoteThirdChoiceDay! +
                                    Utils.getString(
                                        context, 'item_promote__days')),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //Fourth Choice
              InkWell(
                onTap: () {
                  getFourthChoiceDate = true;
                  setState(() {
                    getFourthChoiceDate = true;
                    getFirstChoiceDate = false;
                    getSecondChoiceDate = false;
                    getThirdChoiceDate = false;
                    getFifthChoiceDate = false;
                    getDefaultChoiceDate = false;
                    getEnterDateCountController.clear();
                    amount = amountByFourthChoice.toString();
                    howManyDay = valueHolder.promoteFourthChoiceDay;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: PsDimens.space72,
                  margin: const EdgeInsets.only(
                      left: PsDimens.space12, right: PsDimens.space12),
                  decoration: BoxDecoration(
                    color: Utils.isLightMode(context)
                        ? Colors.white60
                        : Colors.black54,
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    border: Border.all(
                        color: Utils.isLightMode(context)
                            ? Colors.grey[200]!
                            : Colors.black87),
                  ),
                  child: Ink(
                    color: PsColors.backgroundColor,
                    child: Row(
                      children: <Widget>[
                        if (getFourthChoiceDate)
                          Container(
                            width: PsDimens.space4,
                            height: double.infinity,
                            color: PsColors.mainColor,
                          ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(PsDimens.space8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(Utils.getString(context,
                                            'item_promote__promote_for') +
                                        valueHolder.promoteFourthChoiceDay! +
                                        Utils.getString(context,
                                            'item_promote__promote_for_days')),
                                    Text(Utils.getString(
                                            context, currencySymbol) +
                                        Utils.getPriceFormat(
                                            amountByFourthChoice.toString(),valueHolder.priceFormat!)),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: PsDimens.space12),
                                  child: Text(
                                      valueHolder.promoteFourthChoiceDay! +
                                          Utils.getString(
                                              context, 'item_promote__days')),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //Fifth Choice
              InkWell(
                onTap: () {
                  getFifthChoiceDate = true;
                  setState(() {
                    getFifthChoiceDate = true;
                    getFirstChoiceDate = false;
                    getSecondChoiceDate = false;
                    getThirdChoiceDate = false;
                    getFourthChoiceDate = false;
                    getDefaultChoiceDate = false;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: PsDimens.space72,
                  margin: const EdgeInsets.only(
                      left: PsDimens.space12, right: PsDimens.space12),
                  decoration: BoxDecoration(
                    color: Utils.isLightMode(context)
                        ? Colors.white60
                        : Colors.black54,
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    border: Border.all(
                        color: Utils.isLightMode(context)
                            ? Colors.grey[200]!
                            : Colors.black87),
                  ),
                  child: Row(
                    children: <Widget>[
                      if (getFifthChoiceDate)
                        Container(
                          width: PsDimens.space4,
                          height: double.infinity,
                          color: PsColors.mainColor,
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(PsDimens.space8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(Utils.getString(
                                      context, 'item_promote__customs')),
                                  if (getEnterDateCountController.text != '' &&
                                      double.parse(getEnterDateCountController.text) >
                                          0.0)
                                    Text(Utils.getString(context, currencySymbol) +
                                        Utils.getPriceFormat((double.parse(
                                                    getEnterDateCountController
                                                        .text) *
                                                double.parse(appInfoprovider
                                                    .appInfo.data!.oneDay!))
                                            .toString(),valueHolder.priceFormat!))
                                  else
                                    Text(Utils.getString(context, currencySymbol) +
                                        getEnterDateCountController.text)
                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      right: PsDimens.space12),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          width: PsDimens.space60,
                                          height: PsDimens.space32,
                                          margin: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Utils.isLightMode(context)
                                                ? Colors.white60
                                                : Colors.black54,
                                            borderRadius: BorderRadius.circular(
                                                PsDimens.space4),
                                            border: Border.all(
                                                color:
                                                    Utils.isLightMode(context)
                                                        ? Colors.grey[200]!
                                                        : Colors.black87),
                                          ),
                                          child: TextField(
                                              onChanged: (String text) {
                                                print('dddd');
                                                if (double.parse(
                                                        getEnterDateCountController
                                                            .text) >
                                                    0.0) {
                                                  setState(() {});
                                                }
                                              },
                                              onTap: () {
                                                getFifthChoiceDate = true;
                                                setState(() {
                                                  getFifthChoiceDate = true;
                                                  getFirstChoiceDate = false;
                                                  getSecondChoiceDate = false;
                                                  getThirdChoiceDate = false;
                                                  getFourthChoiceDate = false;
                                                  getDefaultChoiceDate = false;
                                                });
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLines: null,
                                              controller:
                                                  getEnterDateCountController,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    left: PsDimens.space28,
                                                    bottom: PsDimens.space16),
                                                border: InputBorder.none,
                                              ))),
                                      Text(Utils.getString(
                                          context, 'item_promote__days')),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: PsDimens.space16),

              if (appInfoprovider.appInfo.data!.paypalEnable ==
                  PsConst.PAYPAL_ENABLE)
                paypalButtonWidget,

              if (appInfoprovider.appInfo.data!.stripeEnable ==
                  PsConst.STRIPE_ENABLE)
                stripeButtonWidget,

              if (appInfoprovider.appInfo.data!.razorEnable ==
                  PsConst.RAZOR_ENABLE)
                razorButtonWidget,

              if (appInfoprovider.appInfo.data!.offlineEnabled ==
                  PsConst.OFFLINE_PAYMENT_ENABLE)
                offlinePaymentButtonWidget,

              if (appInfoprovider.appInfo.data!.payStackEnabled == PsConst.ONE)
                payStackButtonWidget,

              const SizedBox(height: PsDimens.space32),
            ],
          );
        }
      });
    });
  }
}

dynamic callDemoWarningDialog(BuildContext context) async {
  await showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return const DemoWarningDialog();
      });
}
