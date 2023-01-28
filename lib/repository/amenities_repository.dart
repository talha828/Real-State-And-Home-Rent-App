import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/amenities_dao.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/amenities.dart';

class AmenitiesRepository extends PsRepository {
  AmenitiesRepository(
      {required PsApiService psApiService,
      required AmenitiesDao amenitiesDao}) {
    _psApiService = psApiService;
    _amenitiesDao = amenitiesDao;
  }

 late PsApiService _psApiService;
 late AmenitiesDao _amenitiesDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(Amenities amenities) async {
    return _amenitiesDao.insert(_primaryKey, amenities);
  }

  Future<dynamic> update(Amenities amenities) async {
    return _amenitiesDao.update(amenities);
  }

  Future<dynamic> delete(Amenities amenities) async {
    return _amenitiesDao.delete(amenities);
  }

  Future<dynamic> getAllAmenitiesList(
      StreamController<PsResource<List<Amenities>>> amenitiesListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    amenitiesListStream.sink.add(await _amenitiesDao.getAll(status: status));

    final PsResource<List<Amenities>> _resource =
        await _psApiService.getAmenitiesList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      await _amenitiesDao.deleteAll();
      await _amenitiesDao.insertAll(_primaryKey, _resource.data!);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _amenitiesDao.deleteAll();
      }
    }
    amenitiesListStream.sink.add(await _amenitiesDao.getAll());
  }

  Future<dynamic> getNextPageAmenitiesList(
      StreamController<PsResource<List<Amenities>>> amenitiesListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    amenitiesListStream.sink.add(await _amenitiesDao.getAll(status: status));

    final PsResource<List<Amenities>> _resource =
        await _psApiService.getAmenitiesList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      _amenitiesDao
          .insertAll(_primaryKey, _resource.data!)
          .then((dynamic data) async {
        amenitiesListStream.sink.add(await _amenitiesDao.getAll());
      });
    } else {
      amenitiesListStream.sink.add(await _amenitiesDao.getAll());
    }
  }
}
