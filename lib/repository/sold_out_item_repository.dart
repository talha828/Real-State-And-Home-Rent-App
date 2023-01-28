

import 'dart:async';

import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/sold_out_item_dao.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:sembast/sembast.dart';

import 'Common/ps_repository.dart';

class SoldOutItemRepository extends PsRepository {
  SoldOutItemRepository(
      {required PsApiService psApiService,
      required SoldOutItemDao soldOutItemDao}) {
    _psApiService = psApiService;
    _soldOutItemDao = soldOutItemDao;
  }

  String primaryKey = 'id';
  late PsApiService _psApiService;
  late SoldOutItemDao _soldOutItemDao;

  Future<dynamic> insert(Product product) async {
    return _soldOutItemDao.insert(primaryKey, product);
  }

  Future<dynamic> update(Product product) async {
    return _soldOutItemDao.update(product);
  }

  Future<dynamic> delete(Product product) async {
    return _soldOutItemDao.delete(product);
  }

  Future<dynamic> getSoldOutItemList(
      StreamController<PsResource<List<Product>>> soldOutItemListStream,
      String? loginUserId,
      bool isConnectedToInternet,
      int limit,
      int? offset,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('added_user_id', loginUserId));
    soldOutItemListStream.sink
        .add(await _soldOutItemDao.getAll(status: status, finder: finder));

    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource =
          await _psApiService.getSoldOutItemList( limit, offset,loginUserId ?? '',);

      if (_resource.status == PsStatus.SUCCESS) {
        if (isNeedDelete) {
          await _soldOutItemDao.deleteWithFinder(finder);
        }
        await _soldOutItemDao.insertAll(primaryKey, _resource.data!);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          if (isNeedDelete) {
          await _soldOutItemDao.deleteWithFinder(finder);
        }
        }
      }
      soldOutItemListStream.sink
          .add(await _soldOutItemDao.getAll(finder: finder));
    }
  }

  Future<dynamic> getNextPageSoldOutItemList(
      StreamController<PsResource<List<Product>>> soldOutItemListStream,
      String? loginUserId,
      bool isConnectedToInternet,
      int limit,
      int? offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('added_user_id', loginUserId));
    soldOutItemListStream.sink
        .add(await _soldOutItemDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource =
          await _psApiService.getSoldOutItemList( limit, offset, loginUserId ?? '');

      if (_resource.status == PsStatus.SUCCESS) {
        await _soldOutItemDao.insertAll(primaryKey, _resource.data!);
      }
      soldOutItemListStream.sink
          .add(await _soldOutItemDao.getAll(finder: finder));
    }
  }
}
