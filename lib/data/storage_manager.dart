import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static const String themeKey = 'theme_mode';
  static const String devicesKey = 'registered_devices';
  static const String activeDeviceKey = 'active_device_id';

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeKey, mode.index);
  }

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt(themeKey) ?? ThemeMode.system.index;
    return ThemeMode.values[index];
  }

  static Future<void> saveDevices(Map<String, String> devices) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(devices);
    await prefs.setString(devicesKey, jsonString);
  }

  static Future<Map<String, String>> getDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(devicesKey);
    if (jsonString == null) return {};
    
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      debugPrint("Error parsing stored devices: $e");
      return {};
    }
  }

  static Future<void> saveActiveDeviceId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(activeDeviceKey, id);
  }

  static Future<String?> getActiveDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(activeDeviceKey);
  }
}
