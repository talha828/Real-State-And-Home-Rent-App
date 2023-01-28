import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/item_location_city_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/location_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/item_location_city.dart';

class ItemLocationCityProvider extends PsProvider {
  ItemLocationCityProvider(
      {required ItemLocationCityRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Item Location Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    itemLocationListStream =
        StreamController<PsResource<List<ItemLocationCity>>>.broadcast();
    subscription = itemLocationListStream.stream
        .listen((PsResource<List<ItemLocationCity>> resource) {
      updateOffset(resource.data!.length);

      if (ItemLocationCity()
          .isListEqual(_itemLocationList.data!, resource.data!)) {
        _itemLocationList.status = resource.status;
        _itemLocationList.message = resource.message;
      } else {
        _itemLocationList = resource;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  ItemLocationCityRepository? _repo;
  PsValueHolder? psValueHolder;
  LocationParameterHolder latestLocationParameterHolder =
      LocationParameterHolder().getDefaultParameterHolder();
  PsResource<List<ItemLocationCity>> _itemLocationList =
      PsResource<List<ItemLocationCity>>(
          PsStatus.NOACTION, '', <ItemLocationCity>[]);

  PsResource<List<ItemLocationCity>> get itemLocationList => _itemLocationList;
 late StreamSubscription<PsResource<List<ItemLocationCity>>> subscription;
 late StreamController<PsResource<List<ItemLocationCity>>> itemLocationListStream;
  @override
  void dispose() {
    subscription.cancel();
    itemLocationListStream.close();
    isDispose = true;
    print('ItemLocation Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemLocationList(
      Map<dynamic, dynamic> jsonMap, String loginUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getAllItemLocationList(
        itemLocationListStream,
        isConnectedToInternet,
        jsonMap,
        loginUserId,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemLocationList(
    Map<dynamic, dynamic> jsonMap,
    String loginUserId,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo!.getNextPageItemLocationList(
          itemLocationListStream,
          isConnectedToInternet,
          jsonMap,
          loginUserId,
          limit,
          offset!,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemLocationList(
    Map<dynamic, dynamic> jsonMap,
    String loginUserId,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getAllItemLocationList(
        itemLocationListStream,
        isConnectedToInternet,
        jsonMap,
        loginUserId,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
