# Firebase Configuration Setup

## Admin FCM Configuration

To set up Firebase Admin SDK for push notifications:

1. Copy the template file:
   ```bash
   cp lms_admin/lib/configs/fcm_config.dart.template lms_admin/lib/configs/fcm_config.dart
   ```

2. Replace the placeholder values in `fcm_config.dart` with your actual Firebase service account credentials:
   - Download your service account key from Firebase Console
   - Replace `your-project-id` with your Firebase project ID
   - Replace `your-private-key-id` with the private key ID from your service account
   - Replace `YOUR_PRIVATE_KEY_HERE` with the private key content
   - Replace other placeholder values with actual values from your service account JSON

3. The `fcm_config.dart` file is in `.gitignore` to prevent accidental commits of sensitive data.

## Important Security Notes

- Never commit the actual `fcm_config.dart` file with real credentials
- Always use the template file for version control
- Keep your service account credentials secure