import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/data/constant_data.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class DeviceCard extends StatefulWidget {
  final String deviceID;
  final Device device;
  final bool isExpanded;
  final VoidCallback onToggle;

  const DeviceCard({
    super.key,
    required this.deviceID,
    required this.device,
    required this.isExpanded,
    required this.onToggle
  });

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  final TextEditingController deviceNameController = TextEditingController();
  // ValueNotifier<bool> isEditNotifer = ValueNotifier(false);

  bool isEdit = false;
  bool readingOpen = false;

  @override
  void dispose() {
    deviceNameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorNotifier>();
    deviceNameController.text = widget.device.deviceName;
      return TextButton(
        style: TextButton.styleFrom(
          fixedSize: Size.fromWidth(double.infinity),
          backgroundColor: context.mainColors.cardBg,
          foregroundColor: context.mainColors.primaryText,
          padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
          enableFeedback: false,
          splashFactory: NoSplash.splashFactory,
          overlayColor: context.mainColors.secondaryText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(20),
            
          )
        ),
        onPressed: isEdit ? null :() {
            selectedPageNotifier.value = 0;
            sensorProvider.selectDevice(widget.deviceID);
        },
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: widget.onToggle,
                  icon: AnimatedRotation(
                    turns: widget.isExpanded ? 0 : -0.25,
                    duration: Duration(milliseconds: 250),
                    child: Icon(FluentIcons.chevron_down_20_regular, color: context.mainColors.secondaryText,)
                  ),
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                  ),
                ),
                SizedBox(width: 5,),
                Flexible(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.device.deviceName,
                              style: TextStyle(
                                color: context.mainColors.primaryText,
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Text(
                            widget.deviceID,
                            style: TextStyle(
                              color: context.mainColors.mutedText,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Online: ${DateTime.now().difference(widget.device.lastReadingTime).inSeconds <= selectedRefreashRateNotifier.value ? "now\n": DateFormat("$timeFormatHour:mm:ss$timeFormat\nE MMM dd").format(widget.device.lastReadingTime)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: context.mainColors.secondaryText,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: widget.device.isOnline ? context.statusColors.connectText : context.statusColors.disconnectText,
                            radius: 5,
                            child: CircleAvatar(
                              backgroundColor: context.mainColors.cardBg,
                              radius: 4,
                              child: CircleAvatar(
                                backgroundColor: widget.device.isOnline ? context.statusColors.connectText : context.statusColors.disconnectText,
                                radius: 3,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.5),
                          Text(
                            widget.device.isOnline ? 'online' : 'offline',
                            style: TextStyle(
                              color: widget.device.isOnline ? context.statusColors.connectText : context.statusColors.disconnectText,
                              fontSize: 10,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            AnimatedCrossFade(
              firstChild: SizedBox(width: double.infinity,),
              secondChild: AnimatedCrossFade(
                firstChild: expandeWidget(context, sensorProvider),
                secondChild: expandeEditWidget(context, sensorProvider),
                crossFadeState: isEdit ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 250),
              ),
              crossFadeState: widget.isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 250)
            )
          ],
        ),
      );
  } 
  Widget expandeWidget(BuildContext context, SensorNotifier sensorProvider) {
    final allReading = ReadingMeta.supportedReading(context);
    final readings = widget.device.readingProvided;
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(20, 10, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Device Name: ${widget.device.deviceName}',
            style: TextStyle(
              color: context.mainColors.primaryText,
              fontWeight: FontWeight.w400,
              fontSize: 15
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reading Provided:',
                style: TextStyle(
                  color: context.mainColors.primaryText,
                  fontWeight: FontWeight.w400,
                  fontSize: 15
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    readingOpen = !readingOpen;
                  });
                }, 
                // iconSize: 15,
                icon: AnimatedRotation(
                  duration: Duration(milliseconds: 250),
                  turns: readingOpen ? 0 : -0.25,
                  child: Icon(
                    FluentIcons.chevron_down_16_regular,
                    color: context.mainColors.primaryText,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ),
            ],
          ), 
          AnimatedCrossFade(
            firstChild: SizedBox(width: double.infinity,),
            secondChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder(
                  horizontalInside: BorderSide(
                    width: 2,
                    color: context.mainColors.secondaryBg,
                  )
                ),
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FluentIcons.reading_list_20_regular,
                                color: context.mainColors.secondaryText,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Reading',
                                style: TextStyle(
                                  color: context.mainColors.secondaryText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ]
                          ),
                        ),
                      ),
                      TableCell(verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              'Used Unit',
                              style: TextStyle(
                                color: context.mainColors.secondaryText,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                  ...readings.map((reading) {
                  final key = reading.reading;
                  final meta = allReading[key];
      
                  return TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                meta!.icon,
                                color: context.mainColors.mutedText,
                              ),
                              SizedBox(width: 5),
                              Text(
                                meta.readingAbb,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: context.mainColors.secondaryText,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              reading.unit,
                              style: TextStyle(
                                fontSize: 15,
                                color: context.mainColors.secondaryText,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          crossFadeState: readingOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 250)
          ),
          
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: context.statusColors.dangerBg,
                  foregroundColor: context.statusColors.dangerText,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: context.statusColors.dangerText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.directional(
                      topStart: Radius.circular(20),
                      bottomStart: Radius.circular(20),
                      topEnd: Radius.circular(0),
                      bottomEnd: Radius.circular(0),
                    ),
                  )
                ),
                onPressed: () {
                  setState(() {
                    isEdit = false;
                    sensorProvider.deleteDevice(widget.deviceID);
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      FluentIcons.delete_20_regular,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      'Delete',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: context.mainColors.secondaryBg,
                  foregroundColor: context.mainColors.secondaryText,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: context.mainColors.secondaryText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.directional(
                      topStart: Radius.circular(0),
                      bottomStart: Radius.circular(0),
                      topEnd: Radius.circular(20),
                      bottomEnd: Radius.circular(20),
                    )
                  )
                ),
                onPressed: () {
                  setState(() {
                    isEdit = true;
                    readingOpen = false;
                  });
                },
                child: Row(
                  children: [
                    Icon(FluentIcons.edit_20_regular),
                    SizedBox(width: 5,),
                    Text(
                      "Edit",
                      style: TextStyle(
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                )
              ),
            ]
          ),
        ],
      ),
    );
  }

  Widget expandeEditWidget(BuildContext context, SensorNotifier sensorProvider) {
    final allReading = ReadingMeta.supportedReading(context);
    final readings = widget.device.readingProvided;
    final List<ReadingUnit> newUnit = readings;
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(20, 10, 0, 10),
      child: Column(
        children: [
          TextField(
            controller: deviceNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              labelText: "Device Name",
            ),
          ),
          SizedBox(height: 10,),
          ...readings.map((reading) {
            final key = reading.reading;
            final meta = allReading[key];
            final readingUnit = meta!.readingUnit;
            if (readingUnit == null || readingUnit.isEmpty) {
              return const SizedBox.shrink();
            }
            final ReadingUnit unit = reading;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${meta.readingAbb}: ",
                    style: TextStyle(
                      color: context.mainColors.primaryText,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: AnimatedToggleSwitch.size(
                      current: reading.unit, 
                      values: readingUnit.toList(),
                      style: ToggleStyle(
                        backgroundColor: context.mainColors.secondaryBg,
                        indicatorColor: context.mainColors.activeBg,
                        borderColor: context.mainColors.secondaryBg,
                        indicatorBorderRadius: BorderRadius.all(Radius.elliptical(20, 40))
                      ),
                      iconOpacity: 1.0,
                      selectedIconScale: 1.0,
                      indicatorSize: Size.fromWidth(180 / readingUnit.length),
                      iconAnimationType: AnimationType.onHover,
                      styleAnimationType: AnimationType.onHover,
                      animationCurve: Curves.easeInOutExpo,
                      height: 40,
                      spacing: 2.0,
                      customIconBuilder: (context, selectedUnit, global) {
                        final text = readingUnit.toList()[selectedUnit.index];
                        return  Center(
                          child: Text(
                            text,
                            style: TextStyle(
                              color: text == reading.unit  ? context.mainColors.primaryText : context.mainColors.secondaryText,
                              fontSize: 14
                            ),
                          ),
                        );
                      },
                      borderWidth: 0,
                      onChanged: (value) { 
                        setState(() {
                          unit.unit = value;
                        });
                      }
                    ),
                  )
                ],
              ),
            );
          }),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: context.statusColors.dangerBg,
                  foregroundColor: context.statusColors.dangerText,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: context.statusColors.dangerText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.directional(
                      topStart: Radius.circular(20),
                      bottomStart: Radius.circular(20),
                      topEnd: Radius.circular(0),
                      bottomEnd: Radius.circular(0),
                    ),
                  )
                ),
                onPressed: () {
                  setState(() {
                    isEdit = false;
                    sensorProvider.deleteDevice(widget.deviceID);
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      FluentIcons.delete_20_regular,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      'Delete',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: context.mainColors.secondaryBg,
                  foregroundColor: context.mainColors.secondaryText,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: context.mainColors.secondaryText,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.zero))
                ),
                onPressed: () {
                  setState(() {
                    isEdit = false;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      FluentIcons.edit_off_20_regular,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: context.statusColors.safeBg,
                  foregroundColor: context.statusColors.safeText,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: context.statusColors.safeText,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.directional(topStart: Radius.circular(0), bottomStart: Radius.circular(0), topEnd: Radius.circular(20), bottomEnd: Radius.circular(20)))
                ),
                onPressed: () {
                  sensorProvider.updateDeviceName(widget.deviceID, deviceNameController.text);
                  setState(() {
                    isEdit = false;
                  });
                  sensorProvider.deviceNames[widget.deviceID]!.readingProvided = newUnit;
                },
                child: Row(
                  children: [
                    Icon(
                      FluentIcons.save_20_regular,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ),
            ],
          )
        ],
      ),
    );
  }
}