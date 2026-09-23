import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:air_guard/data/palatte.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/view/widget/snack_bar_style.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class ConnectionIndegator extends StatelessWidget {
  const ConnectionIndegator({super.key});

  @override
  Widget build(BuildContext context) {

    final prov = Provider.of<SensorNotifierMQTT>(context);

    return Column(
      children: [
        ValueListenableBuilder(
              valueListenable: Provider.of<SensorNotifierMQTT>(context, listen: false).isConnected,
                builder: (context, isConnected, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Broker Connection:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: context.mainColors.secondaryText
                      )
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10)),
                        backgroundColor: WidgetStatePropertyAll(isConnected ? context.statusColors.connectBg : context.statusColors.disconnectBg,)
                      ),
                      child: Row(
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
                      ),
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
                              margin: const EdgeInsets.only(
                                // bottom: 10,
                                left: 16,
                                right: 16,
                              ),
                              content: SnackBarAnimationStyleWrapper(key: UniqueKey(), text: 'MQTT Disconnected', icon: FluentIcons.plug_disconnected_20_regular, bgColor: context.statusColors.disconnectBg, textColor: context.statusColors.disconnectText),
                            ),
                          );

                          return;
                        }

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
                            margin: const EdgeInsets.only(
                              // bottom: 10,
                              left: 16,
                              right: 16,
                            ),
                            content: SnackBarAnimationStyleWrapper(key: UniqueKey(), text: 'MQTT Connected', icon: FluentIcons.plug_connected_20_regular, bgColor: context.statusColors.connectBg, textColor: context.statusColors.connectText),
                          ),
                        );
                      },
                    )
                  ],
                );
              }
            ),
      ],
    );
  }
}