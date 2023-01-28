import 'dart:async';

import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/package_bought_transaction_history_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/buyadpost_transaction.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/package_transaction_holder.dart';

class PackageTranscationHistoryProvider extends PsProvider {
  PackageTranscationHistoryProvider(
      {required PackageTranscationHistoryRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }

    _repo = repo;

    print('Category Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    transactionListStream =
        StreamController<PsResource<List<PackageTransaction>>>.broadcast();
    subscription = transactionListStream!.stream
        .listen((PsResource<List<PackageTransaction>> resource) {
      updateOffset(resource.data!.length);

      _transactionList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  late PackgageBoughtTransactionParameterHolder holder = PackgageBoughtTransactionParameterHolder();
   PsValueHolder? psValueHolder;

  // ignore: close_sinks
  StreamController<PsResource<List<PackageTransaction>>>? transactionListStream;


  PackageTranscationHistoryRepository? _repo;

  PsResource<List<PackageTransaction>> _transactionList =
      PsResource<List<PackageTransaction>>(PsStatus.NOACTION, '', <PackageTransaction>[]);

  PsResource<List<PackageTransaction>> get transactionList => _transactionList;
  late StreamSubscription<PsResource<List<PackageTransaction>>> subscription;

  final PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _apiStatus;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Category Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadBuyAdTransactionList(
      PackgageBoughtTransactionParameterHolder holder,) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (isConnectedToInternet) {
      await _repo!.getPackageTransactionDetailList(transactionListStream, isConnectedToInternet,
          holder, limit, offset, PsStatus.PROGRESS_LOADING);
    }
    return isConnectedToInternet;
  }

  Future<dynamic> nextPackageTransactionDetailList(
      PackgageBoughtTransactionParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo!.getNextPagePackageTransactionDetailList(
          transactionListStream,
          isConnectedToInternet,
          holder,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetPackageTransactionDetailList(
      PackgageBoughtTransactionParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);
    if (isConnectedToInternet) {
      await _repo!.getNextPagePackageTransactionDetailList(transactionListStream, isConnectedToInternet,
          holder, limit, offset, PsStatus.PROGRESS_LOADING);
    }

    isLoading = false;
    // return isConnectedToInternet;
  }


}
