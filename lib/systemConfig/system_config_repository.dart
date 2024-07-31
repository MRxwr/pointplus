import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';

import 'package:point/systemConfig/system_config_exception.dart';

import '../app/error_message_keys.dart';
import 'model/supportedQuestionLanguage.dart';
import 'model/systemConfigModel.dart';

class SystemConfigRepository {
  SystemConfigRepository();






  Future<SystemConfigModel> getSystemConfig(String fileName) async {
    try {
      final result =await rootBundle.loadString(fileName);
      log(name: 'System Config', result.toString());
      final results = (jsonDecode(result) as Map)['data'];
      return SystemConfigModel.fromJson(results);
    } catch (e) {
      log(name: 'System Config Exception', e.toString());
      throw SystemConfigException(errorMessageCode: e.toString());
    }
  }

  Future<List<SupportedLanguage>> getSupportedQuestionLanguages(String fileName) async {
    try {
      final result =await rootBundle.loadString(fileName);
      log(name: 'System Config', result.toString());
      final results = (jsonDecode(result) as Map)['data'] as List;
      return results
          .map((e) => SupportedLanguage.fromJson(Map.from(e)))
          .toList();
    } catch (e) {
      throw SystemConfigException(errorMessageCode: e.toString());
    }
  }



  Future<List<String>> getImagesFromFile(String fileName) async {
    try {
      final result = await rootBundle.loadString(fileName);
      final images = (jsonDecode(result) as Map)['images'] as List;
      return images.map((e) => e.toString()).toList();
    } catch (e) {
      throw SystemConfigException(errorMessageCode: errorCodeDefaultMessage);
    }
  }
}
