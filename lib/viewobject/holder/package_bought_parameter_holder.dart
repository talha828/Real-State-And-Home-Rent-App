import 'package:flutteradhouse/viewobject/common/ps_holder.dart'
    show PsHolder;

class PackgageBoughtParameterHolder
    extends PsHolder<PackgageBoughtParameterHolder> {
  PackgageBoughtParameterHolder({
     this.userId,
     this.packageId,
     this.paymentMethod,
     this.price,
     this.razorId,
     this.isPaystack,
  });

  final String? userId;
  final String? packageId;
  final String? paymentMethod;
  final String? price;
  final String? razorId;
  final String? isPaystack;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    map['package_id'] = packageId;
    map['payment_method'] = paymentMethod;
    map['price'] = price;
    map['razor_id'] = razorId;
    map['isPaystack'] = isPaystack;

    return map;
  }

  @override
  PackgageBoughtParameterHolder fromMap(dynamic dynamicData) {
    return PackgageBoughtParameterHolder(
      userId: dynamicData['user_id'],
      packageId: dynamicData['package_id'],
      paymentMethod: dynamicData['payment_method'],
      price: dynamicData['price'],
      razorId: dynamicData['razor_id'],
      isPaystack: dynamicData['isPaystack'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId!;
    }
    if (packageId != '') {
      key += packageId!;
    }
    if (paymentMethod != '') {
      key += paymentMethod!;
    }
    if (price != '') {
      key += price!;
    }
    if (razorId != '') {
      key += razorId!;
    }
    if (isPaystack != '') {
      key += isPaystack!;
    }
    
    return key;
  }
}
