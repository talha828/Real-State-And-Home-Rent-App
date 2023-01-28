import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/product_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/common/ps_value_holder.dart';
import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';

class SearchProductProvider extends PsProvider {
  SearchProductProvider(
      {required ProductRepository? repo, this.psValueHolder, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('SearchProductProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      initSubscription();
    });

  }
  ProductRepository? _repo;
  PsValueHolder? psValueHolder;
  PsResource<List<Product>> _tempProductList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);
  PsResource<List<Product>> _productList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get productList => _productList;
  PsResource<List<Product>> get tempProductList => _tempProductList;
  StreamSubscription<PsResource<List<Product>>>? subscription;
  // ignore: close_sinks
  StreamController<PsResource<List<Product>>>? productListStream;
  bool needReset = true;
  dynamic daoSubscription;

      Future<void> initSubscription() async {
    if (productListStream != null) {
      await productListStream!.close();
    }
    if (subscription != null) {
      await subscription?.cancel();
    }

    productListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        productListStream!.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data!.length);

      _productList =
          PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

      print('**** SearchProductProvider ${resource.data!.length}');
      _tempProductList = resource;


            for (int i = 0; i < _tempProductList.data!.length; i++) {
        print('admob::::: index == $i,${_tempProductList.data![i].adType}');  
        if (_tempProductList.data![i].adType == PsConst.GOOGLE_AD_TYPE) {
          _productList.data!.add(Product(
              id: i.toString() + PsConst.ADMOB_FLAG,
              adType: _tempProductList.data![i].adType)); 
          print('admobindex == $i,${_tempProductList.data![i].adType}');     
        } 
        else {
          _productList.data!.add(_tempProductList.data![i]);
        }
      }

      // for (int i = 0; i < _tempProductList.data!.length; i++) {
      //   if (psValueHolder!.isShowAdmobInsideList! &&
      //       (i + 1) % int.parse(psValueHolder!.promoCellNo!) == 0) {

      //   if(psValueHolder!.adType == PsConst.PAID_AD ||  psValueHolder!.adType == PsConst.BUMBS_UP ||  psValueHolder!.adType == PsConst.NORMAL_AD || psValueHolder!.adType == PsConst.PAID_AD_GOOGLE_AD ){
      //     _productList.data!.add(_tempProductList.data![i]);
      //    }

      //     if(psValueHolder!.adType == PsConst.GOOGLE_AD ){
      //      _productList.data!.add(_tempProductList.data![i]);
      //     _productList.data!.add(
      //         Product(id: PsConst.ADMOB_FLAG + _tempProductList.data![i].id!));
      //     }

      //      if(psValueHolder!.adType == PsConst.PAID_AD_GOOGLE_AD &&  _tempProductList.data![i].adType! == 'google_ad'){
      //     _productList.data!.add(
      //         Product(id: PsConst.ADMOB_FLAG + _tempProductList.data![i].id!));
      //     }

      //     // _productList.data!.add(_tempProductList.data![i]);
      //     // _productList.data!.add(
      //     //     Product(id: PsConst.ADMOB_FLAG + _tempProductList.data![i].id!));


      //   } else {
      //     _productList.data!.add(_tempProductList.data![i]);
      //   }
      // }
      _productList.data = Product().checkDuplicate(_productList.data!);

      if (_productList.data == null ||
          _productList.data!.isEmpty ||
          _productList.status != PsStatus.SUCCESS) {
        _productList.status = resource.status;
        _productList.message = resource.message;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

late  ProductParameterHolder productParameterHolder;

  bool isSwitchedFeaturedProduct = false;
  bool isSwitchedDiscountPrice = false;

  String selectedPropertyName = '';
  String selectedPostedName = '';
  String selectedSoldOutName = '';
  String selectedAmenityName = '';
  String selectedLocationName = '';
  String selectedLocationTownshipName = '';

  String propertyById = '';
  String postedById = '';
  String isSoldOut = '';
  String amenityId = '';
  String locationId = '';
  String locationTownshipId = '';

  bool isfirstRatingClicked = false;
  bool isSecondRatingClicked = false;
  bool isThirdRatingClicked = false;
  bool isfouthRatingClicked = false;
  bool isFifthRatingClicked = false;

  String ?_itemLocationId ;
  @override
  void dispose() {
    subscription?.cancel();
    productListStream!.close();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('Search Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductListByKey(
      String loginUserId, ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    if (psValueHolder!.noFilterWithLocationOnMap!) {
      if (productParameterHolder.lat != '' &&
          productParameterHolder.lng != '' &&
          productParameterHolder.lat != null &&
          productParameterHolder.lng != null) {
        _itemLocationId = productParameterHolder.itemLocationCityId!;
        productParameterHolder.itemLocationCityId = '';
      } else {
        if ( _itemLocationId != '') {
          productParameterHolder.itemLocationCityId = _itemLocationId;
        }
      }
    }

       if (daoSubscription != null) {
      await daoSubscription.cancel();
    }
    await initSubscription();
    daoSubscription = await _repo!.subscribeProductList(
        productListStream!, PsStatus.PROGRESS_LOADING, productParameterHolder);
    await _repo!.getProductList(
        productListStream!,
        isConnectedToInternet,
        loginUserId,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING,
        productParameterHolder);
  }

  Future<dynamic> nextProductListByKey(
      String loginUserId, ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      if (psValueHolder!.noFilterWithLocationOnMap!) {
        if (productParameterHolder.lat != '' &&
            productParameterHolder.lng != '' &&
            productParameterHolder.lat != null &&
            productParameterHolder.lng != null) {
          _itemLocationId = productParameterHolder.itemLocationCityId!;
          productParameterHolder.itemLocationCityId = '';
        } else {
          if ( _itemLocationId != '') {
            productParameterHolder.itemLocationCityId = _itemLocationId;
          }
        }
      }

      await _repo!.getNextPageProductList(
          productListStream!,
          isConnectedToInternet,
          loginUserId,
          limit,
          offset!,
          PsStatus.PROGRESS_LOADING,
          productParameterHolder);
    }
  }

  Future<void> resetLatestProductList(
      String loginUserId, ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (psValueHolder!.noFilterWithLocationOnMap!) {
      if (productParameterHolder.lat != '' &&
          productParameterHolder.lng != '' &&
          productParameterHolder.lat != null &&
          productParameterHolder.lng != null) {
        _itemLocationId = productParameterHolder.itemLocationCityId!;
        productParameterHolder.itemLocationCityId = '';
      } else {
        if ( _itemLocationId != '') {
          productParameterHolder.itemLocationCityId = _itemLocationId;
        }
      }
    }

    updateOffset(0);

    isLoading = true;

        if (daoSubscription != null) {
      await daoSubscription.cancel();
    }
    await initSubscription();
    daoSubscription = await _repo!.subscribeProductList(
        productListStream!, PsStatus.PROGRESS_LOADING, productParameterHolder);
    await _repo!.getProductList(
        productListStream!,
        isConnectedToInternet,
        loginUserId,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING,
        productParameterHolder);
  }
}
