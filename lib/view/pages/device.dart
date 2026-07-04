import 'package:flutter/material.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/view/widget/app_bar.dart';
import 'package:air_guard/view/widget/device_card.dart';
import 'package:air_guard/view/widget/curved_bottom_navigation.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:provider/provider.dart';

class ConnectedDevices extends StatelessWidget {
  const ConnectedDevices({super.key});

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorNotifier>();
    return Scaffold(
      backgroundColor: context.mainColors.primaryBg,
      extendBody: true,
      appBar: DefaultAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DeviceCard(id: sensorProvider.deviceID, name: sensorProvider.deviceName),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedBottomNavbar(),
    );
  }
}