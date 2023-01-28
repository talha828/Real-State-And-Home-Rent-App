import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/offer_dao.dart';
import 'package:flutteradhouse/db/offer_map_dao.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/holder/offer_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/offer.dart';
import 'package:flutteradhouse/viewobject/offer_map.dart';
import 'package:sembast/sembast.dart';

class OfferRepository extends PsRepository {
  OfferRepository(
      {required PsApiService psApiService, required OfferDao offerDao}) {
    _psApiService = psApiService;
    _offerDao = offerDao;
  }
  String primaryKey = 'id';
  String mapKey = 'map_key';
 late PsApiService _psApiService;
 late OfferDao _offerDao;

  void sinkOfferListStream(
      StreamController<PsResource<List<Offer>>>? offerListStream,
      PsResource<List<Offer>>? dataList) {
    if (dataList != null && offerListStream != null) {
      offerListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(Offer offer) async {
    return _offerDao.insert(primaryKey, offer);
  }

  Future<dynamic> update(Offer offer) async {
    return _offerDao.update(offer);
  }

  Future<dynamic> delete(Offer offer) async {
    return _offerDao.delete(offer);
  }

  Future<dynamic> getOfferList(
      StreamController<PsResource<List<Offer>>> offerListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      OfferParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final OfferMapDao offerMapDao = OfferMapDao.instance;

    // Load from Db and Send to UI
    sinkOfferListStream(
        offerListStream,
        await _offerDao.getAllByMap(
            primaryKey, mapKey, paramKey, offerMapDao, OfferMap(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Offer>> _resource =
          await _psApiService.getOfferList(holder.toMap());

      print('Param Key $paramKey');
      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<OfferMap> offerMapList = <OfferMap>[];
        int i = 0;
        for (Offer data in _resource.data!) {
          offerMapList.add(OfferMap(
              id: data.id! + paramKey,
              mapKey: paramKey,
              offerId: data.id,
              sorting: i++,
              addedDate: '2020'));
        }

        // Delete and Insert Map Dao
        print('Delete Key $paramKey');
        await offerMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        print('Insert All Key $paramKey');
        await offerMapDao.insertAll(primaryKey, offerMapList);

        // Insert Offer
        await _offerDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          // Delete and Insert Map Dao
          await offerMapDao.deleteWithFinder(
              Finder(filter: Filter.equals(mapKey, paramKey)));
        }
      }
      // Load updated Data from Db and Send to UI
      sinkOfferListStream(
          offerListStream,
          await _offerDao.getAllByMap(
              primaryKey, mapKey, paramKey, offerMapDao, OfferMap()));
    }
  }

  Future<dynamic> getNextPageOfferList(
      StreamController<PsResource<List<Offer>>> offerListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      OfferParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    final String paramKey = holder.getParamKey();
    final OfferMapDao offerMapDao = OfferMapDao.instance;
    // Load from Db and Send to UI
    sinkOfferListStream(
        offerListStream,
        await _offerDao.getAllByMap(
            primaryKey, mapKey, paramKey, offerMapDao, OfferMap(),
            status: status));
    if (isConnectedToInternet) {
      final PsResource<List<Offer>> _resource =
          await _psApiService.getOfferList(holder.toMap());

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<OfferMap> offerMapList = <OfferMap>[];
        final PsResource<List<OfferMap>>? existingMapList = await offerMapDao
            .getAll(finder: Finder(filter: Filter.equals(mapKey, paramKey)));

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data!.length + 1;
        }
        for (Offer data in _resource.data!) {
          offerMapList.add(OfferMap(
              id: data.id! + paramKey,
              mapKey: paramKey,
              offerId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        await offerMapDao.insertAll(primaryKey, offerMapList);

        // Insert Offer
        await _offerDao.insertAll(primaryKey, _resource.data!);
      }
      sinkOfferListStream(
          offerListStream,
          await _offerDao.getAllByMap(
              primaryKey, mapKey, paramKey, offerMapDao, OfferMap()));
    }
  }
}
