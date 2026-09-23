import 'package:flutter/material.dart';
import 'package:air_guard/data/palatte.dart';

class Alart extends StatefulWidget {
  const Alart({super.key});

  @override
  AlartState createState() => AlartState();
}

class AlartState extends State<Alart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alart'),
        centerTitle: true,
        backgroundColor: context.mainColors.cardBg,
        foregroundColor: context.mainColors.primaryText,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction_rounded,
                size: 60,
                color: context.mainColors.secondaryText
              ),
              SizedBox(height: 10),
              Text(
                "Under development",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: context.mainColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}