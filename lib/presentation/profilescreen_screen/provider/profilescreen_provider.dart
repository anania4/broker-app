import 'package:flutter/material.dart';
import 'package:delalochu/presentation/profilescreen_screen/models/profilescreen_model.dart';

import '../../../data/models/userModel/userModel.dart';
import '../../../domain/apiauthhelpers/apiauth.dart';

/// A provider class for the ProfilescreenScreen.
///
/// This provider manages the state of the ProfilescreenScreen, including the
/// current profilescreenModelObj

// ignore_for_file: must_be_immutable
class ProfilescreenProvider extends ChangeNotifier {
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ProfilescreenModel profilescreenModelObj = ProfilescreenModel();
  BrokerModel _brokerData = BrokerModel();
  BrokerModel get brokerData => _brokerData;
  bool loading = false;

  bool isShowPassword = true;
  ProfilescreenProvider() {
    getBroker();
  }
  Future<void> getBroker() async {
    loading = true;
    _brokerData = await ApiAuthHelper.getBrokerData();
    loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
  }

  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }
}
