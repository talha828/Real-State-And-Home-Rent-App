import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/paid_ad_item.dart';
import 'package:sembast/sembast.dart';

class PaidAdItemDao extends PsDao<PaidAdItem> {
  PaidAdItemDao._() {
    init(PaidAdItem());
  }
  static const String STORE_NAME = 'PaidAdItem';
  final String _primaryKey = 'id';

  // Singleton instance
  static final PaidAdItemDao _singleton = PaidAdItemDao._();

  // Singleton accessor
  static PaidAdItemDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(PaidAdItem object) {
    return object.id;
  }

  @override
  Filter getFilter(PaidAdItem object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
