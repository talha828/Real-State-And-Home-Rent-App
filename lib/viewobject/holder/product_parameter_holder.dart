import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/viewobject/common/ps_holder.dart';

class ProductParameterHolder extends PsHolder<dynamic> {
  ProductParameterHolder() {
    searchTerm = '';
    itemCurrencyId = '';
    postedById = '';
    isSoldOut = '';
    propertyById = '';
    itemPriceTypeId = '';
    amenityId = '';
    itemLocationCityId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    status = '1';
    isDiscount = '';
  }

  String? searchTerm;
  String? itemCurrencyId;
  String? postedById;
  String? isSoldOut;
  String? propertyById;
  String? amenityId;
  String? itemPriceTypeId;
  String? itemLocationCityId;
  String? itemLocationName;
  String? itemLocationTownshipId;
  String? itemLocationTownshipName;
  String? maxPrice;
  String? minPrice;
  String? lat;
  String? lng;
  String? mile;
  String? orderBy;
  String? orderType;
  String? addedUserId;
  String? isPaid;
  String? status;
   String? isDiscount;

  bool isFiltered() {
    return !(
        // isAvailable == '' &&
        //   (isDiscount == '0' || isDiscount == '') &&
        //   (isFeatured == '0' || isFeatured == '') &&
        orderBy == '' &&
        orderType == '' &&
        minPrice == '' &&
        maxPrice == '' &&
        postedById == '' &&
        isSoldOut == '' &&
        amenityId == '' &&
        lat == '' &&
        lng == '' &&
        mile == '' &&
        searchTerm == '' );
  }

  // bool isCatAndSubCatFiltered() {
  //   return !(catId == '' && subCatId == '');
  // }

  ProductParameterHolder getRecentParameterHolder() {
    searchTerm = '';
    itemCurrencyId = '';
    postedById = '';
    isSoldOut = '';
    propertyById = '';
    amenityId = '';
    itemPriceTypeId = '';
    itemLocationName = '';
    itemLocationCityId = '';
    itemLocationTownshipId = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

      ProductParameterHolder getSoldOutParameterHolder() {
    searchTerm = '';
    itemCurrencyId = '';
    postedById = '';
    isSoldOut = '1';
    propertyById = '';
    amenityId = '';
    itemPriceTypeId = '';
    itemLocationName = '';
    itemLocationCityId = '';
    itemLocationTownshipId = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getNearestParameterHolder() {
    searchTerm = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getPaidItemParameterHolder() {
    searchTerm = '';
    itemCurrencyId = '';
    postedById = '';
    isSoldOut = '';
    propertyById = '';
    amenityId = '';
    itemPriceTypeId = '';
    itemLocationCityId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = PsConst.ONLY_PAID_ITEM;
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getPendingItemParameterHolder() {
    searchTerm = '';
    itemCurrencyId = '';
    postedById = '';
    isSoldOut = '';
    propertyById = '';
    amenityId = '';
    itemPriceTypeId = '';
    itemLocationCityId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '0';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getRejectedItemParameterHolder() {
    searchTerm = '';
    itemCurrencyId = '';
    postedById = '';
    isSoldOut = '';
    propertyById = '';
    amenityId = '';
    itemLocationCityId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '3';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getDisabledProductParameterHolder() {
    searchTerm = '';
    itemCurrencyId = '';
    postedById = '';
    isSoldOut = '';
    propertyById = '';
    amenityId = '';
    itemPriceTypeId = '';
    itemLocationCityId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '2';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getFeaturedParameterHolder() {
    searchTerm = '';
    itemCurrencyId = '';
    postedById = '';
    isSoldOut = '';
    propertyById = '';
    amenityId = '';
    itemPriceTypeId = '';
    itemLocationCityId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING_FEATURE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getPopularParameterHolder() {
    searchTerm = '';
    itemCurrencyId = '';
    postedById = '';
    isSoldOut = '';
    propertyById = '';
    amenityId = '';
    itemPriceTypeId = '';
    itemLocationCityId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING_TRENDING;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getLatestParameterHolder() {
    searchTerm = '';
    itemCurrencyId = '';
    postedById = '';
    isSoldOut = '';
    propertyById = '';
    amenityId = '';
    itemPriceTypeId = '';
    itemLocationCityId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

    ProductParameterHolder getDiscountParameterHolder() {
    searchTerm = '';
    itemCurrencyId = '';
    postedById = '';
    isSoldOut = '';
    propertyById = '';
    amenityId = '';
    itemPriceTypeId = '';
    itemLocationCityId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '1';

    return this;
  }


  ProductParameterHolder resetParameterHolder() {
    searchTerm = '';
    itemCurrencyId = '';
    postedById = '';
    isSoldOut = '';
    propertyById = '';
    amenityId = '';
    itemPriceTypeId = '';
    itemLocationCityId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['searchterm'] = searchTerm;
    map['item_currency_id'] = itemCurrencyId;
    map['posted_by_id'] = postedById;
    map['is_sold_out'] = isSoldOut;
    map['property_by_id'] = propertyById;
    map['amenity_id'] = amenityId;
    map['item_price_type_id'] = itemPriceTypeId;
    map['item_location_city_id'] = itemLocationCityId;
    map['item_location_township_id'] = itemLocationTownshipId;
    map['max_price'] = maxPrice;
    map['min_price'] = minPrice;
    map['lat'] = lat;
    map['lng'] = lng;
    map['miles'] = mile;
    map['added_user_id'] = addedUserId;
    map['ad_post_type'] = isPaid;
    map['order_by'] = orderBy;
    map['order_type'] = orderType;
    map['status'] = status;
     map['is_discount'] = isDiscount;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    searchTerm = '';
    searchTerm = '';
    itemCurrencyId = '';
    postedById = '';
    isSoldOut = '';
    propertyById = '';
    amenityId = '';
    itemPriceTypeId = '';
    itemLocationCityId = '';
    itemLocationTownshipId = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '';
    isDiscount = '';

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (searchTerm != '') {
      result += searchTerm! + ':';
    }
    if (itemCurrencyId != '') {
      result += itemCurrencyId! + ':';
    }
    if (propertyById != '') {
      result += propertyById! + ':';
    }
    if (postedById != '') {
      result += postedById! + ':';
    }
    if (isSoldOut != '') {
      result += isSoldOut! + ':';
    }
    if (amenityId != '') {
      result += amenityId! + ':';
    }
    if (itemPriceTypeId != '') {
      result += itemPriceTypeId! + ':';
    }
    if (itemLocationCityId != '') {
      result += itemLocationCityId! + ':';
    }
    if (itemLocationTownshipId != '') {
      result += itemLocationTownshipId! + ':';
    }
    if (maxPrice != '') {
      result += maxPrice! + ':';
    }
    if (minPrice != '') {
      result += minPrice! + ':';
    }
    if (lat != '') {
      result += lat! + ':';
    }
    if (lng != '') {
      result += lng! + ':';
    }
    if (mile != '') {
      result += mile! + ':';
    }
    if (addedUserId != '') {
      result += addedUserId! + ':';
    }
    if (status != '') {
      result += status! + ':';
    }
    if (isPaid != '') {
      result += isPaid! + ':';
    }
    if (orderBy != '') {
      result += orderBy !+ ':';
    }
    if (orderType != '') {
      result += orderType!;
    }
        if (isDiscount != '') {
      result += isDiscount!;
    }

    return result;
  }
}
