

import 'package:flutteradhouse/viewobject/common/ps_holder.dart'
    show PsHolder;

class ImageReorderParameterHolder extends PsHolder<ImageReorderParameterHolder> {
  ImageReorderParameterHolder({
    required this.imgId,
    required this.ordering, });

  final String? imgId;
  final String? ordering;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['img_id'] = imgId;
    map['ordering'] = ordering;

    return map;
  }

  @override
  ImageReorderParameterHolder fromMap(dynamic dynamicData) {
    return ImageReorderParameterHolder(
      imgId: dynamicData['img_id'],
      ordering: dynamicData['ordering'],
    );
  }

  Map<String, dynamic> toMapFromObject(ImageReorderParameterHolder obj){
    final Map<String, dynamic> map = <String, dynamic>{};

    map['img_id'] = imgId;
    map['ordering'] = ordering;

    return map;
  }

  List<Map<String, dynamic>> toMapList(List<ImageReorderParameterHolder?> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    for (ImageReorderParameterHolder? data in objectList) {
      if (data != null) {
        mapList.add(toMapFromObject(data));
      }
    }

    return mapList;
  }  

  @override
  String getParamKey() {
    String key = '';

    if (imgId != '') {
      key += imgId!;
    }
    if (ordering != '') {
      key += ordering!;
    }
    return key;
  }
}
