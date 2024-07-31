
import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/resources/langauge_manager.dart';
const String PREFS_KEY_LANG = "PREFS_KEY_LANG";
const String PREFS_KEY_USER_ID = "PREFS_KEY_USER_ID";
const String PREFS_KEY_COUNTRY_ID="PREFS_KEY_COUNTRY_ID";
const String PREFS_KEY_COUNTRY_CODE="PREFS_KEY_COUNTRY_CODE";
const String PREFS_KEY_CURRENCY_CODE="PREFS_KEY_CURRENCY_CODE";
const String PREFS_KEY_COUNTRY_EN_TITLE="PREFS_KEY_COUNTRY_EN_TITLE";
const String PREFS_KEY_COUNTRY_AR_TITLE="PREFS_KEY_COUNTRY_AR_TITLE";
const String PREFS_KEY_AREA_CODE="PREFS_KEY_AREA_CODE";
const String PREFS_KEY_FLAG="PREFS_KEY_FLAG";
const String PREFS_KEY_ONBOARDING_SCREEN_VIEWED =
    "PREFS_KEY_ONBOARDING_SCREEN_VIEWED";
const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";
const String PREFS_KEY_IS_ENABLED = "PREFS_KEY_IS_ENABLED";
class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(PREFS_KEY_LANG);
    print("mLanguahghe ---> ${language}");
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      // return default lang
      return LanguageType.ARABIC.getValue();
    }
  }
  Future<int> getUserId() async {
    int? userId = _sharedPreferences.getInt(PREFS_KEY_USER_ID);
    if (userId != null && userId!= 0 ) {
      return userId;
    } else {
      // return default lang
      return 0;
    }
  }


  Future<void> setEnabled(bool isEnabled) async {

    // set english
    _sharedPreferences.setBool(
        PREFS_KEY_IS_ENABLED, isEnabled);

  }

  Future<bool> getEnabled() async {
    bool? isEnabled = _sharedPreferences.getBool(PREFS_KEY_IS_ENABLED);
    if (isEnabled != null && isEnabled!= false ) {
      return isEnabled;
    } else {
      // return default lang
      return false;
    }
  }
  Future<void> setUserId(int userId) async {

      // set english
      _sharedPreferences.setInt(
          PREFS_KEY_USER_ID, userId);

  }
  Future<void> changeAppLanguage(BuildContext context) async {
    String currentLang = await getAppLanguage();
    Locale loc;
    if (currentLang == LanguageType.ARABIC.getValue()) {
      // set english
      _sharedPreferences.setString(
          PREFS_KEY_LANG, LanguageType.ENGLISH.getValue());
     loc = context.supportedLocales[0];
    } else {
      // set arabic
      _sharedPreferences.setString(
          PREFS_KEY_LANG, LanguageType.ARABIC.getValue());
       loc = context.supportedLocales[1];
    }



    await context.setLocale(loc);




  }



  Future<Locale> getLocal() async {
    String currentLang = await getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getValue()) {
      return ARABIC_LOCAL;
    } else {
      return ENGLISH_LOCAL;
    }
  }

  // on boarding

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED) ??
        false;
  }

  //login

  Future<void> setUserLoggedIn(bool isLoggedIN) async {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, isLoggedIN);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
  }

  Future<void> logout() async {
    _sharedPreferences.remove(PREFS_KEY_IS_USER_LOGGED_IN);
  }
}