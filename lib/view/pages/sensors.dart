import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/view/widget/graph.dart';
import 'package:air_guard/data/constant_data.dart'; 
import 'package:air_guard/view/widget/reading_card.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:air_guard/view/widget/curved_bottom_navigation.dart';

class Sensors extends StatefulWidget {
  const Sensors({super.key});

  @override
  SensorsState createState() => SensorsState();
}

class SensorsState extends State<Sensors> {
  bool isEdit = false;
  final TextEditingController controlledEditName = TextEditingController();

  @override
  void dispose() {
    controlledEditName.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mqtt = context.read<SensorNotifierMQTT>();
    final sensor = context.read<SensorNotifier>();
    mqtt.bindSensorNotifier(sensor);
  }

  @override
  Widget build(BuildContext context) {
    final allReading = ReadingRegistry.getReadings(context);
    final sensorProvider = context.watch<SensorNotifier>();
    final graphReadings = sensorProvider.graphHistory;
    final currentReading = sensorProvider.current;

    return Scaffold(
      extendBody: true,
      appBar: _buildAppBar(context, sensorProvider),
      body: ValueListenableBuilder<int>(
        valueListenable: selectedCardNotifier,
        builder: (context, selectedCard, _) {
          final selectedKey = allReading.keys.elementAt(selectedCard);
          
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 100),
            child: Container(
              padding: const EdgeInsets.all(10),
              color: context.mainColors.primaryBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Horizontal Sensor List ---
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: allReading.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final key = allReading.keys.elementAt(index);
                        final data = allReading.values.elementAt(index);
                        
                        double readingValue = 0.0;
                        if (currentReading != null) {
                          switch (key) {
                            case "aqi": readingValue = currentReading.aqi; break;
                            case "co": readingValue = currentReading.coPPM; break;
                            case "co2": readingValue = currentReading.co2PPM; break;
                            case "temp": readingValue = currentReading.temperature; break;
                            case "hum": readingValue = currentReading.humidity; break;
                            case "press": readingValue = currentReading.pressure; break;
                            case "altit": readingValue = currentReading.altitude; break;
                          }
                        }

                        return ReadingCard(reading: data, readingData: readingValue);
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // --- AI Section ---
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    height: 100,
                    decoration: BoxDecoration(
                      color: context.mainColors.cardBg,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("AI Section", style: TextStyle(color: context.mainColors.secondaryText, fontSize: 15)),
                            Text("Powered by Gemini", style: TextStyle(color: context.mainColors.mutedText, fontSize: 10)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.mainColors.secondaryBg,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // --- Graph Section ---
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    height: 300,
                    decoration: BoxDecoration(
                      color: context.mainColors.cardBg,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${allReading[selectedKey]!.readingName} History",
                          style: TextStyle(color: context.mainColors.secondaryText, fontSize: 15),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.mainColors.secondaryBg,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SensorGraph(
                              sensorId: selectedKey, 
                              readings: graphReadings,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const CurvedBottomNavbar(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, SensorNotifier sensorProvider) {
    return AppBar(
      title: !isEdit
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sensorProvider.deviceName, style: TextStyle(color: context.mainColors.primaryText)),
                IconButton(
                  onPressed: () => setState(() {
                    isEdit = true;
                    controlledEditName.text = sensorProvider.deviceName;
                  }),
                  icon: Icon(FluentIcons.edit_16_regular, color: context.mainColors.mutedText),
                ),
              ],
            )
          : TextField(
              controller: controlledEditName,
              style: TextStyle(color: context.mainColors.primaryText),
              decoration: InputDecoration(
                labelText: "Device Name",
                prefixIcon: IconButton(
                  onPressed: () => setState(() => isEdit = false),
                  icon: Icon(FluentIcons.text_edit_style_20_regular, color: context.mainColors.secondaryText),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    sensorProvider.updateDeviceName(controlledEditName.text);
                    setState(() => isEdit = false);
                  },
                  icon: Icon(FluentIcons.send_20_regular, color: context.mainColors.secondaryText),
                ),
              ),
            ),
    );
  }
}