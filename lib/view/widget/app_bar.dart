import 'package:flutter/material.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/view/pages/settings.dart';
import 'package:air_guard/view/pages/alart.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:provider/provider.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget { // Use StatelessWidget
  const DefaultAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.mainColors.primaryBg,
      foregroundColor: context.mainColors.primaryText,
      surfaceTintColor: context.mainColors.primaryBg,
      title: Row(
        spacing: 8,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AirGuardColors.gradientStart,
                  AirGuardColors.gradientEnd,
                ],
              ),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          Text(
            "Air Guard",
            style: TextStyle(
              color: context.mainColors.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            final sensorNotifier = Provider.of<SensorNotifierMQTT>(context, listen: false);
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: sensorNotifier,
                  child: const Alart(),
                ),
              ),
            );
          },
          icon: Icon(
            FluentIcons.alert_20_regular,
            color: context.mainColors.secondaryText,
          ),
        ),
        IconButton(
          onPressed: () {
            final sensorNotifier = Provider.of<SensorNotifierMQTT>(context, listen: false);
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: sensorNotifier,
                  child: const Setting(),
                ),
              ),
            );
          },
          icon: Icon(
            FluentIcons.settings_20_regular,
            color: context.mainColors.secondaryText,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}