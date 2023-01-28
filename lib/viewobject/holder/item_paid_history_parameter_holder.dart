import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class ItemPaidHistoryParameterHolder
    extends PsHolder<ItemPaidHistoryParameterHolder> {
  ItemPaidHistoryParameterHolder(
      {required this.itemId,
      required this.amount,
      required this.startDate,
      required this.howManyDay,
      required this.paymentMethod,
      required this.paymentMethodNounce,
      required this.startTimeStamp,
      required this.razorId,
      required this.purchasedId,
      required this.isPaystack});

  final String? itemId;
  final String? amount;
  final String? startDate;
  final String? howManyDay;
  final String? paymentMethod;
  final String? paymentMethodNounce;
  final String? startTimeStamp;
  final String? razorId;
  final String? purchasedId;
  final String? isPaystack;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['item_id'] = itemId;
    map['amount'] = amount;
    map['start_date'] = startDate;
    map['how_many_day'] = howManyDay;
    map['payment_method'] = paymentMethod;
    map['payment_method_nonce'] = paymentMethodNounce;
    map['start_timestamp'] = startTimeStamp;
    map['razor_id'] = razorId;
    map['purchased_id'] = purchasedId;
    map['is_paystack'] = isPaystack;

    return map;
  }

  @override
  ItemPaidHistoryParameterHolder fromMap(dynamic dynamicData) {
    return ItemPaidHistoryParameterHolder(
      itemId: dynamicData['item_id'],
      amount: dynamicData['amount'],
      startDate: dynamicData['start_date'],
      howManyDay: dynamicData['how_many_day'],
      paymentMethod: dynamicData['payment_method'],
      paymentMethodNounce: dynamicData['payment_method_nonce'],
      startTimeStamp: dynamicData['start_timestamp'],
      razorId: dynamicData['razor_id'],
      purchasedId: dynamicData['purchased_id'],
      isPaystack: dynamicData['is_paystack'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (itemId != '') {
      key += itemId!;
    }
    if (amount != '') {
      key += amount!;
    }
    if (startDate != '') {
      key += startDate!;
    }
    if (howManyDay != '') {
      key += howManyDay!;
    }
    if (paymentMethod != '') {
      key += paymentMethod!;
    }
    if (paymentMethodNounce != '') {
      key += paymentMethodNounce!;
    }
    if (startTimeStamp != '') {
      key += startTimeStamp!;
    }
    if (razorId != '') {
      key += razorId!;
    }
    if (purchasedId != '') {
      key += purchasedId!;
    }
    if (isPaystack != '') {
      key += isPaystack!;
    }
    return key;
  }
}
