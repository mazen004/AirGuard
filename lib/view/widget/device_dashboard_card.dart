// import 'dart:math' as math;
// import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:air_guard/data/constant.dart';
// import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/data/constant_data.dart';
// import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class DeviceDashboardCard extends StatelessWidget {
  final String deviceID;
   final Device device;

  const DeviceDashboardCard({super.key, required this.deviceID, required this.device});

  @override
  Widget build(BuildContext context) {
    // final sensorProvider = context.watch<SensorNotifier>;
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: device.isOnline ? context.statusColors.connectBg : context.statusColors.disconnectBg,
          overlayColor: device.isOnline ? context.statusColors.connectBg : context.statusColors.disconnectText,
          foregroundColor: device.isOnline ? context.mainColors.primaryText : context.statusColors.disconnectText,
          padding: EdgeInsets.symmetric(horizontal:  15, vertical: 10),
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(20),
            side: BorderSide(
              color: device.isOnline ? context.statusColors.connectText : context.statusColors.disconnectBg,
              width: 2
            )
          ),
        ),
        onPressed: () {
          // sensorProvider.activeDeviceID = deviceID;
        },
      
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                fit: BoxFit.fitWidth,
                  child: Text(
                    device.deviceName,
                    style: TextStyle(
                      // color: context.mainColors.primaryText,
                      fontSize: 17,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}