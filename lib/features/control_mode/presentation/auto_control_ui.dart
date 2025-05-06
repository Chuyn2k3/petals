import 'package:flutter/material.dart';
import 'package:petals/ultis/enum/control_status.dart';

class AutoControlUI extends StatefulWidget {
  const AutoControlUI({
    super.key,
    required this.dataMap,
    required this.controlStatus,
    this.onDurationsChanged,
    this.initialDurations = const [0, 0, 0],
  });
  final Map<String, String> dataMap;
  final ControlStatus controlStatus;
  final Function(List<int>)? onDurationsChanged;
  final List<int> initialDurations;
  @override
  State<AutoControlUI> createState() => _AutoControlUIState();
}

class _AutoControlUIState extends State<AutoControlUI> {
  final List<Color> colors = [
    const Color(0xFF97D077),
    Colors.redAccent,
    Colors.amberAccent,
  ];

  List<int> durations = [0, 0, 0];
 @override
  void
  initState() {
    super.initState();
    // Initialize with the provided durations
    durations = List.from(widget.initialDurations);
  }

  @override
  void
  didUpdateWidget(AutoControlUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update durations when initialDurations change
    if (widget.initialDurations != oldWidget.initialDurations) {
      setState(() {
        durations = List<int>.from(widget.initialDurations);
      });
    }
  }
  void _increaseDuration(int index) {
    setState(() {
      durations[index]++;
    });
    // After updating durations in _increaseDuration and _decreaseDuration methods:
    if (widget.onDurationsChanged != null) {
      widget.onDurationsChanged!(durations);
    }
  }

  void _decreaseDuration(int index) {
    setState(() {
      if (durations[index] > 0) durations[index]--;
    });
// After updating durations in _increaseDuration and _decreaseDuration methods:
    if (widget.onDurationsChanged != null) {
      widget.onDurationsChanged!(durations);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(),
      //width: 360,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF7B9AB6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAutoInfoBlock(),
                  _buildColorDurationSelector(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoInfoBlock() {
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Color", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 30),
                Text("Duration", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ...List.generate(colors.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Color circle
                  Container(
                    margin: const EdgeInsets.fromLTRB(
                      8,
                      8,
                      8,
                      8,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: colors[index],
                    ),
                  ),
                  // Container(
                  //   width: 30,
                  //   height: 30,
                  //   decoration: BoxDecoration(
                  //     color: colors[index],
                  //     shape: BoxShape.circle,
                  //   ),
                  // ),
                  const SizedBox(width: 20),

                  // Duration box
                  Container(
                    width: 60,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        durations[index].toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  _roundedIconButton(Icons.add, () => _increaseDuration(index)),
                  const SizedBox(width: 6),
                  _roundedIconButton(
                      Icons.remove, () => _decreaseDuration(index)),
                ],
              ),
            );
          }),
        ],
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
