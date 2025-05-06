import 'package:flutter/material.dart';
import 'package:petals/constant/config.dart';
import 'package:petals/features/mode_selection/enum/light_number_enum.dart';
import 'package:petals/features/scanning/presentation/scanning_screen.dart';
import 'package:petals/widget/app_spacer.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const lightNumers = LightNumer.values;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _buildBody(
            context,
            lightNumers,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<LightNumer> lightNumers) {
    return Container(
      width: context.screenSize.width * 2 / 3,
      height: 360,
      //color: Colors.white,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(34),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Lights Number",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            AppSpacer.p32(),
            Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                // /mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: lightNumers
                    .map((e) => _buildItem(
                          context,
                          e,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, LightNumer lightNumer) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => ModeScreen(lightNumber: lightNumer),
        //   ),
        // );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QRScanScreen(

              lightNumber: lightNumer,
            ),
          ),
        );
      },
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          color: Color(0xFF7B9AB6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            lightNumer.display,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
