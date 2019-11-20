import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class JsonLoader {
  /// Read from assets
  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle.loadString(assetsPath).then((jsonStr) => jsonDecode(jsonStr));
  }

  String testPath(String relativePath) {
    Directory current = Directory.current;
    String path = current.path.endsWith('/test') ? current.path : current.path + '/test';

    return path + '/' + relativePath;
  }

  /// Read from relative file url
  Future<Map<String, dynamic>> parseJsonFromFile(String path, {bool test = false}) async {
    final file = new File(test ? testPath(path) : path);
    return jsonDecode(await file.readAsString());
  }
}
