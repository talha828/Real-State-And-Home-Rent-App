import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/product_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';

class ItemEntryProvider extends PsProvider {
  ItemEntryProvider(
      {required ProductRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    isDispose = false;
    print('Item Entry Provider: $hashCode');

    itemListStream = StreamController<PsResource<Product>>.broadcast();
    subscription = itemListStream.stream.listen((PsResource<Product> resource) {
      if ( resource.data != null) {
        _itemResource = resource;
        item = resource.data!;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  ProductRepository? _repo;
  PsValueHolder? psValueHolder;
  PsResource<Product> _itemResource =
      PsResource<Product>(PsStatus.NOACTION, '', null);
  PsResource<Product> get itemResource => _itemResource;

  late StreamSubscription<PsResource<Product>> subscription;
 late  StreamController<PsResource<Product>> itemListStream;

 late Product item;

  String propertyById = '';
  String postedById = '';
  String cityId = '';
  String amenityId = '';
  String amenityName = '';
  String itemTypeId = '';
  String itemConditionId = '';
  String itemPriceTypeId = '';
  String itemCurrencyId = '';
  String itemDealOptionId = '';
  String itemLocationCityId = '';
  String itemLocationTownshipId = '';

  bool isCheckBoxSelect = true;
  bool isNegotiableCheckBoxSelect = true;
  String checkOrNotShop = '1';
  String checkOrNotNegotiable = '1';
  String itemId = '';

  // Existing Image Id
  String firstImageId = '';
  String secondImageId = '';
  String thirdImageId = '';
  String fourthImageId = '';
  String fiveImageId = '';

  @override
  void dispose() {
    subscription.cancel();
    itemListStream.close();
    isDispose = true;
    print('Item Entry Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postItemEntry(
    Map<dynamic, dynamic> jsonMap,String loginuserId
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _itemResource = await _repo!.postItemEntry(
        jsonMap,loginuserId, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _itemResource;
  }

  Future<dynamic> getItemFromDB(String? itemId) async {
    isLoading = true;

    await _repo!.getItemFromDB(
        itemId, itemListStream, PsStatus.PROGRESS_LOADING);
  }
}
