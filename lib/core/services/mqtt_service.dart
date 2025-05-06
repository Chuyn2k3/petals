import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:petals/core/services/ste_mode_pay_load.dart';
import 'package:petals/ultis/enum/control_mode.dart';
import 'package:petals/ultis/navigation_service.dart';
import 'package:petals/widget/snack_bar.dart';

class MqttService {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;

  MqttService._internal();

  bool get isConnected =>
      _client.connectionStatus?.state == MqttConnectionState.connected;
  static const String address = "test.mosquitto.org";

  //"hub-uat.selex.vn";
  static const int port = 1883;
  static const String clientId = "chuyen";
  final String userName = "selex";
  final String password = "selex";
  final MqttServerClient _client =
      MqttServerClient.withPort(address, clientId, port);

  void initializeMQTTClient() async {
    // Save the values
    _client.keepAlivePeriod = 20;
    _client.secure = false;
    _client.autoReconnect = true;
    _client.logging(on: true);
    _client.onDisconnected = onDisconnected;
    _client.onConnected = onConnected;
// Tạo SecurityContext và nạp các file chứng chỉ
    // SecurityContext context = SecurityContext.defaultContext;

    // // Nạp file chứng chỉ

    // final caCertBytes =
    //     (await rootBundle.load('assets/mqtt_key/ca.pem')).buffer.asUint8List();
    // final clientCertBytes =
    //     (await rootBundle.load('assets/mqtt_key/client.pem'))
    //         .buffer
    //         .asUint8List();
    // final clientKeyBytes = (await rootBundle.load('assets/mqtt_key/client.key'))
    //     .buffer
    //     .asUint8List();

    // // Thiết lập chứng chỉ với Uint8List
    // context.setTrustedCertificatesBytes(caCertBytes); // CA Certificate
    // context.useCertificateChainBytes(clientCertBytes); // Client Certificate
    // context.usePrivateKeyBytes(clientKeyBytes); // Private Key
    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        // .authenticateAs(userName, password)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    if (kDebugMode) {
      print('EXAMPLE::Mosquitto client connecting....');
    }
    _client.connectionMessage = connMess;
  }

  void onConnected() {
    getContext.showSnackBarSuccess(text: "Kết nối server mqtt thành công");
    print('✅ MQTT connected successfully!');
  }

  Future<void> connect() async {
    initializeMQTTClient();
    try {
      await _client.connect();
      if (isConnected) {
        print('✅ MQTT connected!');
      } else {
        print('❌ Connection failed: ${_client.connectionStatus}');
      }
    } catch (e) {
      print('❌ MQTT Connection failed: $e');
      _client.disconnect();
    }
  }

  void onDisconnected() {
    print('🔌 MQTT disconnected');
    getContext.showSnackBarFail(
        text: "Lỗi kết nối server mqtt, đang thực hiện kết nối lại");
    // Tự động reconnect sau 3 giây
    Future.delayed(const Duration(seconds: 3), () {
      print('🔁 Reconnecting...');
      connect();
    });
  }

  void subscribe(String topic) {
    if (isConnected) {
      _client.subscribe(topic, MqttQos.atMostOnce);
      print('🔔 Subscribed to $topic');
    } else {
      getContext.showSnackBarFail(text: "Lỗi topic mqtt");
      print('⚠️ Cannot subscribe, MQTT not connected.');
    }
  }

  Future<bool> subscribeSyncTopic(String sn, SetModePayload payload) async {
    final syncTopic = 'petals/$sn/sync';
    final completer = Completer<bool>();

    if (!isConnected) {
      getContext.showSnackBarFail(text: "MQTT không kết nối");
      return false;
    }

    _client.subscribe(syncTopic, MqttQos.atMostOnce);

    await Future.delayed(const Duration(milliseconds: 500));

    StreamSubscription? subscription;

    // Set a timeout for the response
    Timer timeoutTimer = Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer.complete(false);
        getContext.showSnackBarFail(
            text: "Gửi lệnh thất bại: Hết thời gian chờ");
        subscription?.cancel(); // ✅ Hủy stream sau khi timeout
      }
    });
    subscription =
        _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final payloadMessage =
          (c[0].payload as MqttPublishMessage).payload.message;
      final receivedData =
          MqttPublishPayload.bytesToStringAsString(payloadMessage);

      try {
        final Map<String, dynamic> receivedMap = jsonDecode(receivedData);

        // Check if this is a SET_MODE response
        if (receivedMap.containsKey("SET_MODE")) {
          SetModePayload receivedPayload;

          // Parse the controlMode and map accordingly
          final controlModeValue = receivedMap["SET_MODE"]["type"];
          final controlMode =
              ControlMode.values.firstWhere((e) => e.value == controlModeValue);

          switch (controlMode) {
            case ControlMode.auto:
              receivedPayload = SetModePayload(
                controlMode: controlMode,
                id: receivedMap["SET_MODE"]["id"],
                redDuration: receivedMap["SET_MODE"]["red_duration"],
                greenDuration: receivedMap["SET_MODE"]["green_duration"],
                yellowDuration: receivedMap["SET_MODE"]["yellow_duration"],
              );
              break;
            case ControlMode.manual:
              receivedPayload = SetModePayload(
                controlMode: controlMode,
                id: receivedMap["SET_MODE"]["id"],
                color: receivedMap["SET_MODE"]["color"],
              );
              break;
            case ControlMode.mimic:
              receivedPayload = SetModePayload(
                controlMode: controlMode,
                redDuration: receivedMap["SET_MODE"]["red_duration"],
                greenDuration: receivedMap["SET_MODE"]["green_duration"],
                yellowDuration: receivedMap["SET_MODE"]["yellow_duration"],
              );
              break;
            case ControlMode.double1:
              receivedPayload = SetModePayload(
                controlMode: controlMode,
                linkedId: receivedMap["SET_MODE"]["linked_id"],
                redDuration: receivedMap["SET_MODE"]["red_duration"],
                greenDuration: receivedMap["SET_MODE"]["green_duration"],
                yellowDuration: receivedMap["SET_MODE"]["yellow_duration"],
              );
              break;
            case ControlMode.blink:
              receivedPayload = SetModePayload(
                controlMode: controlMode,
                blink_period: receivedMap["SET_MODE"]["blink_period"],
                color: receivedMap["SET_MODE"]["color"],
              );
              break;
          }

          // Compare the received payload with the sent payload
          if (receivedPayload.toJson().toString() ==
              payload.toJson().toString()) {
            print('✅ Lệnh SET_MODE thành công!');
            getContext.showSnackBarSuccess(text: "Gửi lệnh thành công");
            if (!completer.isCompleted) {
              completer.complete(true);
              timeoutTimer.cancel();
              subscription?.cancel();
            }
          } else {
            print('❌ Lệnh SET_MODE không khớp.');
            if (!completer.isCompleted) {
              completer.complete(false);
              timeoutTimer.cancel();
              subscription?.cancel();
            }
          }

          print('📥 Received Sync Topic: $syncTopic \n📦 $receivedData');
        }
      } catch (e) {
        print('❌ Lỗi khi xử lý phản hồi: $e');
        if (!completer.isCompleted) {
          completer.complete(false);
          timeoutTimer.cancel();
          subscription?.cancel();
        }
      }
    });

    return completer.future;
  }

  Future<bool> subscribeAddSyncTopic(String sn, int addSlaveIndex) async {
    final syncTopic = 'petals/$sn/sync';
    final completer = Completer<bool>();

    if (!isConnected) {
      getContext.showSnackBarFail(text: "MQTT không kết nối");
      return false;
    }

    _client.subscribe(syncTopic, MqttQos.atMostOnce);
    await Future.delayed(const Duration(milliseconds: 500));

    StreamSubscription? subscription;

    // Set a timeout for the response
    Timer timeoutTimer = Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer.complete(false);
        getContext.showSnackBarFail(
            text: "Gửi lệnh thất bại: Hết thời gian chờ");
        subscription?.cancel(); // ✅ Hủy stream sau khi timeout
      }
    });

    subscription =
        _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final payloadMessage =
          (c[0].payload as MqttPublishMessage).payload.message;
      final receivedData =
          MqttPublishPayload.bytesToStringAsString(payloadMessage);

      try {
        final Map<String, dynamic> receivedMap = jsonDecode(receivedData);

        if (receivedMap.containsKey("ADD_SLAVE")) {
          final addSlaveValue = receivedMap["ADD_SLAVE"];
          print('📥 Received Sync Topic: $syncTopic \n📦 $receivedData');
          print('🔍 Expected: $addSlaveIndex - Received: $addSlaveValue');

          if (addSlaveValue.toString() == addSlaveIndex.toString()) {
            print('✅ Lệnh ADD_SLAVE thành công!');
            getContext.showSnackBarSuccess(
                text: "Gửi lệnh add slave thành công");
            if (!completer.isCompleted) {
              completer.complete(true);
              timeoutTimer.cancel();
              subscription?.cancel();
            }
          } else {
            print('❌ Lệnh ADD_SLAVE không khớp.');
            getContext.showSnackBarFail(text: "Gửi lệnh add slave thất bại");
            if (!completer.isCompleted) {
              completer.complete(false);
              timeoutTimer.cancel();
              subscription?.cancel();
            }
          }
        } else {
          print('📦 Không phải ADD_SLAVE: ${receivedMap.keys}');
        }
      } catch (e) {
        print('❌ Lỗi khi xử lý phản hồi: $e');
        if (!completer.isCompleted) {
          completer.complete(false);
          timeoutTimer.cancel();
          subscription?.cancel();
        }
      }
    });

    return completer.future;
  }

  void publish(String topic, String message) {
    if (!isConnected) {
      getContext.showSnackBarFail(text: "Lỗi topic mqtt");
      print('⚠️ MQTT not connected. Cannot publish.');
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);

    print('📤 Published to $topic: $message');
  }

  void disconnect() {
    _client.disconnect();
    print('👋 Disconnected manually');
  }
}
