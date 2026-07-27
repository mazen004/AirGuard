// import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/data/constant_data.dart';
// import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class DeviceCard extends StatelessWidget {
  final String deviceID;
  final Device device;
  const DeviceCard({super.key, required this.deviceID, required this.device});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        fixedSize: Size.fromWidth(double.infinity),
        backgroundColor: context.mainColors.cardBg,
        foregroundColor: context.mainColors.primaryText,
        padding: EdgeInsets.symmetric(horizontal:  15, vertical: 10),
        enableFeedback: false,
        splashFactory: NoSplash.splashFactory,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
          
        )
      ),
      onPressed: () {},
      child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             FittedBox(
             fit: BoxFit.fitWidth,
               child: Text(
                 device.deviceName,
                 style: TextStyle(
                   color: context.mainColors.primaryText,
                   fontSize: 17,
                   fontWeight: FontWeight.w400
                 ),
               ),
             ),
             Text(
               deviceID,
               style: TextStyle(
                 color: context.mainColors.mutedText,
                 fontSize: 12,
                 fontWeight: FontWeight.w400
               ),
             )
           ],
         ),
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Online: ${DateTime.now().difference(device.lastReadingTime).inSeconds <= selectedRefreashRateNotifier.value ? "now\n": DateFormat("$timeFormatHour:mm:ss$timeFormat\nE MMM dd").format(device.lastReadingTime)}',
              style: TextStyle(
                fontSize: 12,
                color: context.mainColors.secondaryText,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.end,
            ),
          ],
         ),
         Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             CircleAvatar(
               backgroundColor: device.isOnline ? context.statusColors.connectText : context.statusColors.disconnectText,
               radius: 5,
               child: CircleAvatar(
                 backgroundColor: context.mainColors.cardBg,
                 radius: 4,
                 child: CircleAvatar(
                   backgroundColor: device.isOnline ? context.statusColors.connectText : context.statusColors.disconnectText,
                   radius: 3,
                 ),
               ),
             ),
             SizedBox(height: 2.5),
             Text(
               device.isOnline ? 'online' : 'offline',
               style: TextStyle(
                 color: device.isOnline ? context.statusColors.connectText : context.statusColors.disconnectText,
                 fontSize: 10,
                 fontWeight: FontWeight.w400
               ),
             ),
           ],
         )
       ],
      ),
    );
  } 

}