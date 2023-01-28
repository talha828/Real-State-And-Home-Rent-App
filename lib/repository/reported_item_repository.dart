import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/reported_item_dao.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/reported_item.dart';

class ReportedItemRepository extends PsRepository {
  ReportedItemRepository(
      {required PsApiService psApiService,
      required ReportedItemDao reportedItemDao}) {
    _psApiService = psApiService;
    _itemTypeDao = reportedItemDao;
  }

 late PsApiService _psApiService;
 late ReportedItemDao _itemTypeDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(ReportedItem itemType) async {
    return _itemTypeDao.insert(_primaryKey, itemType);
  }

  Future<dynamic> update(ReportedItem itemType) async {
    return _itemTypeDao.update(itemType);
  }

  Future<dynamic> delete(ReportedItem itemType) async {
    return _itemTypeDao.delete(itemType);
  }

  Future<dynamic> getReportedItemList(
      StreamController<PsResource<List<ReportedItem>>> itemTypeListStream,
      bool isConnectedToIntenet,
      String loginUserId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemTypeListStream.sink.add(await _itemTypeDao.getAll(status: status));

    final PsResource<List<ReportedItem>> _resource =
        await _psApiService.getReportedItemList(loginUserId, limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      await _itemTypeDao.deleteAll();
      await _itemTypeDao.insertAll(_primaryKey, _resource.data!);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _itemTypeDao.deleteAll();
      }
    }
    itemTypeListStream.sink.add(await _itemTypeDao.getAll());
  }

  Future<dynamic> getNextPageReportedItemList(
      StreamController<PsResource<List<ReportedItem>>> itemTypeListStream,
      bool isConnectedToIntenet,
      String loginUserId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemTypeListStream.sink.add(await _itemTypeDao.getAll(status: status));

    final PsResource<List<ReportedItem>> _resource =
        await _psApiService.getReportedItemList(loginUserId, limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      _itemTypeDao
          .insertAll(_primaryKey, _resource.data!)
          .then((dynamic data) async {
        itemTypeListStream.sink.add(await _itemTypeDao.getAll());
      });
    } else {
      itemTypeListStream.sink.add(await _itemTypeDao.getAll());
    }
  }
}
