import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/item_deal_option_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/deal_option.dart';

class ItemDealOptionProvider extends PsProvider {
  ItemDealOptionProvider(
      {required ItemDealOptionRepository? repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Item Deal Option Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemDealOptionListStream =
        StreamController<PsResource<List<DealOption>>>.broadcast();
    subscription = itemDealOptionListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _itemDealOptionList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  late StreamController<PsResource<List<DealOption>>> itemDealOptionListStream;
  ItemDealOptionRepository? _repo;

  PsResource<List<DealOption>> _itemDealOptionList =
      PsResource<List<DealOption>>(PsStatus.NOACTION, '', <DealOption>[]);

  PsResource<List<DealOption>> get itemDealOptionList => _itemDealOptionList;
 late StreamSubscription<PsResource<List<DealOption>>> subscription;

  String categoryId = '';

  @override
  void dispose() {
    subscription.cancel();
    itemDealOptionListStream.close();
    isDispose = true;
    print('Item Condition Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemDealOptionList() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getItemDealOptionList(itemDealOptionListStream,
        isConnectedToInternet, limit, offset!, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemDealOptionList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPageItemDealOptionList(itemDealOptionListStream,
          isConnectedToInternet, limit, offset!, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemDealOptionList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo!.getItemDealOptionList(
      itemDealOptionListStream,
      isConnectedToInternet,
      limit,
      offset!,
      PsStatus.PROGRESS_LOADING,
    );

    isLoading = false;
  }
}
