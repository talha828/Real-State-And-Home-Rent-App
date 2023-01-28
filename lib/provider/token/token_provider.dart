import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/token_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';

class TokenProvider extends PsProvider {
  TokenProvider({required TokenRepository? repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    // tokenDataListStream = StreamController<PsResource<ApiStatus>>.broadcast();
    // subscription =
    //     tokenDataListStream.stream.listen((PsResource<ApiStatus> resource) {
    //   _tokenData = resource;

    //   if (resource.status != PsStatus.BLOCK_LOADING &&
    //       resource.status != PsStatus.PROGRESS_LOADING) {
    //     isLoading = false;
    //   }

    //   if (!isDispose) {
    //     notifyListeners();
    //   }
    // });
  }

  // PsResource<ApiStatus> _tokenData =
  //     PsResource<ApiStatus>(PsStatus.NOACTION, '', null);

  // PsResource<ApiStatus> get tokenData => _tokenData;
  // StreamSubscription<PsResource<ApiStatus>> subscription;
  // StreamController<PsResource<ApiStatus>> tokenDataListStream;
  // PsApiService _psApiService;
  TokenRepository? _repo;

  @override
  void dispose() {
    // subscription.cancel();
    isDispose = true;
    print('Token Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadToken() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    // if (isConnectedToInternet) {
    final PsResource<ApiStatus> _resource =
        await _repo!.getToken(isConnectedToInternet, PsStatus.SUCCESS);

    return _resource;
    // if (_resource.status == PsStatus.SUCCESS) {
    //   tokenDataListStream.sink.add(_resource);
    // }
  }
}
