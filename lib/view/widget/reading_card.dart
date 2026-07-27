import 'package:flutter/material.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/constant_data.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:provider/provider.dart';

class ReadingCard extends StatefulWidget {
  final String readingID;
  final ReadingMeta reading;
  final double readingData;

  const ReadingCard({
    super.key,
    required this.readingID,
    required this.reading,
    required this.readingData
  });

  @override
  State<ReadingCard> createState() => _ReadingCardState();
}

class _ReadingCardState extends State<ReadingCard> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<SensorNotifierMQTT>(context);
    final value = prov.isConnected.value
    ? widget.readingData.toStringAsFixed(2)
    : "---";
    return ValueListenableBuilder(
      valueListenable: selectedCardNotifier,
      builder: (context, selectedID, child) {
        final isSelected = widget.readingID == selectedID;
        return SizedBox(
          width: 150,
          height: 100,
          child: TextButton(
            style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              overlayColor:  widget.reading.layerColor,
              backgroundColor: isSelected ? widget.reading.layerColor: context.mainColors.cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: isSelected ? BorderSide(color:  widget.reading.borderColor, width: 2):BorderSide(color: context.mainColors.cardBg)
              ),
              padding: EdgeInsets.all(1),
            ),
            onPressed: () {
              selectedCardNotifier.value = widget.readingID;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 1,
                      children: [
                        Row(
                          spacing: 5,
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
                          children: [
                            Expanded(
                              child: Text(
                                value,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                softWrap: false,
                                style: TextStyle(
                                  color: context.mainColors.primaryText,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              widget.reading.readingUnit,
                              style: TextStyle(
                                color: context.mainColors.mutedText,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                              decoration: BoxDecoration(
                                color: context.statusColors.safeBg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: context.statusColors.safeText,
                                  width: 1,
                                )
                              ),
                              child: Text(
                                "Safe",
                                style: TextStyle(
                                  color: context.statusColors.safeText,
                                  fontSize: 10,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
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
