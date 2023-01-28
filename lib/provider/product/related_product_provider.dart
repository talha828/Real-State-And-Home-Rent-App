import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/product_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';

class RelatedProductProvider extends PsProvider {
  RelatedProductProvider(
      {required ProductRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('RelatedProductProvider : $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    relatedProductListStream =
        StreamController<PsResource<List<Product>>>.broadcast();
    subscription = relatedProductListStream.stream
        .listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data!.length);

      _relatedProductList = resource;
      _relatedProductList.data = Product().checkDuplicate(resource.data!);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  PsValueHolder? psValueHolder;
  ProductRepository ?_repo;

  PsResource<List<Product>> _relatedProductList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get relatedProductList => _relatedProductList;
 late StreamSubscription<PsResource<List<Product>>> subscription;
 late StreamController<PsResource<List<Product>>> relatedProductListStream;

  @override
  void dispose() {
    subscription.cancel();
    relatedProductListStream.close();
    print('Related Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadRelatedProductList(
    String loginUserId,
    String productId,
    String categoryId,
  ) async {
    isLoading = true;

    limit = 10;
    offset = 0;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getRelatedProductList(
        relatedProductListStream,
        productId,
        categoryId,
        loginUserId,
        isConnectedToInternet,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING);
  }
}
