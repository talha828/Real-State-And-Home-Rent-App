import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/follower_item.dart';
import 'package:sembast/sembast.dart';

class FollowerItemDao extends PsDao<FollowerItem> {
  FollowerItemDao._() {
    init(FollowerItem());
  }
  static const String STORE_NAME = 'FollowerItem';
  final String _primaryKey = 'id';

  // Singleton instance
  static final FollowerItemDao _singleton = FollowerItemDao._();

  // Singleton accessor
  static FollowerItemDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(FollowerItem object) {
    return object.id;
  }

  @override
  Filter getFilter(FollowerItem object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
