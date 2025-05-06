import 'package:flutter/material.dart';
import 'package:petals/core/services/mqtt_service.dart';
import 'package:petals/features/main_menu/presentation/enum/main_menu_enum.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({
    super.key,
  });

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    connectMqtt();
  }

  void connectMqtt() async {
    await MqttService().connect();
  }

  @override
  Widget build(BuildContext context) {
    const mainMenu = MainMenu.values;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(32),
          child: Center(
            child: SizedBox(
              width: 360,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 0,
                // physics:
                //     const NeverScrollableScrollPhysics(), // tránh xung đột scroll
                children: mainMenu.map((item) => _buildMenuCard(item)).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(MainMenu mainMenu) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 💡 Thêm dòng này
      children: [
        GestureDetector(
          onTap: mainMenu.onTap,
          child: IconBox(
            icon: mainMenu.icon, // Icon Test/Kết nối
            backgroundColor: mainMenu.color,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Text(
            mainMenu.display,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}

class IconBox extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;

  const IconBox({
    Key? key,
    required this.icon,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: FaIcon(
          icon,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }
}
