import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/property_type_dao.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/property_type.dart';

import 'Common/ps_repository.dart';

class PropertyTypeRepository extends PsRepository {
  PropertyTypeRepository(
      {required PsApiService psApiService,
      required PropertyTypeDao propertyTypeDao}) {
    _psApiService = psApiService;
    _propertyTypeDao = propertyTypeDao;
  }

  String primaryKey = 'id';
  String mapKey = 'map_key';
 late PsApiService _psApiService;
 late PropertyTypeDao _propertyTypeDao;

  void sinkpropertyTypeListStream(
      StreamController<PsResource<List<PropertyType>>>? propertyTypeListStream,
      PsResource<List<PropertyType>>? dataList) {
    if (dataList != null && propertyTypeListStream != null) {
      propertyTypeListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(PropertyType propertyType) async {
    return _propertyTypeDao.insert(primaryKey, propertyType);
  }

  Future<dynamic> update(PropertyType propertyType) async {
    return _propertyTypeDao.update(propertyType);
  }

  Future<dynamic> delete(PropertyType propertyType) async {
    return _propertyTypeDao.delete(propertyType);
  }

  Future<dynamic> getPropertyTypeList(
      StreamController<PsResource<List<PropertyType>>> propertyTypeListStream,
      bool isConnectedToInternet,
      Map<dynamic, dynamic> jsonMap,
      String? loginUserId,
      int limit,
      int offset,
      // propertyTypeParameterHolder holder,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkpropertyTypeListStream(
        propertyTypeListStream, await _propertyTypeDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<PropertyType>> _resource =
          await _psApiService.getPropertyTypeList(jsonMap,loginUserId,limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Delete and Insert Map Dao
        await _propertyTypeDao.deleteAll();

        // Insert PropertyType
        await _propertyTypeDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          print('delete all');
          await _propertyTypeDao.deleteAll();
        }
      }
      // Load updated Data from Db and Send to UI
      sinkpropertyTypeListStream(
          propertyTypeListStream, await _propertyTypeDao.getAll());
    }
  }

  Future<dynamic> getNextPagePropertyTypeList(
      StreamController<PsResource<List<PropertyType>>> propertyTypeListStream,
      bool isConnectedToInternet,
      Map<dynamic, dynamic> jsonMap,
      String? loginUserId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkpropertyTypeListStream(
        propertyTypeListStream, await _propertyTypeDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<PropertyType>> _resource =
          await _psApiService.getPropertyTypeList(jsonMap,loginUserId,limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _propertyTypeDao.getAll();

        await _propertyTypeDao.insertAll(primaryKey, _resource.data!);
      }
      sinkpropertyTypeListStream(
          propertyTypeListStream, await _propertyTypeDao.getAll());
    }
  }

  Future<PsResource<ApiStatus>> postTouchCount(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postTouchCount(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

    Future<PsResource<ApiStatus>> postPropertySubscribe(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postPropertySubscribe(jsonMap,);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
