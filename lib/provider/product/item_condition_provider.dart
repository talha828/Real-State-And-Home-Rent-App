import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/item_condition_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/condition_of_item.dart';

class ItemConditionProvider extends PsProvider {
  ItemConditionProvider({required ItemConditionRepository? repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Item Condition Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemConditionListStream =
        StreamController<PsResource<List<ConditionOfItem>>>.broadcast();
    subscription = itemConditionListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _itemConditionList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

late  StreamController<PsResource<List<ConditionOfItem>>> itemConditionListStream;
  ItemConditionRepository? _repo;

  PsResource<List<ConditionOfItem>> _itemConditionList =
      PsResource<List<ConditionOfItem>>(
          PsStatus.NOACTION, '', <ConditionOfItem>[]);

  PsResource<List<ConditionOfItem>> get itemConditionList => _itemConditionList;
 late StreamSubscription<PsResource<List<ConditionOfItem>>> subscription;

  String categoryId = '';

  @override
  void dispose() {
    subscription.cancel();
    itemConditionListStream.close();
    isDispose = true;
    print('Item Condition Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemConditionList() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getItemConditionList(itemConditionListStream,
        isConnectedToInternet, limit, offset!, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemConditionList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPageItemConditionList(itemConditionListStream,
          isConnectedToInternet, limit, offset!, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemConditionList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo!.getItemConditionList(
      itemConditionListStream,
      isConnectedToInternet,
      limit,
      offset!,
      PsStatus.PROGRESS_LOADING,
    );

    isLoading = false;
  }
}
