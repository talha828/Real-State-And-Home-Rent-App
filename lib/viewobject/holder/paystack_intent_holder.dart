import 'package:flutteradhouse/provider/promotion/item_promotion_provider.dart';
import 'package:flutteradhouse/provider/user/user_provider.dart';
import 'package:flutteradhouse/viewobject/product.dart';

class PayStackInterntHolder {
  const PayStackInterntHolder(
      {required this.product,
      required this.amount,
      required this.howManyDay,
      required this.paymentMethod,
      required this.stripePublishableKey,
      required this.startDate,
      required this.startTimeStamp,
      required this.itemPaidHistoryProvider,
      required this.userProvider,
      required this.payStackKey});

  final Product product;
  final String amount;
  final String howManyDay;
  final String paymentMethod;
  final String? stripePublishableKey;
  final String startDate;
  final String startTimeStamp;
  final ItemPromotionProvider itemPaidHistoryProvider;
  final UserProvider userProvider;
  final String payStackKey;
}
