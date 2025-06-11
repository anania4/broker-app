import 'package:delalochu/domain/apiauthhelpers/apiauth.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../data/models/userModel/userModel.dart';

/// A provider class for the HomescreenScreen.
///
/// This provider manages the state of the HomescreenScreen, including the
/// current homescreenModelObj

// ignore_for_file: must_be_immutable

enum HomescreenProviderState { loading, loaded }

class HomescreenProvider extends ChangeNotifier {
  bool _loading = false;
  get loading => _loading;
  BrokerModel brokerData = BrokerModel();
  bool isOnline = true;
  bool isapproved = false;

  getBroker() async {
    _loading = true;
    brokerData = await ApiAuthHelper.getBrokerData();
    _loading = false;
    notifyListeners();
  }

  loadingData(bool values) {
    _loading = values;
    notifyListeners();
  }

  init() async {
    isOnline = PrefUtils.sharedPreferences!.getBool('isonline') ?? true;
    isapproved = PrefUtils.sharedPreferences!.getBool('isapproved') ?? false;
    notifyListeners();
  }

  Future<void> changeSwitchBox1(bool? value) async {
    await ApiAuthHelper.updateStatus(status: value);
    isOnline = value!;
    PrefUtils.sharedPreferences!.setBool('isonline', value);
    notifyListeners();
  }

  Future<bool> updateLocation({latitude, longtude}) async {
    var res = await ApiAuthHelper.updateLocations(
        latitude: latitude, longtude: longtude);
    notifyListeners();
    return res;
  }
}
