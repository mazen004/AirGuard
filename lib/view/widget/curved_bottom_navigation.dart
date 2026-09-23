import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:air_guard/data/palatte.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/view/widget/snack_bar_style.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

class CurvedBottomNavbar extends StatelessWidget {
  const CurvedBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<SensorNotifierMQTT>(context);
    final sensorProvider = context.watch<SensorNotifier>();
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, _) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: context.mainColors.primaryBg.withAlpha(80),
                blurRadius: 15,
                spreadRadius: 10,
                offset: Offset(0, -5)
              )
            ],
          ),
          child: CurvedNavigationBar(
            index: selectedPage,
            backgroundColor: Colors.transparent, 
            color: context.mainColors.cardBg,
            buttonBackgroundColor: context.mainColors.infoBg,
            animationDuration: const Duration(milliseconds: 600),
            animationCurve: Curves.easeInOutExpo,
            letIndexChange: (index) {
              ScaffoldMessenger.of(context).clearSnackBars();
              if (index == 0) {
                if (!prov.isConnected.value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      key: UniqueKey(),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      margin: EdgeInsets.only(
                        bottom: 10,
                        left: 16,
                        right: 16,
                      ),
                      content: SnackBarAnimationStyleWrapper(key: UniqueKey(), text: 'Connect to MQTT first', icon: FluentIcons.plug_disconnected_20_regular, bgColor: context.statusColors.dangerBg, textColor: context.statusColors.dangerText),
                    ),
                  );

                  return false;
                }
                if (sensorProvider.devices.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      key: UniqueKey(),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      margin: const EdgeInsets.only(
                        bottom: 10,
                        left: 16,
                        right: 16,
                      ),
                      content: SnackBarAnimationStyleWrapper(key: UniqueKey(), text: 'No Devices Found', icon: FluentIcons.dismiss_circle_20_regular, bgColor: context.statusColors.dangerBg, textColor: context.statusColors.dangerText),
                    ),
                  );
                  return false;
                }
                if (sensorProvider.activeDeviceID.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      key: UniqueKey(),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      margin: const EdgeInsets.only(
                        bottom: 10,
                        left: 16,
                        right: 16,
                      ),
                      content: SnackBarAnimationStyleWrapper(key: UniqueKey(), text: 'No Selected Device', icon: FluentIcons.device_eq_20_regular, bgColor: context.statusColors.dangerBg, textColor: context.statusColors.dangerText),
                    ),
                  );
                  return false;
                }
                if (!sensorProvider.devices[sensorProvider.activeDeviceID]!.isOnline) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      key: UniqueKey(),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      margin: const EdgeInsets.only(
                        bottom: 10,
                        left: 16,
                        right: 16,
                      ),
                      content: SnackBarAnimationStyleWrapper(key: UniqueKey(), text: 'Device is offline', icon: FluentIcons.plug_disconnected_20_regular, bgColor: context.statusColors.dangerBg, textColor: context.statusColors.dangerText),
                    ),
                  );
                  return false;
                }
              }
              return true;
            },
            items: [
              CurvedNavigationBarItem(
                child: Icon(
                  selectedPage == 0 ? FluentIcons.device_eq_20_filled : FluentIcons.device_eq_20_regular,
                  color: selectedPage == 0 ? context.mainColors.infoText : context.mainColors.mutedText,
                ),
                label: "Sensor",
                labelStyle: TextStyle(
                  color: selectedPage == 0 ? context.mainColors.infoText : context.mainColors.mutedText
                ),
              ),
              CurvedNavigationBarItem(
                child: Icon(
                  selectedPage == 1 ? FluentIcons.home_20_filled : FluentIcons.home_20_regular,
                  color: selectedPage == 1 ? context.mainColors.infoText : context.mainColors.mutedText,
                ),
                label: "Dashboard",
                labelStyle: TextStyle(
                  color: selectedPage == 1 ? context.mainColors.infoText : context.mainColors.mutedText
                ),
              ),
              CurvedNavigationBarItem(
                child: Icon(
                  selectedPage == 2 ? FluentIcons.settings_20_filled : FluentIcons.settings_20_regular,
                  color: selectedPage == 2 ? context.mainColors.infoText : context.mainColors.mutedText,
                ),
                label: "Custom",
                labelStyle: TextStyle(
                  color: selectedPage == 2 ? context.mainColors.infoText : context.mainColors.mutedText
                ),
              ),
            ],
            onTap: (index){
              selectedPageNotifier.value = index;
            }
          ),
        );
      },
    );
  }
}