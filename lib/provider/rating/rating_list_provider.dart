import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/rating_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/rating.dart';

class RatingListProvider extends PsProvider {
  RatingListProvider({required RatingRepository? repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Rating Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    ratingListStream = StreamController<PsResource<List<Rating>>>.broadcast();
    subscription =
        ratingListStream.stream.listen((PsResource<List<Rating>> resource) {
      updateOffset(resource.data!.length);

      _ratingList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  RatingRepository? _repo;

  PsResource<List<Rating>> _ratingList =
      PsResource<List<Rating>>(PsStatus.NOACTION, '', <Rating>[]);

  PsResource<List<Rating>> get ratingList => _ratingList;
 late StreamSubscription<PsResource<List<Rating>>> subscription;
 late StreamController<PsResource<List<Rating>>> ratingListStream;

  dynamic daoSubscription;

  @override
  void dispose() {
    subscription.cancel();
    ratingListStream.close();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('Rating Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadRatingList(
      Map<dynamic, dynamic> jsonMap, String itemUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    daoSubscription = await _repo!.getAllRatingList(
        ratingListStream,
        jsonMap,
        itemUserId,
        isConnectedToInternet,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextRatingList(
      Map<dynamic, dynamic> jsonMap, String itemUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo!.getNextPageRatingList(ratingListStream, jsonMap, itemUserId,
          isConnectedToInternet, limit, offset!, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetRatingList(
      Map<dynamic, dynamic> jsonMap, String itemUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getAllRatingList(ratingListStream, jsonMap, itemUserId,
        isConnectedToInternet, limit, offset!, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<dynamic> refreshRatingList(
      Map<dynamic, dynamic> jsonMap, String itemUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getAllRatingList(ratingListStream, jsonMap, itemUserId,
        isConnectedToInternet, limit, 0, PsStatus.PROGRESS_LOADING,
        isNeedDelete: false);
  }
}
