import 'package:flutter/material.dart';
import 'package:air_guard/data/palatte.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/view/pages/sensors.dart';
import 'package:air_guard/view/pages/dashboard.dart';
import 'package:air_guard/view/pages/custom.dart';

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
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOutExpo,
      child: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, pageIndex, _) {
          return ValueListenableBuilder(
            valueListenable: isTimeFormat24hNotifier,
            builder: (context, _, _) {
              return ValueListenableBuilder(
                valueListenable: selectedLanguageNotifier,
                builder: (context, _, _) {
                  return IndexedStack(
                     index: pageIndex,
                     children: [
                      Sensors(),
                      Dashboard(),
                      Custom(),
                     ],
                  );
                }
              );
            }
          );
        }
      ),
    );
  }
}