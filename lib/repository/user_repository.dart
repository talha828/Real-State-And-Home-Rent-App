import 'dart:async';
import 'dart:io';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/user_dao.dart';
import 'package:flutteradhouse/db/user_login_dao.dart';
import 'package:flutteradhouse/db/user_map_dao.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/holder/user_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/user.dart';
import 'package:flutteradhouse/viewobject/user_login.dart';
import 'package:flutteradhouse/viewobject/user_map.dart';
import 'package:sembast/sembast.dart';

class UserRepository extends PsRepository {
  UserRepository(
      {required PsApiService psApiService,
      required UserDao userDao,
      UserLoginDao? userLoginDao}) {
    _psApiService = psApiService;
    _userDao = userDao;
    _userLoginDao = userLoginDao;
  }

late PsApiService _psApiService;
late UserDao _userDao;
 UserLoginDao? _userLoginDao;
  final String _userPrimaryKey = 'user_id';
  final String _userLoginPrimaryKey = 'map_key'; //for user login
  final String mapKey = 'map_key'; //for user map

  void sinkUserListStream(
      StreamController<PsResource<List<User>>>? userListStream,
      PsResource<List<User>>? dataList) {
    if (dataList != null && userListStream != null) {
      userListStream.sink.add(dataList);
    }
  }

  void sinkUserDetailStream(StreamController<PsResource<User>> ?userListStream,
      PsResource<User>? data) {
    if (data != null) {
      userListStream!.sink.add(data);
    }
  }

  void sinkUserLoginStream(
      StreamController<PsResource<UserLogin>>? userLoginStream,
      PsResource<UserLogin>? data) {
    if (data != null) {
      userLoginStream!.sink.add(data);
    }
  }

  Future<dynamic> insert(User? user) async {
    return _userDao.insert(_userPrimaryKey, user!);
  }

  Future<dynamic> update(User user) async {
    return _userDao.update(user);
  }

  Future<dynamic> delete(User user) async {
    return _userDao.delete(user);
  }

  Future<dynamic> insertUserLogin(UserLogin user) async {
    return _userLoginDao!.insert(_userLoginPrimaryKey, user);
  }

  Future<dynamic> updateUserLogin(UserLogin user) async {
    return _userLoginDao!.update(user);
  }

  Future<dynamic> deleteUserLogin(UserLogin user) async {
    return _userLoginDao!.delete(user);
  }

  Future<PsResource<User>> postUserRegister(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<User> _resource =
        await _psApiService.postUserRegister(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<User>> completer =
          Completer<PsResource<User>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<User>> postUserLogin(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<User> _resource =
        await _psApiService.postUserLogin(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      await _userLoginDao!.deleteAll();
      await insert(_resource.data!);
      final String userId = _resource.data!.userId!;
      final UserLogin userLogin =
          UserLogin(id: userId, login: true, user: _resource.data);
      await insertUserLogin(userLogin);
      return _resource;
    } else {
      final Completer<PsResource<User>> completer =
          Completer<PsResource<User>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<dynamic> getUserLoginFromDB(String loginUserId,
      StreamController<dynamic> userLoginStream, PsStatus status) async {
    final Finder finder = Finder(filter: Filter.equals('id', loginUserId));

    userLoginStream.sink
        .add(await _userLoginDao!.getOne(finder: finder, status: status));
  }

  Future<dynamic> getUserFromDB(String loginUserId,
      StreamController<dynamic> userStream, PsStatus status) async {
    final Finder finder =
        Finder(filter: Filter.equals(_userPrimaryKey, loginUserId));

    userStream.sink.add(await _userDao.getOne(finder: finder, status: status));
  }

  Future<PsResource<User>> postUserEmailVerify(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<User> _resource =
        await _psApiService.postUserEmailVerify(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      await _userLoginDao!.deleteAll();
      await insert(_resource.data!);
      final String userId = _resource.data!.userId!;
      final UserLogin userLogin =
          UserLogin(id: userId, login: true, user: _resource.data);
      await insertUserLogin(userLogin);
      return _resource;
    } else {
      final Completer<PsResource<User>> completer =
          Completer<PsResource<User>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<User>> postImageUpload(String userId, String platformName,
      File imageFile, bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<User> _resource =
        await _psApiService.postImageUpload(userId, platformName, imageFile);
    if (_resource.status == PsStatus.SUCCESS) {
      await insert(_resource.data!);
      final String userId = _resource.data!.userId!;
      final UserLogin userLogin =
          UserLogin(id: userId, login: true, user: _resource.data);
      await insertUserLogin(userLogin);
      return _resource;
    } else {
      final Completer<PsResource<User>> completer =
          Completer<PsResource<User>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<ApiStatus>> postDeleteUser(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postDeleteUser(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<ApiStatus>> postForgotPassword(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postForgotPassword(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<ApiStatus>> postChangePassword(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postChangePassword(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<User>> postProfileUpdate(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<User> _resource =
        await _psApiService.postProfileUpdate(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      await insert(_resource.data!);
      final String userId = _resource.data!.userId!;
      final UserLogin userLogin =
          UserLogin(id: userId, login: true, user: _resource.data);
      await insertUserLogin(userLogin);
      return _resource;
    } else {
      final Completer<PsResource<User>> completer =
          Completer<PsResource<User>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<User>> postPhoneLogin(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<User> _resource =
        await _psApiService.postPhoneLogin(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      await _userLoginDao!.deleteAll();
      await insert(_resource.data!);
      final String userId = _resource.data!.userId!;
      final UserLogin userLogin =
          UserLogin(id: userId, login: true, user: _resource.data);
      await insertUserLogin(userLogin);
      return _resource;
    } else {
      final Completer<PsResource<User>> completer =
          Completer<PsResource<User>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<User>> postUserFollow(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<User> _resource =
        await _psApiService.postUserFollow(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      await insert(_resource.data!);
      final String userId = _resource.data!.userId!;
      final UserLogin userLogin =
          UserLogin(id: userId, login: true, user: _resource.data);
      await insertUserLogin(userLogin);
      return _resource;
    } else {
      final Completer<PsResource<User>> completer =
          Completer<PsResource<User>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<User>> postFBLogin(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<User> _resource = await _psApiService.postFBLogin(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      await _userLoginDao!.deleteAll();
      await insert(_resource.data!);
      final String userId = _resource.data!.userId!;
      final UserLogin userLogin =
          UserLogin(id: userId, login: true, user: _resource.data);
      await insertUserLogin(userLogin);
      return _resource;
    } else {
      final Completer<PsResource<User>> completer =
          Completer<PsResource<User>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<User>> postGoogleLogin(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<User> _resource =
        await _psApiService.postGoogleLogin(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      await _userLoginDao!.deleteAll();
      await insert(_resource.data!);
      final String userId = _resource.data!.userId!;
      final UserLogin userLogin =
          UserLogin(id: userId, login: true, user: _resource.data);
      await insertUserLogin(userLogin);
      return _resource;
    } else {
      final Completer<PsResource<User>> completer =
          Completer<PsResource<User>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<User>> postAppleLogin(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<User> _resource =
        await _psApiService.postAppleLogin(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      await _userLoginDao!.deleteAll();
      await insert(_resource.data);
      final String? userId = _resource.data!.userId;
      final UserLogin userLogin =
          UserLogin(id: userId, login: true, user: _resource.data);
      await insertUserLogin(userLogin);
      return _resource;
    } else {
      final Completer<PsResource<User>> completer =
          Completer<PsResource<User>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<ApiStatus>> postResendCode(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postResendCode(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<dynamic> getUser(StreamController<PsResource<User>> userListStream,
      String loginUserId, bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('user_id', loginUserId));
    sinkUserDetailStream(
        userListStream, await _userDao.getOne(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<List<User>> _resource =
          await _psApiService.getUser(loginUserId);

      if (_resource.status == PsStatus.SUCCESS) {
        await _userDao.deleteWithFinder(finder);
        await _userDao.insertAll(_userPrimaryKey, _resource.data!);
        // UserLogin(loginUserId,true,_resource.data);
        sinkUserDetailStream(
            userListStream, await _userDao.getOne(finder: finder));
      }
    }
  }

//get own user data
  Future<dynamic> getMyUserData(
      StreamController<PsResource<UserLogin>> userListStream,
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    sinkUserLoginStream(
        userListStream, await _userLoginDao!.getOne(status: status));

    if (isConnectedToInternet) {
      final PsResource<User> _resource =
          await _psApiService.getUserDetail(jsonMap);

      if (_resource.status == PsStatus.SUCCESS) {
        await _userLoginDao!.deleteAll();
        await insert(_resource.data!);
        final String userId = _resource.data!.userId!;
        final UserLogin userLogin =
            UserLogin(id: userId, login: true, user: _resource.data);
        await insertUserLogin(userLogin);
        sinkUserLoginStream(userListStream, await _userLoginDao!.getOne());
      }
    }
  }

//get other user
  Future<dynamic> getOtherUserData(
      StreamController<PsResource<User>> userListStream,
      Map<dynamic, dynamic> jsonMap,
      String otherUserId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('user_id', otherUserId));
    sinkUserDetailStream(
        userListStream, await _userDao.getOne(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<User> _resource =
          await _psApiService.getUserDetail(jsonMap);

      if (_resource.status == PsStatus.SUCCESS) {
        await _userDao.deleteAll();
        await _userDao.insert(_userPrimaryKey, _resource.data!);
        sinkUserDetailStream(
            userListStream, await _userDao.getOne(finder: finder));
      }
    }
  }

  Future<PsResource<ApiStatus>> userReportItem(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.reportItem(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<ApiStatus>> blockUser(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.blockUser(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<ApiStatus>> postUnBlockUser(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postUnBlockUser(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<dynamic> getUserList(
      StreamController<PsResource<List<User>>> userListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      UserParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final UserMapDao userMapDao = UserMapDao.instance;

    // Load from Db and Send to UI
    sinkUserListStream(
        userListStream,
        await _userDao.getAllByMap(
            _userPrimaryKey, mapKey, paramKey, userMapDao, UserMap(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<User>> _resource =
          await _psApiService.getUserList(holder.toMap(), limit, offset);

      print('Param Key $paramKey');
      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<UserMap> userMapList = <UserMap>[];
        int i = 0;
        for (User data in _resource.data!) {
          userMapList.add(UserMap(
              id: data.userId! + paramKey,
              mapKey: paramKey,
              userId: data.userId,
              sorting: i++,
              addedDate: '2019'));
        }

        // Delete and Insert Map Dao
        print('Delete Key $paramKey');
        await userMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        print('Insert All Key $paramKey');
        await userMapDao.insertAll(_userPrimaryKey, userMapList);

        // Insert User
        await _userDao.insertAll(_userPrimaryKey, _resource.data!);
      }
      // Load updated Data from Db and Send to UI
      sinkUserListStream(
          userListStream,
          await _userDao.getAllByMap(
              _userPrimaryKey, mapKey, paramKey, userMapDao, UserMap()));
    }
  }

  Future<dynamic> getNextPageUserList(
      StreamController<PsResource<List<User>>> userListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      UserParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    final String paramKey = holder.getParamKey();
    final UserMapDao userMapDao = UserMapDao.instance;
    // Load from Db and Send to UI
    sinkUserListStream(
        userListStream,
        await _userDao.getAllByMap(
            _userPrimaryKey, mapKey, paramKey, userMapDao, UserMap(),
            status: status));
    if (isConnectedToInternet) {
      final PsResource<List<User>> _resource =
          await _psApiService.getUserList(holder.toMap(), limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<UserMap> userMapList = <UserMap>[];
        final PsResource<List<UserMap>>? existingMapList = await userMapDao
            .getAll(finder: Finder(filter: Filter.equals(mapKey, paramKey)));

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data!.length + 1;
        }
        for (User data in _resource.data!) {
          userMapList.add(UserMap(
              id: data.userId! + paramKey,
              mapKey: paramKey,
              userId: data.userId,
              sorting: i++,
              addedDate: '2019'));
        }

        await userMapDao.insertAll(_userPrimaryKey, userMapList);

        // Insert User
        await _userDao.insertAll(_userPrimaryKey, _resource.data!);
      }
      sinkUserListStream(
          userListStream,
          await _userDao.getAllByMap(
              _userPrimaryKey, mapKey, paramKey, userMapDao, UserMap()));
    }
  }

  Future<dynamic> getAgentList(
      StreamController<PsResource<List<User>>>? agentListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    agentListStream!.sink.add(await _userDao.getAll(status: status));

    final PsResource<List<User>> _resource =
        await _psApiService.getAgentList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      await _userDao.deleteAll();
      await _userDao.insertAll(_userPrimaryKey, _resource.data!);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _userDao.deleteAll();
      }
    }
    agentListStream.sink.add(await _userDao.getAll());
  }

  Future<dynamic> getNextPageAgentList(
      StreamController<PsResource<List<User>>> agentListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    agentListStream.sink.add(await _userDao.getAll(status: status));

    final PsResource<List<User>> _resource =
        await _psApiService.getAgentList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      _userDao
          .insertAll(_userPrimaryKey, _resource.data!)
          .then((dynamic data) async {
        agentListStream.sink.add(await _userDao.getAll());
      });
    } else {
      agentListStream.sink.add(await _userDao.getAll());
    }
  }

  // User Logout
  Future<PsResource<ApiStatus>> userLogout(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postUserLogout(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
