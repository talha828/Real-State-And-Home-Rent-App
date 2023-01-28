import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/item_type.dart';
import 'package:sembast/sembast.dart';

class ItemTypeDao extends PsDao<ItemType> {
  ItemTypeDao() {
    init(ItemType());
  }

  static const String STORE_NAME = 'ItemType';
  final String _primaryKey = 'id';

  @override
  String? getPrimaryKey(ItemType object) {
    return object.id;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(ItemType object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
