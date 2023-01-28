import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/user_map.dart';
import 'package:sembast/sembast.dart';

class UserMapDao extends PsDao<UserMap> {
  UserMapDao._() {
    init(UserMap());
  }
  static const String STORE_NAME = 'UserMap';
  final String _primaryKey = 'id';

  // Singleton instance
  static final UserMapDao _singleton = UserMapDao._();

  // Singleton accessor
  static UserMapDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(UserMap object) {
    return object.id;
  }

  @override
  Filter getFilter(UserMap object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
