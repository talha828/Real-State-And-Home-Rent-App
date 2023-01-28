import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/post_type_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/post_type.dart';

class PostTypeProvider extends PsProvider {
  PostTypeProvider({required PostTypeRepository? repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('PostTypeProvider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    postTypeListStream =
        StreamController<PsResource<List<PostType>>>.broadcast();
    subscription = postTypeListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _postTypeList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

 late StreamController<PsResource<List<PostType>>> postTypeListStream;
  PostTypeRepository? _repo;

  PsResource<List<PostType>> _postTypeList =
      PsResource<List<PostType>>(PsStatus.NOACTION, '', <PostType>[]);

  PsResource<List<PostType>> get postTypeList => _postTypeList;
late  StreamSubscription<PsResource<List<PostType>>> subscription;

  ProductParameterHolder postTypeParamenterHolder =
      ProductParameterHolder().getLatestParameterHolder();

  @override
  void dispose() {
    subscription.cancel();
    postTypeListStream.close();
    isDispose = true;
    print('SubCategory Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadPostTypeList() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getPostTypeList(
      postTypeListStream,
      isConnectedToInternet,
      limit,
      offset!,
      PsStatus.PROGRESS_LOADING,
    );
  }

  Future<dynamic> loadAllPostTypeList() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getAllPostTypeList(
        postTypeListStream, isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextPostTypeList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPagePostTypeList(
        postTypeListStream,
        isConnectedToInternet,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING,
      );
    }
  }

  Future<void> resetPostTypeList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo!.getPostTypeList(
      postTypeListStream,
      isConnectedToInternet,
      limit,
      offset!,
      PsStatus.PROGRESS_LOADING,
    );

    isLoading = false;
  }
}
