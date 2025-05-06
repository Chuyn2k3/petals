import 'package:flutter/material.dart';
import 'package:petals/widget/base_scaffold.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // Các giá trị cho dropdown
  String _connectingMethod = 'Connecting Method';
  String _field1 = 'abcd';
  String _field2 = 'abcd';
  String _field3 = '...';
  String _field4 = '';

  // Giá trị cho cài đặt WiFi
  String _ssidName = 'SSIDName_SN';
  String _password = '1234';

  // Lựa chọn kết nối
  String _selectedConnectionType =
      'Local WiFi Network'; // 'Internet' hoặc 'Local WiFi Network'

  // Trạng thái mở rộng của các dropdown
  bool _isConnectingMethodExpanded = false;
  bool _isField1Expanded = false;
  bool _isField2Expanded = false;
  bool _isField3Expanded = false;
  bool _isField4Expanded = false;

  // Hiển thị chi tiết kết nối
  bool _showConnectionDetails = false;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      onNextPressed: () {},
      child: Column(
        children: [
          _buildSettingHeader(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Dropdown đầu tiên - Connecting Method
                  _buildExpandableDropdown(
                    title: _connectingMethod,
                    isExpanded: _isConnectingMethodExpanded,
                    options: [
                      'Connecting Method',
                      'Internet',
                      'Local WiFi Network'
                    ],
                    onToggle: () {
                      setState(() {
                        _isConnectingMethodExpanded =
                            !_isConnectingMethodExpanded;
                        // Đóng các dropdown khác khi mở dropdown này
                        if (_isConnectingMethodExpanded) {
                          _isField1Expanded = false;
                          _isField2Expanded = false;
                          _isField3Expanded = false;
                          _isField4Expanded = false;
                        }
                      });
                    },
                    onOptionSelected: (value) {
                      setState(() {
                        _connectingMethod = value;
                        _isConnectingMethodExpanded = false;

                        // Nếu chọn Internet hoặc Local WiFi Network
                        if (value == 'Internet' ||
                            value == 'Local WiFi Network') {
                          _selectedConnectionType = value;
                          _showConnectionDetails = true;
                        } else {
                          _showConnectionDetails = false;
                        }
                      });
                    },
                  ),

                  // Hiển thị chi tiết kết nối nếu đã chọn
                  if (_showConnectionDetails) _buildConnectionDetails(),

                  // Các dropdown khác nếu không hiển thị chi tiết kết nối
                  if (!_showConnectionDetails) ...[
                    _buildExpandableDropdown(
                      title: _field1,
                      isExpanded: _isField1Expanded,
                      options: ['abcd', 'efgh', 'ijkl'],
                      onToggle: () {
                        setState(() {
                          _isField1Expanded = !_isField1Expanded;
                          // Đóng các dropdown khác khi mở dropdown này
                          if (_isField1Expanded) {
                            _isConnectingMethodExpanded = false;
                            _isField2Expanded = false;
                            _isField3Expanded = false;
                            _isField4Expanded = false;
                          }
                        });
                      },
                      onOptionSelected: (value) {
                        setState(() {
                          _field1 = value;
                          _isField1Expanded = false;
                        });
                      },
                    ),
                    _buildExpandableDropdown(
                      title: _field2,
                      isExpanded: _isField2Expanded,
                      options: ['abcd', 'efgh', 'ijkl'],
                      onToggle: () {
                        setState(() {
                          _isField2Expanded = !_isField2Expanded;
                          // Đóng các dropdown khác khi mở dropdown này
                          if (_isField2Expanded) {
                            _isConnectingMethodExpanded = false;
                            _isField1Expanded = false;
                            _isField3Expanded = false;
                            _isField4Expanded = false;
                          }
                        });
                      },
                      onOptionSelected: (value) {
                        setState(() {
                          _field2 = value;
                          _isField2Expanded = false;
                          _connectingMethod = value;
                        });
                      },
                    ),
                    _buildExpandableDropdown(
                      title: _field3,
                      isExpanded: _isField3Expanded,
                      options: ['...', 'Option 1', 'Option 2', 'Option 3'],
                      onToggle: () {
                        setState(() {
                          _isField3Expanded = !_isField3Expanded;
                          // Đóng các dropdown khác khi mở dropdown này
                          if (_isField3Expanded) {
                            _isConnectingMethodExpanded = false;
                            _isField1Expanded = false;
                            _isField2Expanded = false;
                            _isField4Expanded = false;
                          }
                        });
                      },
                      onOptionSelected: (value) {
                        setState(() {
                          _field3 = value;
                          _isField3Expanded = false;
                        });
                      },
                    ),
                    _buildExpandableDropdown(
                      title: _field4.isEmpty ? 'Select an option' : _field4,
                      isExpanded: _isField4Expanded,
                      options: ['Option A', 'Option B', 'Option C'],
                      onToggle: () {
                        setState(() {
                          _isField4Expanded = !_isField4Expanded;
                          // Đóng các dropdown khác khi mở dropdown này
                          if (_isField4Expanded) {
                            _isConnectingMethodExpanded = false;
                            _isField1Expanded = false;
                            _isField2Expanded = false;
                            _isField3Expanded = false;
                          }
                        });
                      },
                      onOptionSelected: (value) {
                        setState(() {
                          _field4 = value;
                          _isField4Expanded = false;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      width: double.infinity,
      color: const Color(0xFF7B9AB7),
      child: const Center(
        child: Text(
          'SETTING',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableDropdown({
    required String title,
    required bool isExpanded,
    required List<String> options,
    required VoidCallback onToggle,
    required Function(String) onOptionSelected,
  }) {
    return Column(
      children: [
        // Dropdown header
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: Text(title),
            trailing: Icon(
              isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            ),
            onTap: onToggle,
          ),
        ),
        // Dropdown options
        if (isExpanded)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: options.map((option) {
                return ListTile(
                  title: Text(option),
                  onTap: () => onOptionSelected(option),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildConnectionDetails() {
    // Xác định xem đang hiển thị Internet hay Local WiFi
    bool isInternet = _selectedConnectionType == 'Internet';

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Internet option
          _buildSelectionRow(
            'Internet',
            isInternet,
            () {
              setState(() {
                _selectedConnectionType = 'Internet';
                _connectingMethod = 'Internet';
              });
            },
          ),
          const Divider(),
          // Local WiFi Network option
          _buildSelectionRow(
            'Local WiFi Network',
            !isInternet,
            () {
              setState(() {
                _selectedConnectionType = 'Local WiFi Network';
                _connectingMethod = 'Local WiFi Network';
              });
            },
          ),
          const SizedBox(height: 16),
          // SSID field
          _buildTextField('SSID', isInternet ? '' : _ssidName, (value) {
            setState(() {
              _ssidName = value;
            });
          }),
          const SizedBox(height: 16),
          // Password field
          _buildTextField('Password', isInternet ? '' : _password, (value) {
            setState(() {
              _password = value;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildSelectionRow(String title, bool isSelected, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.purple, width: 2),
              color: isSelected ? Colors.purple : Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }
}
