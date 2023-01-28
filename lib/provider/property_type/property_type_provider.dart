import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/property_type_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/property_type_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/property_type.dart';

class PropertyTypeProvider extends PsProvider {
  PropertyTypeProvider(
      {required PropertyTypeRepository? repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }

    _repo = repo;

    print('PropertyTypeProvider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    propertyTypeListStream =
        StreamController<PsResource<List<PropertyType>>>.broadcast();
    subscription = propertyTypeListStream.stream
        .listen((PsResource<List<PropertyType>> resource) {
      updateOffset(resource.data!.length);

      _propertyTypeList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
 late StreamController<PsResource<List<PropertyType>>> propertyTypeListStream;
  final PropertyTypeParameterHolder propertyType = PropertyTypeParameterHolder();

  PropertyTypeRepository? _repo;
  PsValueHolder? psValueHolder;

  PsResource<List<PropertyType>> _propertyTypeList =
      PsResource<List<PropertyType>>(PsStatus.NOACTION, '', <PropertyType>[]);

  PsResource<List<PropertyType>> get propertyTypeList => _propertyTypeList;
 late StreamSubscription<PsResource<List<PropertyType>>> subscription;

  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _apiStatus;
  @override
  void dispose() {
    subscription.cancel();
    propertyTypeListStream.close();
    isDispose = true;
    print('PropertyTypeProvider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadPropertyTypeList(Map<dynamic, dynamic> jsonMap,String? loginUserId,) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (isConnectedToInternet) {
      await _repo!.getPropertyTypeList(propertyTypeListStream, isConnectedToInternet,jsonMap,loginUserId,
          limit, offset!, PsStatus.PROGRESS_LOADING);
    }
    return isConnectedToInternet;
  }

  Future<dynamic> nextPropertyTypeList(Map<dynamic, dynamic> jsonMap,String? loginUserId,) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo!.getNextPagePropertyTypeList(propertyTypeListStream,
          isConnectedToInternet,jsonMap,loginUserId, limit, offset!, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<dynamic> resetPropertyTypeList(Map<dynamic, dynamic> jsonMap,String? loginUserId,) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);
    if (isConnectedToInternet) {
      await _repo!.getPropertyTypeList(propertyTypeListStream, isConnectedToInternet,jsonMap,loginUserId,
          limit, offset!, PsStatus.PROGRESS_LOADING);
    }

    isLoading = false;
    return isConnectedToInternet;
  }

  Future<dynamic> postTouchCount(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.postTouchCount(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }


    Future<dynamic> postPropertySubscribe(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.postPropertySubscribe(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
