import 'package:flutter/material.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/storage_manager.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/view/widget/snack_bar_style.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      backgroundColor: context.mainColors.primaryBg,
      appBar: AppBar(
        backgroundColor: context.mainColors.primaryBg,
        foregroundColor: context.mainColors.primaryText,
        leading: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.pop(context);
          },
          icon: Icon(FluentIcons.arrow_previous_20_regular)
        ),
        title: const Text("Setting"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Theme Mode:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.mainColors.mutedText,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(7.5),
              decoration: BoxDecoration(
                color: context.mainColors.cardBg,
                borderRadius: BorderRadius.circular(22.5),
              ),
              child: Row(
                  children: [
                    themesButtom("Dark Mode", FluentIcons.weather_moon_20_regular, ThemeMode.dark, 0),
                    themesButtom("System Mode", FluentIcons.desktop_20_regular, ThemeMode.system, 1),
                    themesButtom("Light Mode", FluentIcons.weather_sunny_20_regular, ThemeMode.light, 2),
                  ],
                ),
              ),
            const SizedBox(height: 25),
            ValueListenableBuilder<bool>(
              valueListenable: Provider.of<SensorNotifierMQTT>(context, listen: false).isConnected,
                builder: (context, isConnected, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Broker Connection:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.mainColors.mutedText,
                      ),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        Icon(
                          isConnected ? FluentIcons.cloud_sync_20_regular : FluentIcons.cloud_dismiss_20_regular,
                          color: isConnected ? context.statusColors.connectText : context.statusColors.disconnectText,
                          ),
                        Text(
                          isConnected ? "Connected" : "Disconnected",
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.mainColors.cardBg,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                spacing: 12,
                children: [
                  brokerTextField("Broker URL", controlledURL!, FluentIcons.globe_20_regular),
                  brokerTextField("Topic", controlledTopic!, FluentIcons.apps_list_detail_20_regular),
                  brokerTextField("Port", controlledPort!, FluentIcons.connector_20_regular),
                  brokerTextField("Username", controlledUsername!, FluentIcons.person_20_regular),
                  brokerTextField("Password", controlledPassword!, FluentIcons.password_20_regular, isPassword: true),
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

                                  ScaffoldMessenger.of(context).clearSnackBars();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      key: UniqueKey(),
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      content: SnackBarAnimationStyleWrapper(key: UniqueKey(), text: "MQTT Disconnected",),
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
                          label: Text(isConnected ? "Connected" : "Connect"),
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
            SizedBox(height: 25),
            Text(
              "Genaral:",
              style: TextStyle(
                fontSize: 20,
                color: context.mainColors.mutedText
              ),
            ),
            Column(
              children: [
                SizedBox(height: 300,)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget themesButtom(String text, IconData icon, ThemeMode themeMode, int location) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: themeModeNotifier,
        builder: (context, value, child) {
          bool isActive = themeMode == themeModeNotifier.value;
          return TextButton(
            onPressed: () {
              themeModeNotifier.value = themeMode;
              StorageManager.saveThemeMode(themeMode);
            },
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              backgroundColor: WidgetStateProperty.all(
                isActive ? context.mainColors.activeBg : context.mainColors.secondaryBg,
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 12),
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: location == 0 ? const Radius.circular(20) : Radius.zero,
                    right: location == 2 ? const Radius.circular(20) : Radius.zero,
                  ),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isActive ? context.mainColors.primaryText : context.mainColors.secondaryText,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  text,
                  style: TextStyle(
                    color: isActive ? context.mainColors.primaryText : context.mainColors.secondaryText,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          );
        },
      ),
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
        border: InputBorder.none,
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