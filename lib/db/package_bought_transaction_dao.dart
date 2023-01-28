import 'package:flutteradhouse/db/common/ps_dao.dart' show PsDao;
import 'package:flutteradhouse/viewobject/buyadpost_transaction.dart';
import 'package:sembast/sembast.dart';

class PackageTransactionDao extends PsDao<PackageTransaction> {
  PackageTransactionDao._() {
    init(PackageTransaction());
  }
  static const String STORE_NAME = 'PackageTransaction';
  final String _primaryKey = 'package_id';

  // Singleton instance
  static final PackageTransactionDao _singleton = PackageTransactionDao._();

  // Singleton accessor
  static PackageTransactionDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(PackageTransaction object) {
    return object.packageId;
  }

  @override
  Filter getFilter(PackageTransaction object) {
    return Filter.equals(_primaryKey, object.packageId);
  }
}
