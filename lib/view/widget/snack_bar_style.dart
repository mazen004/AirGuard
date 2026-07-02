import 'package:flutter/material.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:provider/provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class SnackBarAnimationStyleWrapper extends StatefulWidget {
  final String? text;
  const SnackBarAnimationStyleWrapper({super.key, this.text});

  @override
  State<SnackBarAnimationStyleWrapper> createState() => SnackBarAnimationStyleWrapperState();
}

class SnackBarAnimationStyleWrapperState extends State<SnackBarAnimationStyleWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<Offset> offsetAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 400), // Controls scroll-in speed
      vsync: this,
    )..forward(); // Starts the scroll-in immediately

    offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0), // Starts below the screen limits
      end: Offset.zero,             // Scrolls up to its resting position
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack, // Gives it a premium smooth spring bounce
    ));

    // Automatically trigger the scroll-out right before the SnackBar breaks down
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (mounted) controller.reverse(); // Smoothly scrolls back out down the screen
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Provider.of<SensorNotifierMQTT>(context, listen: false).isConnected,
      builder: (context, isConnected, child) {
        final message = widget.text ?? (isConnected ? "MQTT Connection Success" : "MQTT Connection Failed"); //? error
        return SlideTransition(
          position: offsetAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isConnected ? context.statusColors.safeBg : context.statusColors.dangerBg,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              spacing: 8,
              children: [
                Icon(
                  isConnected ? FluentIcons.checkmark_circle_20_regular : FluentIcons.dismiss_circle_20_regular,
                  color: isConnected ? context.statusColors.safeText : context.statusColors.dangerText,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: isConnected ? context.statusColors.safeText : context.statusColors.dangerText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}