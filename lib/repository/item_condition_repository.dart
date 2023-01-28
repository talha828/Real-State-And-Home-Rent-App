import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/item_condition_dao.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/condition_of_item.dart';

class ItemConditionRepository extends PsRepository {
  ItemConditionRepository(
      {required PsApiService psApiService,
      required ItemConditionDao itemConditionDao}) {
    _psApiService = psApiService;
    _itemConditionDao = itemConditionDao;
  }

 late PsApiService _psApiService;
 late ItemConditionDao _itemConditionDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(ConditionOfItem conditionOfItem) async {
    return _itemConditionDao.insert(_primaryKey, conditionOfItem);
  }

  Future<dynamic> update(ConditionOfItem conditionOfItem) async {
    return _itemConditionDao.update(conditionOfItem);
  }

  Future<dynamic> delete(ConditionOfItem conditionOfItem) async {
    return _itemConditionDao.delete(conditionOfItem);
  }

  Future<dynamic> getItemConditionList(
      StreamController<PsResource<List<ConditionOfItem>>>
          itemConditionListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemConditionListStream.sink
        .add(await _itemConditionDao.getAll(status: status));

    final PsResource<List<ConditionOfItem>> _resource =
        await _psApiService.getItemConditionList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      await _itemConditionDao.deleteAll();
      await _itemConditionDao.insertAll(_primaryKey, _resource.data!);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _itemConditionDao.deleteAll();
      }
    }
    itemConditionListStream.sink.add(await _itemConditionDao.getAll());
  }

  Future<dynamic> getNextPageItemConditionList(
      StreamController<PsResource<List<ConditionOfItem>>>
          itemConditionListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemConditionListStream.sink
        .add(await _itemConditionDao.getAll(status: status));

    final PsResource<List<ConditionOfItem>> _resource =
        await _psApiService.getItemConditionList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      _itemConditionDao
          .insertAll(_primaryKey, _resource.data!)
          .then((dynamic data) async {
        itemConditionListStream.sink.add(await _itemConditionDao.getAll());
      });
    } else {
      itemConditionListStream.sink.add(await _itemConditionDao.getAll());
    }
  }
}
