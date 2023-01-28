import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/item_type_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/item_type.dart';

class ItemTypeProvider extends PsProvider {
  ItemTypeProvider({required ItemTypeRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('ItemType Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemTypeListStream =
        StreamController<PsResource<List<ItemType>>>.broadcast();
    subscription = itemTypeListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _itemTypeList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  late StreamController<PsResource<List<ItemType>>> itemTypeListStream;
  ItemTypeRepository? _repo;

  PsResource<List<ItemType>> _itemTypeList =
      PsResource<List<ItemType>>(PsStatus.NOACTION, '', <ItemType>[]);

  PsResource<List<ItemType>> get itemTypeList => _itemTypeList;
late  StreamSubscription<PsResource<List<ItemType>>> subscription;

  String categoryId = '';

  @override
  void dispose() {
    subscription.cancel();
    itemTypeListStream.close();
    isDispose = true;
    print('Item Type Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemTypeList() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getItemTypeList(itemTypeListStream, isConnectedToInternet,
        limit, offset!, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextItemTypeList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPageItemTypeList(itemTypeListStream,
          isConnectedToInternet, limit, offset!, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetItemTypeList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo!.getItemTypeList(
      itemTypeListStream,
      isConnectedToInternet,
      limit,
      offset!,
      PsStatus.PROGRESS_LOADING,
    );

    isLoading = false;
  }
}
