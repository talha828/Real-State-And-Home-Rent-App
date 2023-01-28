import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/offer_map.dart';
import 'package:sembast/sembast.dart';

class OfferMapDao extends PsDao<OfferMap> {
  OfferMapDao._() {
    init(OfferMap());
  }
  static const String STORE_NAME = 'OfferMap';
  final String _primaryKey = 'id';

  // Singleton instance
  static final OfferMapDao _singleton = OfferMapDao._();

  // Singleton accessor
  static OfferMapDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String ?getPrimaryKey(OfferMap object) {
    return object.id;
  }

  @override
  Filter getFilter(OfferMap object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
