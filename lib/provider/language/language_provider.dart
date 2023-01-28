


import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/language_repository.dart';
import 'package:flutteradhouse/viewobject/common/language.dart';

class LanguageProvider extends PsProvider {
  LanguageProvider({required LanguageRepository? repo, int limit = 0 }) : super(repo,limit) {
    _repo = repo;
    isDispose = false;
  }

  LanguageRepository? _repo;

  List<Language> _languageList = <Language>[];
  List<Language> get languageList => _languageList;

  List<String>? _excludedLanguageList = <String>[];
  List<String>? get excludedLanguageList => _excludedLanguageList;

  Language currentLanguage = PsConfig.defaultLanguage;
  String currentCountryCode = '';
  String currentLanguageName = '';

  @override
  void dispose() {
    isDispose = true;
    print('Language Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> addLanguage(Language language) async {
    currentLanguage = language;
    return await _repo!.addLanguage(language);
  }

  Future<void> replaceUserChangesLocalLanguage(bool flag) async {
    await _repo!.replaceUserChangesLocalLanguage(flag);
  }

  Future<void> replaceExcludedLanguages(List<Language?> languages) async {
    await _repo!.replaceExcludedLanguages(languages);
  }

  bool isUserChangesLocalLanguage() {
    return _repo!.isUserChangesLocalLanguage();
  }

  Language getLanguage() {
    currentLanguage = _repo!.getLanguage();
    return currentLanguage;
  }

  List<dynamic> getLanguageList() {
    _languageList = PsConfig.psSupportedLanguageList;
    // final List<String>? excludedLanguageCodes = _repo!.getExcludedLanguageCodes();
    // for (Language language in _languageList) {
    //   if (excludedLanguageCodes!.contains(language.languageCode)) {
    //     _languageList.remove(language);
    //   }
    // }
    return _languageList;
  }

  List<String>? getExcludedLanguageCodeList() {
    _excludedLanguageList = _repo!.getExcludedLanguageCodes();

    return _excludedLanguageList;
  }
}

