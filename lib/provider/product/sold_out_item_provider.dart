import 'dart:async';

import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/sold_out_item_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';

class SoldOutProductProvider extends PsProvider {
  SoldOutProductProvider(
      {required SoldOutItemRepository? repo, this.psValueHolder, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('PendingProductProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        itemListStream.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data!.length);

      _itemList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  SoldOutItemRepository? _repo;
  PsValueHolder? psValueHolder;
    ProductParameterHolder addedUserParameterHolder =
      ProductParameterHolder().getSoldOutParameterHolder();

  PsResource<List<Product>> _itemList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get itemList => _itemList;
  StreamSubscription<PsResource<List<Product>>>? subscription;
late  StreamController<PsResource<List<Product>>> itemListStream;
  @override
  void dispose() {
    subscription?.cancel();
    itemListStream.close();
    isDispose = true;
    print('Added Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadSoldOutProductList(
      String? loginUserId,ProductParameterHolder holder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo!.getSoldOutItemList(
        itemListStream,
        loginUserId,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        );
  }

  Future<dynamic> nextProductList(
      String? loginUserId, ProductParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPageSoldOutItemList(
          itemListStream,
          loginUserId,
          isConnectedToInternet,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          );
    }
  }

  Future<void> resetProductList(
      String? loginUserId, ProductParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getSoldOutItemList(
        itemListStream,
        loginUserId,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        );

    isLoading = false;
  }
}
