import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/constant/ps_dimens.dart';
import 'package:flutteradhouse/provider/promotion/item_promotion_provider.dart';
import 'package:flutteradhouse/provider/user/user_provider.dart';
import 'package:flutteradhouse/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:flutteradhouse/ui/common/dialog/error_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/success_dialog.dart';
import 'package:flutteradhouse/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutteradhouse/ui/common/ps_button_widget.dart';
import 'package:flutteradhouse/ui/common/ps_credit_card_form_for_pay_stack.dart';
import 'package:flutteradhouse/utils/ps_progress_dialog.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/holder/item_paid_history_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/item_paid_history.dart';
import 'package:flutteradhouse/viewobject/product.dart';
// import 'package:theme_manager/theme_manager.dart';

class PayStackView extends StatefulWidget {
  const PayStackView(
      {Key? key,
      required this.product,
      required this.amount,
      required this.howManyDay,
      required this.paymentMethod,
      required this.stripePublishableKey,
      required this.startDate,
      required this.startTimeStamp,
      required this.itemPaidHistoryProvider,
      required this.userProvider,
      required this.payStackKey})
      : super(key: key);

  final Product product;
  final String amount;
  final String howManyDay;
  final String paymentMethod;
  final String stripePublishableKey;
  final String startDate;
  final String startTimeStamp;
  final ItemPromotionProvider itemPaidHistoryProvider;
  final UserProvider userProvider;
  final String payStackKey;

  @override
  State<StatefulWidget> createState() {
    return PayStackViewState();
  }
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
            isPaystack: PsConst.ONE);

    final PsResource<ItemPaidHistory> padiHistoryDataStatus =
        await itemPaidHistoryProvider
            .postItemHistoryEntry(itemPaidHistoryParameterHolder.toMap());

    if (padiHistoryDataStatus.data != null) {
      // progressDialog.dismiss();
      PsProgressDialog.dismissDialog();
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
      PsProgressDialog.dismissDialog();
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

// PaymentCard callCard(String cardNumber, String expiryDate,
//     String cardHolderName, String cvvCode) {
//   final List<String> monthAndYear = expiryDate.split('/');
//   return PaymentCard(
//       number: cardNumber,
//       expiryMonth: int.parse(monthAndYear[0]),
//       expiryYear: int.parse(monthAndYear[1]),
//       name: cardHolderName,
//       cvc: cvvCode);
// }

class PayStackViewState extends State<PayStackView> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

//  final PaystackPlugin plugin = PaystackPlugin();

  @override
  void initState() {
    // plugin.initialize(
    //     publicKey:
    //         'pk_test_ea5593678cc80271640f1929b5a63ac830dd66f8'); //widget.payStackKey);
    super.initState();
  }

  void setError(dynamic error) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            message: Utils.getString(context, error.toString()),
          );
        });
  }

  dynamic callWarningDialog(BuildContext context, String text) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            message: Utils.getString(context, text),
            onPressed: () {},
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // dynamic payStackNow(String token) async {
    //   await PsProgressDialog.showDialog(context);
    //   callPaidAdSubmitApi(
    //     context,
    //     widget.product,
    //     widget.amount,
    //     widget.howManyDay,
    //     widget.paymentMethod,
    //     widget.stripePublishableKey,
    //     widget.startDate,
    //     widget.startTimeStamp,
    //     widget.itemPaidHistoryProvider,
    //     token,
    //   );
    // }

    return PsWidgetWithAppBarWithNoProvider(
      appBarTitle: Utils.getString(context, 'item_promote__pay_stack'),
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  height: 175,
                  width: MediaQuery.of(context).size.width,
                  animationDuration: PsConfig.animation_duration,
                  onCreditCardWidgetChange: (dynamic data) {},
                ),
                PsCreditCardFormForPayStack(
                  onCreditCardModelChange: onCreditCardModelChange,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: PsDimens.space12, right: PsDimens.space12),
                  child: PSButtonWidget(
                    hasShadow: true,
                    width: double.infinity,
                    titleText: Utils.getString(context, 'credit_card__pay'),
                    onPressed: () async {
                      if (cardNumber.isEmpty) {
                        callWarningDialog(
                            context,
                            Utils.getString(
                                context, 'warning_dialog__input_number'));
                      } else if (expiryDate.isEmpty) {
                        callWarningDialog(
                            context,
                            Utils.getString(
                                context, 'warning_dialog__input_date'));
                      } else if (cardHolderName.isEmpty) {
                        callWarningDialog(
                            context,
                            Utils.getString(
                                context, 'warning_dialog__input_holder_name'));
                      } else if (cvvCode.isEmpty) {
                        callWarningDialog(
                            context,
                            Utils.getString(
                                context, 'warning_dialog__input_cvv'));
                      } else {
                        // bool isLight = Utils.isLightMode(context);

                        // if (!isLight) {
                        //   await ThemeManager.of(context).setBrightnessPreference(
                        //           BrightnessPreference.light);
                        // }

                        // final Charge charge = Charge()
                        //   ..amount = (double.parse(
                        //               Utils.getPriceTwoDecimal(widget.amount)) *
                        //           100)
                        //       .round()
                        //   ..email = widget.userProvider.user.data!.userEmail
                        //   ..reference = _getReference()
                        //   ..card = callCard(
                        //       cardNumber, expiryDate, cardHolderName, cvvCode);
                        // try {
                        //   final CheckoutResponse response =
                        //       await plugin.checkout(
                        //     context,
                        //     method: CheckoutMethod.card,
                        //     charge: charge,
                        //     fullscreen: false,
                        //     // logo: MyLogo(),
                        //   );
                        //   if (!isLight) {
                        //     await ThemeManager.of(context).setBrightnessPreference(
                        //           BrightnessPreference.dark);
                        //     isLight = true;
                        //   }
                        //   if (response.status) {
                        //     payStackNow(response.reference!);
                        //   }
                        // } catch (e) {
                        //   print('Check console for error');
                        //   rethrow;
                        // }
                        // if (!isLight) {
                        //   await ThemeManager.of(context).setBrightnessPreference(
                        //           BrightnessPreference.dark);
                        // }
                      }
                    },
                  ),
                ),
                const SizedBox(height: PsDimens.space40)
              ],
            )),
          ),
        ],
      ),
    );
  }

  // String _getReference() {
  //   String platform;
  //   if (Platform.isIOS) {
  //     platform = 'iOS';
  //   } else {
  //     platform = 'Android';
  //   }

  //   return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  // }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
