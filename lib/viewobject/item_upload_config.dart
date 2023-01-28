import 'package:quiver/core.dart';
import 'common/ps_object.dart';


class ItemUploadConfig extends PsObject<ItemUploadConfig> {
  ItemUploadConfig({
     this.priceTypeId,
     this.conditionOfItemId,
     this.image,
     this.video,
     this.videoIcon,
     this.discountRate,
     this.highlightInfo,
     this.priceUnit,
     this.priceNote,
     this.configuration,
     this.area,
     this.isNegotiable,
     this.amenities,
     this.floorNo,
     this.address,
    
  });

  String? priceTypeId;
  String? conditionOfItemId;
  String? image;
  String? video;
  String? videoIcon;
  String? discountRate;
  String? highlightInfo;
  String? priceUnit;
  String? priceNote;
  String? configuration;
  String? area;
  String? isNegotiable; 
  String? amenities; 
  String? floorNo;
  String? address;



  @override
  bool operator ==(dynamic other) => other is ItemUploadConfig && priceTypeId == other.priceTypeId;

  @override
  int get hashCode => hash2(priceTypeId.hashCode, priceTypeId.hashCode);

  @override
  String? getPrimaryKey() {
    return priceTypeId;
  }

  @override
  ItemUploadConfig fromMap(dynamic dynamicData) {
    return ItemUploadConfig(
      priceTypeId: dynamicData['item_price_type_id'],
      conditionOfItemId: dynamicData['condition_of_item_id'],
      image: dynamicData['image'],
      video: dynamicData['video'],
      videoIcon: dynamicData['video_icon'],
      discountRate: dynamicData['discount_rate_by_percentage'],
      highlightInfo: dynamicData['highlight_info'],
      priceUnit: dynamicData['price_unit'],
      priceNote: dynamicData['price_note'],
      configuration: dynamicData['configuration'],
      area: dynamicData['area'],
      isNegotiable: dynamicData['is_negotiable'],
      amenities: dynamicData['amenities'],
      floorNo: dynamicData['floor_no'],
      address: dynamicData['address'],
     

    );
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
   if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};

      data['item_price_type_id'] = object.priceTypeId;
      data['condition_of_item_id'] = object.conditionOfItemId;
      data['image'] = object.image;
      data['video'] = object.video;
      data['video_icon'] = object.videoIcon;
      data['discount_rate_by_percentage'] = object.discountRate;
      data['highlight_info'] = object.highlightInfo; 
      data['price_unit'] = object.priceUnit; 
      data['price_note'] = object.priceNote; 
      data['configuration'] = object.configuration; 
      data['area'] = object.area; 
      data['is_negotiable'] =object.isNegotiable;
      data['amenities'] = object.amenities; 
      data['floor_no'] = object.floorNo; 
      data['address'] = object.address; 


      

      return data;
    } else {
      return null;
    }
  }
    
  @override
  List<ItemUploadConfig> fromMapList(List<dynamic> dynamicDataList) {
    final List<ItemUploadConfig> userLoginList = <ItemUploadConfig>[];

    // if (dynamicDataList != null) {
    for (dynamic dynamicData in dynamicDataList) {
      if (dynamicData != null) {
        userLoginList.add(fromMap(dynamicData));
      }
    }
    // }
    return userLoginList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>?> dynamicList = <Map<String, dynamic>?>[];
    // if (objectList != null) {
    for (dynamic data in objectList) {
      if (data != null) {
        dynamicList.add(toMap(data));
      }
    }
    // }
    return dynamicList;
  }

}