import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/data/storage_manager.dart';
import 'package:country_flags_pro/country_flags_pro.dart';
import 'package:air_guard/view/widget/snack_bar_style.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  TextEditingController? controlledURL;
  TextEditingController? controlledPort;
  TextEditingController? controlledUsername;
  TextEditingController? controlledPassword;
  TextEditingController? controlledTopic;
  bool isPasswordShowen = false;

  List<ThemeMode> supportedThemaMode = [
    ThemeMode.dark,
    ThemeMode.system,
    ThemeMode.light,
  ];

  @override
  void dispose() {
    controlledURL?.dispose();
    controlledPort?.dispose();
    controlledUsername?.dispose();
    controlledPassword?.dispose();
    controlledTopic?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<SensorNotifierMQTT>(context);

    controlledURL ??= TextEditingController(text: prov.mqttUrl);
    controlledPort ??= TextEditingController(text: prov.mqttPort);
    controlledUsername ??= TextEditingController(text: prov.mqttUser);
    controlledPassword ??= TextEditingController(text: prov.mqttPass);
    controlledTopic ??= TextEditingController(text: prov.mqttTopic);
    // final currentThemeMode = supportedThemaMode.indexOf(themeModeNotifier.value);

    return Scaffold(
      backgroundColor: context.mainColors.primaryBg,
      extendBody: true,
      
      appBar: AppBar(
        backgroundColor: context.mainColors.primaryBg,
        foregroundColor: context.mainColors.primaryText,
        surfaceTintColor: context.mainColors.primaryBg,
        leading: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.pop(context);
          },
          icon: Icon(FluentIcons.arrow_previous_20_regular)
        ),
        title: const Text('Setting'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            settingHeaderText('Theme Mode'),
            settingCard(
              cardPadding: 8,
              AnimatedToggleSwitch<ThemeMode>.size(
                style: ToggleStyle(
                  backgroundColor: context.mainColors.secondaryBg,
                  indicatorColor: context.mainColors.activeBg,
                  borderRadius: BorderRadius.circular(15),
                  borderColor: context.mainColors.secondaryBg,
                  indicatorBorderRadius: BorderRadius.all(Radius.elliptical(15, 30))
                ),
                current: themeModeNotifier.value,
                values: [ThemeMode.dark, ThemeMode.system, ThemeMode.light],
                iconOpacity: 1.0,
                selectedIconScale: 1.0,
                iconAnimationType: AnimationType.onHover,
                styleAnimationType: AnimationType.onHover,
                indicatorSize: Size.fromWidth(double.infinity/3),
                height: 30,
                animationCurve: Curves.easeInOutExpo,
                spacing: 2.0,
                customIconBuilder: (context, selectedThemeMode, global) {
                  final text = ['Dark Mode', 'System Mode', 'Light Mode'][selectedThemeMode.index];
                  final icon = [FluentIcons.weather_moon_20_regular, FluentIcons.desktop_20_regular, FluentIcons.weather_sunny_20_regular][selectedThemeMode.index];
                  return  Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 2.5, horizontal: 5),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            color: selectedThemeMode.index == supportedThemaMode.indexOf(themeModeNotifier.value) ? context.mainColors.primaryText :context.mainColors.secondaryText,
                            size: 20,
                          ),
                          SizedBox(width: 5,),
                          Text(
                            text,
                            style: TextStyle(
                              color: selectedThemeMode.index == supportedThemaMode.indexOf(themeModeNotifier.value) ? context.mainColors.primaryText :context.mainColors.secondaryText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                borderWidth: 0,
                onChanged: (index) {
                  themeModeNotifier.value = index;
                  StorageManager.saveThemeMode(index); 
                }
              ),
            ),
            const SizedBox(height: 15),
            ValueListenableBuilder<bool>(
              valueListenable: Provider.of<SensorNotifierMQTT>(context, listen: false).isConnected,
                builder: (context, isConnected, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    settingHeaderText('Broker Connection:'),
                    Row(
                      spacing: 5,
                      children: [
                        Icon(
                          isConnected ? FluentIcons.cloud_sync_20_regular : FluentIcons.cloud_dismiss_20_regular,
                          color: isConnected ? context.statusColors.connectText : context.statusColors.disconnectText,
                          ),
                        Text(
                          isConnected ? 'Connected' : 'Disconnected',
                          style: TextStyle(
                            color: isConnected ? context.statusColors.connectText : context.statusColors.disconnectText,
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }
            ),
            SizedBox(height: 10),
            settingCard(
              Column(
                children: [
                  brokerTextField('Broker URL', controlledURL!, FluentIcons.globe_20_regular),
                  SizedBox(height: 10,),
                  brokerTextField('Topic', controlledTopic!, FluentIcons.apps_list_detail_20_regular),
                  SizedBox(height: 10,),
                  brokerTextField('Port', controlledPort!, FluentIcons.connector_20_regular),
                  SizedBox(height: 10,),
                  brokerTextField('Username', controlledUsername!, FluentIcons.person_20_regular),
                  SizedBox(height: 10,),
                  brokerTextField('Password', controlledPassword!, FluentIcons.password_20_regular, isPassword: true),
                  SizedBox(height: 10,),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: Provider.of<SensorNotifierMQTT>(context, listen: false).isConnected,
                      builder: (context, isConnected, child) {
                        return ElevatedButton.icon(
                          onPressed: () async {
                                if(isConnected){
                                  await prov.disconnect();
                                  if(!context.mounted) return;

                                  ScaffoldMessenger.of(context).clearSnackBars();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      key: UniqueKey(),
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      content: SnackBarAnimationStyleWrapper(key: UniqueKey(), text: 'MQTT Disconnected',),
                                    ),
                                  );

                                  return;
                                }

                                await prov.saveAndConnect(
                                  controlledURL!.text,
                                  controlledPort!.text,
                                  controlledUsername!.text,
                                  controlledPassword!.text,
                                );
                                await prov.connect();

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).clearSnackBars();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    key: UniqueKey(),
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: SnackBarAnimationStyleWrapper(key: UniqueKey()),
                                  ),
                                );
                              },
                          icon: Icon(isConnected ? FluentIcons.plug_connected_20_regular : FluentIcons.plug_disconnected_20_regular),
                          label: Text(isConnected ? 'Connected' : 'Connect'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isConnected ? context.statusColors.connectBg : context.mainColors.secondaryBg,
                            foregroundColor: isConnected ? context.statusColors.connectText : context.mainColors.primaryText,
                            elevation: 0,
                            overlayColor: context.mainColors.activeBg,
                            shadowColor: context.mainColors.infoBg,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            settingHeaderText('Genaral'),
            SizedBox(height: 10,),
            settingCard(
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Language:',
                        style: TextStyle(
                          fontSize: 16,
                          color: context.mainColors.secondaryText,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: selectedLanguageNotifier,
                        builder: (context, selectedLanguage, _) {
                          return SizedBox(
                            width: 180,
                            child: AnimatedToggleSwitch<String>.rolling(
                              current: selectedLanguage,
                              values: ['en', 'ar', 'de', 'fr'],
                              style: ToggleStyle(
                                backgroundColor: context.mainColors.secondaryBg,
                                indicatorColor: context.mainColors.activeBg,
                                borderColor: context.mainColors.secondaryBg,
                              ),
                              height: 40,
                              indicatorSize: Size.fromWidth(40),
                              styleAnimationType: AnimationType.onHover,
                              indicatorAnimationType: AnimationType.onHover,
                              animationCurve: Curves.easeInOutExpo,
                              customIconBuilder: (context, selectedFlage, global) {
                                final text = ['us', 'eg', 'de', 'fr'][selectedFlage.index];
                                return Container(
                                  padding: EdgeInsets.all(2.5),
                                  child: CountryFlagsPro.getFlag(text,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                );
                              },
                              onChanged: (value) {
                                selectedLanguageNotifier.value = value;
                                StorageManager.saveLanguage(value);
                              },
                            ),
                          );
                        }
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Refresh Rate: ',
                        style: TextStyle(
                          color: context.mainColors.secondaryText,
                          fontSize: 16,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: selectedRefreashRateNotifier,
                        builder: (context, refeshRate, _) {
                          return SizedBox(
                            width: 180,
                            child: AnimatedToggleSwitch<int>.size(
                              current: refeshRate,
                              values: [15, 30, 60],
                              style: ToggleStyle(
                                backgroundColor: context.mainColors.secondaryBg,
                                indicatorColor: context.mainColors.activeBg,
                                borderColor: context.mainColors.secondaryBg,
                                indicatorBorderRadius: BorderRadius.all(Radius.elliptical(20, 40))
                              ),
                              iconOpacity: 1.0,
                              selectedIconScale: 1.0,
                              indicatorSize: Size.fromWidth(60),
                              iconAnimationType: AnimationType.onHover,
                              styleAnimationType: AnimationType.onHover,
                              animationCurve: Curves.easeInOutExpo,
                              height: 40,
                              spacing: 2.0,
                              customIconBuilder: (context, selectedRefreshRate, global) {
                                final text = [15, 30, 60][selectedRefreshRate.index];
                                return  Center(
                                  child: Text(
                                    '${text}S',
                                    style: TextStyle(
                                      color: text == refeshRate ? context.mainColors.primaryText : context.mainColors.secondaryText,
                                      fontSize: 14
                                    ),
                                  ),
                                );
                              },
                              borderWidth: 0,
                              onChanged: (value) { 
                                selectedRefreashRateNotifier.value = value;
                                StorageManager.saveRefreshRate(value);
                              }
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Time Format:',
                        style: TextStyle(
                          color: context.mainColors.secondaryText,
                          fontSize: 16,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: isTimeFormat24hNotifier,
                        builder: (context, timeFormat, _) {
                          return SizedBox(
                            width: 180,
                            child: AnimatedToggleSwitch<bool>.size(
                              current: timeFormat,
                              values: [true, false],
                              style: ToggleStyle(
                                backgroundColor: context.mainColors.secondaryBg,
                                indicatorColor: context.mainColors.activeBg,
                                borderColor: context.mainColors.secondaryBg,
                                indicatorBorderRadius: BorderRadius.all(Radius.elliptical(20, 40))
                              ),
                              iconOpacity: 1.0,
                              selectedIconScale: 1.0,
                              indicatorSize: Size.fromWidth(90),
                              height: 40,
                              iconAnimationType: AnimationType.onHover,
                              styleAnimationType: AnimationType.onHover,
                              animationCurve: Curves.easeInOutExpo,
                              spacing: 2.0,
                              customIconBuilder: (context, selectedTimeFormate, global) {
                                final text = ['24hr', '12hr'][selectedTimeFormate.index];
                                final is24hr = isTimeFormat24hNotifier.value ^ (text == '12hr');
                                return  Center(
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      color: is24hr ? context.mainColors.primaryText : context.mainColors.secondaryText,
                                      fontSize: 14
                                    ),
                                  ),
                                );
                              },
                              borderWidth: 0,
                              onChanged: (value) async{ 
                                isTimeFormat24hNotifier.value = value;
                                StorageManager.saveTimeFormat(value);
                              }
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Graph Type:',
                        style: TextStyle(
                          color: context.mainColors.secondaryText,
                          fontSize: 16,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: isGraphTypeAverageNotifier,
                        builder: (context, graphType, _) {
                          return SizedBox(
                            width: 180,
                            child: AnimatedToggleSwitch<bool>.size(
                              current: graphType, 
                              values: [true, false],
                              style: ToggleStyle(
                                backgroundColor: context.mainColors.secondaryBg,
                                indicatorColor: context.mainColors.activeBg,
                                borderColor: context.mainColors.secondaryBg,
                                indicatorBorderRadius: BorderRadius.all(Radius.elliptical(20, 40))
                              ),
                              height: 40,
                              iconOpacity: 1.0,
                              selectedIconScale: 1.0,
                              iconAnimationType: AnimationType.onHover,
                              styleAnimationType: AnimationType.onHover,
                              animationCurve: Curves.easeInOutExpo,
                              indicatorSize: Size.fromWidth(90),
                              customIconBuilder: (context,selectedGraphType, global) {
                                final text = ['Average', 'Live'][selectedGraphType.index];
                                final condition = isGraphTypeAverageNotifier.value ^ (text == "Live");
                                return Center(
                                  child:  Text(text,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: condition ? context.mainColors.primaryText : context.mainColors.secondaryText,
                                    ),
                                  ),
                                );
                              },
                              borderWidth: 0,
                              onChanged: (value) {
                                isGraphTypeAverageNotifier.value = value;
                                StorageManager.saveGraphAverage(value);
                              },
                            ),
                          );
                        }
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget settingCard(Widget widget, {double cardPadding = 15}){
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: context.mainColors.cardBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: widget,
    );
  }

  Widget settingHeaderText(String text){
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: context.mainColors.mutedText
      )
    );
  }

  Widget brokerTextField(String hint, TextEditingController controlled, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controlled,
      obscureText: isPassword && !isPasswordShowen,
      style: TextStyle(
        color: context.mainColors.primaryText,
      ),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: context.mainColors.secondaryText),
        prefixIcon: Icon(icon, color: context.mainColors.secondaryText),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () => setState(() => isPasswordShowen = !isPasswordShowen),
                icon: Icon(
                  isPasswordShowen ? FluentIcons.eye_20_regular : FluentIcons.eye_off_20_regular,
                  color: context.mainColors.secondaryText,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: context.mainColors.mutedText)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: context.mainColors.secondaryBg),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: context.mainColors.activeBg, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

}