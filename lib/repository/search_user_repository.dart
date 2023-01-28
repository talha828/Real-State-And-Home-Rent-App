import 'dart:async';

import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/user_dao.dart';
import 'package:flutteradhouse/viewobject/user.dart';

import 'Common/ps_repository.dart';

class SearchUserRepository extends PsRepository {
  SearchUserRepository(
      {required PsApiService psApiService, required UserDao userDao}) {
    _psApiService = psApiService;
    _userDao = userDao;
  }

  String primaryKey = 'user_id';
  String mapKey = 'map_key';
  late PsApiService _psApiService;
  late UserDao _userDao;

  void sinkSearchUserListStream(
      StreamController<PsResource<List<User>>>? searchUserListStream,
      PsResource<List<User>> dataList) {
    if (searchUserListStream != null) {
      searchUserListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(User user) async {
    return _userDao.insert(primaryKey, user);
  }

  Future<dynamic> update(User user) async {
    return _userDao.update(user);
  }

  Future<dynamic> delete(User user) async {
    return _userDao.delete(user);
  }

  Future<dynamic> getSearchUserList(
      StreamController<PsResource<List<User>>>? searchUserListStream,
      bool isConnectedToInternet,
      Map<dynamic, dynamic> jsonMap,
      String? loginUserId,
      int limit,
      int? offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkSearchUserListStream(
        searchUserListStream, await _userDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<User>> _resource = await _psApiService
          .getSearchUserList(jsonMap, loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Delete and Insert Map Dao
        await _userDao.deleteAll();

        // Insert User
        await _userDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          print('delete all');
          await _userDao.deleteAll();
        }
      }
      // Load updated Data from Db and Send to UI
      sinkSearchUserListStream(searchUserListStream, await _userDao.getAll());
    }
  }

  Future<dynamic> getNextPageSearchUserList(
      StreamController<PsResource<List<User>>>? searchUserListStream,
      bool isConnectedToInternet,
      Map<dynamic, dynamic> jsonMap,
      String? loginUserId,
      int limit,
      int? offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkSearchUserListStream(
        searchUserListStream, await _userDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<User>> _resource = await _psApiService
          .getSearchUserList(jsonMap, loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _userDao.getAll();

        await _userDao.insertAll(primaryKey, _resource.data!);
      }
      sinkSearchUserListStream(searchUserListStream, await _userDao.getAll());
    }
  }

}
