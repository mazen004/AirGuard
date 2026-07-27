  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:air_guard/data/constant_data.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  class StorageManager {
    // Themes Section
    static Future<void> saveThemeMode(ThemeMode mode) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('theme_mode', mode.index);
    }

    static Future<ThemeMode> getThemeMode() async {
      final prefs = await SharedPreferences.getInstance();
      int index = prefs.getInt('theme_mode') ?? ThemeMode.system.index;
      return ThemeMode.values[index];
    }

    // Genaral Data Section
    static Future<void> saveLanguage(String lang) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', lang);
    }

    static Future<void> saveTimeFormat(bool timeFormat) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_24h', timeFormat);
    }

    static Future<void> saveRefreshRate(int refreshRate) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('refresh_rate', refreshRate);
    }
    static Future<void> saveGraphAverage(bool graphAverage) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('graph_is_average', graphAverage);
    }

    static Future<String> getLanguage() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('language') ?? 'en';
    }

    static Future<bool> getTimeFormat() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('is_24h') ?? true;
    }

    static Future<int> getRefreshRate() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('refresh_rate') ?? 30;
    }

    static Future<bool> getGraphAverage() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('graph_is_average') ?? true;
    }

    // Devices Section
    static Future<void> saveDevices(Map<String, Device> devices) async {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(devices.map(((key, value) => MapEntry(key, value.toJson()))));
      await prefs.setString('registered_devices', jsonString);
    }

    static Future<Map<String, Device>> getDevices() async {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('registered_devices');
      if (jsonString == null || jsonString.isEmpty) return {};
      
      try {
        final Map<String, dynamic> decoded = jsonDecode(jsonString);
        return decoded.map(
          (key, value) => MapEntry(
            key, Device.fromJson(value)
          )
        );
      } catch (e) {
        debugPrint('Error parsing stored devices: $e');
        return {};
      }
    }

    static Future<void> updateDeviceLastReading(String deviceID, DateTime time) async{
      final devices = await getDevices();
      if(!devices.containsKey(deviceID)) return;
      if(devices[deviceID]!.lastReadingTime == time) return;
      devices[deviceID]!.lastReadingTime = time;
      await saveDevices(devices);
    }

    static Future<void> saveActiveDeviceId(String id) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('active_device_id', id);
    }

    static Future<String?> getActiveDeviceId() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('active_device_id');
    }

    static Future<void> removeDevice(String deviceID) async{
      final devices = await getDevices();
      if(devices.isEmpty || !devices.containsKey(deviceID)) return;
      devices.removeWhere(((key, value) => key == deviceID));
    }
  }
/**/