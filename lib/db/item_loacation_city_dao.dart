import 'package:flutteradhouse/db/common/ps_dao.dart' show PsDao;
import 'package:flutteradhouse/viewobject/item_location_city.dart';
import 'package:sembast/sembast.dart';

class ItemLocationCityDao extends PsDao<ItemLocationCity> {
  ItemLocationCityDao._() {
    init(ItemLocationCity());
  }
  static const String STORE_NAME = 'ItemLocationCity';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ItemLocationCityDao _singleton = ItemLocationCityDao._();

  // Singleton accessor
  static ItemLocationCityDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(ItemLocationCity object) {
    return object.id;
  }

  @override
  Filter getFilter(ItemLocationCity object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
