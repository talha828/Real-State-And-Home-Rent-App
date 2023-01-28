import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/user_dao.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/user.dart';

class AgentRepository extends PsRepository {
  AgentRepository(
      {required PsApiService psApiService, required UserDao userDao}) {
    _psApiService = psApiService;
    _userDao = userDao;
  }

 late PsApiService _psApiService;
 late UserDao _userDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(User user) async {
    return _userDao.insert(_primaryKey, user);
  }

  Future<dynamic> update(User user) async {
    return _userDao.update(user);
  }

  Future<dynamic> delete(User user) async {
    return _userDao.delete(user);
  }

  Future<dynamic> getAgentList(
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
      await _userDao.deleteAll();
      await _userDao.insertAll(_primaryKey, _resource.data!);
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
    // final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));

    agentListStream.sink.add(await _userDao.getAll(status: status));

    final PsResource<List<User>> _resource =
        await _psApiService.getAgentList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      _userDao
          .insertAll(_primaryKey, _resource.data!)
          .then((dynamic data) async {
        agentListStream.sink.add(await _userDao.getAll());
      });
    } else {
      agentListStream.sink.add(await _userDao.getAll());
    }
  }
}
