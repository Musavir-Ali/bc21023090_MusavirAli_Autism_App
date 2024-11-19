import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  final isLoading = false.obs;
  String userRole = '';

  final loginKey = GlobalKey<FormState>();
  final newPasswordKey = GlobalKey<FormState>();

  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController newPassword = TextEditingController();

  String? otp;
  bool isLoginAction = true; // This flag will help us determine which action to validate for

  final adminNotifications = false.obs;
  final chatNotifications = false.obs;
  final listsNotifications = false.obs;
  final equipmentsNotifications = false.obs;
  final myPersonalTasks = false.obs;

  final isFaqExpanded = false.obs;

  // Added properties for resend email functionality
  final resendCounter = 20.obs;
  final canResend = false.obs;
  final isResendLoading = false.obs;

  selectLanguage(String? lang) {
    Get.updateLocale(Locale(lang!));
  }
}

