import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:flutteradhouse/viewobject/offline_payment.dart';

class OfflinePaymentMethod extends PsObject<OfflinePaymentMethod> {
  OfflinePaymentMethod({
    this.id,
    this.offlinePayment,
    this.message,
  });
  List<OfflinePayment>? offlinePayment;
  String? message;

  String? id;

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  OfflinePaymentMethod fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return OfflinePaymentMethod(
          id: dynamicData['id'],
          offlinePayment:
              OfflinePayment().fromMapList(dynamicData['offline_payment']),
          message: dynamicData['message']);
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['offline_payment'] =
          OfflinePayment().toMapList(object.offlinePayment);
      data['message'] = object.message;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<OfflinePaymentMethod> fromMapList(List<dynamic> dynamicDataList) {
    final List<OfflinePaymentMethod> psAppInfoList = <OfflinePaymentMethod>[];

    //if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          psAppInfoList.add(fromMap(json));
        }
      }
  //  }
    return psAppInfoList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<dynamic> objectList) {
    final List<dynamic> dynamicList = <dynamic>[];
   // if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
   // }

    return dynamicList as List<Map<String, dynamic>?>;
  }
}
