import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/item_currency_dao.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/item_currency.dart';

class ItemCurrencyRepository extends PsRepository {
  ItemCurrencyRepository(
      {required PsApiService psApiService,
      required ItemCurrencyDao itemCurrencyDao}) {
    _psApiService = psApiService;
    _itemConditionDao = itemCurrencyDao;
  }

 late PsApiService _psApiService;
 late ItemCurrencyDao _itemConditionDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(ItemCurrency itemCurrency) async {
    return _itemConditionDao.insert(_primaryKey, itemCurrency);
  }

  Future<dynamic> update(ItemCurrency itemCurrency) async {
    return _itemConditionDao.update(itemCurrency);
  }

  Future<dynamic> delete(ItemCurrency itemCurrency) async {
    return _itemConditionDao.delete(itemCurrency);
  }

  Future<dynamic> getItemCurrencyList(
      StreamController<PsResource<List<ItemCurrency>>> itemConditionListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemConditionListStream.sink
        .add(await _itemConditionDao.getAll(status: status));

    final PsResource<List<ItemCurrency>> _resource =
        await _psApiService.getItemCurrencyList(limit, offset);

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

  Future<dynamic> getNextPageItemCurrencyList(
      StreamController<PsResource<List<ItemCurrency>>> itemConditionListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemConditionListStream.sink
        .add(await _itemConditionDao.getAll(status: status));

    final PsResource<List<ItemCurrency>> _resource =
        await _psApiService.getItemCurrencyList(limit, offset);

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
