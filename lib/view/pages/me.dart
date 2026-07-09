import 'package:air_guard/data/constant.dart';
import 'package:air_guard/view/widget/curved_bottom_navigation.dart';
import 'package:flutter/material.dart';

class Me extends StatelessWidget {
  const Me({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.mainColors.primaryBg,
      body: Container(
        child: null,
      ),
      bottomNavigationBar: CurvedBottomNavbar(),
    );
  }
}