import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/view/widget/app_bar.dart';
import 'package:air_guard/view/widget/device_card.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:air_guard/view/widget/curved_bottom_navigation.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorNotifier>();
    final reading = sensorProvider.current?.timestamp; 
    var readingTime = "";
    if (reading != null){
      readingTime = DateFormat("$timeFormatHour:mm:ss$timeFormat").format(reading);
    }
    else{
      readingTime = "00:00:00";
    }
    // final readingTime = "HH:mm:ss";

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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DeviceCard(id: sensorProvider.deviceID, name: sensorProvider.deviceName, readingsTime: readingTime,),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.mainColors.cardBg,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FluentIcons.add_20_regular,
                      color: context.mainColors.primaryText,
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedBottomNavbar(),
    );
  }
}