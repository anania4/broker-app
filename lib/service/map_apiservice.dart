import 'dart:convert';
import '../../../core/app_export.dart';
import 'package:http/http.dart' as http;

import '../data/models/GoogleMapSearchModel.dart';

class MapApiService {
  static Future<GoogleMapSearchModel> searchAddressRequest(
      {String? search}) async {
    try {
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=geocode&key=${ConstantStrings.MapKey}&components=country:et'));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Map<String, dynamic> map =
            jsonDecode(await response.stream.bytesToString());
        return GoogleMapSearchModel.fromJson(map);
      }
    } catch (e, s) {
      Logger.log('$e', stackTrace: s);
    }
    return GoogleMapSearchModel();
  }
}
