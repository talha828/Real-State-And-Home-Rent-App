

import 'dart:ui';

import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class Language extends PsObject<Language?> {
  Language({this.languageCode, this.countryCode, this.name});
  String? languageCode;
  String? countryCode;
  String? name;

  Locale toLocale() {
    return Locale(languageCode!, countryCode);
  }

  @override
  bool operator ==(dynamic other) =>
      other is Language && languageCode == other.languageCode;

  @override
  int get hashCode => hash2(languageCode.hashCode, languageCode.hashCode);

  @override
  String? getPrimaryKey() {
    return languageCode;
  }

  @override
  Language? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Language(
          languageCode: dynamicData['language_code'],
          countryCode: dynamicData['country_code'],
          name: dynamicData['name'],);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['language_code'] = object.languageCode;
      data['country_code'] = object.countryCode;
      data['name'] = object.name;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Language?> fromMapList(List<dynamic> dynamicDataList) {
    final List<Language?> psAppVersionList = <Language?>[];

    // if (dynamicDataList != null) {
    for (dynamic json in dynamicDataList) {
      if (json != null) {
        psAppVersionList.add(fromMap(json));
      }
    }
    // }
    return psAppVersionList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<Language?> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
    for (Language? data in objectList) {
      if (data != null) {
        mapList.add(toMap(data));
      }
    }
    return mapList;
  }
}
