import 'package:delalochu/core/app_export.dart';
import 'package:delalochu/presentation/forgotPassword/models/otpCodeModel.dart';
import 'package:delalochu/presentation/loginscreen_screen/provider/loginscreen_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../core/utils/progress_dialog_utils.dart';
import '../../domain/apiauthhelpers/apiauth.dart';
import 'provider/forgotpassword_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();

  static Widget builder(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add other providers here if needed
        ChangeNotifierProvider(create: (context) => LoginscreenProvider()),
      ],
      child: ForgotPasswordScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? phoneNumber;
  bool isContinueClicked = false;
  bool isphonenumberNotValid = false;

  bool isPhoneValidated = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 60.v),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 40.h, right: 43.h, bottom: 161.v),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgImage190x258,
                          width: 258.h,
                          alignment: Alignment.center,
                        ),
                        SizedBox(height: 17.v),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: appTheme.blueGray400,
                              fontSize: 24.fSize,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 18.v),
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: Text(
                            'Please enter you phone number to receive a verification code ',
                            style: TextStyle(
                              color: appTheme.blueGray400,
                              fontSize: 14.fSize,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: 18.v),
                        // _buildPhoneNumber(context),
                        buildPhoneNumberWithCountry(context),
                      ],
                    ),
                  ),
                ),
              ),
              _buildContinueButton(context),
              SizedBox(height: 60.v),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget buildPhoneNumberWithCountry(BuildContext context) {
    const _initialCountryCode = 'ET';
    var _country =
        countries.firstWhere((element) => element.code == _initialCountryCode);
    return Consumer<ForgotPasswordProvider>(
      builder: (context, provider, child) {
        return IntlPhoneField(
          controller: provider.phonenumberController,
          disableLengthCheck: false,
          textInputAction: TextInputAction.next,
          style: TextStyle(color: appTheme.black900),
          decoration: InputDecoration(
            filled: true,
            fillColor: appTheme.blueGray50,
            labelText: "msg_enter_your_phone".tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: appTheme.black900.withOpacity(0.23),
                width: 1,
              ),
            ),
          ),
          initialCountryCode: _initialCountryCode,
          onChanged: (value) {
            if (value.number.length >= _country.minLength &&
                value.number.length <= _country.maxLength) {
              setState(() {
                isPhoneValidated = true;
                phoneNumber = value.completeNumber;
              });
            } else {
              setState(() {
                isPhoneValidated = false;
              });
            }
          },
          onCountryChanged: (country) => _country = country,
        );
      },
    );
  }

  /// Section Widget
  Widget _buildContinueButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (isPhoneValidated) {
          if (_formKey.currentState!.validate() && phoneNumber != null) {
            ProgressDialogUtils.showProgressDialog(
              context: context,
              isCancellable: false,
            );
            var res = await ApiAuthHelper.requestForResetePassword(
              phonenumber: phoneNumber.toString().trim(),
            );
            if (res == 'true') {
              ProgressDialogUtils.hideProgressDialog();
              onTapContinueButton();
              ProgressDialogUtils.showSnackBar(
                context: context,
                message: 'We have sent Four digits to $phoneNumber !',
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
          } else {
            ProgressDialogUtils.showSnackBar(
              context: context,
              message: 'Please enter your phone number',
              duration: 3,
            );
            return null;
          }
        } else {
          ProgressDialogUtils.showSnackBar(
            context: context,
            message: 'Please enter your phone number',
            duration: 2,
          );
          return null;
        }
      },
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
              "Send",
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
  }

  /// Navigates to the categoryscreenoneScreen when the action is triggered.
  onTapContinueButton() {
    NavigatorService.pushNamed(
      AppRoutes.otpcodeverificationscreen,
      arguments: OtpCodeVerificationModel(
        phone: phoneNumber ?? '',
      ),
    );
  }
}
