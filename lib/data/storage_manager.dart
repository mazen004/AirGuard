import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
  }

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await  SharedPreferences.getInstance();
    int index = prefs.getInt('theme_mode') ?? ThemeMode.system.index;
    return ThemeMode.values[index];
  }

}

/* new StorageManager
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static const String _themeKey = 'theme_mode';
  static const String _devicesKey = 'registered_devices';
  static const String _activeDeviceKey = 'active_device_id';

  // --- Theme Mode Storage ---
  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt(_themeKey) ?? ThemeMode.system.index;
    return ThemeMode.values[index];
  }

  // --- Devices Map Storage (ID -> Name) ---
  static Future<void> saveDevices(Map<String, String> devices) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert the Map to a JSON string before saving
    final jsonString = jsonEncode(devices);
    await prefs.setString(_devicesKey, jsonString);
  }

  static Future<Map<String, String>> getDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_devicesKey);
    if (jsonString == null) return {};
    
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      // Cast the dynamic map back to a strictly typed Map<String, String>
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      debugPrint("Error parsing stored devices: $e");
      return {};
    }
  }

  // --- Active Device ID Storage ---
  static Future<void> saveActiveDeviceId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeDeviceKey, id);
  }

  static Future<String?> getActiveDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeDeviceKey);
  }
}
*/