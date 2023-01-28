import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/post_type_dao.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/post_type.dart';

class PostTypeRepository extends PsRepository {
  PostTypeRepository(
      {required PsApiService psApiService,
      required PostTypeDao postTypeDao}) {
    _psApiService = psApiService;
    _postTypeDao = postTypeDao;
  }

 late PsApiService _psApiService;
 late PostTypeDao _postTypeDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(PostType postType) async {
    return _postTypeDao.insert(_primaryKey, postType);
  }

  Future<dynamic> update(PostType postType) async {
    return _postTypeDao.update(postType);
  }

  Future<dynamic> delete(PostType postType) async {
    return _postTypeDao.delete(postType);
  }

  Future<dynamic> getPostTypeList(
      StreamController<PsResource<List<PostType>>> postTypeListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {

    postTypeListStream.sink.add(await _postTypeDao.getAll(status: status));

    final PsResource<List<PostType>> _resource =
        await _psApiService.getPostTypeList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      await _postTypeDao.deleteAll();
      await _postTypeDao.insertAll(_primaryKey, _resource.data!);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _postTypeDao.deleteAll();
      }
    }
    postTypeListStream.sink.add(await _postTypeDao.getAll());
  }

  Future<dynamic> getAllPostTypeList(
      StreamController<PsResource<List<PostType>>> postTypeListStream,
      bool isConnectedToIntenet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {

    postTypeListStream.sink.add(await _postTypeDao.getAll(status: status));

    final PsResource<List<PostType>> _resource =
        await _psApiService.getAllPostTypeList();

    if (_resource.status == PsStatus.SUCCESS) {
      await _postTypeDao.deleteAll();
      await _postTypeDao.insertAll(_primaryKey, _resource.data!);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _postTypeDao.deleteAll();
      }
    }
    postTypeListStream.sink.add(await _postTypeDao.getAll());
  }

  Future<dynamic> getNextPagePostTypeList(
      StreamController<PsResource<List<PostType>>> postTypeListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {

    postTypeListStream.sink.add(await _postTypeDao.getAll(status: status));

    final PsResource<List<PostType>> _resource =
        await _psApiService.getPostTypeList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      _postTypeDao
          .insertAll(_primaryKey, _resource.data!)
          .then((dynamic data) async {
        postTypeListStream.sink.add(await _postTypeDao.getAll());
      });
    } else {
      postTypeListStream.sink.add(await _postTypeDao.getAll());
    }
  }
}
