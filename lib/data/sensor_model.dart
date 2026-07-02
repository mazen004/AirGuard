// import 'package:flutter/material.dart';

class SensorReading {
  final double aqi;
  final String category;

  final double coPPM;
  final double co2PPM;

  final double temperature;
  final double humidity;
  final double pressure;
  final double altitude;

  final DateTime timestamp;

  SensorReading({
    required this.aqi,
    required this.category,
    required this.coPPM,
    required this.co2PPM,
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.altitude,
    required this.timestamp,
  });

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    double d(dynamic value) =>
        double.tryParse(value?.toString() ?? "0") ?? 0;

    final air = json["airQuality"] ?? {};
    final gas = json["gas"] ?? {};
    final env = json["environment"] ?? {};
    final ts = json["timestamp"] ?? {};

    return SensorReading(
      aqi: d(air["aqi"]),
      category: air["category"]?.toString() ?? "SAFE",

      coPPM: d(gas["coPPM"]),
      co2PPM: d(gas["co2PPM"]),

      temperature: d(env["temperature"]),
      humidity: d(env["humidity"]),
      pressure: d(env["pressure"]),
      altitude: d(env["altitude"]),

      timestamp: DateTime.parse(ts["iso"]),
    );
  }

  int get hour => timestamp.hour;

  int get minute => timestamp.minute;

  int get day => timestamp.day;

  int get month => timestamp.month;

  int get year => timestamp.year;
}