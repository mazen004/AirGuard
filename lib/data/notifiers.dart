import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:air_guard/data/mqtt_server.dart';
import 'package:air_guard/data/sensor_model.dart';
import 'package:air_guard/data/constant_data.dart';
import 'package:air_guard/data/storage_manager.dart';
// import 'package:shared_preferences/shared_preferences.dart';

final ValueNotifier<int> selectedPageNotifier = ValueNotifier(1);
final ValueNotifier<String> selectedCardNotifier = ValueNotifier('aqi');
final ValueNotifier<bool> isTimeFormat24hNotifier = ValueNotifier(true);
final ValueNotifier<String> selectedLanguageNotifier = ValueNotifier("en");
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);

String get timeFormatHour => isTimeFormat24hNotifier.value ? "HH" : "hh";
String get timeFormat => isTimeFormat24hNotifier.value ? "" : " a";

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

  // Future<void> saveAndConnect(
  //   String url,
  //   String port,
  //   String user,
  //   String pass,
  // ) async {
  //   mqttUrl = url;
  //   mqttPort = port;
  //   mqttUser = user;
  //   mqttPass = pass;

  //   notifyListeners();

  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString("mqtt_url", url);
  //   await prefs.setString("mqtt_port", port);
  //   await prefs.setString("mqtt_user", user);
  //   await prefs.setString("mqtt_pass", pass);
  // }

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
      
      debugPrint("MQTT Disconnected successfully.");
    } catch (e) {
      debugPrint("Error disconnecting: $e");
    }
  }
}

class SensorNotifier extends ChangeNotifier {
  final Map<String, Device> _devices = {};
  String _activeDeviceID = "";

  SensorNotifier() {
    loadSavedDevices();
  }

  String get activeDeviceID => _activeDeviceID;
  Map<String, Device> get devices => Map.unmodifiable(_devices);
  String get deviceName => _devices[_activeDeviceID]?.deviceName ?? "Air Guard";
  String get deviceID => _activeDeviceID;

  SensorReading? current;
  final List<SensorReading> _history = [];
  final List<SensorReading> _graphHistory = [];
  // late SensorReading _emaValue;

  List<SensorReading> get graphHistory => List.unmodifiable(_graphHistory);

  Future<void> loadSavedDevices() async {
    final savedDevices = await StorageManager.getDevices();
    _devices.addAll(savedDevices);

    final savedActiveID = await StorageManager.getActiveDeviceId();
    if (savedActiveID != null && _devices.containsKey(savedActiveID)) {
      _activeDeviceID = savedActiveID;
    } else if (_devices.isNotEmpty) {
      _activeDeviceID = _devices.keys.first;
    }
    notifyListeners();
  }

  Future<void> selectDevice(String id) async {
    if (_devices.isEmpty) return;
    if (_devices.containsKey(id)) {
      _activeDeviceID = id;
      await StorageManager.saveActiveDeviceId(id);
      
      clearHistory(); 
      notifyListeners();
    }
  }

  Future<void> updateDevice(String id, Device device) async {
    if (_devices.isEmpty) return;
    if (!_devices.containsKey(id)) return;
    if (_devices[id] == device) return;
    _devices[id] = device;
    await StorageManager.saveDevices(_devices);
    notifyListeners();
  }


  void processHardwareData(String jsonString) async {
    try {
      final decoded = jsonDecode(jsonString);

      final String? incomingDeviceId = decoded['deviceID'];
      if (incomingDeviceId == null || incomingDeviceId.isEmpty) return;

      if (!_devices.containsKey(incomingDeviceId)) {
        _devices[incomingDeviceId] = Device(
            deviceName: "Air Guard",
            readingProvided: ReadingMeta.defaultReadingProvided(),
            lastReadingTime: SensorReading.fromJson(decoded).timestamp,
            refreshRate: 15,
            isOnline: _devices[incomingDeviceId]?.isOnline ?? false,
            isGraphAverage: false,
          );
        await StorageManager.saveDevices(_devices);
        
        if (_activeDeviceID.isEmpty) {
          _activeDeviceID = incomingDeviceId;
          await StorageManager.saveActiveDeviceId(incomingDeviceId);
        }
        notifyListeners();
      }

      if (incomingDeviceId == _activeDeviceID) {
        final reading = SensorReading.fromJson(decoded);

        current = reading;
        _history.add(reading);
        _removeOldHistory(reading.timestamp);
        updateHourlyHistory(reading);

        _devices[activeDeviceID]!.isOnline = Device.updateISOnline(reading.timestamp);

        notifyListeners();
      }
    } catch (e) {
      debugPrint("Sensor Parsing Error: $e");
    }
  }

  void deleteDevice(String id) async {
    if ( _devices.isEmpty || !_devices.containsKey(id)) return;
    _devices.remove(id);
    await StorageManager.removeDevice(id);
    notifyListeners();
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

  void updateHourlyHistory(SensorReading reading) async{
    if (_graphHistory.isEmpty) {
      _graphHistory.add(reading);
      // _emaValue = reading;
      return;
    }
    final last = _graphHistory.last;
    final sameHour = last.timestamp.year == reading.timestamp.year &&
                    last.timestamp.month == reading.timestamp.month &&
                    last.timestamp.day == reading.timestamp.day &&
                    last.timestamp.hour == reading.timestamp.hour;

    _devices[activeDeviceID]!.lastReadingTime = reading.timestamp;
    _devices[activeDeviceID]!.isOnline = true;
    await StorageManager.updateDeviceLastReading(_activeDeviceID, reading.timestamp);

    if (sameHour) {
      _graphHistory[_graphHistory.length - 1] = reading;
    } else {
      _graphHistory.add(reading);
    }
    while (_graphHistory.length > 48) {
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
      case "altit": return reading.altitude;
      case "press": return reading.pressure;
      default: return 0;
    }
  }
}

/**/