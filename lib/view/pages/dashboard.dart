import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/view/widget/app_bar.dart';
import 'package:air_guard/view/widget/device_dashboard_card.dart';
import 'package:air_guard/view/widget/device_card.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:air_guard/view/widget/curved_bottom_navigation.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorNotifier>();
    final deviceData = sensorProvider.deviceNames;

    return Scaffold(
      extendBody: true,
      backgroundColor: context.mainColors.primaryBg,
      appBar: DefaultAppBar(),
      body: deviceData.isEmpty ?
      Center(
        child: Text(
          "No Device is Added Start by Adding One",
          style: TextStyle(
            color: context.mainColors.mutedText
          ),
        ),
      )
      : Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DeviceDashboardCard(
              deviceID: sensorProvider.activeDeviceID,
              device: deviceData.values.elementAt(0),
            ),
            SizedBox(height: 15,),
            Expanded(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: deviceData.length,
                separatorBuilder: (_, _) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return DeviceCard(
                    deviceID: deviceData.keys.elementAt(index),
                    device: deviceData.values.elementAt(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.mainColors.cardBg,
        foregroundColor: context.mainColors.primaryText,
        splashColor: context.mainColors.secondaryBg.withAlpha(80),
        tooltip: "Add New Device",
        shape: CircleBorder(),
        onPressed: () {},
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: context.mainColors.primaryBg.withAlpha(80),
                blurRadius: 15,
                spreadRadius: 10,
              )
            ],
          ),
          child: Icon(
            FluentIcons.add_20_regular,
            color: context.mainColors.primaryText,
          ),
        )
      ),
      bottomNavigationBar: CurvedBottomNavbar(),
    );
  }
}