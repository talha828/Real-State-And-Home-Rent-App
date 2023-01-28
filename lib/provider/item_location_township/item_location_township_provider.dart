import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/item_location_township_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/location_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/item_location_township.dart';

class ItemLocationTownshipProvider extends PsProvider {
  ItemLocationTownshipProvider(
      {required ItemLocationTownshipRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Item Location Township Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    itemLocationTownshipListStream =
        StreamController<PsResource<List<ItemLocationTownship>>>.broadcast();
    subscription = itemLocationTownshipListStream.stream
        .listen((PsResource<List<ItemLocationTownship>> resource) {
      updateOffset(resource.data!.length);

      if (ItemLocationTownship()
          .isListEqual(_itemLocationTownshipList.data!, resource.data!)) {
        _itemLocationTownshipList.status = resource.status;
        _itemLocationTownshipList.message = resource.message;
      } else {
        _itemLocationTownshipList = resource;
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

  ItemLocationTownshipRepository? _repo;
  PsValueHolder? psValueHolder;
  LocationParameterHolder latestLocationParameterHolder =
      LocationParameterHolder().getDefaultParameterHolder();
  PsResource<List<ItemLocationTownship>> _itemLocationTownshipList =
      PsResource<List<ItemLocationTownship>>(
          PsStatus.NOACTION, '', <ItemLocationTownship>[]);

  PsResource<List<ItemLocationTownship>> get itemLocationTownshipList =>
      _itemLocationTownshipList;
late StreamSubscription<PsResource<List<ItemLocationTownship>>> subscription;
late StreamController<PsResource<List<ItemLocationTownship>>>
      itemLocationTownshipListStream;
  @override
  void dispose() {
    subscription.cancel();
    itemLocationTownshipListStream.close();
    isDispose = true;
    print('ItemLocation Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemLocationTownshipListByCityId(
      Map<dynamic, dynamic> jsonMap, String loginUserId, String cityId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getAllItemLocationTownshipList(
        itemLocationTownshipListStream,
        isConnectedToInternet,
        jsonMap,
        loginUserId,
        limit,
        offset!,
        cityId,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemLocationTownshipListByCityId(
    Map<dynamic, dynamic> jsonMap,
    String loginUserId,
    String cityId,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo!.getNextPageItemLocationTownshipList(
          itemLocationTownshipListStream,
          isConnectedToInternet,
          jsonMap,
          loginUserId,
          limit,
          offset!,
          cityId,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemLocationTownshipListByCityId(
    Map<dynamic, dynamic> jsonMap,
    String loginUserId,
    String cityId,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getAllItemLocationTownshipList(
        itemLocationTownshipListStream,
        isConnectedToInternet,
        jsonMap,
        loginUserId,
        limit,
        offset!,
        cityId,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
