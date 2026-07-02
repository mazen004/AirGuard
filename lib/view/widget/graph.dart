import 'dart:math' as math;
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
              fontSize: 16, color: context.mainColors.mutedText
            ),
          )
        )
      );
    }

    final spots = buildSpots();
    final values = spots.map((e) => e.y).toList();
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final padding = (maxValue - minValue).abs() * 0.10 + 1;

    final now = DateTime.now();
    final maxX = now.millisecondsSinceEpoch.toDouble();
    final minX = now.subtract(const Duration(hours: 23)).millisecondsSinceEpoch.toDouble();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      height: 250,
      child: LineChart(
        LineChartData(
          minX: minX, maxX: maxX,
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
                    "${DateFormat("HH:mm").format(date)}\n${spot.y.toStringAsFixed(2)}",
                    TextStyle(color: sensorColor, fontSize: 12),
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
                interval: 3600000, 
                getTitlesWidget: (val, meta) => bottomTitles(val, meta, context.mainColors),
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
                  color: sensorColor,
                  strokeWidth: 1,
                )
              ),
              belowBarData: BarAreaData(
                show: true,
                color: sensorColor.withAlpha(50)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta,
   dynamic context,) {
    if (value < meta.min || value > meta.max) return const SizedBox.shrink();

    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final isMidnight = date.hour == 0;

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
                    color: context.primaryText
                  )
                )
              ),
            if (isMidnight)
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  DateFormat("dd/MM").format(date),
                  style: TextStyle(
                    fontSize: 9,
                    color: context.primaryText
                  )
                )
              ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> buildSpots() => readings.map((r) => FlSpot(r.timestamp.millisecondsSinceEpoch.toDouble(), sensorValue(r))).toList();

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