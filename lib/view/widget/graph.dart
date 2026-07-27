import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/sensor_model.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:provider/provider.dart';

class SensorGraph extends StatefulWidget {
  final String sensorID;
  final List<SensorReading> readings;

  const SensorGraph({super.key, required this.sensorID, required this.readings});

  @override
  State<SensorGraph> createState() => _SensorGraphState();
}

class _SensorGraphState extends State<SensorGraph> with SingleTickerProviderStateMixin {
  static int windowSlots = 24;
  static Duration slot = Duration(hours: 1);

  late final AnimationController _controller;
  late final Animation<double> _reveal;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _reveal = CurvedAnimation(parent: _controller, curve: Curves.easeInOutExpo);
    _controller.forward();
  }

 @override
  void didUpdateWidget(covariant SensorGraph oldWidget) {
    super.didUpdateWidget(oldWidget);

    final sensorChanged = oldWidget.sensorID != widget.sensorID;
    final lengthChanged = oldWidget.readings.length != widget.readings.length;

    bool newHourSlot = false;
    if (oldWidget.readings.isNotEmpty && widget.readings.isNotEmpty) {
      final oldLastHour = _hourBucket(oldWidget.readings.last.timestamp);
      final newLastHour = _hourBucket(widget.readings.last.timestamp);
      newHourSlot = oldLastHour != newLastHour;
    }

    if (sensorChanged || lengthChanged || newHourSlot) {
      _controller.forward(from: 0);
    }
  }

  DateTime _hourBucket(DateTime t) => DateTime(t.year, t.month, t.day, t.hour);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sensorColor = getSensorColor(context.cardColors);
    final prov = Provider.of<SensorNotifierMQTT>(context);
    final readings = widget.readings;
    final sensorId = widget.sensorID;

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

    final spots = buildSpots(readings, sensorId);
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

    final fixedMinX = windowStartMs - xMargin;
    final fixedMaxX = windowEndMs + xMargin;
    final fixedMinY = minValue - padding;
    final fixedMaxY = maxValue + padding;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      height: 250,
      child: AnimatedBuilder(
        animation: _reveal,
        builder: (context, _) {
          final visibleSpots = _truncatedSpots(spots, _reveal.value);

          return LineChart(
            LineChartData(
              minX: fixedMinX,
              maxX: fixedMaxX,
              minY: fixedMinY,
              maxY: fixedMaxY,
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
                      final index = spot.spotIndex;
                      if (index >= readings.length) return null;
                      final reading = readings[index];
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
                  spots: visibleSpots,
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
            duration: Duration.zero,
          );
        },
      ),
    );
  }

  List<FlSpot> _truncatedSpots(List<FlSpot> allSpots, double t) {
    if (allSpots.isEmpty) return allSpots;
    if (allSpots.length == 1) return allSpots;

    final minX = allSpots.first.x;
    final maxX = allSpots.last.x;
    final cutoff = minX + (maxX - minX) * t;

    final result = <FlSpot>[];
    for (int i = 0; i < allSpots.length; i++) {
      if (allSpots[i].x <= cutoff) {
        result.add(allSpots[i]);
      } else {
        final prev = allSpots[i - 1];
        final next = allSpots[i];
        final frac = (cutoff - prev.x) / (next.x - prev.x);
        final y = prev.y + (next.y - prev.y) * frac;
        result.add(FlSpot(cutoff, y));
        break;
      }
    }

    if (result.isEmpty) result.add(allSpots.first);
    return result;
  }

  Widget bottomTitles(double value, TitleMeta meta, DateTime currentReading, dynamic mainColor) {
    if (value <= meta.min || value >= meta.max) {
      return SizedBox.shrink();
    }

    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    if (date.isAfter(currentReading)) {
      return SizedBox.shrink();
    }

    if (currentReading.hour % 2 == 0) {
      if (date.hour % 2 != 0) {
        return SizedBox.shrink();
      }
    } else {
      if (date.hour % 2 == 0) {
        return SizedBox.shrink();
      }
    }

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

  List<FlSpot> buildSpots(List<SensorReading> readings, String sensorId) {
    return readings.map((r) {
      final hourStart = DateTime(r.timestamp.year, r.timestamp.month, r.timestamp.day, r.timestamp.hour);
      return FlSpot(hourStart.millisecondsSinceEpoch.toDouble(), sensorValue(r, sensorId));
    }).toList();
  }

  double sensorValue(SensorReading r, String sensorId) {
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
    switch (widget.sensorID) {
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