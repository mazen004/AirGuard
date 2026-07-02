import 'package:flutter/material.dart';
import 'package:air_guard/data/constant.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class ReadingData{
  final int id;
  final IconData icon;
  final Color borderColor, layerColor, mainColor;
  final String readingName, readingAbb, readingUnit;

  ReadingData({
    required this.id,
    required this.icon,
    required this.borderColor,
    required this.layerColor,
    required this.mainColor,
    required this.readingName,
    required this.readingAbb,
    required this.readingUnit,
    });
}

class ThresholdValue {
  final double warningValue, dangerValue;

  ThresholdValue({
    required this.warningValue,
    required this.dangerValue,
  });
}

class ReadingRegistry {
  static Map<String, ReadingData> getReadings(BuildContext context) {
    return {
      'aqi': ReadingData(
        id: 0,
        borderColor: context.cardColors.aqiBorder,
        layerColor: context.cardColors.aqiGlow,
        mainColor: context.cardColors.aqiLeftSide,
        readingName: 'Air Quality Index',
        readingAbb: "AQI",
        readingUnit: '%',
        icon: FluentIcons.cloud_checkmark_20_regular
      ),
      'co': ReadingData(
        id: 1,
        borderColor: context.cardColors.coBorder,
        layerColor: context.cardColors.coGlow,
        mainColor: context.cardColors.coLeftSide,
        readingName: 'Carbon Monoxide',
        readingAbb: "CO",
        readingUnit: 'ppm',
        icon: FluentIcons.cloud_off_20_regular
      ),
      'co2': ReadingData(
        id: 2,
        borderColor: context.cardColors.co2Border,
        layerColor: context.cardColors.co2Glow,
        mainColor: context.cardColors.co2LeftSide,
        readingName: 'Carbon Dioxide',
        readingAbb: "CO₂",
        readingUnit: 'ppm',
        icon: FluentIcons.weather_squalls_20_regular
      ),
      'temp': ReadingData(
        id: 3,
        borderColor: context.cardColors.tempBorder,
        layerColor: context.cardColors.tempGlow,
        mainColor: context.cardColors.tempLeftSide,
        readingName: 'Temperature',
        readingAbb: "Temp",
        readingUnit: '°C',
        icon: FluentIcons.temperature_20_regular
      ),
      'hum': ReadingData(
        id: 4,
        borderColor: context.cardColors.humBorder,
        layerColor: context.cardColors.humGlow,
        mainColor: context.cardColors.humLeftSide,
        readingName: 'Humidity',
        readingAbb: "Humidity",
        readingUnit: '%',
        icon: FluentIcons.drop_20_regular
      ),
      'press': ReadingData(
        id: 5,
        borderColor: context.cardColors.pressBorder,
        layerColor: context.cardColors.pressGlow,
        mainColor: context.cardColors.pressLeftSide,
        readingName: 'Pressure',
        readingAbb: "Pressure",
        readingUnit: 'hPa',
        icon: Icons.compress_rounded
      ),
      'altit': ReadingData(
        id: 6,
        borderColor: context.cardColors.altiBorder,
        layerColor: context.cardColors.altiGlow,
        mainColor: context.cardColors.altiLeftSide,
        readingName: 'Altitude',
        readingAbb: "Altitude",
        readingUnit: 'm',
        icon: FluentIcons.ruler_20_regular
      ),
    };
  }
}

// class ThresholdValueRegistry {
//   static Map<String, ThresholdValue> getReadings(BuildContext context) {
//     return {
//       'aqi': ThresholdValue(
//       ),
//       'co': ThresholdValue(
//       ),
//       'co2': ThresholdValue(
//       ),
//       'temp': ThresholdValue(
//       ),
//       'hum': ThresholdValue(
//       ),
//       'press': ThresholdValue(
//       ),
//       'altit': ThresholdValue(
//       ),
//     };
//   }
// }