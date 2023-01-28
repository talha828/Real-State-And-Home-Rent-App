import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/common/ps_shared_preferences.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/common/language.dart';
import 'package:flutteradhouse/viewobject/common/language_value_holder.dart';

class LanguageRepository extends PsRepository {
  LanguageRepository({required PsSharedPreferences psSharedPreferences}) {
    _psSharedPreferences = psSharedPreferences;
  }

  final StreamController<PsLanguageValueHolder> _valueController =
      StreamController<PsLanguageValueHolder>();
  Stream<PsLanguageValueHolder> get psValueHolder => _valueController.stream;

late  PsSharedPreferences _psSharedPreferences;

  void loadLanguageValueHolder() {
    final String? _languageCodeKey = _psSharedPreferences.shared
        .getString(PsConst.LANGUAGE__LANGUAGE_CODE_KEY);
    final String? _countryCodeKey = _psSharedPreferences.shared
        .getString(PsConst.LANGUAGE__COUNTRY_CODE_KEY);
    final String? _languageNameKey = _psSharedPreferences.shared
        .getString(PsConst.LANGUAGE__LANGUAGE_NAME_KEY);

    _valueController.add(PsLanguageValueHolder(
      languageCode: _languageCodeKey,
      countryCode: _countryCodeKey,
      name: _languageNameKey,
    ));
  }

  Future<void> addLanguage(Language language) async {
    await _psSharedPreferences.shared
        .setString(PsConst.LANGUAGE__LANGUAGE_CODE_KEY, language.languageCode!);
    await _psSharedPreferences.shared
        .setString(PsConst.LANGUAGE__COUNTRY_CODE_KEY, language.countryCode!);
    await _psSharedPreferences.shared
        .setString(PsConst.LANGUAGE__LANGUAGE_NAME_KEY, language.name!);
    await _psSharedPreferences.shared.setString('locale',
        Locale(language.languageCode!, language.countryCode).toString());
    loadLanguageValueHolder();
  }


    Future<dynamic> replaceUserChangesLocalLanguage(bool flag) async {
    await _psSharedPreferences.shared.setBool(PsConst.USER_CHANGE_LOCAL_LANGUAGE, flag);
    loadLanguageValueHolder();
  }

  bool isUserChangesLocalLanguage() {
    return _psSharedPreferences.shared.getBool(PsConst.USER_CHANGE_LOCAL_LANGUAGE) ?? false;
  }

  Future<dynamic> replaceExcludedLanguages(List<Language?> languages) async {
    final List<String> languageCodeList = <String>[];
    for (Language? language in languages)
      languageCodeList.add(language!.languageCode ?? '');
    await _psSharedPreferences.shared.setStringList(PsConst.EXCLUDEDLANGUAGES, languageCodeList);
    loadLanguageValueHolder();
  }

  List<String>? getExcludedLanguageCodes() {
    return _psSharedPreferences.shared.getStringList(PsConst.EXCLUDEDLANGUAGES);
  }

  Language getLanguage() {
    final String? languageCode = _psSharedPreferences.shared
            .getString(PsConst.LANGUAGE__LANGUAGE_CODE_KEY) ??
        PsConfig.defaultLanguage.languageCode;
    final String? countryCode = _psSharedPreferences.shared
            .getString(PsConst.LANGUAGE__COUNTRY_CODE_KEY) ??
        PsConfig.defaultLanguage.countryCode;
    final String? languageName = _psSharedPreferences.shared
            .getString(PsConst.LANGUAGE__LANGUAGE_NAME_KEY) ??
        PsConfig.defaultLanguage.name;


    return Language(
        languageCode: languageCode,
        countryCode: countryCode,
        name: languageName);
  }
}
