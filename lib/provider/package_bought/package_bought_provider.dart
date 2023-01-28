

import 'dart:async';

import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/package_bought_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/package.dart';

class PackageBoughtProvider extends PsProvider {
  PackageBoughtProvider({required PackageBoughtRepository? repo, int limit = 0}) : super(repo,limit) {
    _repo = repo;
    print('ContactUs Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    packageListStream = StreamController<PsResource<List<Package>>>.broadcast();
    subscription =
        packageListStream.stream.listen((PsResource<List<Package>> resource) {
      updateOffset(resource.data!.length);

      _packageList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  PackageBoughtRepository? _repo;

  PsResource<ApiStatus> _packageBought =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get packageBought => _packageBought;

  PsResource<List<Package>> _packageList =
      PsResource<List<Package>>(PsStatus.NOACTION, '', <Package>[]);

  PsResource<List<Package>> get packageList => _packageList;
  late StreamSubscription<PsResource<List<Package>>> subscription;
  late StreamController<PsResource<List<Package>>> packageListStream;

  @override
  void dispose() {
    subscription.cancel();
    packageListStream.close();
    isDispose = true;
    print('Package Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> getAllPackages() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getAllPackages(
        packageListStream, isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> buyAdPackge(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _packageBought = await _repo!.buyAdPackage(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _packageBought;
  }


}
