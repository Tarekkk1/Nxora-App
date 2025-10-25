import 'package:flutter/material.dart';
import 'package:lms_admin/configs/app_config.dart';
import 'package:lms_admin/utils/reponsive.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CustomButtons {
  static OutlinedButton customOutlineButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    Color bgColor = Colors.transparent,
    Color foregroundColor = AppConfig.themeColor,
  }) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        backgroundColor: bgColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        side: BorderSide(color: foregroundColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(icon, size: 18),
      label: Visibility(
        visible: !Responsive.isMobile(context),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }

  static RoundedLoadingButton submitButton(
    BuildContext context, {
    required RoundedLoadingButtonController buttonController,
    required String text,
    required VoidCallback onPressed,
    double? borderRadius,
    double? width,
    double? height,
    double? elevation,
    Color? bgColor,
  }) {
    return RoundedLoadingButton(
      onPressed: onPressed,
      animateOnTap: false,
      color: bgColor ?? const Color(0xFF1c6ea4),
      width: width ?? MediaQuery.of(context).size.width,
      elevation: 0,
      height: height ?? 52,
      borderRadius: borderRadius ?? 12,
      controller: buttonController,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ElevatedButton modernButton(
    BuildContext context, {
    required String text,
    required VoidCallback onPressed,
    Color? bgColor,
    Color? textColor,
    IconData? icon,
    double? radius,
    EdgeInsets? padding,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor ?? const Color(0xFF1c6ea4),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 12),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: textColor ?? Colors.white),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static TextButton normalButton(
    BuildContext context, {
    required String text,
    Color? bgColor,
    double? radius,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: bgColor ?? const Color(0xFF1c6ea4),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 12),
        ),
      ),
      child: Text(
        'Okay',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  static Container circleButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    Color? bgColor,
    double? radius,
    String? tooltip,
    Color? iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? const Color(0xFF1c6ea4).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radius ?? 12),
        border: Border.all(
          color: (bgColor ?? const Color(0xFF1c6ea4)).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: iconColor ?? const Color(0xFF1c6ea4),
          size: 18,
        ),
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}
