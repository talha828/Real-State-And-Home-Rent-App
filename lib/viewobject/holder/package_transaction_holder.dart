import 'package:flutteradhouse/viewobject/common/ps_holder.dart'
    show PsHolder;

class PackgageBoughtTransactionParameterHolder
    extends PsHolder<PackgageBoughtTransactionParameterHolder> {
  PackgageBoughtTransactionParameterHolder({
     this.userId,

  });

  final String? userId;


  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;


    return map;
  }

  @override
  PackgageBoughtTransactionParameterHolder fromMap(dynamic dynamicData) {
    return PackgageBoughtTransactionParameterHolder(
      userId: dynamicData['user_id'],

    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId!;
    }

    
    return key;
  }
}
