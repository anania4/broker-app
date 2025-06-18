import 'dart:convert';
import 'dart:io';

import 'package:delalochu/core/utils/navigator_service.dart';
import 'package:delalochu/data/models/packageModel/packageModel.dart';
import 'package:delalochu/data/models/servicesModel/getServicesList.dart';
import 'package:delalochu/data/models/userModel/userModel.dart';
import 'package:delalochu/presentation/historyscreen_screen/models/connectionhistoryModel.dart';
import 'package:delalochu/presentation/homescreen_screen/models/requestcheckModel.dart';
import 'package:delalochu/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/pref_utils.dart';

class ApiAuthHelper {
  // static var domain = "https://api.delalaye.com";
  static var domain = "https://dev-api.delalaye.com";
  // static var domain = "http://192.168.107.204:4000";
  static Future<bool> updateProfile(
      {username, phoneNumber, password, image = '', isnopasandimage}) async {
    try {
      debugPrint('bio $password');
      debugPrint('phone bio---> $phoneNumber');

      var token = PrefUtils.sharedPreferences!.getString('token') ?? '';
      var userId = PrefUtils.sharedPreferences!.getInt('userId') ?? '';
      var headers = {'x-auth-token': token, 'Content-Type': 'application/json'};
      var request =
          http.Request('PUT', Uri.parse('$domain/api/broker/profile/$userId'));
      if (image == '') {
        debugPrint('image null');
        request.body = json.encode(
            {"fullName": username, "phone": phoneNumber, "bio": password});
      } else {
        debugPrint('image');
        request.body = json.encode({
          "fullName": username,
          "phone": phoneNumber,
          "photo": image,
          "bio": password
        });
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      debugPrint('updateProfile Error: $e StackTres => $s');
      return false;
    }
  }

  static Future<bool> checkForOTP({otpCode}) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('PUT', Uri.parse('$domain/api/broker/check-otp'));
      request.body = json.encode({"otp": otpCode});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(await response.stream.bytesToString());
        if (jsonResponse['broker'] != null) {
          PrefUtils.sharedPreferences!
              .setInt('userId', jsonResponse['broker']['id']);
          return true;
        }
      }
    } catch (e, s) {
      debugPrint('updateStatus Error: $e StackTres => $s');
    }
    return false;
  }

  static Future<bool> changePassword({newpassword}) async {
    try {
      var userId = PrefUtils.sharedPreferences!.getInt('userId') ?? '';
      debugPrint('new p $userId');
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'PUT', Uri.parse('$domain/api/broker/reset-password/$userId'));
      request.body = json.encode({"newPassword": newpassword});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            '================================================================');
        print(response.statusCode);
        print(response.reasonPhrase);
        print(
            '================================================================');
      }
    } catch (e, s) {
      debugPrint('changePassword Error: $e StackTres => $s');
    }
    return false;
  }

  static Stream<List<CheckForCustomerRequestModel>>
      getBrokerDatastreams() async* {
    List<CheckForCustomerRequestModel> brokerdata = [];
    try {
      var token = PrefUtils.sharedPreferences!.getString('token') ?? '';
      var headers = {'x-auth-token': token};
      var request =
          http.Request('GET', Uri.parse('$domain/api/broker/request'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        CheckForCustomerRequestModel res =
            CheckForCustomerRequestModel.fromJson(jsonResponse);
        brokerdata.add(res);
      } else if (response.statusCode == 401) {}
    } catch (e, s) {
      debugPrint('Error: $e StackTres => $s');
    }
    debugPrint('===================> object');
    yield brokerdata;
  }

  static Future<bool> acceptORpassuserRequest({status, cennectionId}) async {
    var res = false;
    try {
      var token = PrefUtils.sharedPreferences!.getString('token') ?? '';
      var headers = {'x-auth-token': token, 'Content-Type': 'application/json'};
      var request = http.Request('PUT',
          Uri.parse('$domain/api/broker/connection/response/$cennectionId'));
      request.body = json.encode({"status": status});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        debugPrint(await response.stream.bytesToString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      debugPrint('acceptORpassuserRequest Error: $e stackTrace: $s');
    }
    return res;
  }

  static Future<bool> canceluserRequest({status, cennectionId}) async {
    var res = false;
    try {
      var token = PrefUtils.sharedPreferences!.getString('token') ?? '';
      var headers = {'Content-Type': 'application/json', 'x-auth-token': token};
      var request = http.Request('PUT',
          Uri.parse('$domain/api/broker/connection/cancel/$cennectionId'));
      request.body = json.encode({"reason": "1"});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        debugPrint(await response.stream.bytesToString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      debugPrint('cancelBrokerRequest Exception: => $e' 'StackTrace:' '$s');
    }
    return res;
  }

  static Future<List<Connection>> fetchConnectionHistory(
      {status, cennectionId}) async {
    List<Connection> listofres = [];
    try {
      var token = PrefUtils.sharedPreferences!.getString('token') ?? '';
      debugPrint('token: ' + token);
      var headers = {'x-auth-token': token};
      var request = http.Request(
          'GET', Uri.parse('$domain/api/broker/connection/history'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData =
            json.decode(await response.stream.bytesToString());
        for (var item in responseData['connections']) {
          listofres.add(Connection.fromJson(item));
        }
        listofres.sort(
            (a, b) => b.createdAt!.compareTo(a.createdAt ?? DateTime.now()));
      }
    } catch (e, s) {
      debugPrint('cancelBrokerRequest Exception: => $e' 'StackTrace:' '$s');
    }
    return listofres;
  }

  static Future<bool> updateStatus({status}) async {
    try {
      var token = PrefUtils.sharedPreferences!.getString('token') ?? '';
      var headers = {'Content-Type': 'application/json', 'x-auth-token': token};
      var request =
          http.Request('PUT', Uri.parse('$domain/api/broker/availablity'));
      request.body = json.encode({"avilableForWork": status});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      debugPrint('updateStatus Error: $e StackTres => $s');
      return false;
    }
  }

  static Future<bool> updateLocations({latitude, longtude}) async {
    try {
      var token = PrefUtils.sharedPreferences!.getString('token') ?? '';
      debugPrint("token: " + token);
      var headers = {'Content-Type': 'application/json', 'x-auth-token': token};
      var request =
          http.Request('PUT', Uri.parse('$domain/api/broker/location'));
      request.body = json.encode({"longtude": longtude, "latitude": latitude});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        debugPrint(
            "Current location responseData => ${responseData.toString()}");
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      debugPrint('updateLocations Error: $e StackTres => $s');
      return false;
    }
  }

  static Future<String> requestForResetePassword({phonenumber}) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('PUT', Uri.parse('$domain/api/broker/forgot-password/'));
      request.body = json.encode({"phone": phonenumber});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        debugPrint(await response.stream.bytesToString());
        return 'true';
      } else if (response.statusCode == 400) {
        var jsonResponse = json.decode(await response.stream.bytesToString());
        var errorMsgs = jsonResponse['errors'] as List<dynamic>;
        if (errorMsgs.isNotEmpty) {
          var firstError = errorMsgs[0];
          var errorMessage = firstError['msg'] ?? 'Unknown error';
          return errorMessage;
        }
        return 'Unknown error';
      } else {
        return 'false';
      }
    } catch (e, s) {
      if (e is SocketException) {
        return 'No Internet connection, Please try again';
      }
      debugPrint('requestForResetePassword Error: $e StackTres => $s');
      return 'false';
    }
  }

  static Future<List<Package>> getPackage() async {
    var packageModel = <Package>[];
    try {
      var token = PrefUtils.sharedPreferences!.getString('token') ?? '';
      var request =
          http.Request('GET', Uri.parse('$domain/api/broker/packages'));
      var headers = {'x-auth-token': token};
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData =
            json.decode(await response.stream.bytesToString());
        for (var item in responseData['packages']) {
          packageModel.add(Package.fromJson(item));
        }
      } else if (response.statusCode == 400) {
        var jsonResponse = json.decode(await response.stream.bytesToString());
        var errorMsgs = jsonResponse['errors'] as List<dynamic>;
        if (errorMsgs.isNotEmpty) {
          var firstError = errorMsgs[0];
          var errorMessage = firstError['msg'] ?? 'Unknown error';
          return errorMessage;
        }
        return packageModel;
      }
    } catch (e, s) {
      debugPrint('Error: $e StackTres => $s');
    }
    return packageModel;
  }

  static Future<BrokerModel> getBrokerData() async {
    BrokerModel brokerdata = BrokerModel();
    try {
      var token = PrefUtils.sharedPreferences!.getString('token') ?? '';
      debugPrint('token =>$token ');
      var headers = {'x-auth-token': token};
      var request = http.Request('GET', Uri.parse('$domain/api/auth/broker'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var respon = await response.stream.bytesToString();
        debugPrint('this is Broker Data ===> $respon');
        var jsonResponse = json.decode(respon);
        BrokerModel res = BrokerModel.fromJson(jsonResponse);
        return res;
      } else if (response.statusCode == 401) {
        PrefUtils.sharedPreferences!.setBool('isLoggedIn', false);
        NavigatorService.pushNamedAndRemoveUntil(AppRoutes.loginscreenScreen);
        return brokerdata;
      } else {
        return brokerdata;
      }
    } catch (e, s) {
      debugPrint('getBrokerData Error: $e StackTres => $s');
      return brokerdata;
    }
  }

  static Stream<List<BrokerModel>> getBrokerDatastream() async* {
    List<BrokerModel> brokerdata = [];
    try {
      var token = PrefUtils.sharedPreferences!.getString('token') ?? '';
      var headers = {'x-auth-token': token};
      var request = http.Request('GET', Uri.parse('$domain/api/auth/broker'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(await response.stream.bytesToString());
        BrokerModel res = BrokerModel.fromJson(jsonResponse);
        brokerdata.add(res);
        yield brokerdata;
      } else {
        yield brokerdata;
      }
    } catch (e, s) {
      debugPrint('Error: $e StackTres => $s');
      yield brokerdata;
    }
  }

  static Future<List<Service>> getservice() async {
    List<Service> services = [];
    try {
      var request =
          http.Request('GET', Uri.parse('$domain/api/broker/services'));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print('success $response');
        var jsonResponse = json.decode(await response.stream.bytesToString());
        Services servicesData = Services.fromJson(jsonResponse);
        services = servicesData.services ?? [];
      } else {
        print('else ${response.statusCode}');

      }
    } catch (e, s) {
      debugPrint('getservice Error fetching services: $e $s');
    }
    return services;
  }

  static Future<String> signUp({
    required String userName,
    required String password,
    required String phoneNumber,
    required String imageFile,
    required String googleId,
    required String email,
    required List<dynamic> services,
    required bool ihaveACar,
    required List<Map<String, dynamic>> addresses,
  }) async {
    try {
      print(phoneNumber);
      print("Address ${addresses.length} addresses  $addresses");
      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse('$domain/api/auth/signup/broker'));
      request.body = json.encode({
        "photo": imageFile,
        "fullName": userName,
        "password": password,
        "phone": phoneNumber,
        "services": services,
        "hasCar": ihaveACar,
        "googleId": googleId,
        "email": email,
        "addresses": addresses
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var data = json.decode(await response.stream.bytesToString());
        PrefUtils.sharedPreferences!.setString('token', data['token']);
        PrefUtils.sharedPreferences!
            .setBool('isapproved', data['broker']["approved"] ?? false);
        PrefUtils.sharedPreferences!.setBool('isLoggedIn', true);
        PrefUtils.sharedPreferences!.setInt('userId', data['broker']['id']);
        PrefUtils.sharedPreferences!.setString('phoneNumber', phoneNumber);
        return 'true';
      } else if (response.statusCode == 400) {
        // Parse the error response and return the "msg" value
        var jsonResponse = json.decode(await response.stream.bytesToString());
        var errorMsgs = jsonResponse['errors'] as List<dynamic>;
        if (errorMsgs.isNotEmpty) {
          var firstError = errorMsgs[0];
          var errorMessage = firstError['msg'] ?? 'Unknown error';
          return errorMessage;
        }
        return 'Unknown error';
      } else {
        debugPrint('Server response ${response.stream.first}');
        return '${response.reasonPhrase}';
      }
    } catch (e, s) {
      if (e is SocketException) {
        return 'No Internet connection, Please try again';
      }
      debugPrint('Signup Error ==> $e  StackTrace => $s');
      return 'Unknown error';
    }
  }

  static Future<String> login({
    required String password,
    required String phoneNumber,
  }) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse('$domain/api/auth/broker/login'));
      request.body = json.encode({"phone": phoneNumber, "password": password});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(await response.stream.bytesToString());
        PrefUtils.sharedPreferences!.setString('token', jsonResponse['token']);
        PrefUtils.sharedPreferences!.setString('phoneNumber', phoneNumber);
        PrefUtils.sharedPreferences!
            .setInt('userId', jsonResponse['user']['id']);
        PrefUtils.sharedPreferences!.setBool('isLoggedIn', true);
        debugPrint("token => ${jsonResponse['token']}");
        return ''; // Handle success case here if needed
      } else if (response.statusCode == 400) {
        // Parse the error response and return the "msg" value
        var jsonResponse = json.decode(await response.stream.bytesToString());
        var errorMsgs = jsonResponse['errors'] as List<dynamic>;
        if (errorMsgs.isNotEmpty) {
          var firstError = errorMsgs[0];
          var errorMessage = firstError['msg'] ?? 'Unknown error';
          return errorMessage;
        }
        return 'Unknown error';
      } else {
        return response.reasonPhrase.toString();
      }
    } catch (e, s) {
      if (e is SocketException) {
        return 'No Internet connection, Please try again';
      }
      debugPrint('Error ==> $e  StackTrace => $s');
      return '$e';
    }
  }
static Future<String> topupURl({
  required int packageId,
  required String phoneNUmber,
}) async {
  try {
    var token = PrefUtils.sharedPreferences!.getString('token') ?? '';
    var userId = PrefUtils.sharedPreferences!.getInt('userId') ?? '';
    debugPrint('token => $token');
    debugPrint('userId => $userId');
    var headers = {'x-auth-token': token, 'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('$domain/api/broker/topup/$userId'));
    request.body =
        json.encode({"packageId": packageId, "phone": phoneNUmber});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    
    // ✅ Read stream once
    var responseBody = await response.stream.bytesToString();
    print('response top up => $responseBody ${response.statusCode}');
    
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(responseBody);
      print("checkout url ${jsonResponse['checkout_url']}");
      var checkoutUrl = jsonResponse['checkout_url'];
      return checkoutUrl.toString();
    } else if (response.statusCode == 400) {
      return 'error';
    } else if (response.statusCode == 401) {
      return 'error';
    } else {
      return 'error';
    }
  } catch (e, s) {
    debugPrint('Error ==> $e  StackTrace => $s');
    return 'error';
  }
}


  static Future<String> googleSignIn({
    required String accessToken,
  }) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('$domain/api/auth/broker/login/google'));
      request.body = json.encode({"idToken": "$accessToken"});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData =
            json.decode(await response.stream.bytesToString());
        if (responseData['userExists'] == true) {
          PrefUtils.sharedPreferences!
              .setString('token', responseData['token']);
          PrefUtils.sharedPreferences!
              .setInt('userId', responseData['broker']['id']);
          PrefUtils.sharedPreferences!.setBool(
              'isapproved', responseData['broker']["approved"] ?? false);
          PrefUtils.sharedPreferences!.setBool('isLoggedIn', true);
          return 'true';
        } else {
          PrefUtils.sharedPreferences!
              .setString('googleId', responseData['id']);
          PrefUtils.sharedPreferences!
              .setString('email', responseData['email']);
          PrefUtils.sharedPreferences!
              .setString('username', responseData['name']);
          PrefUtils.sharedPreferences!
              .setString('picture', responseData['picture']);
          return 'false';
        }
      } else {
        return 'error';
      }
    } catch (e, s) {
      if (e is SocketException) {
        return 'No Internet connection, Please try again';
      }
      debugPrint('Error ==> $e  StackTrace => $s');
      return 'error';
    }
  }
}
