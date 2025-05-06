import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:petals/core/services/mqtt_service.dart';
import 'package:petals/core/services/ste_mode_pay_load.dart';
import 'package:petals/ultis/navigation_service.dart';
import 'package:petals/ultis/shared_preferences_manager.dart';
import 'package:petals/widget/snack_bar.dart';

class MqttConfig {
  static bool isTopicSubscribed = false; // Flag kiểm tra topic đã đăng ký chưa
  static ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  static Future<bool> publishSetMode(SetModePayload payload) async {
    try {
      isLoading.value = true;
      bool result = false;
      final sn =
          GetIt.instance<SharedPreferencesManager>().getString("master_SN");
      if (sn == null) {
        getContext.showSnackBarFail(text: "Lỗi topic MQTT");
        isLoading.value = false;
        return false;
      }

      final topic = 'petals/$sn/command';
      final message = jsonEncode(payload.wrap());

      // Đăng ký topic lệnh nếu chưa đăng ký
      if (!isTopicSubscribed) {
        MqttService().subscribe(topic);
        await Future.delayed(const Duration(milliseconds: 500));
        isTopicSubscribed = true;
      }

      if (!MqttService().isConnected) {
        getContext.showSnackBarFail(text: "MQTT không kết nối");
        isLoading.value = false;
        return false;
      }

      MqttService().publish(topic, message);
      print('🔫 Gửi SET_MODE đến $topic\n📦 $message');
      await Future.delayed(const Duration(milliseconds: 700));
      result = await MqttService().subscribeSyncTopic(sn, payload);

      // Đăng ký topic sync để nhận phản hồi

      isLoading.value = false;
      return result;
    } catch (e) {
      print('❌ Lỗi khi gửi SET_MODE: $e');
      getContext.showSnackBarFail(text: "Lỗi khi gửi lệnh: $e");
      isLoading.value = false;
      return false;
    }
  }

  static Future<bool> publishAddSlave(int slaveIndex) async {
    try {
      isLoading.value = true;
      bool result = false;
      final sn =
          GetIt.instance<SharedPreferencesManager>().getString("master_SN");
      if (sn == null) {
        getContext.showSnackBarFail(text: "Lỗi topic MQTT");
        isLoading.value = false;
        return false;
      }

      final payload = {"ADD_SLAVE": slaveIndex};
      final topic = 'petals/$sn/command';
      final message = jsonEncode(payload);

      if (!isTopicSubscribed) {
        MqttService().subscribe(topic);
        await Future.delayed(const Duration(milliseconds: 500));
        isTopicSubscribed = true;
      }

      if (!MqttService().isConnected) {
        getContext.showSnackBarFail(text: "MQTT không kết nối");
        isLoading.value = false;
        return false;
      }

      MqttService().publish(topic, message);
      await Future.delayed(const Duration(milliseconds: 500));
      result = await MqttService().subscribeAddSyncTopic(sn, slaveIndex);

      print('🔫 Gửi ADD_SLAVE đến $topic\n📦 $message');

      // Đăng ký topic sync để nhận phản hồi

      isLoading.value = false;
      return result;
    } catch (e) {
      print('❌ Lỗi khi gửi ADD_SLAVE: $e');
      getContext.showSnackBarFail(text: "Lỗi khi gửi lệnh: $e");
      isLoading.value = false;
      return false;
    }
  }
}
