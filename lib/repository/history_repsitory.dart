import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/db/history_dao.dart';
import 'package:flutteradhouse/viewobject/product.dart';

import 'Common/ps_repository.dart';

class HistoryRepository extends PsRepository {
  HistoryRepository({required HistoryDao historyDao}) {
    _historyDao = historyDao;
  }

  String primaryKey = 'id';
late  HistoryDao _historyDao;

  Future<dynamic> insert(Product history) async {
    return _historyDao.insert(primaryKey, history);
  }

  Future<dynamic> update(Product history) async {
    return _historyDao.update(history);
  }

  Future<dynamic> delete(Product history) async {
    return _historyDao.delete(history);
  }

  Future<dynamic> getAllHistoryList(
      StreamController<PsResource<List<Product>>> historyListStream,
      PsStatus status) async {
    historyListStream.sink.add(await _historyDao.getAll(status: status));
  }

  Future<dynamic> addAllHistoryList(
      StreamController<PsResource<List<Product>>> historyListStream,
      PsStatus status,
      Product product) async {
    await _historyDao.insert(primaryKey, product);
    // historyListStream.sink.add(await _historyDao.getAll(status: status));
  }
}
