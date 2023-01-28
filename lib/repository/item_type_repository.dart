import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/item_type_dao.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/item_type.dart';

class ItemTypeRepository extends PsRepository {
  ItemTypeRepository(
      {required PsApiService psApiService,
      required ItemTypeDao itemTypeDao}) {
    _psApiService = psApiService;
    _itemTypeDao = itemTypeDao;
  }

 late PsApiService _psApiService;
 late ItemTypeDao _itemTypeDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(ItemType itemType) async {
    return _itemTypeDao.insert(_primaryKey, itemType);
  }

  Future<dynamic> update(ItemType itemType) async {
    return _itemTypeDao.update(itemType);
  }

  Future<dynamic> delete(ItemType itemType) async {
    return _itemTypeDao.delete(itemType);
  }

  Future<dynamic> getItemTypeList(
      StreamController<PsResource<List<ItemType>>> itemTypeListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemTypeListStream.sink.add(await _itemTypeDao.getAll(status: status));

    final PsResource<List<ItemType>> _resource =
        await _psApiService.getItemTypeList(limit, offset);

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

  Future<dynamic> getNextPageItemTypeList(
      StreamController<PsResource<List<ItemType>>> itemTypeListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemTypeListStream.sink.add(await _itemTypeDao.getAll(status: status));

    final PsResource<List<ItemType>> _resource =
        await _psApiService.getItemTypeList(limit, offset);

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
