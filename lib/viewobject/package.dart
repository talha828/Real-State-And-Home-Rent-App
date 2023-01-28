import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:flutteradhouse/viewobject/item_currency.dart';
import 'package:quiver/core.dart';


class Package extends PsObject<Package> {
  Package({
    this.packageId,
    this.title,
    this.price,
    this.currencyId,
    this.postCount,
    this.status,
    this.addedDate,
    this.addedDateStr,
    this.iapId,
    this.platform,
    this.currency
  });

  String? packageId;
  String? title;
  String? price;
  String? currencyId;
  String? postCount;
  String? status;
  String? addedDate;
  String? addedDateStr;
  String? iapId;
  String? platform;
  ItemCurrency? currency;

  @override
  bool operator ==(dynamic other) => other is Package && packageId == other.packageId;

  @override
  int get hashCode {
    return hash2(packageId.hashCode, packageId.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return packageId;
  }

  @override
  Package fromMap(dynamic dynamicData) {
    // if (dynamicData != null) {
    return Package(
      packageId : dynamicData['package_id'],
      title: dynamicData['title'],
      price: dynamicData['price'],
      currencyId: dynamicData['currency_id'],
      postCount: dynamicData['post_count'],
      status: dynamicData['status'],
      addedDate: dynamicData['added_date'],
      addedDateStr: dynamicData['added_date_str'],
      iapId: dynamicData['package_in_app_purchased_prd_id'],
      platform: dynamicData['type'],
      currency : ItemCurrency().fromMap(dynamicData['currency']),
    );
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(Package? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['package_id'] = object.packageId;
      data['title'] = object.title;
      data['price'] = object.price;
      data['currency_id'] = object.currencyId;
      data['post_count'] = object.postCount;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_date_str'] = object.addedDateStr;
      data['package_in_app_purchased_prd_id'] = object.iapId;
      data['type'] = object.platform;
      data['currency'] = ItemCurrency().toMap(object.currency);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Package> fromMapList(List<dynamic> dynamicDataList) {
    final List<Package> blogList = <Package>[];

    for (dynamic dynamicData in dynamicDataList) {
      if (dynamicData != null) {
        blogList.add(fromMap(dynamicData));
      }
    }
    return blogList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<Package?> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
    for (Package? data in objectList) {
      if (data != null) {
        mapList.add(toMap(data));
      }
    }
    return mapList;
  }
}
