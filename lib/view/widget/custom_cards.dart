import 'package:flutter/material.dart';
import 'package:air_guard/data/palatte.dart';
import 'package:air_guard/data/constant_data.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class CustomCards extends StatefulWidget {
  final Item item;
  const CustomCards({super.key, required this.item});

  @override
  CustomCardsState createState() => CustomCardsState();
}

class CustomCardsState extends State<CustomCards> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        fixedSize: Size.fromWidth(double.infinity),
        backgroundColor: context.mainColors.cardBg,
        foregroundColor: context.mainColors.primaryText,
        padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
        enableFeedback: false,
        splashFactory: NoSplash.splashFactory,
        overlayColor: context.mainColors.secondaryText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        )
      ),
      onPressed: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    widget.item.icon,
                    color: context.mainColors.secondaryText,
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.item.title,
                    style: TextStyle(
                      color: context.mainColors.primaryText,
                      fontSize: 17,
                      fontWeight: FontWeight.w400
                    ),
                  )
                ],
              ),
              IconButton(
                onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
                },
                icon: AnimatedRotation(
                  turns: isExpanded ? 0 : -0.25,
                  duration: Duration(milliseconds: 250),
                  child: Icon(FluentIcons.chevron_down_20_regular, color: context.mainColors.secondaryText,)
                ),
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
            firstChild: SizedBox(width: double.infinity,),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 15, 5),
              child: widget.item.child,
            ),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 250)
          ),
        ],
      ),
    );
  }
}