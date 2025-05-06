import 'package:flutter/material.dart';
import 'package:petals/ultis/enum/control_status.dart';

class ManualControlUI extends StatefulWidget {
  const ManualControlUI({
    super.key,
    required this.dataMap,
    required this.controlStatus,
    this.selectedColor,
    this.onColorSelected,
  });
  final Map<String, String> dataMap;
  final ControlStatus controlStatus;
  final Color? selectedColor;
  final Function(Color?)? onColorSelected;
  @override
  State<ManualControlUI> createState() => _ManualControlUIState();
}

class _ManualControlUIState extends State<ManualControlUI> {
  final List<Color> colors = [
    Colors.green,
    Colors.red,
    Colors.yellow,
  ];
  Color? selectedColor;


  @override
  void initState() {
    super.initState();
    setState(() {
      selectedColor = widget.selectedColor;
    });

  }
@override
  void
  didUpdateWidget(ManualControlUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update durations when initialDurations change
    if (widget.selectedColor != oldWidget.selectedColor) {
      setState(() {
        selectedColor = widget.selectedColor;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF7B9AB6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildManualInfoBlock(),
                  _buildColorDurationSelector(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualInfoBlock() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        color: Color(0xFFD9D9D9),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 29),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 21),
            child: Text(
              widget.controlStatus.display,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildRow("S/N", widget.dataMap['serial'] ?? ""),
          const SizedBox(height: 7),
          _buildRow("Battery", "${widget.dataMap['battery'] ?? ""}%"),
          const SizedBox(height: 7),
          _buildRow("Status", widget.dataMap['status'] ?? ""),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text("Color",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white)),
        ),
        ...colors.map((color) => _buildColorCircle(color)).toList(),
      ],
    );
  }

  Widget _buildColorCircle(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
        if (widget.onColorSelected != null) {
          widget.onColorSelected!(color);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 6) : null,
        ),
        child: CircleAvatar(
          radius: 24,
          backgroundColor: color,
        ),
      ),
    );
  }

  Widget _roundedIconButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
