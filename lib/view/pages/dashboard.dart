import 'package:flutter/material.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/view/widget/app_bar.dart';
import 'package:air_guard/view/widget/curved_bottom_navigation.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: DefaultAppBar(),
      body: Container(
        decoration: BoxDecoration(
          color: context.mainColors.primaryBg
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction_rounded,
                size: 60,
                color: context.mainColors.secondaryText
              ),
              SizedBox(height: 10),
              Text(
                "Under development",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: context.mainColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedBottomNavbar(),
    );
  }
}