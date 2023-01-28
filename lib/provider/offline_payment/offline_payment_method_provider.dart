import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/offline_payment_method_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/offline_payment_method.dart';

class OfflinePaymentMethodProvider extends PsProvider {
  OfflinePaymentMethodProvider(
      {required OfflinePaymentMethodRepository? repo,
      this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('OfflinePaymentMethod Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    notiListStream =
        StreamController<PsResource<OfflinePaymentMethod>>.broadcast();
    subscription = notiListStream.stream.listen((dynamic resource) {
      // updateOffset(resource.data.length);

      _notiList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  OfflinePaymentMethodRepository? _repo;
  PsValueHolder? psValueHolder;
  String userId = '';
  String deviceToken ='';

  final PsResource<OfflinePaymentMethod> _noti =
      PsResource<OfflinePaymentMethod>(PsStatus.NOACTION, '', null);
  PsResource<OfflinePaymentMethod> get user => _noti;

  PsResource<OfflinePaymentMethod> _notiList =
      PsResource<OfflinePaymentMethod>(PsStatus.NOACTION, '', null);
  PsResource<OfflinePaymentMethod> get offlinePaymentMethod => _notiList;
 late StreamSubscription<dynamic> subscription;
 late StreamController<PsResource<OfflinePaymentMethod>> notiListStream;
  @override
  void dispose() {
    subscription.cancel();
    notiListStream.close();
    isDispose = true;
    print('Notification Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> getOfflinePaymentList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    await _repo!.getOfflinePaymentList(notiListStream, isConnectedToInternet,
        limit, offset!, PsStatus.BLOCK_LOADING);
  }

  Future<dynamic> nextOfflinePaymentList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPageOfflinePaymentList(notiListStream,
          isConnectedToInternet, limit, offset!, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetOfflinePaymentList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getOfflinePaymentList(notiListStream, isConnectedToInternet,
        limit, offset!, PsStatus.BLOCK_LOADING);

    isLoading = false;
  }
}
