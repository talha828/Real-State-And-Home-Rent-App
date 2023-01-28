

import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:sembast/sembast.dart';

class SoldOutItemDao extends PsDao<Product> {
  SoldOutItemDao._() {
    init(Product());
  }

  static const String STORE_NAME = 'ReportedItem';
  final String _primaryKey = 'id';

  // Singleton instance
  static final SoldOutItemDao _singleton = SoldOutItemDao._();

  // Singleton accessor
  static SoldOutItemDao get instance => _singleton;

  @override
  String? getPrimaryKey(Product object) {
    return object.id;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(Product object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
