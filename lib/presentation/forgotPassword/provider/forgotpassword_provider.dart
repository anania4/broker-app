import 'package:flutter/material.dart';

/// A provider class for the SignupscreenScreen.
///
/// This provider manages the state of the SignupscreenScreen, including the
/// current signupscreenModelObj

// ignore_for_file: must_be_immutable
class ForgotPasswordProvider extends ChangeNotifier {
  TextEditingController phonenumberController = TextEditingController();

  bool isShowPassword = true;
  bool isShowconfirmPassword = true;

  @override
  void dispose() {
    super.dispose();
    phonenumberController.dispose();
  }

  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  void changeconfirmPasswordVisibility() {
    isShowconfirmPassword = !isShowconfirmPassword;
    notifyListeners();
  }
}
