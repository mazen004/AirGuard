import 'package:flutter/material.dart';
import 'package:air_guard/data/constant.dart';
// import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class DeviceCard extends StatelessWidget {
   final String name, id;
   final String readingsTime;

  const DeviceCard({super.key, required this.name, required this.id, required this.readingsTime});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        fixedSize: Size.fromWidth(double.infinity),
        backgroundColor: context.mainColors.cardBg,
        foregroundColor: context.mainColors.primaryText,
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
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             FittedBox(
              fit: BoxFit.fitWidth,
               child: Text(
                 name,
                 style: TextStyle(
                   color: context.mainColors.primaryText,
                   fontSize: 17,
                   fontWeight: FontWeight.w400
                 ),
               ),
             ),
             Text(
               id,
               style: TextStyle(
                 color: context.mainColors.mutedText,
                 fontSize: 12,
                 fontWeight: FontWeight.w400
               ),
             )
           ],
         ),
         Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(
            //   "Last Reading: $readingsTime",
            //   style: TextStyle(
            //     fontSize: 12,
            //     color: context.mainColors.secondaryText,
            //     fontWeight: FontWeight.w400
            //   ),
            // ),
          ],
         ),
         Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
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
                ),
              ],
            ),
            Text(
              "Last Reading: $readingsTime",
              style: TextStyle(
                fontSize: 12,
                color: context.mainColors.secondaryText,
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