import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/offer.dart';
import 'package:sembast/sembast.dart';

class OfferDao extends PsDao<Offer> {
  OfferDao._() {
    init(Offer());
  }

  static const String STORE_NAME = 'Offer';
  final String _primaryKey = 'id';
  // Singleton instance
  static final OfferDao _singleton = OfferDao._();

  // Singleton accessor
  static OfferDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(Offer object) {
    return object.id;
  }

  @override
  Filter getFilter(Offer object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
