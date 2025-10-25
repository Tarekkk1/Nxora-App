import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_admin/components/app_logo.dart';
import 'package:lms_admin/configs/assets_config.dart';
import 'package:lms_admin/models/app_settings_model.dart';
import 'package:lms_admin/providers/auth_state_provider.dart';
import 'package:lms_admin/providers/user_data_provider.dart';
import 'package:lms_admin/utils/reponsive.dart';
import 'package:lms_admin/pages/home.dart';
import 'package:lms_admin/services/auth_service.dart';
import 'package:lms_admin/utils/next_screen.dart';
import 'package:lms_admin/utils/toasts.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:svg_flutter/svg.dart';

import '../tabs/admin_tabs/app_settings/app_setting_providers.dart';

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  var emailCtlr = TextEditingController();
  var passwordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnCtlr =
      RoundedLoadingButtonController();
  bool _obsecureText = true;
  IconData _lockIcon = CupertinoIcons.eye_fill;

  _onChangeVisiblity() {
    if (_obsecureText == true) {
      setState(() {
        _obsecureText = false;
        _lockIcon = CupertinoIcons.eye;
      });
    } else {
      setState(() {
        _obsecureText = true;
        _lockIcon = CupertinoIcons.eye_fill;
      });
    }
  }

  void _handleLogin() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _btnCtlr.start();
      UserCredential? userCredential = await AuthService()
          .loginWithEmailPassword(emailCtlr.text, passwordCtrl.text);
      if (userCredential?.user != null) {
        debugPrint('Login Success');
        _checkVerification(userCredential!);
      } else {
        _btnCtlr.reset();
        if (!mounted) return;
        openFailureToast(context, 'Email/Password is invalid');
      }
    }
  }

  _checkVerification(UserCredential userCredential) async {
    final UserRoles role =
        await AuthService().checkUserRole(userCredential.user!.uid);
    if (role == UserRoles.admin || role == UserRoles.author) {
      ref.read(userRoleProvider.notifier).update((state) => role);

      final settings = await ref.read(appSettingsProvider.future);
      final LicenseType license = settings?.license ?? LicenseType.none;
      final bool isVerified = license != LicenseType.none;

      // if (isVerified) {
        await ref.read(userDataProvider.notifier).getData();
        if (!mounted) return;
        NextScreen.replaceAnimation(context, const Home());
      // } else {
      //   if (!mounted) return;
      //   NextScreen.replaceAnimation(context, const VerifyInfo());
      // }
    } else {
      await AuthService()
          .adminLogout()
          .then((value) => openFailureToast(context, 'Access Denied'));
    }
  }

  _handleDemoAdminLogin() async {
    ref.read(userRoleProvider.notifier).update((state) => UserRoles.guest);
    await AuthService()
        .loginAnnonumously()
        .then((value) => NextScreen.replaceAnimation(context, const Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1c6ea4).withValues(alpha: 0.1),
              const Color(0xFF1a2851).withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Row(
          children: [
            // Left side - Logo and branding
            if (Responsive.isDesktop(context) || Responsive.isDesktopLarge(context))
              Expanded(
                flex: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1c6ea4),
                        Color(0xFF1a2851),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo section
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                        child: const AppLogo(
                          imageString: AssetsConfig.logo,
                          height: 80,
                          width: 280,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Welcome text
                      Text(
                        'Welcome to',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nxora Admin Panel',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Manage your learning management system\nwith ease and efficiency',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 60),
                      // Decorative element
                      SvgPicture.asset(
                        AssetsConfig.loginImageString,
                        height: 200,
                        width: 200,
                        colorFilter: ColorFilter.mode(
                          Colors.white.withValues(alpha: 0.3),
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Right side - Login form
            Expanded(
              flex: Responsive.isDesktop(context) || Responsive.isDesktopLarge(context) ? 4 : 1,
              child: Container(
                color: Colors.white,
                child: Form(
                  key: formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: _getHorizontalPadding(),
                        vertical: 40.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Mobile logo (only shown on mobile)
                          if (!Responsive.isDesktop(context) && !Responsive.isDesktopLarge(context))
                            Center(
                              child: Column(
                                children: [
                                  const AppLogo(
                                    imageString: AssetsConfig.logo,
                                    height: 60,
                                    width: 200,
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          
                          // Login header
                          Text(
                            'Sign In',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: const Color(0xFF1a2851),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Access your admin dashboard',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.blueGrey.shade600,
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Email field
                          _buildInputField(
                            context: context,
                            label: 'Email Address',
                            controller: emailCtlr,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Enter your email',
                            validator: (value) {
                              if (value!.isEmpty) return 'Email is required';
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () => emailCtlr.clear(),
                              icon: const Icon(Icons.clear_rounded),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Password field
                          _buildInputField(
                            context: context,
                            label: 'Password',
                            controller: passwordCtrl,
                            obscureText: _obsecureText,
                            hintText: 'Enter your password',
                            validator: (value) {
                              if (value!.isEmpty) return 'Password is required';
                              if (value.length < 6) return 'Password must be at least 6 characters';
                              return null;
                            },
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: _onChangeVisiblity,
                                  icon: Icon(_lockIcon),
                                ),
                                IconButton(
                                  onPressed: () => passwordCtrl.clear(),
                                  icon: const Icon(Icons.clear_rounded),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: RoundedLoadingButton(
                              onPressed: _handleLogin,
                              controller: _btnCtlr,
                              color: const Color(0xFF1c6ea4),
                              borderRadius: 12,
                              animateOnTap: false,
                              elevation: 0,
                              child: Text(
                                'Sign In',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Footer
                          Center(
                            child: Text(
                              '© 2024 Nxora. All rights reserved.',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.blueGrey.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: const Color(0xFF1a2851),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _getHorizontalPadding() {
    if (Responsive.isDesktopLarge(context)) {
      return 120;
    } else if (Responsive.isDesktop(context)) {
      return 80;
    } else if (Responsive.isTablet(context)) {
      return 100;
    } else {
      return 30;
    }
  }
}
