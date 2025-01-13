import 'dart:convert';
import 'package:flutter/services.dart';

class ApiKeyLoader {
  static Future<String> loadUnsplashKey() async {
    final jsonString = await rootBundle.loadString('assets/api_keys.json');
    final data = json.decode(jsonString);
    return data['unsplash_access_key'];
  }
}

