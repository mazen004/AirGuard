import 'package:flutter/material.dart';
import 'package:air_guard/data/palatte.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/data/storage_manager.dart';
import 'package:country_flags_pro/country_flags_pro.dart';
// import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class General extends StatelessWidget {
  const General({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Language:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: context.mainColors.secondaryText,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: selectedLanguageNotifier,
              builder: (context, selectedLanguage, _) {
                return SizedBox(
                  width: 180,
                  child: AnimatedToggleSwitch<String>.rolling(
                    current: selectedLanguage,
                    values: ['en', 'ar', 'de', 'fr'],
                    style: ToggleStyle(
                      backgroundColor: context.mainColors.secondaryBg,
                      indicatorColor: context.mainColors.activeBg,
                      borderColor: context.mainColors.secondaryBg,
                    ),
                    height: 40,
                    indicatorSize: Size.fromWidth(40),
                    styleAnimationType: AnimationType.onHover,
                    indicatorAnimationType: AnimationType.onHover,
                    animationCurve: Curves.easeInOutExpo,
                    customIconBuilder: (context, selectedFlage, global) {
                      final text = ['us', 'eg', 'de', 'fr'][selectedFlage.index];
                      return Container(
                        padding: EdgeInsets.all(2.5),
                        child: CountryFlagsPro.getFlag(text,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      );
                    },
                    onChanged: (value) {
                      selectedLanguageNotifier.value = value;
                      StorageManager.saveLanguage(value);
                    },
                  ),
                );
              }
            )
          ],
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Time Format:',
              style: TextStyle(
                color: context.mainColors.secondaryText,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: isTimeFormat24hNotifier,
              builder: (context, timeFormat, _) {
                return SizedBox(
                  width: 180,
                  child: AnimatedToggleSwitch<bool>.size(
                    current: timeFormat,
                    values: [true, false],
                    style: ToggleStyle(
                      backgroundColor: context.mainColors.secondaryBg,
                      indicatorColor: context.mainColors.activeBg,
                      borderColor: context.mainColors.secondaryBg,
                      indicatorBorderRadius: BorderRadius.all(Radius.elliptical(20, 40))
                    ),
                    iconOpacity: 1.0,
                    selectedIconScale: 1.0,
                    indicatorSize: Size.fromWidth(90),
                    height: 40,
                    iconAnimationType: AnimationType.onHover,
                    styleAnimationType: AnimationType.onHover,
                    animationCurve: Curves.easeInOutExpo,
                    spacing: 2.0,
                    customIconBuilder: (context, selectedTimeFormate, global) {
                      final text = ['24hr', '12hr'][selectedTimeFormate.index];
                      final is24hr = isTimeFormat24hNotifier.value ^ (text == '12hr');
                      return  Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: is24hr ? context.mainColors.primaryText : context.mainColors.secondaryText,
                            fontSize: 14
                          ),
                        ),
                      );
                    },
                    borderWidth: 0,
                    onChanged: (value) async{ 
                      isTimeFormat24hNotifier.value = value;
                      StorageManager.saveTimeFormat(value);
                    }
                  ),
                );
              }
            ),
          ],
        ),
        SizedBox(height: 10,),
      ],
    );
  }
}