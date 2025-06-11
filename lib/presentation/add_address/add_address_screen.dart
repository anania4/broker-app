import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../core/app_export.dart';
import '../../core/utils/progress_dialog_utils.dart';
import '../../data/models/GoogleMapSearchModel.dart';
import '../../domain/apiauthhelpers/apiauth.dart';
import '../../service/map_apiservice.dart';
import '../../widgets/custom_text_form_field.dart';
import '../forgotPassword/provider/forgotpassword_provider.dart';
import '../signupscreen_screen/models/signupscreen_model.dart';

class AddAddressScreen extends StatefulWidget {
  final bool? isFromProfile;

  const AddAddressScreen({super.key, this.isFromProfile});
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();

  static Widget builder(BuildContext context) {
    return AddAddressScreen();
  }

  static SignupscreenModel getArguments(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route != null) {
      return route.settings.arguments as SignupscreenModel;
    }
    throw Exception("Arguments not found");
  }
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final List<Map<String, dynamic>> _selectedAddresses = [];
  final TextEditingController _searchController = TextEditingController();
  List<Prediction> listAddress = [];
  bool isSearching = false;
  late List<Map<String, dynamic>> addedaddresses = []; // Initialize the list

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) return;
    setState(() => isSearching = true);
    try {
      final response = await MapApiService.searchAddressRequest(search: query);
      setState(() {
        listAddress = response.predictions!;
        isSearching = false;
      });
    } catch (error) {
      setState(() => isSearching = false);
      debugPrint("Error during address search: $error");
    }
  }

  Future<void> _onAddressSelected(String? placeId) async {
    if (placeId == null) return;

    try {
      final endpoint =
          'https://maps.googleapis.com/maps/api/place/details/json?key=${ConstantStrings.MapKey}&placeid=$placeId';

      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final Map<String, dynamic> locationData = jsonDecode(response.body);
        final formattedAddress = locationData['result']['formatted_address'];
        final location = locationData['result']['geometry']['location'];
        final LatLng selectedLocation =
            LatLng(location['lat'], location['lng']);

        if (!_selectedAddresses
                .any((address) => address['name'] == formattedAddress) &&
            _selectedAddresses.length < 4) {
          setState(() {
            _selectedAddresses.add({
              'name': formattedAddress,
              'latitude': selectedLocation.latitude,
              'longitude': selectedLocation.longitude,
            });
            _searchController.clear();
            listAddress.clear();
          });
        }
      }
    } catch (error) {
      debugPrint("Error fetching address details: $error");
    }
  }

  void _removeAddress(Map<String, dynamic> address) {
    setState(() {
      _selectedAddresses.remove(address);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Add Addresses"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextFormField(
              controller: _searchController,
              onChanged: (value) => _searchAddress(_searchController.text),
              hintText: "Search for an address".tr,
              hintStyle: TextStyle(
                color: appTheme.blueGray400,
              ),
              textInputAction: TextInputAction.done,
              textStyle: TextStyle(
                color: appTheme.black900,
              ),
              maxLines: 1,
              borderDecoration: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.h,
                vertical: 19.v,
              ),
              suffix: const Icon(Icons.search),
            ),
          ),
          if (listAddress.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: listAddress.length,
                itemBuilder: (context, index) {
                  final prediction = listAddress[index];
                  return ListTile(
                    title: Text(
                      prediction.description ?? "",
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () => _onAddressSelected(prediction.placeId),
                  );
                },
              ),
            ),
          if (_selectedAddresses.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _selectedAddresses.length,
                itemBuilder: (context, index) {
                  final address = _selectedAddresses[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          address['name'],
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          "Lat: ${address['latitude']}, Lng: ${address['longitude']}",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _removeAddress(address),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          if (_selectedAddresses.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<ForgotPasswordProvider>(
                  builder: (context, provider, child) {
                return ElevatedButton(
                  onPressed: () => widget.isFromProfile == true ? _submitAddress(context) :  _onSubmit(context, provider),
                  child: Container(
                    width: 343,
                    height: 50,
                    padding: const EdgeInsets.only(top: 16, bottom: 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.79, 0.61),
                        end: Alignment(-0.79, -0.61),
                        colors: [Color(0xFFF06400), Color(0xFFFFA05B)],
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50, color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Done".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 50)
          ],
        ],
      ),
    );
  }

  Future<void> _submitAddress(BuildContext context) async {
  if (_selectedAddresses.isEmpty) {
    ProgressDialogUtils.showSnackBar(
      context: context,
      message: "Please add at least one address",
      duration: 2,
    );
    return;
  }

  if (_selectedAddresses.isNotEmpty) {
      addedaddresses.clear();
      for (var i = 0; i < _selectedAddresses.length; i++) {
        setState(() {
          addedaddresses.add({
            "name": _selectedAddresses[i]['name'],
            "latitude": _selectedAddresses[i]['latitude'],
            "longitude": _selectedAddresses[i]['longitude']
          });
        });
      }
  }

  try {
    var token = PrefUtils.sharedPreferences!.getString('token') ?? '';

    var headers = {
      'Content-Type': 'application/json',
      'x-auth-token': token,
    };
    var request = http.Request(
      'POST',
      Uri.parse('${ApiAuthHelper.domain}/api/broker/brokeraddress'),
    );



    print('addresses $addedaddresses');

    request.body = json.encode({
      'brokerId': PrefUtils.sharedPreferences!.getInt('userId'),
      "addresses": addedaddresses,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = json.decode(await response.stream.bytesToString());
      print('data $data');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Address submitted successfully!')),
      );
      Navigator.pushNamed(context, AppRoutes.profilescreenScreen);
    } else if (response.statusCode == 400) {
      var jsonResponse = json.decode(await response.stream.bytesToString());
      var errorMsgs = jsonResponse['errors'] as List<dynamic>;
      if (errorMsgs.isNotEmpty) {
        var errorMessage = errorMsgs[0]['msg'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected server response.')),
      );
      print('Unexpected server response: ${response.statusCode}');
    }
  } catch (e, s) {
    if (e is SocketException) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet connection.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
    print('Signup Error ==> $e  StackTrace => $s');
  }
}


  Future<void> _onSubmit(
      BuildContext context, ForgotPasswordProvider provider) async {
    final SignupscreenModel signupModel =
        AddAddressScreen.getArguments(context);
    if (_selectedAddresses.isEmpty) {
      ProgressDialogUtils.showSnackBar(
        context: context,
        message: "Please add at least one address",
        duration: 2,
      );
      return;
    }
    ProgressDialogUtils.showProgressDialog(
        context: context, isCancellable: false);

    if (_selectedAddresses.isNotEmpty) {
      addedaddresses.clear();
      for (var i = 0; i < _selectedAddresses.length; i++) {
        setState(() {
          addedaddresses.add({
            "name": _selectedAddresses[i]['name'],
            "latitude": _selectedAddresses[i]['latitude'],
            "longitude": _selectedAddresses[i]['longitude']
          });
        });
      }
      ProgressDialogUtils.showProgressDialog(
        context: context,
        isCancellable: false,
      );
      var res = await ApiAuthHelper.signUp(
        userName: signupModel.userName,
        password: signupModel.password,
        phoneNumber: signupModel.isFromGoogle
            ? "+251${provider.phonenumberController.text}"
            : signupModel.phoneNumber,
        imageFile: signupModel.imageFile,
        services: signupModel.selectedservice,
        ihaveACar: signupModel.hasAcar,
        googleId: signupModel.googleId,
        email: signupModel.email,
        addresses: addedaddresses, // Pass the initialized list
      );
      if (res == 'true') {
        ProgressDialogUtils.hideProgressDialog();
        onTapContinueButton(context);
        ProgressDialogUtils.showSnackBar(
          context: context,
          message: 'You have successfully signed up',
          duration: 2,
        );
      } else {
        ProgressDialogUtils.hideProgressDialog();
        ProgressDialogUtils.showSnackBar(
          context: context,
          message: '$res',
          duration: 2,
        );
        return;
      }
    }
  }

  /// Navigates to the homescreenScreen when the action is triggered.
  onTapContinueButton(BuildContext context) {
    NavigatorService.pushNamedAndRemoveUntil(
      AppRoutes.homescreenScreens,
      arguments: {},
    );
  }
}
