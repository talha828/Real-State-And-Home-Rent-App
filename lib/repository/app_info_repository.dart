import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/ps_app_info.dart';

class AppInfoRepository extends PsRepository {
  AppInfoRepository({
    required PsApiService psApiService,
  }) {
    _psApiService = psApiService;
  }
 late PsApiService _psApiService;

  Future<PsResource<PSAppInfo>> postDeleteHistory(Map<dynamic, dynamic> jsonMap,
      {bool isLoadFromServer = true}) async {
    final PsResource<PSAppInfo> _resource =
        await _psApiService.postPsAppInfo(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      if (_resource.data!.deleteObject!.isNotEmpty) {}
      return _resource;
    } else {
      final Completer<PsResource<PSAppInfo>> completer =
          Completer<PsResource<PSAppInfo>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
