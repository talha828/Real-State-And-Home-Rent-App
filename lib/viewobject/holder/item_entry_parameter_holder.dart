import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class ItemEntryParameterHolder extends PsHolder<ItemEntryParameterHolder> {
  ItemEntryParameterHolder({
    this.title,
    this.description,
    this.area,
    this.address,
    this.configuration,
    this.highlightInfomation,
    this.floorNo,
    this.postedById,
    this.propertyById,
    this.itemPriceTypeId,
    this.price,
    this.discountRate,
    this.priceUnit,
    this.priceNote,
    this.isNegotiable,
    this.itemCurrencyId,
    this.itemLocationCityId,
    this.itemLocationTownshipId,
    this.latitude,
    this.longitude,
    this.amenityId,
    this.id,
    this.addedUserId,
  });

  final String? title;
  final String? description;
  final String? area;
  final String? address;
  final String? configuration;
  final String? highlightInfomation;
  final String? floorNo;
  final String? postedById;
  final String? propertyById;
  final String? itemPriceTypeId;
  final String? price;
  final String? discountRate;
  final String? priceUnit;
  final String? priceNote;
  final String? isNegotiable;
  final String? itemCurrencyId;
  final String? itemLocationCityId;
  final String? itemLocationTownshipId;
  final String? latitude;
  final String? longitude;
  final String? amenityId;
  final String? id;
  final String? addedUserId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['title'] = title;
    map['description'] = description;
    map['area'] = area;
    map['address'] = address;
    map['configuration'] = configuration;
    map['highlight_info'] = highlightInfomation;
    map['floor_no'] = floorNo;
    map['posted_by_id'] = postedById;
    map['property_by_id'] = propertyById;
    map['item_price_type_id'] = itemPriceTypeId;
    map['price'] = price;
    map['discount_rate_by_percentage'] = discountRate;
    map['price_unit'] = priceUnit;
    map['price_note'] = priceNote;
    map['is_negotiable'] = isNegotiable;
    map['item_currency_id'] = itemCurrencyId;
    map['item_location_city_id'] = itemLocationCityId;
    map['item_location_township_id'] = itemLocationTownshipId;
    map['lat'] = latitude;
    map['lng'] = longitude;
    map['amenities'] = amenityId;
    map['id'] = id;
    map['added_user_id'] = addedUserId;

    return map;
  }

  @override
  ItemEntryParameterHolder fromMap(dynamic dynamicData) {
    return ItemEntryParameterHolder(
      title: dynamicData['title'],
      description: dynamicData['description'],
      area: dynamicData['area'],
      address: dynamicData['address'],
      configuration: dynamicData['configuration'],
      highlightInfomation: dynamicData['highlight_info'],
      floorNo: dynamicData['floor_no'],
      postedById: dynamicData['posted_by_id'],
      propertyById: dynamicData['property_by_id'],
      itemPriceTypeId: dynamicData['item_price_type_id'],
      price: dynamicData['price'],
      discountRate: dynamicData['discount_rate_by_percentage'],
      priceUnit: dynamicData['price_unit'],
      priceNote: dynamicData['price_note'],
      isNegotiable: dynamicData['is_negotiable'],
      itemCurrencyId: dynamicData['item_currency_id'],
      itemLocationCityId: dynamicData['item_location_city_id'],
      itemLocationTownshipId: dynamicData['item_location_township_id'],
      latitude: dynamicData['lat'],
      longitude: dynamicData['lng'],
      amenityId: dynamicData['amenities'],
      id: dynamicData['id'],
      addedUserId: dynamicData['added_user_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (title != '') {
      key += title!;
    }
    if (description != '') {
      key += description!;
    }
    if (area != '') {
      key += area!;
    }
    if (address != '') {
      key += address!;
    }
    if (configuration != '') {
      key += configuration!;
    }
    if (highlightInfomation != '') {
      key += highlightInfomation!;
    }
    if (floorNo != '') {
      key += floorNo!;
    }
    if (postedById != '') {
      key += postedById!;
    }
    if (propertyById != '') {
      key += propertyById!;
    }
    if (itemPriceTypeId != '') {
      key += itemPriceTypeId!;
    }
    if (price != '') {
      key += price!;
    }
    if (discountRate != '') {
      key += discountRate!;
    }
    if (priceUnit != '') {
      key += priceUnit!;
    }
    if (priceNote != '') {
      key += priceNote!;
    }
    if (isNegotiable != '') {
      key += isNegotiable!;
    }
    if (itemCurrencyId != '') {
      key += itemCurrencyId!;
    }
    if (itemLocationCityId != '') {
      key += itemLocationCityId!;
    }
    if (itemLocationTownshipId != '') {
      key += itemLocationTownshipId!;
    }
    if (latitude != '') {
      key += latitude!;
    }
    if (longitude != '') {
      key += longitude!;
    }
    if (amenityId != '') {
      key += amenityId!;
    }
    if (id != '') {
      key += id!;
    }
    if (addedUserId != '') {
      key += addedUserId!;
    }

    return key;
  }
}
