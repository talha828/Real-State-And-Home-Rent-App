import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class AppSetting extends PsObject<AppSetting> {
  AppSetting({this.latitude, this.longitude, this.isSubLocation, this.isPaidApp,this.isBlockedDisabled,this.isPropertySubscribe,this.maxImageCount,this.adType,this.promoCellNo});
  String? latitude;
  String? longitude;
  String? isSubLocation;
  String? isPaidApp;
  String? isBlockedDisabled;
  String? isPropertySubscribe;
  String? maxImageCount;
  String? adType;
  String? promoCellNo;

  @override
  bool operator ==(dynamic other) =>
      other is AppSetting && latitude == other.latitude;

  @override
  int get hashCode => hash2(latitude.hashCode, latitude.hashCode);

  @override
  String? getPrimaryKey() {
    return latitude;
  }

  @override
  AppSetting fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return AppSetting(
          latitude: dynamicData['lat'],
          longitude: dynamicData['lng'],
          isSubLocation: dynamicData['is_sub_location'],
          isPaidApp: dynamicData['is_paid_app'],
          isBlockedDisabled: dynamicData['is_block_user'],
          isPropertySubscribe: dynamicData['is_propertyby_subscription'],
          maxImageCount: dynamicData['max_img_upload_of_item'],
          adType: dynamicData['ad_type'],
          promoCellNo: dynamicData['promo_cell_interval_no']);

    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['lat'] = object.latitude;
      data['lng'] = object.longitude;
      data['is_sub_location'] = object.isSubLocation;
      data['is_paid_app'] = object.isPaidApp;
      data['is_block_user'] = object.isBlockedDisabled;
      data['is_propertyby_subscription'] = object.isPropertySubscribe;
      data['max_img_upload_of_item'] = object.maxImageCount;
      data['ad_type'] = object.adType;
      data['promo_cell_interval_no'] = object.promoCellNo;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AppSetting> fromMapList(List<dynamic> dynamicDataList) {
    final List<AppSetting> appSettingList = <AppSetting>[];

    //if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          appSettingList.add(fromMap(json));
        }
      }
   // }
    return appSettingList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<AppSetting> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
   // if (objectList != null) {
      for (AppSetting? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
   // }

    return mapList;
  }
}
