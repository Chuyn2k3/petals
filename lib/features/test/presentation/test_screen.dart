import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petals/features/control_mode/presentation/auto_control_ui.dart';
import 'package:petals/features/mode_selection/enum/light_number_enum.dart';
import 'package:petals/ultis/enum/control_status.dart';
import 'package:petals/ultis/enum/test_mode.dart';
import 'package:petals/widget/base_scaffold.dart';
import 'package:petals/widget/select_button.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({
    super.key,
    // required this.lightNumber,
    // required this.scannedDevicesInfo,
  });
  // final LightNumer lightNumber;
  // final Map<ScanStage, Map<String, String>> scannedDevicesInfo;
  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  TestMode selectedMode = TestMode.mimic;
  ControlStatus modeStatus = ControlStatus.master; // Dùng enum ControlStatus

  @override
  void initState() {
    super.initState();
    // Lock portrait up
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildBanner(),
              _buildDropdown(),
              const SizedBox(height: 16),
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
    );
  }

  Widget _buildBanner() {
    return Container(
      color: const Color(0xFFD9D9D9),
      padding: const EdgeInsets.symmetric(
        //vertical: 8,
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
    switch (LightNumer.one) {
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
            DropdownButton<TestMode>(
              value: selectedMode,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedMode = value;
                  });
                }
              },
              underline: const SizedBox(),
              dropdownColor: const Color(0xFF97D077),
              iconEnabledColor: Colors.white,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              items: TestMode.values
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
      //mainAxisAlignment: MainAxisAlignment.start,
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
              modeStatus = status; // Cập nhật trạng thái bằng enum
            });
          },
          isSelected: modeStatus == status,
          label: status.display,
        ),
      );
      buttons.add(const SizedBox(width: 8)); // Thêm khoảng cách giữa các nút
    }
    return buttons;
  }

  List<ControlStatus> _getButtonStatusesForMode() {
    switch (LightNumer.one) {
      case LightNumer.one:
        return []; // Không có nút cho mode 1
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
      case TestMode.mimic:
      case TestMode.blink:
        return AutoControlUI(dataMap: {},controlStatus: modeStatus,);
    }
  }

  @override
  void dispose() {
    // Unlock back to normal when screen is disposed
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }
}
