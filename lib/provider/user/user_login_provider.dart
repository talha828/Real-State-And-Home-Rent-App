import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/user_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/user_login.dart';

class UserLoginProvider extends PsProvider {
  UserLoginProvider(
      {required UserRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    isDispose = false;
    print('User Login Provider: $hashCode');

    userLoginStream = StreamController<PsResource<UserLogin>>.broadcast();
    subscriptionUserLogin = userLoginStream.stream
        .listen((PsResource<UserLogin> userLoginResource) {
      _userLogin = userLoginResource;

      if (userLoginResource.status != PsStatus.BLOCK_LOADING &&
          userLoginResource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  UserRepository? _repo;
  PsValueHolder? psValueHolder;

  UserParameterHolder userParameterHolder =
      UserParameterHolder().getOtherUserData();

  PsResource<UserLogin> _userLogin =
      PsResource<UserLogin>(PsStatus.NOACTION, '', null);
  PsResource<UserLogin> get userLogin => _userLogin;

  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get apiStatus => _apiStatus;

 late StreamController<PsResource<UserLogin>> userLoginStream;
 late StreamSubscription<PsResource<UserLogin>> subscriptionUserLogin;

  @override
  void dispose() {
    subscriptionUserLogin.cancel();
    userLoginStream.close();
    isDispose = true;
    print('User Login Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> getUserLoginFromDB(String loginUserId) async {
    isLoading = true;

    await _repo!.getUserLoginFromDB(
        loginUserId, userLoginStream, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> getMyUserData(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _userLogin = await _repo!.getMyUserData(userLoginStream, jsonMap,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _userLogin;
  }

  Future<dynamic> postDeleteUser(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.postDeleteUser(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
