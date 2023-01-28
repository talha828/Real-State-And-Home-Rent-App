
import 'package:flutteradhouse/viewobject/common/ps_holder.dart'
    show PsHolder;

class PropertySubscribeParameterHolder
    extends PsHolder<PropertySubscribeParameterHolder> {
  PropertySubscribeParameterHolder({
    required this.userId,
    required this.selectedpropertyId,
  });
  final String userId;
  final List<String?>  selectedpropertyId;
  
  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['user_id'] = userId;
    map['property_by_ids'] = selectedpropertyId;
    return map;
  }

  @override
  PropertySubscribeParameterHolder fromMap(dynamic dynamicData) {
    return PropertySubscribeParameterHolder(
      userId: dynamicData['user_id'],
      selectedpropertyId: dynamicData['property_by_ids'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
      if (selectedpropertyId.toString() != '') {
      key += selectedpropertyId.toString();
    }

    return key;
  }
}
