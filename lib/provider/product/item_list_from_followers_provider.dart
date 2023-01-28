import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/product_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/follow_user_item_list_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';

class ItemListFromFollowersProvider extends PsProvider {
  ItemListFromFollowersProvider(
      {required ProductRepository repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }
    _repo = repo;

    print('ItemListFromFollowersProvider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    itemListFromFollowersStream =
        StreamController<PsResource<List<Product>>>.broadcast();
    subscription = itemListFromFollowersStream.stream
        .listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data!.length);

      print('**** ItemListFromFollowersProvider ${resource.data!.length}');
      _itemListFromFollowersList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

late  FollowUserItemParameterHolder followUserItemParameterHolder = 
      FollowUserItemParameterHolder().getLatestParameterHolder();
  ProductRepository? _repo;
late  PsValueHolder psValueHolder;
  PsResource<List<Product>> _itemListFromFollowersList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get itemListFromFollowersList =>
      _itemListFromFollowersList;
 late StreamSubscription<PsResource<List<Product>>> subscription;
 late StreamController<PsResource<List<Product>>> itemListFromFollowersStream;

  dynamic daoSubscription;

  @override
  void dispose() {
    subscription.cancel();
    itemListFromFollowersStream.close();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemListFromFollowersList(
        Map<dynamic, dynamic> jsonMap, String loginUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    daoSubscription = await _repo!.getAllItemListFromFollower(
      itemListFromFollowersStream,
      isConnectedToInternet,
      jsonMap,
      loginUserId,
      limit,
      offset!,
      PsStatus.PROGRESS_LOADING,
    );
  }

  Future<dynamic> nextItemListFromFollowersList(
      Map<dynamic, dynamic> jsonMap, String loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo!.getNextPageItemListFromFollower(
          itemListFromFollowersStream,
          isConnectedToInternet,
          jsonMap,
          loginUserId,
          limit,
          offset!,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemListFromFollowersList(
      Map<dynamic, dynamic> jsonMap, String loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    daoSubscription = await _repo!.getAllItemListFromFollower(
      itemListFromFollowersStream,
      isConnectedToInternet,
      jsonMap,
      loginUserId,
      limit,
      offset!,
      PsStatus.PROGRESS_LOADING,
    );

    isLoading = false;
  }
}
