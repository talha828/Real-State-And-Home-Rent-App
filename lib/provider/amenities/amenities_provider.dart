import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/amenities_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/amenities.dart';

class AmenitiesProvider extends PsProvider {
  AmenitiesProvider({required AmenitiesRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('AmenitiesProvider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    amenitiesListStream =
        StreamController<PsResource<List<Amenities>>>.broadcast();
    subscription = amenitiesListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _amenitiesList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  late StreamController<PsResource<List<Amenities>>> amenitiesListStream;
  AmenitiesRepository? _repo;

  PsResource<List<Amenities>> _amenitiesList =
      PsResource<List<Amenities>>(PsStatus.NOACTION, '', <Amenities>[]);

  PsResource<List<Amenities>> get amenitiesList => _amenitiesList;
 late StreamSubscription<PsResource<List<Amenities>>> subscription;

  @override
  void dispose() {
    subscription.cancel();
    amenitiesListStream.close();
    isDispose = true;
    print('SubCategory Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadAmenitiesList() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getAllAmenitiesList(
      amenitiesListStream,
      isConnectedToInternet,
      limit,
      offset!,
      PsStatus.PROGRESS_LOADING,
    );
  }

  Future<dynamic> nextAmenitiesList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPageAmenitiesList(
        amenitiesListStream,
        isConnectedToInternet,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING,
      );
    }
  }

  Future<void> resetAmenitiesList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo!.getAllAmenitiesList(
      amenitiesListStream,
      isConnectedToInternet,
      limit,
      offset!,
      PsStatus.PROGRESS_LOADING,
    );

    isLoading = false;
  }
}
