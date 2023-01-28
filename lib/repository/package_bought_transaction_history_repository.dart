import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/package_bought_transaction_dao.dart';
import 'package:flutteradhouse/viewobject/buyadpost_transaction.dart';
import 'package:flutteradhouse/viewobject/holder/package_transaction_holder.dart';

import 'Common/ps_repository.dart';

class PackageTranscationHistoryRepository extends PsRepository {
  PackageTranscationHistoryRepository(
      {required PsApiService psApiService, required PackageTransactionDao transactionDao}) {
    _psApiService = psApiService;
    _transactionDao = transactionDao;
  }

  String primaryKey = 'package_id';
  String mapKey = 'map_key';
  late PsApiService _psApiService;
  late PackageTransactionDao _transactionDao;

  void sinkCategoryListStream(
      StreamController<PsResource<List<PackageTransaction>>>? transactionListStream,
      PsResource<List<PackageTransaction>> dataList) {
    if (transactionListStream != null) {
      transactionListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(PackageTransaction transaction) async {
    return _transactionDao.insert(primaryKey, transaction);
  }

  Future<dynamic> update(PackageTransaction transaction) async {
    return _transactionDao.update(transaction);
  }

  Future<dynamic> delete(PackageTransaction transaction) async {
    return _transactionDao.delete(transaction);
  }

  Future<dynamic> getPackageTransactionDetailList(
      StreamController<PsResource<List<PackageTransaction>>>? transactionListStream,
      bool isConnectedToInternet,
      PackgageBoughtTransactionParameterHolder holder,
      int limit,
      int? offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkCategoryListStream(
        transactionListStream, await _transactionDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<PackageTransaction>> _resource = await _psApiService
          .getPackageTransactionDetailList(holder.toMap(),);

      if (_resource.status == PsStatus.SUCCESS) {
        // Delete and Insert Map Dao
        await _transactionDao.deleteAll();

        // Insert Category
        await _transactionDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          print('delete all');
          await _transactionDao.deleteAll();
        }
      }
      // Load updated Data from Db and Send to UI
      sinkCategoryListStream(transactionListStream, await _transactionDao.getAll());
    }
  }

  Future<dynamic> getNextPagePackageTransactionDetailList(
      StreamController<PsResource<List<PackageTransaction>>>? transactionListStream,
      bool isConnectedToInternet,
      PackgageBoughtTransactionParameterHolder holder,
      int limit,
      int? offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkCategoryListStream(
        transactionListStream, await _transactionDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<PackageTransaction>> _resource = await _psApiService
          .getPackageTransactionDetailList(holder.toMap(), );

      if (_resource.status == PsStatus.SUCCESS) {
        await _transactionDao.getAll();

        await _transactionDao.insertAll(primaryKey, _resource.data!);
      }
      sinkCategoryListStream(transactionListStream, await _transactionDao.getAll());
    }
  }


}
