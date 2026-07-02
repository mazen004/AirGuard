import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:air_guard/data/sensor_model.dart';

class SensorNotifier extends ChangeNotifier {
  String deviceName = "Air Guard Station";
  String deviceID = "ESP32_AQI_01";

  SensorReading? current;

  /// Complete history (every MQTT reading)
  final List<SensorReading> _history = [];

  /// Hourly history used by graphs
  final List<SensorReading> _graphHistory = [];

  List<SensorReading> get graphHistory =>
      List.unmodifiable(_graphHistory);

  void updateDeviceName(String newName) {
    if (newName.trim().isEmpty) return;

    if (newName == deviceName) return;

    deviceName = newName;
    notifyListeners();
  }

  void processHardwareData(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);

      final reading = SensorReading.fromJson(decoded);

      current = reading;

      _history.add(reading);

      _removeOldHistory(reading.timestamp);

      _updateHourlyHistory(reading);

      notifyListeners();
    } catch (e) {
      debugPrint("Sensor Parsing Error: $e");
    }
  }

  void clearHistory() {
    _history.clear();
    _graphHistory.clear();

    notifyListeners();
  }

  void _removeOldHistory(DateTime newest) {
    _history.removeWhere(
      (element) =>
          newest.difference(element.timestamp).inHours >= 24,
    );

    _graphHistory.removeWhere(
      (element) =>
          newest.difference(element.timestamp).inHours >= 24,
    );
  }

  void _updateHourlyHistory(SensorReading reading) {
    if (_graphHistory.isEmpty) {
      _graphHistory.add(reading);
      return;
    }

    final last = _graphHistory.last;

    final sameHour =
        last.timestamp.year == reading.timestamp.year &&
        last.timestamp.month == reading.timestamp.month &&
        last.timestamp.day == reading.timestamp.day &&
        last.timestamp.hour == reading.timestamp.hour;

    if (sameHour) {
      _graphHistory[_graphHistory.length - 1] = reading;
    } else {
      _graphHistory.add(reading);
    }

    while (_graphHistory.length > 24) {
      _graphHistory.removeAt(0);
    }
  }

  List<SensorReading> getSensorHistory(String sensorId) {
    return List.unmodifiable(_graphHistory);
  }

  double sensorValue(
    SensorReading reading,
    String sensorId,
  ) {
    switch (sensorId) {
      case "aqi":
        return reading.aqi;

      case "co":
        return reading.coPPM;

      case "co2":
        return reading.co2PPM;

      case "temp":
        return reading.temperature;

      case "hum":
        return reading.humidity;

      case "press":
        return reading.pressure;

      case "altit":
        return reading.altitude;

      default:
        return 0;
    }
  }
}