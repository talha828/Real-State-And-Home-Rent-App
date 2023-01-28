import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/rating_dao.dart';
import 'package:flutteradhouse/viewobject/rating.dart';
import 'package:sembast/sembast.dart';

import 'Common/ps_repository.dart';

class RatingRepository extends PsRepository {
  RatingRepository(
      {required PsApiService psApiService, required RatingDao ratingDao}) {
    _psApiService = psApiService;
    _ratingDao = ratingDao;
  }

  String primaryKey = 'id';
  late PsApiService _psApiService;
  late RatingDao _ratingDao;

  Future<dynamic> insert(Rating rating) async {
    return _ratingDao.insert(primaryKey, rating);
  }

  Future<dynamic> update(Rating rating) async {
    return _ratingDao.update(rating);
  }

  Future<dynamic> delete(Rating rating) async {
    return _ratingDao.delete(rating);
  }

  Future<dynamic> getAllRatingList(
      StreamController<PsResource<List<Rating>>> ratingListStream,
      Map<dynamic, dynamic> jsonMap,
      String userId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('to_user_id', userId));
    ratingListStream.sink
        .add(await _ratingDao.getAll(status: status, finder: finder));

    if (isConnectedToInternet) {
      final PsResource<List<Rating>> _resource =
          await _psApiService.getRatingList(jsonMap, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        if (isNeedDelete) {
          await _ratingDao.deleteWithFinder(finder);
        }
        await _ratingDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          if (isNeedDelete) {
            await _ratingDao.deleteWithFinder(finder);
          }
        }
      }
      // ratingListStream.sink.add(await _ratingDao.getAll(finder: finder));
      final dynamic subscription = _ratingDao.getAllWithSubscription(
          status: PsStatus.SUCCESS,
          finder: finder,
          onDataUpdated: (List<Rating> resultList) {
            print('***<< Data Updated >>***');
            if ( status != PsStatus.NOACTION) {
              print(status);
              ratingListStream.sink.add(
                  PsResource<List<Rating>>(PsStatus.SUCCESS, '', resultList));
            } else {
              print('No Action');
            }
          });

      return subscription;
    }
  }

  Future<dynamic> getNextPageRatingList(
      StreamController<PsResource<List<Rating>>> ratingListStream,
      Map<dynamic, dynamic> jsonMap,
      String userId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('to_user_id', userId));
    ratingListStream.sink
        .add(await _ratingDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Rating>> _resource =
          await _psApiService.getRatingList(jsonMap, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _ratingDao.insertAll(primaryKey, _resource.data!);
      }
      ratingListStream.sink.add(await _ratingDao.getAll(finder: finder));
    }
  }

  Future<dynamic> postRating(
      StreamController<PsResource<Rating>> ratingListStream,
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<Rating> _resource =
        await _psApiService.postRating(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      // await _ratingDao
      //     .deleteWithFinder(Finder(filter: Filter.equals(primaryKey,jsonMap['id'])));
      await _ratingDao.insert(primaryKey, _resource.data!);
    }

    // final dynamic subscription = _ratingDao.getOneWithSubscription(
    //     status: PsStatus.SUCCESS,
    //    onDataUpdated: (PsResource<List<Rating>> resultList) {
    //     print('***<< Data Updated >>***');
    //     if (status != null && status != PsStatus.NOACTION) {
    //       print(status);
    //       ratingListStream.sink.add(resultList);
    //     } else {
    //       print('No Action');
    //     }
    //   });

    // return subscription;

    final dynamic subscription = _ratingDao.getOneWithSubscription(
        status: PsStatus.SUCCESS,
        onDataUpdated: (Rating rating) {
          if ( status != PsStatus.NOACTION) {
            print(status);
            ratingListStream.sink.add(PsResource<Rating>(status, '', rating));
          } else {
            print('No Action');
          }
        });

    return subscription;
    // if (_resource.status == PsStatus.SUCCESS) {
    //   // ratingListStream.sink
    //   //     .add(await _ratingDao.getAll(status: PsStatus.SUCCESS));
    //   return _resource;
    // } else {
    //   final Completer<PsResource<Rating>> completer =
    //       Completer<PsResource<Rating>>();
    //   completer.complete(_resource);
    //   // ratingListStream.sink
    //   //     .add(await _ratingDao.getAll(status: PsStatus.SUCCESS));
    //   return completer.future;
    // }
  }
}
