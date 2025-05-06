import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:petals/core/services/mqtt_config.dart';
import 'package:petals/features/control_mode/presentation/control_mode_screen.dart';
import 'package:petals/features/mode_selection/enum/light_number_enum.dart';
import 'package:petals/ultis/shared_preferences_manager.dart';
import 'package:petals/widget/action_button.dart';
import 'package:petals/widget/base_scaffold.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

// Enum để theo dõi giai đoạn quét hiện tại
enum ScanStage { MASTER, SLAVE1, SLAVE2, SLAVE3, COMPLETED }

// Enum để theo dõi trạng thái quét
enum ScanResultType { initial, success, fail }

class QRScanScreen extends StatefulWidget {
  final LightNumer lightNumber;

  const QRScanScreen({
    super.key,
    required this.lightNumber,
  });

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  ScanResultType scanResultType = ScanResultType.initial;
  ScanStage currentStage = ScanStage.MASTER;
  bool isCameraActive = false;
  late String scannedSerial = "";
  late String scannedBattery = "";
  late String scannedStatus = "";
  // Map để lưu trữ mã thiết bị đã quét theo giai đoạn
  final Map<ScanStage, String> scannedDevices = {};
  final Map<ScanStage, Map<String, String>> scannedDevicesInfo = {
    ScanStage.MASTER: {},
    ScanStage.SLAVE1: {},
    ScanStage.SLAVE2: {},
    ScanStage.SLAVE3: {},
  };
  @override
  void reassemble() {
    super.reassemble();
    controller?.pauseCamera();
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController ctrl) async {
    controller = ctrl;
    await Future.delayed(Duration(milliseconds: 300));
    // Mặc định tạm dừng camera cho đến khi người dùng nhấn nút SCAN
    controller?.pauseCamera();

    ctrl.scannedDataStream.listen((scanData) async {
      final code = scanData.code;
      print(code);
      try {
        final contentUrl = convertToContentUrl(code ?? "");
        final response = await http.get(Uri.parse(contentUrl));
        if (response.statusCode == 200) {
          // Trường hợp nội dung là JSON:

          final document = html_parser.parse(response.body);
          final text = document.body?.text.trim();

          print("📦 Nội dung từ HTML: $text");
          // ví dụ: nếu text là mã, bạn có thể xử lý tiếp tại đây
          _processScannedCode(text ?? "");
        } else {}
      } catch (e) {
        print('Lỗi khi xử lý QR: $e');
      }
    });
  }

  String convertToContentUrl(String originalUrl) {
    final uri = Uri.parse(originalUrl);
    final segments = List<String>.from(uri.pathSegments);

    if (segments.isNotEmpty) {
      // Chèn "content" vào trước phần tử cuối
      segments.insert(segments.length - 1, "content");
    }

    final newUri = uri.replace(pathSegments: segments);
    return newUri.toString();
  }

  void _processScannedCode(String code) async {
    print("haha");
    print("KKK $code mmmm");
    final parts = code.split('-');
    if (parts.length < 4) {
      _onScanFailed();
      return;
    }

    final type = parts[0]; // 'M' hoặc 'S'
    final sn = parts[1]; // Serial Number
    final battery = parts[2];
    final status = extractBeforeFunction(parts[3]);
    print("hehe" + type);
    print("part0 ${parts[0]}");
    print("part1 ${parts[1]}");
    print("part2 ${parts[2]}");
    print("part3 ${status}");

    final isMasterCode = type == 'M';
    final isSlaveCode = type == 'S';

    final isMasterStage = currentStage == ScanStage.MASTER;
    final isSlaveStage = currentStage == ScanStage.SLAVE1 ||
        currentStage == ScanStage.SLAVE2 ||
        currentStage == ScanStage.SLAVE3;

    final isValid =
        (isMasterStage && isMasterCode) || (isSlaveStage && isSlaveCode);

    if (!isValid) {
      _onScanFailed();
      return;
    }

    setState(() {
      scannedSerial = sn;
      scannedBattery = battery;
      scannedStatus = status == '0' ? "OK" : "Lỗi";

      scannedDevicesInfo[currentStage] = {
        'serial': scannedSerial,
        'battery': scannedBattery,
        'status': scannedStatus,
      };

      scannedDevices[currentStage] = code;
      scanResultType = ScanResultType.success;
      isCameraActive = false;
      //controller?.pauseCamera();
    });
    if (isMasterStage && isMasterCode) {
      await GetIt.instance<SharedPreferencesManager>().putString(
          "master_SN", "${parts[0]}-${parts[1]}-${parts[2]}-${status}");
    }
  }

  String extractBeforeFunction(String htmlContent) {
    // Tìm vị trí xuất hiện của đoạn "function(){function c(){"
    int startIndex = htmlContent.indexOf("(function(){function c(){");

    // Nếu không tìm thấy, trả về toàn bộ chuỗi
    if (startIndex == -1) {
      return htmlContent;
    }

    // Cắt chuỗi từ đầu đến vị trí đó
    return htmlContent.substring(0, startIndex).trim();
  }

  void _onScanFailed() {
    setState(() {
      scanResultType = ScanResultType.fail;
      isCameraActive = false;
      controller?.pauseCamera();
    });
  }

  void _handleRescan() {
    setState(() {
      // Xóa kết quả quét hiện tại và tiếp tục quét
      scannedDevices.remove(currentStage);
      scanResultType = ScanResultType.initial;
      isCameraActive = true;
      controller?.resumeCamera();
    });
  }

  void _handleScan() {
    setState(() {
      scanResultType = ScanResultType.initial;
      isCameraActive = true;
      controller?.resumeCamera();
    });
  }

// Add this code to the _handleContinue method in QRScanScreen
  void _handleContinue() async {
    final isMasterStage = currentStage == ScanStage.MASTER;
    bool success = true;

    if (!isMasterStage) {
      switch (currentStage) {
        case ScanStage.SLAVE1:
          success = await MqttConfig.publishAddSlave(1);
          break;
        case ScanStage.SLAVE2:
          success = await MqttConfig.publishAddSlave(2);
          break;
        case ScanStage.SLAVE3:
          success = await MqttConfig.publishAddSlave(3);
          break;
        case ScanStage.MASTER:
        case ScanStage.COMPLETED:
          break;
      }
    }

    if (!success) {
      // If the MQTT command failed, don't proceed
      return;
    }

    // Kiểm tra xem đã hoàn thành tất cả các bước quét cần thiết chưa
    if (_isAllRequiredDevicesScanned()) {
      // Nếu đã hoàn thành, chuyển đến màn hình Mode
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ModeScreen(
            lightNumber: widget.lightNumber,
            scannedDevicesInfo: scannedDevicesInfo,
          ),
        ),
      );
    } else {
      // Nếu chưa, chuyển sang giai đoạn tiếp theo
      setState(() {
        _moveToNextStage();
        scanResultType = ScanResultType.initial;
        isCameraActive = true;
        controller?.resumeCamera();
      });
    }
  }

  bool _isAllRequiredDevicesScanned() {
    switch (widget.lightNumber) {
      case LightNumer.one:
        return currentStage == ScanStage.MASTER;
      case LightNumer.two:
        return currentStage == ScanStage.SLAVE1;
      case LightNumer.three:
        return currentStage == ScanStage.SLAVE2;
      case LightNumer.four:
        return currentStage == ScanStage.SLAVE3;
      default:
        return false;
    }
  }

  void _moveToNextStage() {
    switch (currentStage) {
      case ScanStage.MASTER:
        currentStage = ScanStage.SLAVE1;
        break;
      case ScanStage.SLAVE1:
        currentStage = ScanStage.SLAVE2;
        break;
      case ScanStage.SLAVE2:
        currentStage = ScanStage.SLAVE3;
        break;
      case ScanStage.SLAVE3:
        currentStage = ScanStage.COMPLETED;
        break;
      default:
        break;
    }
  }

  Widget _buildCameraBox() {
    switch (scanResultType) {
      case ScanResultType.initial:
        return _buildQRScanner();
      case ScanResultType.fail:
        return _buildFailBox();
      case ScanResultType.success:
        return _buildSuccessBox();
    }
  }

  Widget _buildQRScanner() {
    String scanInstructions;
    switch (currentStage) {
      case ScanStage.MASTER:
        scanInstructions = 'Vui lòng quét thiết bị Master!';
        break;
      case ScanStage.SLAVE1:
        scanInstructions = 'Vui lòng quét thiết bị Slave 1!';
        break;
      case ScanStage.SLAVE2:
        scanInstructions = 'Vui lòng quét thiết bị Slave 2!';
        break;
      case ScanStage.SLAVE3:
        scanInstructions = 'Vui lòng quét thiết bị Slave 3!';
        break;
      default:
        scanInstructions = 'Vui lòng quét thiết bị!';
    }

    return SizedBox(
      width: 240,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.greenAccent,
                borderRadius: 16,
                borderLength: 30,
                borderWidth: 8,
                cutOutSize: 180,
              ),
            ),
          ),
          //
          Positioned(
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                scanInstructions,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          // Hiển thị chỉ báo tiến trình
          Positioned(
            bottom: 12,
            child: _buildProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    int totalSteps;
    switch (widget.lightNumber) {
      case LightNumer.one:
        totalSteps = 1;
        break;
      case LightNumer.two:
        totalSteps = 2;
        break;
      case LightNumer.three:
        totalSteps = 3;
        break;
      case LightNumer.four:
        totalSteps = 4;
        break;
      default:
        totalSteps = 1;
    }

    int currentStep;
    switch (currentStage) {
      case ScanStage.MASTER:
        currentStep = 1;
        break;
      case ScanStage.SLAVE1:
        currentStep = 2;
        break;
      case ScanStage.SLAVE2:
        currentStep = 3;
        break;
      case ScanStage.SLAVE3:
        currentStep = 4;
        break;
      default:
        currentStep = 1;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Bước $currentStep/$totalSteps',
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildFailBox() {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.triangleExclamation,
              color: Colors.white, size: 48),
          SizedBox(height: 12),
          Text("Quét không thành công",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            "Vui lòng thử lại",
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSuccessBox() {
    String deviceType;
    switch (currentStage) {
      case ScanStage.MASTER:
        deviceType = "Master";
        break;
      case ScanStage.SLAVE1:
        deviceType = "Slave 1";
        break;
      case ScanStage.SLAVE2:
        deviceType = "Slave 2";
        break;
      case ScanStage.SLAVE3:
        deviceType = "Slave 3";
        break;
      default:
        deviceType = "Unknown";
    }

    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              deviceType,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow("S/N", scannedSerial),
          _buildInfoRow("Battery", scannedBattery),
          _buildInfoRow("Status", scannedStatus),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.grey.shade300,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget tùy chỉnh để tạo ActionButton với tâm màu tùy chỉnh
  Widget _buildCustomActionButton({
    required String label,
    Color? centerColor,
    required VoidCallback onPressed,
  }) {
    // Giả sử ActionButton là một widget tùy chỉnh trong dự án của bạn
    // Nếu không thể sửa đổi ActionButton, bạn có thể tạo một widget tương tự

    // Phiên bản 1: Nếu ActionButton cho phép truyền tham số màu sắc
    return ActionButton(
      label: label,
      onPressed: onPressed,
      buttonColor: centerColor ??
          const Color(0xFF7B9AB7), // Giả sử ActionButton có tham số centerColor
    );

    // Phiên bản 2: Nếu ActionButton không cho phép tùy chỉnh màu sắc, bạn có thể tạo một widget tương tự
    // return Container(
    //   decoration: BoxDecoration(
    //     shape: BoxShape.circle,
    //     color: Colors.white,
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withOpacity(0.2),
    //         blurRadius: 5,
    //         offset: const Offset(0, 2),
    //       ),
    //     ],
    //   ),
    //   child: Material(
    //     color: Colors.transparent,
    //     child: InkWell(
    //       onTap: onPressed,
    //       borderRadius: BorderRadius.circular(30),
    //       child: Container(
    //         width: 60,
    //         height: 60,
    //         padding: const EdgeInsets.all(4),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Container(
    //               width: 24,
    //               height: 24,
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 color: centerColor,
    //               ),
    //             ),
    //             const SizedBox(height: 4),
    //             Text(
    //               label,
    //               style: const TextStyle(
    //                 fontSize: 12,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      onNextPressed: () {},
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCameraBox(),
              const SizedBox(height: 24),
              // Chỉ hiển thị các nút mô phỏng cho mục đích kiểm thử
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (currentStage == ScanStage.MASTER)
                  //   ActionButton(
                  //     label: "Simulate Master",
                  //     onPressed: () => _simulateScan("2A-MASTER-001", true),
                  //   ),
                  // const SizedBox(height: 8),
                  // if (currentStage == ScanStage.SLAVE1)
                  //   ActionButton(
                  //     label: "Simulate Slave 1",
                  //     onPressed: () => _simulateScan("1F-SLAVE-001", false),
                  //   ),
                  // const SizedBox(height: 8),
                  // if (currentStage == ScanStage.SLAVE2)
                  //   ActionButton(
                  //     label: "Simulate Slave 2",
                  //     onPressed: () => _simulateScan("3G-SLAVE-002", false),
                  //   ),
                  // const SizedBox(height: 8),
                  // if (currentStage == ScanStage.SLAVE3)
                  //   ActionButton(
                  //     label: "Simulate Slave 3",
                  //     onPressed: () => _simulateScan("5H-SLAVE-003", false),
                  //   ),
                  if (scanResultType == ScanResultType.initial)
                    _buildCustomActionButton(
                      label: "Scan",
                      onPressed: _handleScan,
                    ),
                  if (scanResultType == ScanResultType.fail)
                    _buildCustomActionButton(
                      label: "Rescan",
                      onPressed: _handleRescan,
                    ),
                ],
              ),
              const SizedBox(height: 24),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     ActionButton(
              //       label: "Fail Master",
              //       onPressed: () => _simulateFailScan(
              //           "1F-SLAVE-001", false), // Gửi slave khi cần master
              //       buttonColor: Colors.red,
              //     ),
              //     const SizedBox(width: 8),
              //     ActionButton(
              //       label: "Fail Slave 1",
              //       onPressed: () => _simulateFailScan(
              //           "2A-MASTER-001", true), // Gửi master khi cần slave
              //       buttonColor: Colors.red,
              //     ),
              //     const SizedBox(width: 8),
              //     ActionButton(
              //       label: "Fail Slave 2",
              //       onPressed: () => _simulateFailScan(
              //           "4B-MASTER-002", true), // Gửi master khi cần slave
              //       buttonColor: Colors.red,
              //     ),
              //     const SizedBox(width: 8),
              //     ActionButton(
              //       label: "Fail Slave 3",
              //       onPressed: () => _simulateFailScan(
              //           "6C-MASTER-003", true), // Gửi master khi cần slave
              //       buttonColor: Colors.red,
              //     ),
              //   ],
              // ),
              if (scanResultType == ScanResultType.success)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Nút OK với tâm màu xanh
                    _buildCustomActionButton(
                      label: "OK",
                      centerColor: Colors.green,
                      onPressed: _handleContinue,
                    ),
                    const SizedBox(width: 8), // Khoảng cách giữa các nút
                    // Nút Rescan với tâm màu hồng
                    _buildCustomActionButton(
                      label: "Rescan",
                      centerColor: Colors.pink,
                      onPressed: _handleRescan,
                    ),
                  ],
                ),
            ],
          ),
        ),
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
      ]),
    );
  }

  void _simulateScan(String fakeCode, bool isMaster) {
    // Kiểm tra xem mã có phù hợp với giai đoạn hiện tại không
    bool isValidForCurrentStage =
        (currentStage == ScanStage.MASTER && isMaster) ||
            (currentStage != ScanStage.MASTER && !isMaster);

    if (isValidForCurrentStage) {
      setState(() {
        scannedDevices[currentStage] = fakeCode;
        scanResultType = ScanResultType.success;
        isCameraActive = false;
        controller?.pauseCamera();
      });
    } else {
      setState(() {
        scanResultType = ScanResultType.fail;
        isCameraActive = false;
      });

      //  _showErrorDialog();
    }
  }

  void _simulateFailScan(String fakeCode, bool isMaster) {
    // Luôn đặt trạng thái thành thất bại
    setState(() {
      scanResultType = ScanResultType.fail;
      isCameraActive = false;
      controller?.pauseCamera();
    });

    //_showErrorDialog();
  }
}
