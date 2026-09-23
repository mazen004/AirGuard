import 'package:flutter/material.dart';
import 'package:air_guard/data/palatte.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/data/storage_manager.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class ThemeButtons extends StatefulWidget {
  const ThemeButtons({super.key});

  @override
  State<ThemeButtons> createState() => _ThemeButtonsState();
}

class _ThemeButtonsState extends State<ThemeButtons> {
  final List<ThemeMode> supportedThemaMode = [
    ThemeMode.dark,
    ThemeMode.system,
    ThemeMode.light,
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch<ThemeMode>.size(
      style: ToggleStyle(
        backgroundColor: context.mainColors.secondaryBg,
        indicatorColor: context.mainColors.activeBg,
        borderRadius: BorderRadius.circular(20),
        borderColor: context.mainColors.secondaryBg,
        indicatorBorderRadius: BorderRadius.all(Radius.elliptical(15, 30))
      ),
      current: themeModeNotifier.value,
      values: [ThemeMode.dark, ThemeMode.system, ThemeMode.light],
      iconOpacity: 1.0,
      selectedIconScale: 1.0,
      iconAnimationType: AnimationType.onHover,
      styleAnimationType: AnimationType.onHover,
      indicatorSize: Size.fromWidth(double.infinity/3),
      height: 40,
      animationCurve: Curves.easeInOutExpo,
      spacing: 2.0,
      customIconBuilder: (context, selectedThemeMode, global) {
        final text = ['Dark Mode', 'System Mode', 'Light Mode'][selectedThemeMode.index];
        final icon = [FluentIcons.weather_moon_20_regular, FluentIcons.desktop_20_regular, FluentIcons.weather_sunny_20_regular][selectedThemeMode.index];
        return  Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 2.5, horizontal: 5),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: selectedThemeMode.index == supportedThemaMode.indexOf(themeModeNotifier.value) ? context.mainColors.primaryText :context.mainColors.secondaryText,
                  size: 20,
                ),
                SizedBox(width: 5,),
                Text(
                  text,
                  style: TextStyle(
                    color: selectedThemeMode.index == supportedThemaMode.indexOf(themeModeNotifier.value) ? context.mainColors.primaryText :context.mainColors.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      borderWidth: 0,
      onChanged: (index) {
        themeModeNotifier.value = index;
        StorageManager.saveThemeMode(index); 
      }
    );
  }
}