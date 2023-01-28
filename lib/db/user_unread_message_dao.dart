import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/user_unread_message.dart';
import 'package:sembast/sembast.dart';

class UserUnreadMessageDao extends PsDao<UserUnreadMessage> {
  UserUnreadMessageDao._() {
    init(UserUnreadMessage());
  }

  static const String STORE_NAME = 'UserUnreadMessage';
  final String _primaryKey = 'id';
  // Singleton instance
  static final UserUnreadMessageDao _singleton = UserUnreadMessageDao._();

  // Singleton accessor
  static UserUnreadMessageDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(UserUnreadMessage object) {
    return object.id;
  }

  @override
  Filter getFilter(UserUnreadMessage object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
