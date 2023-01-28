import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/favourite_product.dart';
import 'package:sembast/sembast.dart';

class FavouriteProductDao extends PsDao<FavouriteProduct> {
  FavouriteProductDao._() {
    init(FavouriteProduct());
  }
  static const String STORE_NAME = 'FavouriteProduct';
  final String _primaryKey = 'id';

  // Singleton instance
  static final FavouriteProductDao _singleton = FavouriteProductDao._();

  // Singleton accessor
  static FavouriteProductDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(FavouriteProduct object) {
    return object.id;
  }

  @override
  Filter getFilter(FavouriteProduct object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
