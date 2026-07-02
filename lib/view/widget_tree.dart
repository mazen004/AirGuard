import 'package:flutter/material.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/view/pages/sensors.dart';
import 'package:air_guard/view/pages/dashboard.dart';
import 'package:air_guard/view/pages/connected_device.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  WidgetTreeState createState() => WidgetTreeState();
}

class WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: context.mainColors.primaryBg,
      ),
      duration: Duration(milliseconds: 400),
      child: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, pageIndex, _) {
          return IndexedStack(
             index: pageIndex,
             children: [
              Sensors(),
              Dashboard(),
              ConnectedDevices(),
             ],
          );
        }
      ),
    );
  }
}