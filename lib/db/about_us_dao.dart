import 'package:flutteradhouse/db/common/ps_dao.dart' show PsDao;
import 'package:flutteradhouse/viewobject/about_us.dart';
import 'package:sembast/sembast.dart';

class AboutUsDao extends PsDao<AboutUs> {
  AboutUsDao._() {
    init(AboutUs());
  }
  static const String STORE_NAME = 'AboutUs';
  final String _primaryKey = 'about_id';

  // Singleton instance
  static final AboutUsDao _singleton = AboutUsDao._();

  // Singleton accessor
  static AboutUsDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(AboutUs object) {
    return object.aboutId;
  }

  @override
  Filter getFilter(AboutUs object) {
    return Filter.equals(_primaryKey, object.aboutId);
  }
}
