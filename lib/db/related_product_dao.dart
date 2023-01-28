import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/related_product.dart';
import 'package:sembast/sembast.dart';

class RelatedProductDao extends PsDao<RelatedProduct> {
  RelatedProductDao._() {
    init(RelatedProduct());
  }

  static const String STORE_NAME = 'RelatedProduct';
  final String _primaryKey = 'id';
  // Singleton instance
  static final RelatedProductDao _singleton = RelatedProductDao._();

  // Singleton accessor
  static RelatedProductDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(RelatedProduct object) {
    return object.id;
  }

  @override
  Filter getFilter(RelatedProduct object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
