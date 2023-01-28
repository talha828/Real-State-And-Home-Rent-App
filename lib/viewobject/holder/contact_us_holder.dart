import 'package:flutteradhouse/viewobject/common/ps_holder.dart' show PsHolder;

class ContactUsParameterHolder extends PsHolder<ContactUsParameterHolder> {
  ContactUsParameterHolder({
    required this.name,
    required this.email,
    required this.message,
    required this.phone,
  });

  final String? name;
  final String? email;
  final String? message;
  final String? phone;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['contact_name'] = name;
    map['contact_email'] = email;
    map['contact_message'] = message;
    map['contact_phone'] = phone;
    return map;
  }

  @override
  ContactUsParameterHolder fromMap(dynamic dynamicData) {
    return ContactUsParameterHolder(
      name: dynamicData['contact_name'],
      email: dynamicData['contact_email'],
      message: dynamicData['contact_message'],
      phone: dynamicData['contact_phone'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (name != '') {
      key += name!;
    }
    if (email != '') {
      key += email!;
    }
    if (message != '') {
      key += message!;
    }
    if (phone != '') {
      key += phone!;
    }

    return key;
  }
}
