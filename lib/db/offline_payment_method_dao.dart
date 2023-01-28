import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/offline_payment_method.dart';
import 'package:sembast/sembast.dart';

class OfflinePaymentMethodDao extends PsDao<OfflinePaymentMethod> {
  OfflinePaymentMethodDao._() {
    init(OfflinePaymentMethod());
  }

  static const String STORE_NAME = 'OfflinePaymentMethod';
  final String _primaryKey = 'id';
  // Singleton instance
  static final OfflinePaymentMethodDao _singleton = OfflinePaymentMethodDao._();

  // Singleton accessor
  static OfflinePaymentMethodDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(OfflinePaymentMethod object) {
    return object.id;
  }

  @override
  Filter getFilter(OfflinePaymentMethod object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
