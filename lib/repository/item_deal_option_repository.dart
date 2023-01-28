import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/deal_option_dao.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/deal_option.dart';

class ItemDealOptionRepository extends PsRepository {
  ItemDealOptionRepository(
      {required PsApiService psApiService,
      required ItemDealOptionDao itemDealOptionDao}) {
    _psApiService = psApiService;
    _itemDealOptionDao = itemDealOptionDao;
  }

 late PsApiService _psApiService;
 late ItemDealOptionDao _itemDealOptionDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(DealOption dealOption) async {
    return _itemDealOptionDao.insert(_primaryKey, dealOption);
  }

  Future<dynamic> update(DealOption dealOption) async {
    return _itemDealOptionDao.update(dealOption);
  }

  Future<dynamic> delete(DealOption dealOption) async {
    return _itemDealOptionDao.delete(dealOption);
  }

  Future<dynamic> getItemDealOptionList(
      StreamController<PsResource<List<DealOption>>> itemDealOptionListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemDealOptionListStream.sink
        .add(await _itemDealOptionDao.getAll(status: status));

    final PsResource<List<DealOption>> _resource =
        await _psApiService.getItemDealOptionList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      await _itemDealOptionDao.deleteAll();
      await _itemDealOptionDao.insertAll(_primaryKey, _resource.data!);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _itemDealOptionDao.deleteAll();
      }
    }
    itemDealOptionListStream.sink.add(await _itemDealOptionDao.getAll());
  }

  Future<dynamic> getNextPageItemDealOptionList(
      StreamController<PsResource<List<DealOption>>> itemDealOptionListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemDealOptionListStream.sink
        .add(await _itemDealOptionDao.getAll(status: status));

    final PsResource<List<DealOption>> _resource =
        await _psApiService.getItemDealOptionList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      _itemDealOptionDao
          .insertAll(_primaryKey, _resource.data!)
          .then((dynamic data) async {
        itemDealOptionListStream.sink.add(await _itemDealOptionDao.getAll());
      });
    } else {
      itemDealOptionListStream.sink.add(await _itemDealOptionDao.getAll());
    }
  }
}
