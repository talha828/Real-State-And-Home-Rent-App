import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/offline_payment_method_dao.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/offline_payment_method.dart';

class OfflinePaymentMethodRepository extends PsRepository {
  OfflinePaymentMethodRepository(
      {required PsApiService psApiService,
      required OfflinePaymentMethodDao offlinePaymentMethodDao}) {
    _psApiService = psApiService;
    _offlinePaymentMethodDao = offlinePaymentMethodDao;
  }

 late PsApiService _psApiService;
 late OfflinePaymentMethodDao _offlinePaymentMethodDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(OfflinePaymentMethod noti) async {
    return _offlinePaymentMethodDao.insert(_primaryKey, noti);
  }

  Future<dynamic> update(OfflinePaymentMethod noti) async {
    return _offlinePaymentMethodDao.update(noti);
  }

  Future<dynamic> delete(OfflinePaymentMethod noti) async {
    return _offlinePaymentMethodDao.delete(noti);
  }

  Future<dynamic> getOfflinePaymentList(
      StreamController<PsResource<OfflinePaymentMethod>> notiListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    notiListStream.sink
        .add(await _offlinePaymentMethodDao.getOne(status: status));

    if (isConnectedToInternet) {
      final PsResource<OfflinePaymentMethod> _resource =
          await _psApiService.getOfflinePaymentList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _offlinePaymentMethodDao.deleteAll();
        _resource.data!.id = '1';
        await _offlinePaymentMethodDao.insert(_primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _offlinePaymentMethodDao.deleteAll();
        }
      }
      notiListStream.sink.add(await _offlinePaymentMethodDao.getOne());
    }
  }

  Future<dynamic> getNextPageOfflinePaymentList(
      StreamController<PsResource<OfflinePaymentMethod>> notiListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    notiListStream.sink
        .add(await _offlinePaymentMethodDao.getOne(status: status));

    if (isConnectedToInternet) {
      final PsResource<OfflinePaymentMethod> _resource =
          await _psApiService.getOfflinePaymentList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        _offlinePaymentMethodDao
            .insert(_primaryKey, _resource.data!)
            .then((dynamic data) async {
          notiListStream.sink.add(await _offlinePaymentMethodDao.getOne());
        });
      } else {
        notiListStream.sink.add(await _offlinePaymentMethodDao.getOne());
      }
    }
  }
}
