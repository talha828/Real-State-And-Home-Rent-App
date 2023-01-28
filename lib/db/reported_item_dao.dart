import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/reported_item.dart';
import 'package:sembast/sembast.dart';

class ReportedItemDao extends PsDao<ReportedItem> {
  ReportedItemDao._() {
    init(ReportedItem());
  }

  static const String STORE_NAME = 'ReportedItem';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ReportedItemDao _singleton = ReportedItemDao._();

  // Singleton accessor
  static ReportedItemDao get instance => _singleton;

  @override
  String? getPrimaryKey(ReportedItem object) {
    return object.id;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(ReportedItem object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
