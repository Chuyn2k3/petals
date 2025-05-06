import 'package:flutter/material.dart';

class AppSpacer extends StatelessWidget {
  final double? width;
  final double? height;

  const AppSpacer._({Key? key, this.width, this.height}) : super(key: key);

  factory AppSpacer.p32() => const AppSpacer._(height: 32, width: 32);
  factory AppSpacer.p24() => const AppSpacer._(height: 24, width: 24);
  factory AppSpacer.p20() => const AppSpacer._(height: 20, width: 20);
  factory AppSpacer.p16() => const AppSpacer._(height: 16, width: 16);
  factory AppSpacer.p12() => const AppSpacer._(height: 12, width: 12);
  factory AppSpacer.p8() => const AppSpacer._(height: 8, width: 8);
  factory AppSpacer.p4() => const AppSpacer._(height: 4, width: 4);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
