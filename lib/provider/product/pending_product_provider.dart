import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/product_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';

class PendingProductProvider extends PsProvider {
  PendingProductProvider(
      {required ProductRepository? repo, this.psValueHolder, int limit = 0})
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
  ProductRepository? _repo;
 late PsValueHolder? psValueHolder;
  ProductParameterHolder addedUserParameterHolder =
      ProductParameterHolder().getPendingItemParameterHolder();
  PsResource<List<Product>> _itemList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get itemList => _itemList;
 late StreamSubscription<PsResource<List<Product>>> subscription;
late  StreamController<PsResource<List<Product>>> itemListStream;
  @override
  void dispose() {
    subscription.cancel();
    itemListStream.close();
    isDispose = true;
    print('Added Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductList(
      String loginUserId, ProductParameterHolder holder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo!.getItemListByUserId(
        itemListStream,
        loginUserId,
        isConnectedToInternet,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING,
        holder);
  }

  Future<dynamic> nextProductList(
      String loginUserId, ProductParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPageItemListByUserId(
          itemListStream,
          loginUserId,
          isConnectedToInternet,
          limit,
          offset!,
          PsStatus.PROGRESS_LOADING,
          holder);
    }
  }

  Future<void> resetProductList(
      String loginUserId, ProductParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getItemListByUserId(
        itemListStream,
        loginUserId,
        isConnectedToInternet,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING,
        holder);

    isLoading = false;
  }
}
