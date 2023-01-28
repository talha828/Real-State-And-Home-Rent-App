import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/amenities.dart';
import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:flutteradhouse/viewobject/item_currency.dart';
import 'package:flutteradhouse/viewobject/item_location_city.dart';
import 'package:flutteradhouse/viewobject/item_location_township.dart';
import 'package:flutteradhouse/viewobject/item_price_type.dart';
import 'package:flutteradhouse/viewobject/post_type.dart';
import 'package:flutteradhouse/viewobject/property_type.dart';
import 'package:flutteradhouse/viewobject/rating_detail.dart';
import 'package:flutteradhouse/viewobject/user.dart';
import 'package:quiver/core.dart';

import 'default_photo.dart';

class Product extends PsObject<Product> {
  Product(
      {this.id,
      this.itemCurrencyId,
      this.itemLocationCityId,
      this.itemLocationTownshipId,
      this.conditionOfItemId,
      this.propertyById,
      this.postedById,
      this.description,
      this.highlightInformation,
      this.price,
      this.isSoldOut,
      this.floorNo,
      this.itemPriceTypeId,
      this.title,
      this.address,
      this.area,
      this.lat,
      this.lng,
      this.status,
      this.addedDate,
      this.addedUserId,
      this.updatedDate,
      this.updatedUserId,
      this.updatedFlag,
      this.touchCount,
      this.favouriteCount,
      this.configuration,
      this.priceUnit,
      this.priceNote,
      this.isNegotiable,
      this.isPaid,
      this.dynamicLink,
      this.addedDateStr,
      this.paidStatus,
      this.photoCount,
      this.videoCount,
      this.defaultPhoto,
      this.video,
      this.videoThumbnail,
      this.postType,
      this.propertyType,
      this.itemCurrency,
      this.itemPriceType,
      this.itemLocationCity,
      this.itemLocationTownship,
      this.itemAmenitiesList,
      this.user,
      this.ratingDetail,
      this.isFavourited,
      this.isOwner,
      this.discountRate,
      this.discountedPrice,
      this.adType});

  String? id;
  String? itemCurrencyId;
  String? itemLocationCityId;
  String? itemLocationTownshipId;
  String? conditionOfItemId;
  String? propertyById;
  String? postedById;
  String? description;
  String? highlightInformation;
  String? price;
  String? isSoldOut;
  String? floorNo;
  String? itemPriceTypeId;
  String? title;
  String? address;
  String? area;
  String? lat;
  String? lng;
  String? status;
  String? addedDate;
  String? addedUserId;
  String? updatedDate;
  String? updatedUserId;
  String? updatedFlag;
  String? touchCount;
  String? favouriteCount;
  String? configuration;
  String? priceUnit;
  String? priceNote;
  String? isNegotiable;
  String? isPaid;
  String? dynamicLink;
  String? addedDateStr;
  String? paidStatus;
  String? photoCount;
  String? videoCount;
  String? isFavourited;
  String? isOwner;
  DefaultPhoto? defaultPhoto;
  DefaultPhoto? video;
  DefaultPhoto? videoThumbnail;
  PostType? postType;
  PropertyType? propertyType;
  ItemCurrency? itemCurrency;
  ItemPriceType? itemPriceType;
  ItemLocationCity? itemLocationCity;
  ItemLocationTownship? itemLocationTownship;
  List<Amenities>? itemAmenitiesList;
  User? user;
  RatingDetail? ratingDetail;
  String? discountRate;
  String? discountedPrice;
  String? adType;

  @override
  bool operator ==(dynamic other) => other is Product && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  Product fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return Product(
        id: dynamicData['id'],
        itemCurrencyId: dynamicData['item_currency_id'],
        itemLocationCityId: dynamicData['item_location_city_id'],
        itemLocationTownshipId: dynamicData['item_location_township_id'],
        conditionOfItemId: dynamicData['condition_of_item_id'],
        propertyById: dynamicData['property_by_id'],
        postedById: dynamicData['posted_by_id'],
        description: dynamicData['description'],
        highlightInformation: dynamicData['highlight_info'],
        price: dynamicData['price'],
        isSoldOut: dynamicData['is_sold_out'],
        floorNo: dynamicData['floor_no'],
        itemPriceTypeId: dynamicData['item_price_type_id'],
        title: dynamicData['title'],
        address: dynamicData['address'],
        area: dynamicData['area'],
        lat: dynamicData['lat'],
        lng: dynamicData['lng'],
        status: dynamicData['status'],
        addedDate: dynamicData['added_date'],
        addedUserId: dynamicData['added_user_id'],
        updatedDate: dynamicData['updated_date'],
        updatedUserId: dynamicData['updated_user_id'],
        updatedFlag: dynamicData['updated_flag'],
        touchCount: dynamicData['touch_count'],
        favouriteCount: dynamicData['favourite_count'],
        configuration: dynamicData['configuration'],
        priceUnit: dynamicData['price_unit'],
        priceNote: dynamicData['price_note'],
        isNegotiable: dynamicData['is_negotiable'],
        isPaid: dynamicData['is_paid'],
        dynamicLink: dynamicData['dynamic_link'],
        addedDateStr: dynamicData['added_date_str'],
        paidStatus: dynamicData['paid_status'],
        photoCount: dynamicData['photo_count'],
        videoCount: dynamicData['video_count'],
        defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
        video: DefaultPhoto().fromMap(dynamicData['default_video']),
        videoThumbnail: DefaultPhoto().fromMap(dynamicData['default_video_icon']),
        postType: PostType().fromMap(dynamicData['post_type']),
        propertyType: PropertyType().fromMap(dynamicData['property_type']),
        itemCurrency: ItemCurrency().fromMap(dynamicData['item_currency']),
        itemPriceType: ItemPriceType().fromMap(dynamicData['item_price_type']),
        itemLocationCity:
            ItemLocationCity().fromMap(dynamicData['item_location_city']),
        itemLocationTownship: ItemLocationTownship()
            .fromMap(dynamicData['item_location_township']),
        itemAmenitiesList: Amenities().fromMapList(dynamicData['amenities']),
        user: User().fromMap(dynamicData['user']),
        ratingDetail: RatingDetail().fromMap(dynamicData['rating_details']),
        isFavourited: dynamicData['is_favourited'],
        isOwner: dynamicData['is_owner'],
        discountRate: dynamicData['discount_rate_by_percentage'],
        discountedPrice: dynamicData['discounted_price'],
        adType: dynamicData['ad_type'],
      );
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['item_currency_id'] = object.itemCurrencyId;
      data['item_location_city_id'] = object.itemLocationCityId;
      data['item_location_township_id'] = object.itemLocationTownshipId;
      data['condition_of_item_id'] = object.conditionOfItemId;
      data['property_by_id'] = object.propertyById;
      data['posted_by_id'] = object.postedById;
      data['description'] = object.description;
      data['highlight_info'] = object.highlightInformation;
      data['price'] = object.price;
      data['is_sold_out'] = object.isSoldOut;
      data['floor_no'] = object.floorNo;
      data['item_price_type_id'] = object.itemPriceTypeId;
      data['title'] = object.title;
      data['address'] = object.address;
      data['area'] = object.area;
      data['lat'] = object.lat;
      data['lng'] = object.lng;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['touch_count'] = object.touchCount;
      data['favourite_count'] = object.favouriteCount;
      data['configuration'] = object.configuration;
      data['price_unit'] = object.priceUnit;
      data['price_note'] = object.priceNote;
      data['is_negotiable'] = object.isNegotiable;
      data['is_paid'] = object.isPaid;
      data['dynamic_link'] = object.dynamicLink;
      data['added_date_str'] = object.addedDateStr;
      data['paid_status'] = object.paidStatus;
      data['photo_count'] = object.photoCount;
      data['video_count'] = object.videoCount;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      data['default_video'] = DefaultPhoto().toMap(object.video);
      data['default_video_icon'] = DefaultPhoto().toMap(object.videoThumbnail);
      data['post_type'] = PostType().toMap(object.postType);
      data['property_type'] = PropertyType().toMap(object.propertyType);
      data['item_currency'] = ItemCurrency().toMap(object.itemCurrency);
      data['item_price_type'] = ItemPriceType().toMap(object.itemPriceType);
      data['item_location_city'] =
          ItemLocationCity().toMap(object.itemLocationCity);
      data['item_location_township'] =
          ItemLocationTownship().toMap(object.itemLocationTownship);
      data['amenities'] = Amenities().toMapList(object.itemAmenitiesList);
      data['user'] = User().toMap(object.user);
      data['rating_details'] = RatingDetail().toMap(object.ratingDetail);
      data['is_favourited'] = object.isFavourited;
      data['is_owner'] = object.isOwner;
      data['discount_rate_by_percentage'] = object.discountRate;
      data['discounted_price'] = object.discountedPrice;
      data['ad_type'] = object.adType;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Product> fromMapList(List<dynamic> dynamicDataList) {
    final List<Product> newFeedList = <Product>[];
    //if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          newFeedList.add(fromMap(json));
        }
      }
    //}
    return newFeedList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>?> dynamicList = <Map<String, dynamic>?>[];

    //if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
   //}
    return dynamicList;
  }

  List<Product> checkDuplicate(List<Product> dataList) {
    final Map<String?, String?> idCache = <String, String>{};
    final List<Product> _tmpList = <Product>[];
    for (int i = 0; i < dataList.length; i++) {
      if (idCache[dataList[i].id] == null) {
        _tmpList.add(dataList[i]);
        idCache[dataList[i].id] = dataList[i].id;
      } else {
        Utils.psPrint('Duplicate');
      }
    }

    return _tmpList;
  }

  bool isSame(List<Product> cache, List<Product> newList) {
    if (cache.length == newList.length) {
      bool status = true;
      for (int i = 0; i < cache.length; i++) {
        if (cache[i].id != newList[i].id) {
          status = false;
          break;
        }
      }

      return status;
    } else {
      return false;
    }
  }
}
