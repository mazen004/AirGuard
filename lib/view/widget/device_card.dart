import 'package:air_guard/data/constant.dart';
import 'package:flutter/material.dart';

class DeviceCard extends StatefulWidget {
  final String name, id;

  const DeviceCard({super.key, required this.name, required this.id});

  @override
  DeviceCardState createState() => DeviceCardState();
}

class DeviceCardState extends State<DeviceCard> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        fixedSize: Size.fromWidth(double.infinity),
        backgroundColor: context.mainColors.cardBg,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Text(
               widget.name,
               style: TextStyle(
                 color: context.mainColors.primaryText,
                 fontSize: 20,
                 fontWeight: FontWeight.w300
               ),
             ),
             Text(
               widget.id,
               style: TextStyle(
                 color: context.mainColors.mutedText,
                 fontSize: 10,
                 fontWeight: FontWeight.w600
               ),
             )
           ],
         ),
         Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: context.statusColors.connectText,
              radius: 5,
              child: CircleAvatar(
                backgroundColor: context.mainColors.cardBg,
                radius: 4,
                child: CircleAvatar(
                  backgroundColor: context.statusColors.connectText,
                  radius: 3,
                ),
              ),
            ),
            SizedBox(height: 2.5),
            Text(
              "online",
              style: TextStyle(
                color: context.statusColors.connectText,
                fontSize: 10,
                fontWeight: FontWeight.w400
              ),
            )
          ],
         )
       ],
      ),
    );
  }
}