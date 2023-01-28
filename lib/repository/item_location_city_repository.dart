import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/item_loacation_city_dao.dart';
import 'package:flutteradhouse/viewobject/item_location_city.dart';

import 'Common/ps_repository.dart';

class ItemLocationCityRepository extends PsRepository {
  ItemLocationCityRepository(
      {required PsApiService psApiService,
      required ItemLocationCityDao itemLocationCityDao}) {
    _psApiService = psApiService;
    _itemLocationCityDao = itemLocationCityDao;
  }

  String primaryKey = 'id';
 late PsApiService _psApiService;
 late ItemLocationCityDao _itemLocationCityDao;

  Future<dynamic> insert(ItemLocationCity itemLocationCity) async {
    return _itemLocationCityDao.insert(primaryKey, itemLocationCity);
  }

  Future<dynamic> update(ItemLocationCity itemLocationCity) async {
    return _itemLocationCityDao.update(itemLocationCity);
  }

  Future<dynamic> delete(ItemLocationCity itemLocationCity) async {
    return _itemLocationCityDao.delete(itemLocationCity);
  }

  Future<dynamic> getAllItemLocationList(
      StreamController<PsResource<List<ItemLocationCity>>>
          itemLocationListStream,
      bool isConnectedToInternet,
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemLocationListStream.sink
        .add(await _itemLocationCityDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemLocationCity>> _resource = await _psApiService
          .getItemLocationList(jsonMap, loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _itemLocationCityDao.deleteAll();
        await _itemLocationCityDao.insertAll(primaryKey, _resource.data!);
        itemLocationListStream.sink.add(await _itemLocationCityDao.getAll());
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _itemLocationCityDao.deleteAll();
        }
      }
      itemLocationListStream.sink.add(await _itemLocationCityDao.getAll(
          status: _resource.status, message: _resource.message));
    }
  }

  Future<dynamic> getNextPageItemLocationList(
      StreamController<PsResource<List<ItemLocationCity>>>
          itemLocationListStream,
      bool isConnectedToInternet,
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemLocationListStream.sink
        .add(await _itemLocationCityDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemLocationCity>> _resource = await _psApiService
          .getItemLocationList(jsonMap, loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _itemLocationCityDao.insertAll(primaryKey, _resource.data!);
      }
      itemLocationListStream.sink.add(await _itemLocationCityDao.getAll());
    }
  }
}
