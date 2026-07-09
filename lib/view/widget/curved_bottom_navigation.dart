import 'package:air_guard/data/constant.dart';
import 'package:flutter/material.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

class CurvedBottomNavbar extends StatelessWidget {
  const CurvedBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
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
            animationDuration: const Duration(milliseconds: 300),
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
                  selectedPage == 2 ? FluentIcons.person_20_filled : FluentIcons.person_20_regular,
                  color: selectedPage == 2 ? context.mainColors.infoText : context.mainColors.mutedText,
                ),
                label: "Me",
                labelStyle: TextStyle(
                  color: selectedPage == 2 ? context.mainColors.infoText : context.mainColors.mutedText
                ),
              ),
            ],
            onTap: (index) => selectedPageNotifier.value = index,
          ),
        );
      },
    );
  }
}