import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/blocked_user_dao.dart';
import 'package:flutteradhouse/viewobject/blocked_user.dart';
import 'package:sembast/sembast.dart';

import 'Common/ps_repository.dart';

class BlockedUserRepository extends PsRepository {
  BlockedUserRepository(
      {required PsApiService psApiService,
      required BlockedUserDao blockedUserDao}) {
    _psApiService = psApiService;
    _blockedUserDao = blockedUserDao;
  }

  String primaryKey = 'user_id';
 late PsApiService _psApiService;
 late BlockedUserDao _blockedUserDao;

  Future<dynamic> insert(BlockedUser blockedUser) async {
    return _blockedUserDao.insert(primaryKey, blockedUser);
  }

  Future<dynamic> update(BlockedUser blockedUser) async {
    return _blockedUserDao.update(blockedUser);
  }

  Future<dynamic> delete(BlockedUser blockedUser) async {
    return _blockedUserDao.delete(blockedUser);
  }

  Future<dynamic> postDeleteUserFromDB(
      StreamController<PsResource<List<BlockedUser>>> blockedUserListStream,
      String userId,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('user_id', userId));
    await _blockedUserDao.deleteWithFinder(finder);
    return blockedUserListStream.sink.add(await _blockedUserDao.getAll());
  }

  Future<dynamic> getAllBlockedUserList(
      StreamController<PsResource<List<BlockedUser>>> blogListStream,
      bool isConnectedToInternet,
      String loginUserId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    blogListStream.sink.add(await _blockedUserDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<BlockedUser>> _resource =
          await _psApiService.getBlockedUserList(loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _blockedUserDao.deleteAll();
        await _blockedUserDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _blockedUserDao.deleteAll();
        }
      }
      blogListStream.sink.add(await _blockedUserDao.getAll());
    }
  }

  Future<dynamic> getNextPageBlockedUserList(
      StreamController<PsResource<List<BlockedUser>>> blogListStream,
      bool isConnectedToInternet,
      String loginUserId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    blogListStream.sink.add(await _blockedUserDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<BlockedUser>> _resource =
          await _psApiService.getBlockedUserList(loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _blockedUserDao.insertAll(primaryKey, _resource.data!);
      }
      blogListStream.sink.add(await _blockedUserDao.getAll());
    }
  }
}
