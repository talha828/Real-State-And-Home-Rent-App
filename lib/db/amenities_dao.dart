import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/amenities.dart';
import 'package:sembast/sembast.dart';

class AmenitiesDao extends PsDao<Amenities> {
  AmenitiesDao._() {
    init(Amenities());
  }

  static const String STORE_NAME = 'Amenities';
  final String _primaryKey = 'id';

  // Singleton instance
  static final AmenitiesDao _singleton = AmenitiesDao._();

  // Singleton accessor
  static AmenitiesDao get instance => _singleton;

  @override
  String? getPrimaryKey(Amenities object) {
    return object.id;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(Amenities object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
