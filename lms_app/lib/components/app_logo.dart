import 'package:flutter/material.dart';
import 'package:lms_app/configs/app_assets.dart';

class AppLogo extends StatelessWidget {
  final double? height;
  final double? width;
  final bool showBackground;
  
  const AppLogo({
    super.key,
    this.height,
    this.width,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget logoWidget = Image.asset(
      logo,
      height: height ?? 40,
      width: width ?? 100,
      fit: BoxFit.contain,
    );

    if (showBackground) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: logoWidget,
      );
    }

    return logoWidget;
  }
}
