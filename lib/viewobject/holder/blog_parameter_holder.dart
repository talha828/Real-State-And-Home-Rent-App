import 'package:flutteradhouse/viewobject/common/ps_holder.dart';

class BlogParameterHolder extends PsHolder<BlogParameterHolder> {
  BlogParameterHolder({
    this.searchTerm,
    this.cityId,
  });

  String? searchTerm;
  String? cityId;
  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['searchterm'] = searchTerm;
    map['city_id'] = cityId;

    return map;
  }

  @override
  BlogParameterHolder fromMap(dynamic dynamicData) {
    return BlogParameterHolder(
      searchTerm: dynamicData['searchterm'],
      cityId: dynamicData['city_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (searchTerm != '') {
      key += searchTerm!;
    }
    if (cityId != '') {
      key += cityId!;
    }
    return key;
  }
}