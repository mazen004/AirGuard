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
      backgroundColor: context.mainColors.primaryBg,
      extendBody: true,
      appBar: buildAppBar(context, sensorProvider),
      body: ValueListenableBuilder<int>(
        valueListenable: selectedCardNotifier,
        builder: (context, selectedCard, _) {
          final selectedKey = allReading.keys.elementAt(selectedCard);
          
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 90),
            child: Container(
              padding: EdgeInsets.all(10),
              color: context.mainColors.primaryBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: allReading.length,
                      separatorBuilder: (_, _) => SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final key = allReading.keys.elementAt(index);
                        final data = allReading.values.elementAt(index);
                        
                        double readingValue = 0.0;
                        if (currentReading != null) {
                          switch (key) {
                            case "aqi":
                              readingValue = currentReading.aqi;
                              break;
                            case "co":
                              readingValue = currentReading.coPPM;
                              break;
                            case "co2":
                              readingValue = currentReading.co2PPM;
                              break;
                            case "temp":
                              readingValue = currentReading.temperature;
                              break;
                            case "hum":
                              readingValue = currentReading.humidity;
                              break;
                            case "press":
                              readingValue = currentReading.pressure;
                              break;
                            case "altit":
                              readingValue = currentReading.altitude;
                              break;
                          }
                        }

                        return ReadingCard(reading: data, readingData: readingValue);
                      },
                    ),
                  ),

                  SizedBox(height: 10),

                  // --- AI Section ---
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                    height: 100,
                    decoration: BoxDecoration(
                      color: context.mainColors.cardBg,
                      borderRadius: BorderRadius.circular(20),
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
                        SizedBox(height: 5),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.mainColors.secondaryBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  // --- Graph Section ---
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                    height: 300,
                    decoration: BoxDecoration(
                      color: context.mainColors.cardBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${allReading[selectedKey]!.readingName} History",
                          style: TextStyle(color: context.mainColors.secondaryText, fontSize: 15),
                        ),
                        SizedBox(height: 5),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.mainColors.secondaryBg,
                              borderRadius: BorderRadius.circular(10),
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
      bottomNavigationBar: CurvedBottomNavbar(),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context, SensorNotifier sensorProvider) {
    return AppBar(
      backgroundColor: context.mainColors.primaryBg,
      scrolledUnderElevation: 0,
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
                    sensorProvider.updateDeviceName(sensorProvider.deviceID, controlledEditName.text);
                    setState(() => isEdit = false);
                  },
                  icon: Icon(FluentIcons.send_20_regular, color: context.mainColors.secondaryText),
                ),
              ),
            ),
    );
  }
}