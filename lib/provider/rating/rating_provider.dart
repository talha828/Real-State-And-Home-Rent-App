import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/rating_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/rating.dart';

class RatingProvider extends PsProvider {
  RatingProvider({required RatingRepository? repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Rating Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    ratingStream = StreamController<PsResource<Rating>>.broadcast();
    subscription = ratingStream.stream.listen((PsResource<Rating> resource) {
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

  RatingRepository?_repo;

  PsResource<Rating> _ratingList =
      PsResource<Rating>(PsStatus.NOACTION, '', null);

  PsResource<Rating> get ratingData => _ratingList;
 late StreamSubscription<PsResource<Rating>> subscription;
 late StreamController<PsResource<Rating>> ratingStream;

  dynamic daoSubscription;

  @override
  void dispose() {
    subscription.cancel();
    ratingStream.close();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('Rating Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postRating(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    daoSubscription = await _repo!.postRating(ratingStream, jsonMap,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return daoSubscription;
  }
}
