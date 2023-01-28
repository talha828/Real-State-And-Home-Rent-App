import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/item_paid_history_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/item_paid_history.dart';

class ItemPromotionProvider extends PsProvider {
  ItemPromotionProvider(
      {required ItemPaidHistoryRepository? itemPaidHistoryRepository,
      int limit = 0})
      : super(itemPaidHistoryRepository, limit) {
    _repo = itemPaidHistoryRepository;
    isDispose = false;
    print('Item Paid History Provider: $hashCode');

    itemPaidHistoryStream =
        StreamController<PsResource<ItemPaidHistory>>.broadcast();
    subscription = itemPaidHistoryStream.stream
        .listen((PsResource<ItemPaidHistory> resource) {
      if (resource.data != null) {
        _itemPaidHistoryEntry = resource;
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

  String? selectedDate;
  DateTime? selectedDateTime;

  ItemPaidHistoryRepository? _repo;
  PsResource<ItemPaidHistory> _itemPaidHistoryEntry =
      PsResource<ItemPaidHistory>(PsStatus.NOACTION, '', null);
  PsResource<ItemPaidHistory> get item => _itemPaidHistoryEntry;

 late StreamSubscription<PsResource<ItemPaidHistory>> subscription;
 late StreamController<PsResource<ItemPaidHistory>> itemPaidHistoryStream;

  @override
  void dispose() {
    subscription.cancel();
    itemPaidHistoryStream.close();
    isDispose = true;
    print('Item Paid History Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postItemHistoryEntry(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _itemPaidHistoryEntry = await _repo!.postItemPaidHistory(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _itemPaidHistoryEntry;
  }
}
