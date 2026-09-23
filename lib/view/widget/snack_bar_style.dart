import 'package:flutter/material.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:provider/provider.dart';

class SnackBarAnimationStyleWrapper extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color bgColor; 
  final Color textColor; 
  const SnackBarAnimationStyleWrapper({super.key, required this.text, required this.icon, required this.bgColor, required this.textColor});

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
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward(); 

    offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0), 
      end: Offset.zero,             
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack, 
    ));
  
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (mounted) controller.reverse(); 
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
        final message = widget.text;
        return SlideTransition(
          position: offsetAnimation,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.bgColor,
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
                  widget.icon,
                  color: widget.textColor,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: widget.textColor,
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