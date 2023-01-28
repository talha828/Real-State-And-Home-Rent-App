import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/post_type.dart';
import 'package:sembast/sembast.dart';

class PostTypeDao extends PsDao<PostType> {
  PostTypeDao() {
    init(PostType());
  }

  static const String STORE_NAME = 'PostType';
  final String _primaryKey = 'id';

  @override
  String? getPrimaryKey(PostType object) {
    return object.id;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(PostType object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
