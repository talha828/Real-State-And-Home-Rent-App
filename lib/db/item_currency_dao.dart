import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/item_currency.dart';
import 'package:sembast/sembast.dart';

class ItemCurrencyDao extends PsDao<ItemCurrency> {
  ItemCurrencyDao() {
    init(ItemCurrency());
  }

  static const String STORE_NAME = 'ItemCurrency';
  final String _primaryKey = 'id';

  @override
  String? getPrimaryKey(ItemCurrency object) {
    return object.id;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(ItemCurrency object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
