import 'package:flutteradhouse/db/common/ps_dao.dart' show PsDao;
import 'package:flutteradhouse/viewobject/property_type.dart';
import 'package:sembast/sembast.dart';

class PropertyTypeDao extends PsDao<PropertyType> {
  PropertyTypeDao() {
    init(PropertyType());
  }
  static const String STORE_NAME = 'PropertyType';
  final String _primaryKey = 'id';

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(PropertyType object) {
    return object.id;
  }

  @override
  Filter getFilter(PropertyType object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
