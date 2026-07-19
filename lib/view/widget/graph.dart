import 'dart:math' as math;
// import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/sensor_model.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:provider/provider.dart';

class SensorGraph extends StatelessWidget {
  final String sensorId;
  final List<SensorReading> readings;

  const SensorGraph({super.key, required this.sensorId, required this.readings});

  static int windowSlots = 24;
  static Duration slot = Duration(hours: 1);

  @override
  Widget build(BuildContext context) {
    final sensorColor = getSensorColor(context.cardColors);
    final prov = Provider.of<SensorNotifierMQTT>(context);

    if (!prov.isConnected.value || readings.isEmpty) {
      return SizedBox(
        height: 250,
        child: Center(
          child: Text(
            "Waiting for data...",
            style: TextStyle(fontSize: 16, color: context.mainColors.mutedText),
          ),
        ),
      );
    }

    final spots = buildSpots();
    final values = spots.map((e) => e.y).toList();
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final padding = (maxValue - minValue).abs() * 0.10 + 1;

    final n = readings.length;
    final firstTsRaw = readings.first.timestamp;
    final lastTsRaw = readings.last.timestamp;
    final firstHour = DateTime(firstTsRaw.year, firstTsRaw.month, firstTsRaw.day, firstTsRaw.hour);
    final lastHour = DateTime(lastTsRaw.year, lastTsRaw.month, lastTsRaw.day, lastTsRaw.hour);

    late DateTime windowStart;
    late DateTime windowEnd;

    if (n >= windowSlots) {
      windowEnd = lastHour;
      windowStart = lastHour.subtract(slot * (windowSlots));
    } else {
      final emptySlots = windowSlots - n;
      final leftEmpty = emptySlots ~/ 2;
      windowStart = firstHour.subtract(slot * leftEmpty);
      windowEnd = windowStart.add(slot * (windowSlots - 1));
    }

    final windowStartMs = windowStart.millisecondsSinceEpoch.toDouble();
    final windowEndMs = windowEnd.millisecondsSinceEpoch.toDouble();
    final xMargin = (windowEndMs - windowStartMs) * 0.02;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      height: 250,
      child: LineChart(
        LineChartData(
          minX: windowStartMs - xMargin,
          maxX: windowEndMs + xMargin,
          minY: minValue - padding,
          maxY: maxValue + padding,
          clipData: FlClipData.all(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
          ),
          borderData: FlBorderData(show: false),

          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final reading = readings[spot.spotIndex];
                  final hourStart = DateTime(
                    reading.timestamp.year,
                    reading.timestamp.month,
                    reading.timestamp.day,
                    reading.timestamp.hour,
                  );

                  final startLabel = DateFormat("$timeFormatHour:00$timeFormat").format(hourStart);

                  return LineTooltipItem(
                    "$startLabel\n${spot.y.toStringAsFixed(2)} ${getUnit(sensorId)}",
                    TextStyle(
                      fontSize: 12,
                      color: context.mainColors.primaryText,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                interval: slot.inMilliseconds * 1,
                getTitlesWidget: (val, meta) =>
                    bottomTitles(val, meta, lastTsRaw, context.mainColors),
              ),
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              barWidth: 3,
              spots: spots,
              isCurved: true,
              gradient: LinearGradient(
                begin: AlignmentGeometry.centerLeft,
                end: AlignmentGeometry.centerRight,
                colors: [
                  sensorColor.withAlpha(85),
                  sensorColor
                ]
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (a, b, c, d) => FlDotCirclePainter(
                  radius: 2,
                  color: context.mainColors.secondaryBg,
                  strokeColor: sensorColor,
                  strokeWidth: 2,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: AlignmentGeometry.topCenter,
                  end: AlignmentGeometry.bottomCenter,
                  colors: [
                    sensorColor.withAlpha(50),
                    context.mainColors.secondaryBg,
                  ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta, DateTime currentReading, dynamic mainColor) {
    if (value <= meta.min || value >= meta.max) {
      return SizedBox.shrink();
    }

    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    if (date.isAfter(currentReading)) {
      return SizedBox.shrink();
    }

    if(currentReading.hour % 2 == 0) {
      if (date.hour % 2 != 0) {
        return SizedBox.shrink();
      }
    }
    else{
      if(date.hour % 2 == 0){
        return SizedBox.shrink();
      }
    }

    // if (date.hour % 2 != 0) {
    //   return SizedBox.shrink();
    // }

    final bool isCurrent = currentReading.hour == date.hour;

    final isMidnight = date.hour == 0;

    return SideTitleWidget(
      meta: meta,
      angle: -math.pi / 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            DateFormat("$timeFormatHour:00$timeFormat").format(date),
            style: TextStyle(
              fontSize: 10,
              color: isCurrent ? mainColor.secondaryText : mainColor.mutedText
            ),
          ),
          if (isMidnight)
            Text(
              DateFormat("dd/MM").format(date),
              style: TextStyle(
                fontSize: 9,
                color: isCurrent ? mainColor.secondaryText : mainColor.mutedText
              ),
            ),
        ],
      ),
    );
  }

  List<FlSpot> buildSpots() {
    return readings.map((r) {
      final hourStart = DateTime(r.timestamp.year, r.timestamp.month, r.timestamp.day, r.timestamp.hour);
      return FlSpot(hourStart.millisecondsSinceEpoch.toDouble(), sensorValue(r));
    }).toList();
  }

  double sensorValue(SensorReading r) {
    switch (sensorId) {
      case "aqi": return r.aqi;
      case "co": return r.coPPM;
      case "co2": return r.co2PPM;
      case "temp": return r.temperature;
      case "hum": return r.humidity;
      case "press": return r.pressure;
      case "altit": return r.altitude;
      default: return 0;
    }
  }

  String getUnit(String id) {
    switch (id) {
      case "aqi": return "%";
      case "co": return "ppm";
      case "co2": return "ppm";
      case "temp": return "°C";
      case "hum": return "%";
      case "press": return "hPa";
      case "altit": return "m";
      default: return "";
    }
  }

  Color getSensorColor(CardPalette colors) {
    switch (sensorId) {
      case 'co2': return colors.co2LeftSide;
      case 'co': return colors.coLeftSide;
      case 'temp': return colors.tempLeftSide;
      case 'hum': return colors.humLeftSide;
      case 'press': return colors.pressLeftSide;
      case 'altit': return colors.altiLeftSide;
      default: return colors.aqiLeftSide;
    }
  }
}