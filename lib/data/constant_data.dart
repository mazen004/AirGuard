import 'package:flutter/material.dart';
import 'package:air_guard/data/constant.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class ReadingMeta{
  final IconData icon;
  final Color borderColor, layerColor, mainColor;
  final String readingName, readingAbb, readingDefaultUnit;
  final List<String>? readingUnit;

  ReadingMeta({
    required this.icon,
    required this.borderColor,
    required this.layerColor,
    required this.mainColor,
    required this.readingName,
    required this.readingAbb,
    required this.readingDefaultUnit,
    this.readingUnit,
  });
  static List<ReadingUnit> defaultReadingProvided() {
    const defaults = {
      'aqi': '%',
      'co': 'ppm',
      'co2': 'ppm',
      'temp': '°C',
      'hum': '%',
      'press': 'hPa',
      'altit': 'm',
    };
    return defaults.entries
        .map((e) => ReadingUnit(reading: e.key, unit: e.value))
        .toList();
  }

  static Map<String, ReadingMeta> supportedReading(BuildContext context) {
    return {
      'aqi': ReadingMeta(
        borderColor: context.cardColors.aqiBorder,
        layerColor: context.cardColors.aqiGlow,
        mainColor: context.cardColors.aqiLeftSide,
        readingName: 'Air Quality Index',
        readingAbb: "AQI",
        readingDefaultUnit: '%',
        icon: FluentIcons.cloud_checkmark_20_regular,
      ),
      'co': ReadingMeta(
        borderColor: context.cardColors.coBorder,
        layerColor: context.cardColors.coGlow,
        mainColor: context.cardColors.coLeftSide,
        readingName: 'Carbon Monoxide',
        readingAbb: "CO",
        readingDefaultUnit: 'ppm',
        icon: FluentIcons.cloud_off_20_regular,
      ),
      'co2': ReadingMeta(
        borderColor: context.cardColors.co2Border,
        layerColor: context.cardColors.co2Glow,
        mainColor: context.cardColors.co2LeftSide,
        readingName: 'Carbon Dioxide',
        readingAbb: "CO₂",
        readingDefaultUnit: 'ppm',
        icon: FluentIcons.weather_squalls_20_regular,
      ),
      'temp': ReadingMeta(
        borderColor: context.cardColors.tempBorder,
        layerColor: context.cardColors.tempGlow,
        mainColor: context.cardColors.tempLeftSide,
        readingName: 'Temperature',
        readingAbb: "Temp",
        readingDefaultUnit: '°C',
        icon: FluentIcons.temperature_20_regular,
        readingUnit: ['°C', '°F', 'K']
      ),
      'hum': ReadingMeta(
        borderColor: context.cardColors.humBorder,
        layerColor: context.cardColors.humGlow,
        mainColor: context.cardColors.humLeftSide,
        readingName: 'Humidity',
        readingAbb: "Humidity",
        readingDefaultUnit: '%',
        icon: FluentIcons.drop_20_regular,
      ),
      'press': ReadingMeta(
        borderColor: context.cardColors.pressBorder,
        layerColor: context.cardColors.pressGlow,
        mainColor: context.cardColors.pressLeftSide,
        readingName: 'Pressure',
        readingAbb: "Pressure",
        readingDefaultUnit: 'hPa',
        icon: Icons.compress_rounded,
        readingUnit: ['hPa', 'Pa', 'atm']
      ),
      'altit': ReadingMeta(
        borderColor: context.cardColors.altiBorder,
        layerColor: context.cardColors.altiGlow,
        mainColor: context.cardColors.altiLeftSide,
        readingName: 'Altitude',
        readingAbb: "Altitude",
        readingDefaultUnit: 'm',
        icon: Icons.landscape_rounded,
        readingUnit: ['m', 'Km']
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

class ReadingUnit {
  String reading;
  String unit;

  ReadingUnit({
    required this.reading,
    required this.unit
  });

  Map<String, dynamic> toJson() => {
    "reading": reading,
    "unit": unit
  };
  factory ReadingUnit.fromJson(Map<String, dynamic> json) => ReadingUnit(
    reading: json['reading'],
    unit: json['unit']
  );
}

class Device{
  String deviceName;
  List<ReadingUnit> readingProvided;
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
        .map((r) => ReadingUnit.fromJson(r))
        .toList(),
    lastReadingTime: DateTime.parse(json['lastReadingTime']),
    isOnline: json['isOnline'] ?? Device.updateISOnline(DateTime.parse(json['lastReadingTime'])),
  );
  static bool updateISOnline(DateTime time) => DateTime.now().difference(time).inSeconds > 90 ? false : true;
}