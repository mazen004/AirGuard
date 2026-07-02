import 'package:flutter/material.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/constant_data.dart';
import 'package:air_guard/data/notifiers.dart';

class ReadingCard extends StatefulWidget {
  final ReadingData reading;
  final double readingData;

  const ReadingCard({
    super.key,
    required this.reading,
    required this.readingData
  });

  @override
  State<ReadingCard> createState() => _ReadingCardState();
}

class _ReadingCardState extends State<ReadingCard> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedCardNotifier,
      builder: (context, selectedId, child) {
        final isSelected = widget.reading.id == selectedId;
        return TextButton(
          style: TextButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            // overlayColor:  widget.reading.layerColor,
            backgroundColor: isSelected ? widget.reading.layerColor: context.mainColors.cardBg,
            fixedSize: Size(150, 100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: isSelected ? BorderSide(color:  widget.reading.borderColor, width: 2):BorderSide(color: Colors.transparent)
            ),
            padding: EdgeInsets.all(1),
          ),
          onPressed: () {
            selectedCardNotifier.value = widget.reading.id;
          },
          child: Container(
            padding: EdgeInsets.only(right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 2.5,
              children: [
                Container(
                  width: 8,
                  height: 95,
                  decoration: BoxDecoration(
                    color: widget.reading.mainColor,
                    borderRadius: BorderRadius.horizontal(left: Radius.elliptical(8, 16)),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        spacing: 2.5,
                        children: [
                          Icon(widget.reading.icon, color: widget.reading.mainColor),
                          FittedBox(
                            child: Text(
                              widget.reading.readingAbb,
                              style: TextStyle(
                                color: context.mainColors.secondaryText, 
                                fontSize: 15
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 10,
                        children: [
                          FittedBox(
                            child: Text(
                              widget.readingData.toString(),
                              // "---",
                              style: TextStyle(
                                color: context.mainColors.primaryText,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            widget.reading.readingUnit,
                            style: TextStyle(
                              color: context.mainColors.mutedText,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
