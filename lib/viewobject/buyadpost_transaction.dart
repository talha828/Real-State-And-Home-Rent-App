import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:flutteradhouse/viewobject/package.dart';
import 'package:flutteradhouse/viewobject/user.dart';
import 'package:quiver/core.dart';


class PackageTransaction extends PsObject<PackageTransaction> {
  PackageTransaction({
    this.id,
    this.userId,
    this.packageId,
    this.packageMethod,
    this.price,
    this.razorId,
    this.isPayStack,
    this.addedDate,
    this.addedDateStr,
    this.user,
    this.package
  });

  String? id;
  String? userId;
  String? packageId;
  String? packageMethod;
  String? price;
  String? razorId;
  String? isPayStack;
  String? addedDate;
  String? addedDateStr;
  User? user;
  Package? package;

  @override
  bool operator ==(dynamic other) => other is PackageTransaction && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  PackageTransaction fromMap(dynamic dynamicData) {
    // if (dynamicData != null) {
    return PackageTransaction(
      id : dynamicData['id'],
      userId: dynamicData['user_id'],
      packageId: dynamicData['package_id'],
      packageMethod: dynamicData['payment_method'],
      price: dynamicData['price'],
      razorId: dynamicData['razor_id'],
      isPayStack: dynamicData['isPaystack'],
      addedDate: dynamicData['added_date'],
      addedDateStr: dynamicData['added_date_str'],
      user : User().fromMap(dynamicData['user'],),
      package : Package().fromMap(dynamicData['package']),
    );
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(PackageTransaction? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['user_id'] = object.userId;
      data['package_id'] = object.packageId;
      data['payment_method'] = object.packageMethod;
      data['price'] = object.price;
      data['razor_id'] = object.razorId;
      data['isPaystack'] = object.isPayStack;
      data['added_date'] = object.addedDate;
      data['added_date_str'] = object.addedDateStr;
      data['user'] = User().toMap(object.user as User);
      data['package'] = Package().toMap(object.package as Package);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<PackageTransaction> fromMapList(List<dynamic> dynamicDataList) {
    final List<PackageTransaction> blogList = <PackageTransaction>[];

    for (dynamic dynamicData in dynamicDataList) {
      if (dynamicData != null) {
        blogList.add(fromMap(dynamicData));
      }
    }
    return blogList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<PackageTransaction?> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
    for (PackageTransaction? data in objectList) {
      if (data != null) {
        mapList.add(toMap(data));
      }
    }
    return mapList;
  }
}
