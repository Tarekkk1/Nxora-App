import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/services/device_service.dart';
import 'package:lms_app/utils/snackbars.dart';

class DeviceValidationService {
  static const String adminEmail = 'tarekzeyad31@yahoo.com';
  
  /// Validates if the current device is allowed to access the given email account
  /// Returns true if access is allowed, false otherwise
  static Future<bool> validateDeviceAccess(BuildContext context, String email) async {
    // Admin email is always allowed
    if (email == adminEmail) {
      return true;
    }
    
    try {
      final currentDeviceId = await DeviceService.getDeviceId();
      
      // Get user document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final userData = userDoc.docs.first.data();
        final storedDeviceId = userData['device_id'];

        // If device ID exists and doesn't match current device
        if (storedDeviceId != null && storedDeviceId != currentDeviceId) {
          if (context.mounted) {
            openSnackbarFailure(context, 'This account can only be accessed from the original device');
          }
          return false;
        }
      }
      
      return true;
    } catch (e) {
      debugPrint('Device validation error: $e');
      if (context.mounted) {
        openSnackbarFailure(context, 'Device validation failed. Please try again.');
      }
      return false;
    }
  }
  
  /// Updates the device ID for a user account (useful for admin functions)
  static Future<void> updateUserDeviceId(String userId, String? newDeviceId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'device_id': newDeviceId});
    } catch (e) {
      debugPrint('Failed to update device ID: $e');
      throw Exception('Failed to update device ID');
    }
  }
  
  /// Removes device binding for a user (admin function)
  static Future<void> removeDeviceBinding(String userId) async {
    await updateUserDeviceId(userId, null);
  }
  
  /// Gets device information for debugging/admin purposes
  static Future<Map<String, String>> getDeviceInfo() async {
    final deviceId = await DeviceService.getDeviceId();
    return {
      'device_id': deviceId,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}