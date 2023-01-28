import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/user_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/user.dart';

class UserListProvider extends PsProvider {
  UserListProvider(
      {required UserRepository? repo, this.psValueHolder, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('UserListProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    userListStream = StreamController<PsResource<List<User>>>.broadcast();
    subscription =
        userListStream.stream.listen((PsResource<List<User>> resource) {
      updateOffset(resource.data!.length);

      _userList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
late  UserParameterHolder followerUserParameterHolder =
      UserParameterHolder().getFollowerUsers();
 late UserParameterHolder followingUserParameterHolder =
      UserParameterHolder().getFollowingUsers();
 late UserParameterHolder otherUserParameterHolder =
      UserParameterHolder().getOtherUserData();

  UserRepository? _repo;
  PsValueHolder ?psValueHolder;

  PsResource<List<User>> _userList =
      PsResource<List<User>>(PsStatus.NOACTION, '', <User>[]);

  PsResource<List<User>> get userList => _userList;
 late StreamSubscription<PsResource<List<User>>> subscription;
 late StreamController<PsResource<List<User>>> userListStream;
  @override
  void dispose() {
    subscription.cancel();
    userListStream.close();
    isDispose = true;
    print('Added Item Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadUserList(UserParameterHolder holder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo!.getUserList(userListStream, isConnectedToInternet, limit,
        offset!, PsStatus.PROGRESS_LOADING, holder);
  }

  Future<dynamic> nextUserList(UserParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPageUserList(userListStream, isConnectedToInternet,
          limit, offset!, PsStatus.PROGRESS_LOADING, holder);
    }
  }

  Future<void> resetUserList(UserParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getUserList(userListStream, isConnectedToInternet, limit,
        offset!, PsStatus.PROGRESS_LOADING, holder);

    isLoading = false;
  }
}
