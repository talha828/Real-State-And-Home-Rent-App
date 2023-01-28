import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/item_price_type_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/item_price_type.dart';

class ItemPriceTypeProvider extends PsProvider {
  ItemPriceTypeProvider({required ItemPriceTypeRepository? repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Item Price Type Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemPriceTypeListStream =
        StreamController<PsResource<List<ItemPriceType>>>.broadcast();
    subscription = itemPriceTypeListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _itemPriceTypeList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

 late StreamController<PsResource<List<ItemPriceType>>> itemPriceTypeListStream;
  ItemPriceTypeRepository? _repo;

  PsResource<List<ItemPriceType>> _itemPriceTypeList =
      PsResource<List<ItemPriceType>>(PsStatus.NOACTION, '', <ItemPriceType>[]);

  PsResource<List<ItemPriceType>> get itemPriceTypeList => _itemPriceTypeList;
 late StreamSubscription<PsResource<List<ItemPriceType>>> subscription;

  String categoryId = '';

  @override
  void dispose() {
    subscription.cancel();
    itemPriceTypeListStream.close();
    isDispose = true;
    print('Item Price Type Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemPriceTypeList() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getItemPriceTypeList(itemPriceTypeListStream,
        isConnectedToInternet, limit, offset!, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemPriceTypeList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPageItemPriceTypeList(itemPriceTypeListStream,
          isConnectedToInternet, limit, offset!, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemPriceTypeList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo!.getItemPriceTypeList(
      itemPriceTypeListStream,
      isConnectedToInternet,
      limit,
      offset!,
      PsStatus.PROGRESS_LOADING,
    );

    isLoading = false;
  }
}
