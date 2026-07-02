import 'package:air_guard/data/constant.dart';
import 'package:flutter/material.dart';
// import 'package:air_guard/data/constant.dart';
import 'package:air_guard/view/widget/app_bar.dart';
import 'package:air_guard/view/widget/curved_bottom_navigation.dart';

class ConnectedDevices extends StatefulWidget {
  const ConnectedDevices({super.key});

  @override
  ConnectedDevicesState createState() => ConnectedDevicesState();
}

class ConnectedDevicesState extends State<ConnectedDevices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.mainColors.primaryBg,
      extendBody: true,
      appBar: DefaultAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded, size: 60, color: context.mainColors.secondaryText),
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
      bottomNavigationBar: CurvedBottomNavbar(),
    );
  }
}