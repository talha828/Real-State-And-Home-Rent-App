import 'package:flutteradhouse/db/common/ps_dao.dart' show PsDao;
import 'package:flutteradhouse/viewobject/item_location_township.dart';
import 'package:sembast/sembast.dart';

class ItemLocationTownshipDao extends PsDao<ItemLocationTownship> {
  ItemLocationTownshipDao._() {
    init(ItemLocationTownship());
  }
  static const String STORE_NAME = 'ItemLocationTownship';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ItemLocationTownshipDao _singleton = ItemLocationTownshipDao._();

  // Singleton accessor
  static ItemLocationTownshipDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(ItemLocationTownship object) {
    return object.id;
  }

  @override
  Filter getFilter(ItemLocationTownship object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
