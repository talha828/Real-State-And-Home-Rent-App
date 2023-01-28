import 'package:flutteradhouse/db/common/ps_dao.dart' show PsDao;
import 'package:flutteradhouse/viewobject/package.dart';
import 'package:sembast/sembast.dart';

class PackageDao extends PsDao<Package> {
  PackageDao._() {
    init(Package());
  }
  static const String STORE_NAME = 'Package';
  final String _primaryKey = 'package_id';

  // Singleton instance
  static final PackageDao _singleton = PackageDao._();

  // Singleton accessor
  static PackageDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(Package object) {
    return object.packageId;
  }

  @override
  Filter getFilter(Package object) {
    return Filter.equals(_primaryKey, object.packageId);
  }
}
