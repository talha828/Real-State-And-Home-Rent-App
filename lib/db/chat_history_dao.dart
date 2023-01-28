import 'package:flutteradhouse/db/common/ps_dao.dart';
import 'package:flutteradhouse/viewobject/chat_history.dart';
import 'package:sembast/sembast.dart';

class ChatHistoryDao extends PsDao<ChatHistory> {
  ChatHistoryDao._() {
    init(ChatHistory());
  }

  static const String STORE_NAME = 'ChatHistory';
  final String _primaryKey = 'id';
  // Singleton instance
  static final ChatHistoryDao _singleton = ChatHistoryDao._();

  // Singleton accessor
  static ChatHistoryDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(ChatHistory object) {
    return object.id;
  }

  @override
  Filter getFilter(ChatHistory object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
