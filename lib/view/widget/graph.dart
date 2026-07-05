import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/sensor_model.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:provider/provider.dart';

String ?unit; 
class SensorGraph extends StatelessWidget {
  final String sensorId;
  final List<SensorReading> readings;

  const SensorGraph({super.key, required this.sensorId, required this.readings});

  static const int windowSlots = 24;
  static const Duration slot = Duration(hours: 1);

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
            style: TextStyle(
              fontSize: 16,
              color: context.mainColors.mutedText
            )
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
    final firstTs = readings.first.timestamp;
    final lastTs = readings.last.timestamp;

    late DateTime windowStart;
    late DateTime windowEnd;

    if (n >= windowSlots) {
      // Full window: slide with the latest reading
      windowEnd = lastTs;
      windowStart = lastTs.subtract(slot * (windowSlots));
    } else {
      // Growing phase: center existing points, empty slots split left/right
      final emptySlots = windowSlots - n;
      final leftEmpty = emptySlots ~/ 2;
      windowStart = firstTs.subtract(slot * leftEmpty);
      windowEnd = windowStart.add(slot * (windowSlots));
    }

    final windowStartMs = windowStart.millisecondsSinceEpoch.toDouble();
    final windowEndMs = windowEnd.millisecondsSinceEpoch.toDouble();

    // small buffer so edge points aren't bisected by the chart's clip boundary
    final xMargin = (windowEndMs - windowStartMs) * 0.02;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      height: 250,
      child: LineChart(
        LineChartData(
          minX: windowStartMs - xMargin,
          maxX: windowEndMs + xMargin,
          minY: minValue - padding, maxY: maxValue + padding,
          clipData: const FlClipData.all(),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),

          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                  return LineTooltipItem(
                    "${DateFormat("HH:mm").format(date)}\n${spot.y.toStringAsFixed(2)} $unit",
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
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                interval: slot.inMilliseconds * 1,
                getTitlesWidget: (val, meta) => bottomTitles(val, meta, lastTs, context.mainColors),
              ),
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              barWidth: 3,
              spots: spots,
              isCurved: true,
              color: sensorColor,
              dotData: FlDotData(
                show: true,
                getDotPainter: (a, b, c, d) => FlDotCirclePainter(
                  radius: 2,
                  color: context.mainColors.secondaryBg,
                  strokeColor: sensorColor,
                  strokeWidth: 2,
                ),
              ),
              belowBarData: BarAreaData(show: true, color: sensorColor.withAlpha(50)),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta, DateTime lastReading, dynamic mainColor){
    if (value <= meta.min || value >= meta.max) return const SizedBox.shrink();

    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    // if (date.hour.isOdd) return SizedBox.shrink();
    if (date.isAfter(lastReading)) return SizedBox.shrink();
    final isMidnight = date.hour <= 0;

    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Transform.rotate(
              angle: -math.pi/4,
              child: Text(
                  DateFormat("HH:00").format(date),
                  style: TextStyle(
                    fontSize: 10,
                    color: mainColor.mutedText
                  )
                )
              ),
            if (isMidnight)
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  DateFormat("dd/MM").format(date),
                  style: TextStyle(
                    fontSize: 9,
                    color: mainColor.mutedText
                  )
                )
              ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> buildSpots() {
    return readings.map((r) => FlSpot(
      r.timestamp.millisecondsSinceEpoch.toDouble(),
      sensorValue(r)
    )).toList();
  }

  double sensorValue(SensorReading r) {
    switch (sensorId) {
      case "aqi": 
        unit = "%";
        return r.aqi;
      case "co":
        unit = "ppm";
        return r.coPPM;
      case "co2": 
        unit = "ppm";
        return r.co2PPM;
      case "temp": 
        unit = "°C";
        return r.temperature;
      case "hum": 
        unit = "%";
        return r.humidity;
      case "press": 
        unit = "hPa";
        return r.pressure;
      case "altit": 
        unit = "m";
        return r.altitude;
      default: return 0;
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