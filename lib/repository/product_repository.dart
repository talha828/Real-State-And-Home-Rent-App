import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/favourite_product_dao.dart';
import 'package:flutteradhouse/db/follower_item_dao.dart';
import 'package:flutteradhouse/db/product_dao.dart';
import 'package:flutteradhouse/db/product_map_dao.dart';
import 'package:flutteradhouse/db/related_product_dao.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/favourite_product.dart';
import 'package:flutteradhouse/viewobject/follower_item.dart';
import 'package:flutteradhouse/viewobject/holder/mark_sold_out_item_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/product.dart';
import 'package:flutteradhouse/viewobject/product_map.dart';
import 'package:flutteradhouse/viewobject/related_product.dart';
import 'package:sembast/sembast.dart';

class ProductRepository extends PsRepository {
  ProductRepository(
      {required PsApiService psApiService, required ProductDao productDao}) {
    _psApiService = psApiService;
    _productDao = productDao;
  }
  String primaryKey = 'id';
  String mapKey = 'map_key';
  String addedUserIdKey = 'added_user_id';
  String collectionIdKey = 'collection_id';
 late PsApiService _psApiService;
 late ProductDao _productDao;

  void sinkProductListStream(
      StreamController<PsResource<List<Product>>>? productListStream,
      PsResource<List<Product>>? dataList) {
    if (dataList != null && productListStream != null) {
      productListStream.sink.add(dataList);
    }
  }

  void sinkFavouriteProductListStream(
      StreamController<PsResource<List<Product>>>? favouriteProductListStream,
      PsResource<List<Product>>? dataList) {
    if (dataList != null && favouriteProductListStream != null) {
      favouriteProductListStream.sink.add(dataList);
    }
  }

  void sinkFollowerItemListStream(
      StreamController<PsResource<List<Product>>>? followerItemListStream,
      PsResource<List<Product>>? dataList) {
    if (dataList != null && followerItemListStream != null) {
      followerItemListStream.sink.add(dataList);
    }
  }

  void sinkCollectionProductListStream(
      StreamController<PsResource<List<Product>>>? collectionProductListStream,
      PsResource<List<Product>>? dataList) {
    if (dataList != null && collectionProductListStream != null) {
      collectionProductListStream.sink.add(dataList);
    }
  }

  void sinkItemDetailStream(
      StreamController<PsResource<Product>>? itemDetailStream,
      PsResource<Product>? data) {
    if (data != null) {
      itemDetailStream!.sink.add(data);
    }
  }

  void sinkRelatedProductListStream(
      StreamController<PsResource<List<Product>>> ?relatedProductListStream,
      PsResource<List<Product>>? dataList) {
    if (dataList != null && relatedProductListStream != null) {
      relatedProductListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(Product product) async {
    return _productDao.insert(primaryKey, product);
  }

  Future<dynamic> update(Product product) async {
    return _productDao.update(product);
  }

  Future<dynamic> delete(Product product) async {
    return _productDao.delete(product);
  }

  Future<dynamic> getItemFromDB(String? itemId,
      StreamController<dynamic> itemStream, PsStatus status) async {
    final Finder finder = Finder(filter: Filter.equals(primaryKey, itemId));

    itemStream.sink
        .add(await _productDao.getOne(finder: finder, status: status));
  }

      Future<dynamic> subscribeProductList(
      StreamController<PsResource<List<Product>>> productListStream,
      PsStatus status,
      ProductParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    print('SearchProductProvider ' + paramKey);
    final ProductMapDao productMapDao = ProductMapDao.instance;

    // Load from Db and Send to UI
    final dynamic subscription = await _productDao.getAllWithSubscriptionByMap(
        primaryKey: primaryKey,
        mapKey: mapKey,
        paramKey: paramKey,
        mapDao: productMapDao,
        mapObj: ProductMap(),
        status: PsStatus.SUCCESS,
        onDataUpdated: (PsResource<List<Product>> resultList) {
          print('***<< Data Updated >>*** ' + paramKey);
          if ( status != PsStatus.NOACTION) {
            print(status);

            productListStream.sink.add(resultList);
          } else {
            print('No Action');
          }
        });

    return subscription;
  }

  Future<dynamic> getProductList(
      StreamController<PsResource<List<Product>>> productListStream,
      bool isConnectedToInternet,
      String loginUserId,
      int limit,
      int offset,
      PsStatus status,
      ProductParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final ProductMapDao productMapDao = ProductMapDao.instance;

    // Load from Db and Send to UI
    sinkProductListStream(
        productListStream,
        await _productDao.getAllByMap(
            primaryKey, mapKey, paramKey, productMapDao, ProductMap(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource = await _psApiService
          .getProductList(holder.toMap(), loginUserId, limit, offset);

      print('Param Key $paramKey');
      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ProductMap> productMapList = <ProductMap>[];
        int i = 0;
        for (Product data in _resource.data!) {
          productMapList.add(ProductMap(
              id: data.id! + paramKey,
              mapKey: paramKey,
              productId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        // Delete and Insert Map Dao
        print('Delete Key $paramKey');

        await productMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        print('Insert All Key $paramKey');
        await productMapDao.insertAll(primaryKey, productMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          print('delete all');
          await productMapDao.deleteWithFinder(
              Finder(filter: Filter.equals(mapKey, paramKey)));
        }
      }
      // Load updated Data from Db and Send to UI
      sinkProductListStream(
          productListStream,
          await _productDao.getAllByMap(
              primaryKey, mapKey, paramKey, productMapDao, ProductMap()));
    //   final dynamic subscription =
    //       await _productDao.getAllWithSubscriptionByMap(
    //           primaryKey: primaryKey,
    //           mapKey: mapKey,
    //           paramKey: paramKey,
    //           mapDao: productMapDao,
    //           mapObj: ProductMap(),
    //           status: PsStatus.SUCCESS,
    //           onDataUpdated: (PsResource<List<Product>> resultList) {
    //             print('***<< Data Updated >>***');
    //             if (status != null && status != PsStatus.NOACTION) {
    //               print(status);
    //               productListStream.sink.add(resultList);
    //             } else {
    //               print('No Action');
    //             }
    //           });

    //   return subscription;
   }
  }

  Future<dynamic> getNextPageProductList(
      StreamController<PsResource<List<Product>>> productListStream,
      bool isConnectedToInternet,
      String loginUserId,
      int limit,
      int offset,
      PsStatus status,
      ProductParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    final String paramKey = holder.getParamKey();
    final ProductMapDao productMapDao = ProductMapDao.instance;
    // Load from Db and Send to UI
    sinkProductListStream(
        productListStream,
        await _productDao.getAllByMap(
            primaryKey, mapKey, paramKey, productMapDao, ProductMap(),
            status: status));
    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource = await _psApiService
          .getProductList(holder.toMap(), loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ProductMap> productMapList = <ProductMap>[];
        final PsResource<List<ProductMap>>? existingMapList = await productMapDao
            .getAll(finder: Finder(filter: Filter.equals(mapKey, paramKey)));

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data!.length + 1;
        }
        for (Product data in _resource.data!) {
          productMapList.add(ProductMap(
              id: data.id! + paramKey,
              mapKey: paramKey,
              productId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        await productMapDao.insertAll(primaryKey, productMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      }
      sinkProductListStream(
          productListStream,
          await _productDao.getAllByMap(
              primaryKey, mapKey, paramKey, productMapDao, ProductMap()));
    }
  }

  Future<dynamic> getItemDetail(
      StreamController<PsResource<Product>> itemDetailStream,
      String? itemId,
      String? loginUserId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals(primaryKey, itemId));
    sinkItemDetailStream(itemDetailStream,
        await _productDao.getOne(status: status, finder: finder));

    if (isConnectedToInternet) {
      final PsResource<Product> _resource =
          await _psApiService.getItemDetail(itemId, loginUserId);

      if (_resource.status == PsStatus.SUCCESS) {
        // await _productDao.deleteWithFinder(finder);
        await _productDao.insert(primaryKey, _resource.data!);
      }
      // sinkItemDetailStream(
      //     itemDetailStream, await _productDao.getOne(finder: finder));

      final dynamic subscription = _productDao.getOneWithSubscription(
          status: PsStatus.SUCCESS,
          finder: finder,
          onDataUpdated: (Product product) {
            if (status != PsStatus.NOACTION) {
              print(status);
              itemDetailStream.sink
                  .add(PsResource<Product>(status, '', product));
            } else {
              print('No Action');
            }
          });

      return subscription;
    }
  }

  Future<dynamic> deleteLocalProductCacheById(
      StreamController<PsResource<Product>> itemDetailStream,
      String itemId,
      String loginUserId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final Finder finder = Finder(filter: Filter.equals(primaryKey, itemId));

    await _productDao.deleteWithFinder(finder);

    sinkItemDetailStream(
        itemDetailStream, await _productDao.getOne(finder: finder));
  }

  Future<dynamic> deleteLocalProductCacheByUserId(
      StreamController<PsResource<Product>> itemDetailStream,
      String loginUserId,
      String addedUserId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final Finder finder =
        Finder(filter: Filter.equals(addedUserIdKey, addedUserId));

    await _productDao.deleteWithFinder(finder);

    sinkItemDetailStream(
        itemDetailStream, await _productDao.getOne(finder: finder));
  }

  Future<dynamic> getItemDetailForFav(
      StreamController<PsResource<Product>> productDetailStream,
      String itemId,
      String loginUserId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals(primaryKey, itemId));

    if (isConnectedToInternet) {
      final PsResource<Product> _resource =
          await _psApiService.getItemDetail(itemId, loginUserId);

      if (_resource.status == PsStatus.SUCCESS) {
        // await _productDao.deleteWithFinder(finder);
        await _productDao.insert(primaryKey, _resource.data!);
        sinkItemDetailStream(
            productDetailStream, await _productDao.getOne(finder: finder));
      }
    }
  }

  Future<dynamic> getAllFavouritesList(
      StreamController<PsResource<List<Product>>> favouriteProductListStream,
      String? loginUserId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    // final String paramKey = holder.getParamKey();
    final FavouriteProductDao favouriteProductDao =
        FavouriteProductDao.instance;

    // Load from Db and Send to UI
    sinkFavouriteProductListStream(
        favouriteProductListStream,
        await _productDao.getAllByJoin(
            primaryKey, favouriteProductDao, FavouriteProduct(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource =
          await _psApiService.getFavouritesList(loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<FavouriteProduct> favouriteProductMapList =
            <FavouriteProduct>[];
        int i = 0;
        for (Product data in _resource.data!) {
          favouriteProductMapList.add(FavouriteProduct(
            id: data.id,
            sorting: i++,
          ));
        }

        // Delete and Insert Map Dao
        await favouriteProductDao.deleteAll();
        await favouriteProductDao.insertAll(
            primaryKey, favouriteProductMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          // Delete and Insert Map Dao
          await favouriteProductDao.deleteAll();
        }
      }
      // Load updated Data from Db and Send to UI
      sinkFavouriteProductListStream(
          favouriteProductListStream,
          await _productDao.getAllByJoin(
              primaryKey, favouriteProductDao, FavouriteProduct()));
    }
  }

  Future<dynamic> getNextPageFavouritesList(
      StreamController<PsResource<List<Product>>> favouriteProductListStream,
      String loginUserId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final FavouriteProductDao favouriteProductDao =
        FavouriteProductDao.instance;
    // Load from Db and Send to UI
    sinkFavouriteProductListStream(
        favouriteProductListStream,
        await _productDao.getAllByJoin(
            primaryKey, favouriteProductDao, FavouriteProduct(),
            status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource =
          await _psApiService.getFavouritesList(loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<FavouriteProduct> favouriteProductMapList =
            <FavouriteProduct>[];
        final PsResource<List<FavouriteProduct>>? existingMapList =
            await favouriteProductDao.getAll();

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data!.length + 1;
        }
        for (Product data in _resource.data!) {
          favouriteProductMapList.add(FavouriteProduct(
            id: data.id,
            sorting: i++,
          ));
        }

        await favouriteProductDao.insertAll(
            primaryKey, favouriteProductMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      }
      sinkFavouriteProductListStream(
          favouriteProductListStream,
          await _productDao.getAllByJoin(
              primaryKey, favouriteProductDao, FavouriteProduct()));
    }
  }

  Future<PsResource<Product>> postFavourite(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<Product> _resource =
        await _psApiService.postFavourite(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<Product>> completer =
          Completer<PsResource<Product>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<ApiStatus>> postTouchCount(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postTouchCount(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<dynamic> getRelatedProductList(
      StreamController<PsResource<List<Product>>> relatedProductListStream,
      String productId,
      String categoryId,
      String loginUserId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final RelatedProductDao relatedProductDao = RelatedProductDao.instance;

    // Load from Db and Send to UI
    sinkRelatedProductListStream(
        relatedProductListStream,
        await _productDao.getAllByJoin(
            primaryKey, relatedProductDao, RelatedProduct(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource =
          await _psApiService.getRelatedProductList(
              productId, categoryId, loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<RelatedProduct> relatedProductMapList = <RelatedProduct>[];
        int i = 0;
        for (Product data in _resource.data!) {
          relatedProductMapList.add(RelatedProduct(
            id: data.id,
            sorting: i++,
          ));
        }

        // Delete and Insert Map Dao
        await relatedProductDao.deleteAll();
        await relatedProductDao.insertAll(primaryKey, relatedProductMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          // Delete and Insert Map Dao
          await relatedProductDao.deleteAll();
        }
      }
      // Load updated Data from Db and Send to UI
      sinkRelatedProductListStream(
          relatedProductListStream,
          await _productDao.getAllByJoin(
              primaryKey, relatedProductDao, RelatedProduct()));
    }
  }

  Future<dynamic> getAllItemListFromFollower(
      StreamController<PsResource<List<Product>>> itemListFromFollowersStream,
      bool isConnectedToInternet,
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final FollowerItemDao followerItemDao = FollowerItemDao.instance;

    // Load from Db and Send to UI
    sinkFollowerItemListStream(
        itemListFromFollowersStream,
        await _productDao.getAllByJoin(
            primaryKey, followerItemDao, FollowerItem(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource = await _psApiService
          .getAllItemListFromFollower(jsonMap, loginUserId, limit, offset);
      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<FollowerItem> followerItemMapList = <FollowerItem>[];
        int i = 0;
        for (Product data in _resource.data!) {
          followerItemMapList.add(FollowerItem(
            id: data.id,
            sorting: i++,
          ));
        }

        // Delete and Insert Map Dao
        await followerItemDao.deleteAll();
        await followerItemDao.insertAll(primaryKey, followerItemMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          // Delete and Insert Map Dao
          await followerItemDao.deleteAll();
        }
      }
      // Load updated Data from Db and Send to UI
      // sinkFollowerItemListStream(
      //     itemListFromFollowersStream,
      //     await _productDao.getAllByJoin(
      //         primaryKey, followerItemDao, FollowerItem()));

      final dynamic subscription =
          await _productDao.getAllWithSubscriptionByJoin(
              primaryKey: primaryKey,
              mapDao: followerItemDao,
              mapObj: FollowerItem(),
              status: PsStatus.SUCCESS,
              onDataUpdated: (PsResource<List<Product>> resultList) {
                print('***<< Data Updated >>***');
                if (status != PsStatus.NOACTION) {
                  print(status);
                  itemListFromFollowersStream.sink.add(resultList);
                } else {
                  print('No Action');
                }
              });

      return subscription;
    }
  }

  Future<dynamic> getNextPageItemListFromFollower(
      StreamController<PsResource<List<Product>>> itemListFromFollowersStream,
      bool isConnectedToInternet,
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final FollowerItemDao followerItemDao = FollowerItemDao.instance;
    // Load from Db and Send to UI
    sinkFollowerItemListStream(
        itemListFromFollowersStream,
        await _productDao.getAllByJoin(
            primaryKey, followerItemDao, FollowerItem(),
            status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource = await _psApiService
          .getAllItemListFromFollower(jsonMap, loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<FollowerItem> followerItemMapList = <FollowerItem>[];
        final PsResource<List<FollowerItem>>? existingMapList =
            await followerItemDao.getAll();

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data!.length + 1;
        }
        for (Product data in _resource.data!) {
          followerItemMapList.add(FollowerItem(
            id: data.id,
            sorting: i++,
          ));
        }

        await followerItemDao.insertAll(primaryKey, followerItemMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      }
      sinkFavouriteProductListStream(
          itemListFromFollowersStream,
          await _productDao.getAllByJoin(
              primaryKey, followerItemDao, FollowerItem()));
    }
  }

  Future<dynamic> getItemListByUserId(
      StreamController<PsResource<List<Product>>> productListStream,
      String loginUserId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      ProductParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final ProductMapDao productMapDao = ProductMapDao.instance;

    // Load from Db and Send to UI
    sinkProductListStream(
        productListStream,
        await _productDao.getAllByMap(
            primaryKey, mapKey, paramKey, productMapDao, ProductMap(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource = await _psApiService
          .getItemListByUserId(holder.toMap(), loginUserId, limit, offset);

      print('Param Key $paramKey');
      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ProductMap> productMapList = <ProductMap>[];
        int i = 0;
        for (Product data in _resource.data!) {
          productMapList.add(ProductMap(
              id: data.id! + paramKey,
              mapKey: paramKey,
              productId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        // Delete and Insert Map Dao
        print('Delete Key $paramKey');
        await productMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        print('Insert All Key $paramKey');

        await productMapDao.insertAll(primaryKey, productMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          // Delete and Insert Map Dao
          await productMapDao.deleteWithFinder(
              Finder(filter: Filter.equals(mapKey, paramKey)));
        }
      }

      final dynamic subscription =
          await _productDao.getAllWithSubscriptionByMap(
              primaryKey: primaryKey,
              mapKey: mapKey,
              paramKey: paramKey,
              mapDao: productMapDao,
              mapObj: ProductMap(),
              status: PsStatus.SUCCESS,
              onDataUpdated: (PsResource<List<Product>> resultList) {
                print('***<< Data Updated >>***');
                if ( status != PsStatus.NOACTION) {
                  print(status);
                  productListStream.sink.add(resultList);
                } else {
                  print('No Action');
                }
              });

      return subscription;
    }
  }

  Future<dynamic> getNextPageItemListByUserId(
      StreamController<PsResource<List<Product>>> productListStream,
      String loginUserId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      ProductParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    final String paramKey = holder.getParamKey();
    final ProductMapDao productMapDao = ProductMapDao.instance;
    // Load from Db and Send to UI
    sinkProductListStream(
        productListStream,
        await _productDao.getAllByMap(
            primaryKey, mapKey, paramKey, productMapDao, ProductMap(),
            status: status));
    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource = await _psApiService
          .getItemListByUserId(holder.toMap(), loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ProductMap> productMapList = <ProductMap>[];
        final PsResource<List<ProductMap>>? existingMapList = await productMapDao
            .getAll(finder: Finder(filter: Filter.equals(mapKey, paramKey)));

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data!.length + 1;
        }
        for (Product data in _resource.data!) {
          productMapList.add(ProductMap(
              id: data.id! + paramKey,
              mapKey: paramKey,
              productId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        await productMapDao.insertAll(primaryKey, productMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      }
      sinkProductListStream(
          productListStream,
          await _productDao.getAllByMap(
              primaryKey, mapKey, paramKey, productMapDao, ProductMap()));
    }
  }

  /// Mark As sold
  Future<dynamic> markSoldOutItem(
      StreamController<PsResource<Product>> markSoldOutStream,
      String loginUserId,
      bool isConnectedToInternet,
      PsStatus status,
      MarkSoldOutItemParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    sinkItemDetailStream(
        markSoldOutStream, await _productDao.getOne(status: status));

    if (isConnectedToInternet) {
      final PsResource<Product> _resource =
          await _psApiService.markSoldOutItem(holder.toMap(), loginUserId);

      if (_resource.status == PsStatus.SUCCESS) {
        //await _productDao.deleteAll();
        await _productDao.update(_resource.data!);
        sinkItemDetailStream(markSoldOutStream, await _productDao.getOne());
      }
    }
  }

  Future<PsResource<Product>> postItemEntry(Map<dynamic, dynamic> jsonMap,String loginuserId,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<Product> _resource =
        await _psApiService.postItemEntry(jsonMap,loginuserId);

    if (_resource.status == PsStatus.SUCCESS) {
      await insert(_resource.data!);
      return _resource;
    } else {
      final Completer<PsResource<Product>> completer =
          Completer<PsResource<Product>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  ///
  /// For Delete item
  ///
  Future<PsResource<ApiStatus>> userDeleteItem(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.deleteItem(jsonMap);
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
