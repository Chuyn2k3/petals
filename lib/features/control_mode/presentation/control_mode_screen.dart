import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:petals/core/services/mqtt_config.dart";
import "package:petals/core/services/mqtt_service.dart";
import "package:petals/core/services/ste_mode_pay_load.dart";
import "package:petals/features/control_mode/presentation/auto_control_ui.dart";
import "package:petals/features/control_mode/presentation/manual_control_ui.dart";
import "package:petals/features/mode_selection/enum/light_number_enum.dart";
import "package:petals/features/scanning/presentation/scanning_screen.dart";
import "package:petals/ultis/enum/control_mode.dart";
import "package:petals/ultis/enum/control_status.dart";
import "package:petals/widget/base_scaffold.dart";
import "package:petals/widget/select_button.dart";

class ModeScreen extends StatefulWidget {
  const ModeScreen({
    super.key,
    required this.lightNumber,
    required this.scannedDevicesInfo,
  });
  final LightNumer lightNumber;
  final Map<ScanStage, Map<String, String>> scannedDevicesInfo;
  @override
  State<ModeScreen> createState() => _ModeScreenState();
}

class _ModeScreenState extends State<ModeScreen> {
  ControlMode selectedMode = ControlMode.auto;
  ControlStatus modeStatus = ControlStatus.master;
  Map<String, String> dataMap = {};

  // Add these variables to store the selected values
  Map<ControlMode, Map<ControlStatus, Color?>> selectedColorsByModeStatus = {
    for (var mode in ControlMode.values)
      mode: {
        for (var status in ControlStatus.values) status: null,
      },
  };

  // Modified to store durations by both mode and status
  Map<ControlMode, Map<ControlStatus, List<int>>> durationsByModeStatus = {
    for (var mode in ControlMode.values)
      mode: {
        for (var status in ControlStatus.values) status: [0, 0, 0],
      },
  };

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
    // Lock portrait up
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Color? getSelectedManualColor() {
    return selectedColorsByModeStatus[selectedMode]?[modeStatus];
  }

  void setSelectedManualColor(Color? color) {
    setState(() {
      selectedColorsByModeStatus[selectedMode]?[modeStatus] = color;
    });
  }

  // Helper method to get durations for current mode and status
  List<int> getCurrentDurations() {
    return durationsByModeStatus[selectedMode]?[modeStatus] ?? [0, 0, 0];
  }

  void updateDuration(List<int> value) {
    setState(() {
      durationsByModeStatus[selectedMode]?[modeStatus] = value;
    });
  }

  int getColorValue(Color? color) {
    if (color == null) {
      return 3;
    }
    switch (color) {
      case Colors.red:
        return 0;
      case Colors.green:
        return 1;
      case Colors.yellow:
        return 2;
      default:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      isNextButton: true,
      onNextPressed: () async {
        final durations = getCurrentDurations();
        if (MqttService().isConnected) {
          SetModePayload modePayload;
          switch (selectedMode) {
            case ControlMode.auto:
              modePayload = SetModePayload(
                controlMode: selectedMode,
                id: modeStatus.value,
                redDuration: durations[0] * 1000,
                greenDuration: durations[1] * 1000,
                yellowDuration: durations[2] * 1000,
              );
              break;
            case ControlMode.manual:
              modePayload = SetModePayload(
                controlMode: selectedMode,
                id: modeStatus.value,
                color: getColorValue(getSelectedManualColor()),
              );
              break;
            case ControlMode.mimic:
              modePayload = SetModePayload(
                controlMode: selectedMode,
                redDuration: durations[0] * 1000,
                greenDuration: durations[1] * 1000,
                yellowDuration: durations[2] * 1000,
              );
              break;
            case ControlMode.double1:
              modePayload = SetModePayload(
                controlMode: selectedMode,
                id: modeStatus.value,
                redDuration: durations[0] * 1000,
                greenDuration: durations[1] * 1000,
                yellowDuration: durations[2] * 1000,
              );
              break;
            case ControlMode.blink:
              modePayload = SetModePayload(
                controlMode: selectedMode,
                blink_period: 2000,
                color: getColorValue(getSelectedManualColor()),
              );
              break;
          }
          await MqttConfig.publishSetMode(modePayload);
        }
      },
      child: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildBanner(),
                  _buildDropdown(),
                  const SizedBox(height: 16),
                  if (selectedMode != ControlMode.manual &&
                      selectedMode != ControlMode.blink)
                    _buildControlStatus(),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 2 / 3,
                      child: _buildModeUI())
                ],
              ),
            ),
          ),
          // Loading overlay
          ValueListenableBuilder<bool>(
            valueListenable: MqttConfig.isLoading,
            builder: (context, isLoading, child) {
              return isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Đang gửi lệnh...',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      color: const Color(0xFFD9D9D9),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      margin: const EdgeInsets.only(bottom: 4),
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          _getTitleForMode(),
          style: const TextStyle(
            color: Color(0xFF000000),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getTitleForMode() {
    switch (widget.lightNumber) {
      case LightNumer.one:
        return "SINGLE LIGHT MODE";
      case LightNumer.two:
        return "2 LIGHTS MODE";
      case LightNumer.three:
        return "3 LIGHTS MODE";
      case LightNumer.four:
        return "4 LIGHTS MODE";
      default:
        return "CONTROL MODE";
    }
  }

  Widget _buildDropdown() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999),
          color: const Color(0xFF97D077),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(
          right: 20,
          bottom: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<ControlMode>(
              value: selectedMode,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedMode = value;
                  });
                }
              },
              underline: const SizedBox(),
              dropdownColor: const Color(0xff97d077),
              iconEnabledColor: Colors.white,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              items: ControlMode.values
                  .map(
                    (mode) => DropdownMenuItem(
                      value: mode,
                      child: Text(mode.display),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(width: 8),
            Image.network(
              "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/5b8a2df4-f8a9-4d9d-8b8e-f3e9e479507f",
              width: 20,
              height: 20,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlStatus() {
    return Wrap(
      children: _buildStatusButtons(),
    );
  }

  List<Widget> _buildStatusButtons() {
    List<ControlStatus> buttonStatuses = _getButtonStatusesForMode();

    List<Widget> buttons = [];
    for (ControlStatus status in buttonStatuses) {
      buttons.add(
        SelectButton(
          onTap: () {
            setState(() {
              modeStatus = status;
            });
            getDeviceInfo();
          },
          isSelected: modeStatus == status,
          label: status.display,
        ),
      );
      buttons.add(const SizedBox(width: 8));
    }
    return buttons;
  }

  List<ControlStatus> _getButtonStatusesForMode() {
    switch (widget.lightNumber) {
      case LightNumer.one:
        return [];
      case LightNumer.two:
        return [ControlStatus.master, ControlStatus.slave1];
      case LightNumer.three:
        return [
          ControlStatus.master,
          ControlStatus.slave1,
          ControlStatus.slave2
        ];
      case LightNumer.four:
        return [
          ControlStatus.master,
          ControlStatus.slave1,
          ControlStatus.slave2,
          ControlStatus.slave3
        ];
      default:
        return [];
    }
  }

  Widget _buildModeUI() {
    switch (selectedMode) {
      case ControlMode.auto:
        return AutoControlUI(
          dataMap: dataMap,
          controlStatus: modeStatus,
          initialDurations: getCurrentDurations(),
          onDurationsChanged: (durations) {
            updateDuration(durations);
          },
        );
      case ControlMode.manual:
        return ManualControlUI(
          dataMap: dataMap,
          controlStatus: modeStatus,
          selectedColor: getSelectedManualColor(),
          onColorSelected: (color) {
            setSelectedManualColor(color);
          },
        );
      case ControlMode.mimic:
      case ControlMode.double1:
        return AutoControlUI(
          dataMap: dataMap,
          controlStatus: modeStatus,
          initialDurations: getCurrentDurations(),
          onDurationsChanged: (durations) {
            updateDuration(durations);
          },
        );

      case ControlMode.blink:
        return ManualControlUI(
          dataMap: dataMap,
          controlStatus: modeStatus,
          selectedColor: getSelectedManualColor(),
          onColorSelected: (color) {
            setSelectedManualColor(color);
          },
        );
    }
  }

  void getDeviceInfo() {
    switch (modeStatus) {
      case ControlStatus.master:
        setState(() {
          dataMap = widget.scannedDevicesInfo[ScanStage.MASTER] ?? {};
        });
        break;
      case ControlStatus.slave1:
        setState(() {
          dataMap = widget.scannedDevicesInfo[ScanStage.SLAVE1] ?? {};
        });
        break;
      case ControlStatus.slave2:
        setState(() {
          dataMap = widget.scannedDevicesInfo[ScanStage.SLAVE2] ?? {};
        });
        break;
      case ControlStatus.slave3:
        setState(() {
          dataMap = widget.scannedDevicesInfo[ScanStage.SLAVE3] ?? {};
        });
        break;
    }
  }

  @override
  void dispose() {
    // Unlock back to normal when screen is disposed
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }
}