import 'package:flutter/material.dart';
import 'package:air_guard/data/constant.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class ReadingMeta{
  // final int id;
  final IconData icon;
  final Color borderColor, layerColor, mainColor;
  final String readingName, readingAbb, readingUnit;

  ReadingMeta({
    // required this.id,
    required this.icon,
    required this.borderColor,
    required this.layerColor,
    required this.mainColor,
    required this.readingName,
    required this.readingAbb,
    required this.readingUnit,
  });
  static Map<String, ReadingMeta> supportedReading(BuildContext context) {
    return {
      'aqi': ReadingMeta(
        // id: 0,
        borderColor: context.cardColors.aqiBorder,
        layerColor: context.cardColors.aqiGlow,
        mainColor: context.cardColors.aqiLeftSide,
        readingName: 'Air Quality Index',
        readingAbb: "AQI",
        readingUnit: '%',
        icon: FluentIcons.cloud_checkmark_20_regular
      ),
      'co': ReadingMeta(
        // id: 1,
        borderColor: context.cardColors.coBorder,
        layerColor: context.cardColors.coGlow,
        mainColor: context.cardColors.coLeftSide,
        readingName: 'Carbon Monoxide',
        readingAbb: "CO",
        readingUnit: 'ppm',
        icon: FluentIcons.cloud_off_20_regular
      ),
      'co2': ReadingMeta(
        // id: 2,
        borderColor: context.cardColors.co2Border,
        layerColor: context.cardColors.co2Glow,
        mainColor: context.cardColors.co2LeftSide,
        readingName: 'Carbon Dioxide',
        readingAbb: "CO₂",
        readingUnit: 'ppm',
        icon: FluentIcons.weather_squalls_20_regular
      ),
      'temp': ReadingMeta(
        // id: 3,
        borderColor: context.cardColors.tempBorder,
        layerColor: context.cardColors.tempGlow,
        mainColor: context.cardColors.tempLeftSide,
        readingName: 'Temperature',
        readingAbb: "Temp",
        readingUnit: '°C',
        icon: FluentIcons.temperature_20_regular
      ),
      'hum': ReadingMeta(
        // id: 4,
        borderColor: context.cardColors.humBorder,
        layerColor: context.cardColors.humGlow,
        mainColor: context.cardColors.humLeftSide,
        readingName: 'Humidity',
        readingAbb: "Humidity",
        readingUnit: '%',
        icon: FluentIcons.drop_20_regular
      ),
      'press': ReadingMeta(
        // id: 5,
        borderColor: context.cardColors.pressBorder,
        layerColor: context.cardColors.pressGlow,
        mainColor: context.cardColors.pressLeftSide,
        readingName: 'Pressure',
        readingAbb: "Pressure",
        readingUnit: 'hPa',
        icon: Icons.compress_rounded
      ),
      'altit': ReadingMeta(
        // id: 6,
        borderColor: context.cardColors.altiBorder,
        layerColor: context.cardColors.altiGlow,
        mainColor: context.cardColors.altiLeftSide,
        readingName: 'Altitude',
        readingAbb: "Altitude",
        readingUnit: 'm',
        icon: Icons.landscape_rounded
      ),
    };
  }
}

class Threshold {
  double warningValue, dangerValue;

  Threshold({
    required this.warningValue,
    required this.dangerValue,
  });

  static Map<String, Threshold> thresholdValue(BuildContext context) {
    return {
      'aqi': Threshold(
        warningValue: 100,
        dangerValue: 150
      ),
      'co': Threshold(
        warningValue: 9,
        dangerValue: 35
      ),
      'co2': Threshold(
        warningValue: 1000,
        dangerValue: 2000
      ),
    };
  }
}

class ReadingPerDevice {
  int readingID;
  String reading;
  String unit;

  ReadingPerDevice({
    required this.readingID,
    required this.reading,
    required this.unit
  });

  Map<String, dynamic> toJson() => {
    "readingID": readingID,
    "reading": reading,
    "unit": unit
  };
  factory ReadingPerDevice.fromJson(Map<String, dynamic> json) => ReadingPerDevice(
    readingID: json['readingID'],
    reading: json['reading'],
    unit: json['unit']
  );
}

class Device{
  String deviceName;
  List<ReadingPerDevice> readingProvided;
  DateTime lastReadingTime;
  bool isOnline;

  Device({
    required this.deviceName,
    required this.readingProvided,
    required this.lastReadingTime,
    required this.isOnline,
  });
  Map<String, dynamic> toJson() => {
    'deviceName': deviceName,
    'readingProvided': readingProvided.map((r) => r.toJson()).toList(),
    'lastReadingTime': lastReadingTime.toIso8601String(),
    'isOnline': isOnline,
  };

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    deviceName: json['deviceName'],
    readingProvided: (json['readingProvided'] as List)
        .map((r) => ReadingPerDevice.fromJson(r))
        .toList(),
    lastReadingTime: DateTime.parse(json['lastReadingTime']),
    isOnline: json['isOnline'] ?? true,
  );
}