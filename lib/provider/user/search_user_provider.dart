import 'dart:async';

import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/search_user_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/search_user_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/user.dart';

class SearchUserProvider extends PsProvider {
  SearchUserProvider(
      {required SearchUserRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }

    _repo = repo;

    print('SearchUser Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    searchUserListStream =
        StreamController<PsResource<List<User>>>.broadcast();
    subscription = searchUserListStream!.stream
        .listen((PsResource<List<User>> resource) {
      updateOffset(resource.data!.length);

      _searchUserList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  // ignore: close_sinks
  StreamController<PsResource<List<User>>>? searchUserListStream;
  SearchUserParameterHolder searchUserParameterHolder =
      SearchUserParameterHolder();

  SearchUserRepository? _repo;
  PsValueHolder? psValueHolder;

  PsResource<List<User>> _searchUserList =
      PsResource<List<User>>(PsStatus.NOACTION, '', <User>[]);

  PsResource<List<User>> get searchUserList => _searchUserList;
  late StreamSubscription<PsResource<List<User>>> subscription;

  final PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _apiStatus;
  @override
  void dispose() {
    subscription.cancel();
    searchUserListStream!.close();
    isDispose = true;
    print('Search User Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadSearchUserList(
      Map<dynamic, dynamic> jsonMap, String? loginUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (isConnectedToInternet) {
      await _repo!.getSearchUserList(searchUserListStream, isConnectedToInternet,
          jsonMap, loginUserId, limit, offset, PsStatus.PROGRESS_LOADING);
    }
    return isConnectedToInternet;
  }

  Future<dynamic> nextSearchUserList(
      Map<dynamic, dynamic> jsonMap, String? loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo!.getNextPageSearchUserList(
          searchUserListStream,
          isConnectedToInternet,
          jsonMap,
          loginUserId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetSearchUserList(
      Map<dynamic, dynamic> jsonMap, String? loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);
    if (isConnectedToInternet) {
      await _repo!.getSearchUserList(searchUserListStream, isConnectedToInternet,
          jsonMap, loginUserId, limit, offset, PsStatus.PROGRESS_LOADING);
    }

    isLoading = false;
    // return isConnectedToInternet;
  }

}
