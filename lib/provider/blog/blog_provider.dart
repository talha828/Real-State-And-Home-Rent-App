import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/blog_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/blog.dart';
import 'package:flutteradhouse/viewobject/holder/blog_parameter_holder.dart';

class BlogProvider extends PsProvider {
  BlogProvider({required BlogRepository? repo, int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }
    _repo = repo;

    print('Blog Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    blogListStream = StreamController<PsResource<List<Blog>>>.broadcast();
    subscription =
        blogListStream.stream.listen((PsResource<List<Blog>> resource) {
      updateOffset(resource.data!.length);

      _blogList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  BlogRepository? _repo;
 late BlogParameterHolder blogParameterHolder = BlogParameterHolder();

  PsResource<List<Blog>> _blogList =
      PsResource<List<Blog>>(PsStatus.NOACTION, '', <Blog>[]);

  PsResource<List<Blog>> get blogList => _blogList;
 late StreamSubscription<PsResource<List<Blog>>> subscription;
 late StreamController<PsResource<List<Blog>>> blogListStream;
  @override
  void dispose() {
    subscription.cancel();
    blogListStream.close();
    isDispose = true;
    print('Blog Provider Dispose: $hashCode');
    super.dispose();
  }

    Future<dynamic> loadBlogList(
      String loginUserId, BlogParameterHolder blogParameterHolder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getAllBlogList(
        blogListStream,
        isConnectedToInternet,
        loginUserId,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING,
        blogParameterHolder);
  }


  Future<dynamic> nextBlogList(
      String loginUserId, BlogParameterHolder blogParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      // await _repo.getNextPageBlogList(blogListStream, isConnectedToInternet,
      //    limit, offset, PsStatus.PROGRESS_LOADING);
      await _repo!.getNextPageBlogList(
          blogListStream,
          isConnectedToInternet,
          loginUserId,
          limit,
          offset!,
          PsStatus.PROGRESS_LOADING,
          blogParameterHolder);
    }
  }

  Future<void> resetBlogList(
      String loginUserId, BlogParameterHolder blogParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getNextPageBlogList(
        blogListStream,
        isConnectedToInternet,
        loginUserId,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING,
        blogParameterHolder);

    isLoading = false;
  }
}
