import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late MqttServerClient client;

  final String broker;
  final int port;
  final String username;
  final String password;
  final String topic;

  final void Function()? onConnected;
  final void Function()? onDisconnected;
  final void Function(String data)? onData;

  MqttService({
    required this.broker,
    required this.port,
    required this.username,
    required this.password,
    required this.topic,
    this.onConnected,
    this.onDisconnected,
    this.onData,
  });

  Future<bool> connect() async {
    client = MqttServerClient(broker, '');

    client.port = port;
    client.secure = true;
    client.keepAlivePeriod = 20;
    client.logging(on: false);

    client.setProtocolV311();

    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(
          'flutter_${DateTime.now().millisecondsSinceEpoch}',
        )
        .authenticateAs(username, password)
        .startClean();

    try {
      await client.connect();

      if (client.connectionStatus?.state ==
          MqttConnectionState.connected) {
        onConnected?.call();
        subscribe();
        return true;
      }

      onDisconnected?.call();
      client.disconnect();
      return false;
    } catch (e) {
      debugPrint("Error parsing stored devices: $e");

      onDisconnected?.call();

      client.disconnect();

      return false;
    }
  }

  void subscribe() {
    client.subscribe(topic, MqttQos.atMostOnce);

    client.updates?.listen((events) {
      final message = events.first.payload as MqttPublishMessage;

      final payload = MqttPublishPayload.bytesToStringAsString(
        message.payload.message,
      );

      onData?.call(payload);
    });
  }

  void disconnect() {
    client.disconnect();
    onDisconnected?.call();
  }
}