import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/history_repsitory.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/product.dart';

class HistoryProvider extends PsProvider {
  HistoryProvider({required HistoryRepository? repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('History Provider: $hashCode');

    historyListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        historyListStream.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data!.length);

      _historyList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  HistoryRepository? _repo;

  PsResource<List<Product>> _historyList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get historyList => _historyList;
 late StreamSubscription<PsResource<List<Product>>> subscription;
 late StreamController<PsResource<List<Product>>> historyListStream;
  @override
  void dispose() {
    subscription.cancel();
    historyListStream.close();
    isDispose = true;
    print('History Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadHistoryList() async {
    isLoading = true;
    await _repo!.getAllHistoryList(historyListStream, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> addHistoryList(Product product) async {
    isLoading = true;
    await _repo!.addAllHistoryList(
        historyListStream, PsStatus.PROGRESS_LOADING, product);
  }

  Future<void> resetHistoryList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getAllHistoryList(historyListStream, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
