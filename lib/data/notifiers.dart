import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:air_guard/data/mqtt_server.dart';
import 'package:air_guard/data/sensor_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);
final ValueNotifier<int> selectedPageNotifier = ValueNotifier(1);
final ValueNotifier<int> selectedCardNotifier = ValueNotifier(0);

class SensorNotifierMQTT extends ChangeNotifier {
  final ValueNotifier<bool> isConnected = ValueNotifier(false);

  late MqttService mqttService;
  late SensorNotifier sensorNotifier;

  String mqttUrl = '01dd14f3785f4ebc94fcd632df4b74e8.s1.eu.hivemq.cloud';
  String mqttPort = '8883';
  String mqttUser = 'AirQualitySensor';
  String mqttPass = 'AirGaurdv1';
  String mqttTopic = 'airstation/AQS-001/readings';

  void bindSensorNotifier(SensorNotifier notifier) {
    sensorNotifier = notifier;
  }

  void updateConnectionStatus(bool status) {
    isConnected.value = status;
  }

  Future<void> saveAndConnect(
    String url,
    String port,
    String user,
    String pass,
  ) async {
    mqttUrl = url;
    mqttPort = port;
    mqttUser = user;
    mqttPass = pass;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("mqtt_url", url);
    await prefs.setString("mqtt_port", port);
    await prefs.setString("mqtt_user", user);
    await prefs.setString("mqtt_pass", pass);
  }

  Future<void> connect() async {
    mqttService = MqttService(
      broker: mqttUrl,
      port: int.parse(mqttPort),
      username: mqttUser,
      password: mqttPass,
      topic: mqttTopic,

      onConnected: () {
        updateConnectionStatus(true);
      },

      onDisconnected: () {
        updateConnectionStatus(false);
      },

      onData: (payload) {
        sensorNotifier.processHardwareData(payload);
      },
    );

    await mqttService.connect();
  }

  Future<void> disconnect() async {
    try {
      mqttService.disconnect();
      
      updateConnectionStatus(false);
      
      print("MQTT Disconnected successfully.");
    } catch (e) {
      print("Error disconnecting: $e");
    }
  }
}

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

/* new SensorNotifier
  class SensorNotifier extends ChangeNotifier {
    final Map<String, String> _deviceNames = {};
    String _activeDeviceId = "";

    SensorNotifier() {
      // Automatically load stored devices when the notifier is initialized
      _loadSavedDevices();
    }

    // Getters to safely expose data
    String get activeDeviceId => _activeDeviceId;
    Map<String, String> get deviceNames => Map.unmodifiable(_deviceNames);
    String get deviceName => _deviceNames[_activeDeviceId] ?? "Air Guard";
    String get deviceID => _activeDeviceId;

    SensorReading? current;
    final List<SensorReading> _history = [];
    final List<SensorReading> _graphHistory = [];

    List<SensorReading> get graphHistory => List.unmodifiable(_graphHistory);

    /// Async method to restore historical setups from local storage
    Future<void> _loadSavedDevices() async {
      final savedDevices = await StorageManager.getDevices();
      _deviceNames.addAll(savedDevices);

      final savedActiveId = await StorageManager.getActiveDeviceId();
      if (savedActiveId != null && _deviceNames.containsKey(savedActiveId)) {
        _activeDeviceId = savedActiveId;
      } else if (_deviceNames.isNotEmpty) {
        _activeDeviceId = _deviceNames.keys.first;
      }
      notifyListeners();
    }

    /// Switch active monitored device
    Future<void> selectDevice(String id) async {
      if (_deviceNames.containsKey(id)) {
        _activeDeviceId = id;
        await StorageManager.saveActiveDeviceId(id);
        
        // Clear history charts since we are looking at a different hardware unit now
        clearHistory(); 
        notifyListeners();
      }
    }

    /// Changes a device's name and updates local storage
    Future<void> updateDeviceName(String id, String newName) async {
      if (newName.trim().isEmpty) return;
      if (!_deviceNames.containsKey(id)) return;
      if (_deviceNames[id] == newName) return;

      _deviceNames[id] = newName;
      await StorageManager.saveDevices(_deviceNames);
      notifyListeners();
    }

    /// Processes cloud stream
    void processHardwareData(String jsonString) async {
      try {
        final decoded = jsonDecode(jsonString);

        // Extract the device ID that comes from the cloud payload
        final String? incomingDeviceId = decoded['deviceID'];
        if (incomingDeviceId == null || incomingDeviceId.isEmpty) return;

        // 1. Check if this is a newly discovered device
        if (!_deviceNames.containsKey(incomingDeviceId)) {
          _deviceNames[incomingDeviceId] = "Air Guard"; // Default Name
          await StorageManager.saveDevices(_deviceNames);
          
          // If no device was active yet, set this new one as active
          if (_activeDeviceId.isEmpty) {
            _activeDeviceId = incomingDeviceId;
            await StorageManager.saveActiveDeviceId(incomingDeviceId);
          }
          notifyListeners();
        }

        // 2. Only record sensor history if the message matches the current active view screen
        if (incomingDeviceId == _activeDeviceId) {
          final reading = SensorReading.fromJson(decoded);

          current = reading;
          _history.add(reading);
          _removeOldHistory(reading.timestamp);
          _updateHourlyHistory(reading);

          notifyListeners();
        }
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
      _history.removeWhere((el) => newest.difference(el.timestamp).inHours >= 24);
      _graphHistory.removeWhere((el) => newest.difference(el.timestamp).inHours >= 24);
    }

    void _updateHourlyHistory(SensorReading reading) {
      if (_graphHistory.isEmpty) {
        _graphHistory.add(reading);
        return;
      }
      final last = _graphHistory.last;
      final sameHour = last.timestamp.year == reading.timestamp.year &&
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

    List<SensorReading> getSensorHistory(String sensorId) => List.unmodifiable(_graphHistory);

    double sensorValue(SensorReading reading, String sensorId) {
      switch (sensorId) {
        case "aqi": return reading.aqi;
        case "co": return reading.coPPM;
        case "co2": return reading.co2PPM;
        case "temp": return reading.temperature;
        case "hum": return reading.humidity;
        case "press": return reading.pressure;
        case "altit": return reading.altitude;
        default: return 0;
      }
    }
  }
*/