import 'package:delalochu/core/app_export.dart';
import 'package:delalochu/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../core/utils/progress_dialog_utils.dart';
import '../../domain/apiauthhelpers/apiauth.dart';
import '../../localization/lang_provider.dart';
import '../signupscreen_screen/models/signupscreen_model.dart';
import 'provider/loginscreen_provider.dart';
import 'package:delalochu/domain/googleauth/google_auth_helper.dart';

class LoginscreenScreen extends StatefulWidget {
  const LoginscreenScreen({Key? key}) : super(key: key);

  @override
  LoginscreenScreenState createState() => LoginscreenScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginscreenProvider(),
      child: LoginscreenScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class LoginscreenScreenState extends State<LoginscreenScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? password;

  String? phoneNumber;

  bool isphonenumberNotValid = false;

  bool isPhoneValidated = true;

  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: null,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<Locale>(
                    padding: EdgeInsets.all(5),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppies',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    icon: Icon(
                      Icons.language,
                      color: Colors.black,
                    ),
                    value: languageProvider.currentLocale,
                    borderRadius: BorderRadius.circular(10),
                    dropdownColor: appTheme.blueGray400,
                    alignment: Alignment.center,
                    iconEnabledColor: Colors.white,
                    iconSize: 20,
                    items: <DropdownMenuItem<Locale>>[
                      DropdownMenuItem<Locale>(
                        value: Locale('en', ''),
                        child: Text('Eng'),
                      ),
                      DropdownMenuItem<Locale>(
                        value: Locale('am', ''),
                        child: Text('አማርኛ'),
                      ),
                      DropdownMenuItem<Locale>(
                        value: Locale('da', ''),
                        child: Text('A/Oromoo'),
                      ),
                      // Add more languages here as needed
                    ],
                    onChanged: (Locale? newLocale) {
                      if (newLocale != null) {
                        languageProvider.changeLanguage(newLocale);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                SizedBox(
                    height: 25.v), // here I supdata the height of the column
                Padding(
                  padding: EdgeInsets.only(
                    left: 43.h,
                    right: 43.h,
                  ),
                  child: Column(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgImage190x258,
                        width: 258.h,
                      ),
                      SizedBox(height: 19.v),
                      Text(
                        "msg_login_to_your_account".tr,
                        style: TextStyle(
                          color: appTheme.blueGray400,
                          fontSize: 24.fSize,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20.v),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "lbl_phone_number".tr,
                          style: TextStyle(
                            color: appTheme.blueGray400,
                            fontSize: 14.fSize,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.v),
                      // _buildPhoneNumber(context),
                      // SizedBox(height: 12.v),
                      _buildPhoneNumberWithCountry(context),
                      SizedBox(height: 12.v),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "lbl_password".tr,
                          style: TextStyle(
                            color: appTheme.blueGray400,
                            fontSize: 14.fSize,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.v),
                      _buildPassword(context),
                      SizedBox(height: 23.v),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            onTapForgotPasswordText(context);
                          },
                          child: Text(
                            "msg_forgot_password".tr,
                            style: TextStyle(
                              color: appTheme.orangeA200,
                              fontSize: 16.fSize,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 55.v),
                      _buildLogin(context),
                      SizedBox(height: 25.v),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.h),
                          child: GestureDetector(
                            onTap: () {
                              onTapSignUpText(context);
                            },
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "msg_don_t_have_an_account2".tr,
                                    style:
                                        CustomTextStyles.bodyLargeBluegray400),
                                TextSpan(
                                  text: "lbl_sign_up".tr,
                                  style: CustomTextStyles
                                      .bodyLargeOnPrimaryContainer,
                                )
                              ]),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 62.v),
                      Text("msg_alternatively_login".tr,
                          style: TextStyle(
                              color: appTheme.black900,
                              fontSize: 14.fSize,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400)),
                      SizedBox(height: 22.v),
                      _buildAppleIdandGooglesButton(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildPhoneNumberWithCountry(BuildContext context) {
    const _initialCountryCode = 'ET';
    var _country =
        countries.firstWhere((element) => element.code == _initialCountryCode);
    return Consumer<LoginscreenProvider>(
      builder: (context, provider, child) {
        return IntlPhoneField(
          controller: provider.phoneNumberController,
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
  Widget _buildPassword(BuildContext context) {
    return Consumer<LoginscreenProvider>(
      builder: (context, provider, child) {
        return CustomTextFormField(
            controller: provider.passwordController,
            hintText: "lbl_enter_password".tr,
            hintStyle: TextStyle(color: appTheme.blueGray400),
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.visiblePassword,
            textStyle: TextStyle(color: appTheme.black900),
            onChanged: (p0) => password = p0,
            prefix: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.h, vertical: 13.v),
              child: CustomImageView(
                imagePath: ImageConstant.imgFisslock,
                color: appTheme.blueGray400,
                height: 16.adaptSize,
                width: 16.adaptSize,
              ),
            ),
            prefixConstraints: BoxConstraints(maxHeight: 42.v),
            suffix: InkWell(
              onTap: () {
                provider.changePasswordVisibility();
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(30.h, 13.v, 8.h, 13.v),
                child: provider.isShowPassword
                    ? Icon(Icons.visibility_off_rounded,
                        color: appTheme.blueGray400)
                    : Icon(Icons.visibility, color: appTheme.blueGray400),
              ),
            ),
            suffixConstraints: BoxConstraints(maxHeight: 42.v),
            validator: (value) {
              if (value == null || value == '') {
                return "err_msg_please_enter_valid_password".tr;
              } else {
                return null;
              }
            },
            obscureText: provider.isShowPassword);
      },
    );
  }

  /// Section Widget
  Widget _buildLogin(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (isPhoneValidated) {
          if (_formKey.currentState!.validate()) {
            try {
              if (await NetworkInfo().isConnected()) {
                ProgressDialogUtils.showProgressDialog(
                  context: context,
                  isCancellable: false,
                );
                var res = await ApiAuthHelper.login(
                  password: password!,
                  phoneNumber: phoneNumber!,
                );
                if (res == '') {
                  ProgressDialogUtils.hideProgressDialog();
                  onTapLogin(context);
                  ProgressDialogUtils.showSnackBar(
                    context: context,
                    message: 'You have successfully logged in',
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
                  message:
                      'There is no intranet connection, please check you internet and try again',
                  duration: 2,
                );
              }
            } on NetworkException catch (e) {
              ProgressDialogUtils.showSnackBar(
                context: context,
                message:
                    'No Intranet connection is available, please try again $e',
                duration: 2,
              );
            } catch (e) {
              debugPrint('Error while connecting to the server => $e');
              ProgressDialogUtils.showSnackBar(
                context: context,
                message:
                    'No Intranet connection is available, please try again',
                duration: 2,
              );
            }
          } else {
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
              'lbl_login'.tr,
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

  void showAlertDialog(BuildContext context) {
    var alert = AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFFFFA05B),
          ),
          Container(
            child: const Text(
              'Please wait...',
              style: TextStyle(
                fontFamily: 'Rg',
                color: Color(0xFFFFA05B),
              ),
            ),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildAppleIdandGooglesButton(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 343,
        height: 108,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GestureDetector(
            //   onTap: () {},
            //   child: Container(
            //     width: 343,
            //     height: 50,
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //     clipBehavior: Clip.antiAlias,
            //     decoration: ShapeDecoration(
            //       color: Colors.white,
            //       shape: RoundedRectangleBorder(
            //         side: BorderSide(width: 1, color: Color(0xFFF06400)),
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         CustomImageView(
            //             imagePath: ImageConstant.imgApplePng0,
            //             height: 24.adaptSize,
            //             width: 24.adaptSize),
            //         const SizedBox(width: 8),
            //         Text(
            //           'APPLE ID',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 14,
            //             fontFamily: 'Poppins',
            //             fontWeight: FontWeight.w400,
            //             height: 0,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(height: 8.v),
            GestureDetector(
              onTap: () {
                googleLogin();
              },
              child: Container(
                width: 343,
                height: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFFF06400)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgGooglePng0,
                      height: 24.adaptSize,
                      width: 24.adaptSize,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'GOOGLE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Navigates to the signupscreenScreen when the action is triggered.
  onTapLogin(BuildContext context) {
    NavigatorService.pushNamedAndRemoveUntil(
      AppRoutes.homescreenScreens,
      arguments: {},
    );
  }

  /// Navigates to the categoryscreenoneScreen when the action is triggered.
  onTapContinueButton({
    required BuildContext context,
    required String googleId,
    required String userName,
    required String phoneNumber,
    required String password,
    required String image,
    required String email,
  }) {
    NavigatorService.pushNamed(
      AppRoutes.categoryscreenoneScreen,
      arguments: SignupscreenModel(
        imageFile: image,
        password: password,
        userName: userName,
        phoneNumber: phoneNumber,
        email: email,
        googleId: googleId,
        isFromGoogle: true,
        hasAcar: false,
        selectedservice: [],
      ),
    );
  }

  /// Navigates to the signupscreenScreen when the action is triggered.
  onTapSignUpText(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.signupscreenScreen,
    );
  }

  /// Navigates to the signupscreenScreen when the action is triggered.
  onTapForgotPasswordText(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.forgotpasswordScreen,
    );
  }

  Future<void> googleLogin() async {
    ProgressDialogUtils.showProgressDialog(
      context: context,
      isCancellable: false,
    );

    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

    try {
      // Need to disconnect or cannot login with another account.
      await googleSignIn.disconnect();
    } catch (_) {
      // Ignore disconnect errors.
    }

    try {
      var googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        ProgressDialogUtils.hideProgressDialog();
        ProgressDialogUtils.showSnackBar(
          context: context,
          message: "Something went wrong!",
          duration: 2,
        );
        return;
      }

      var auth = await googleSignInAccount.authentication;
      debugPrint('accessToken => ${auth.accessToken}');
      var res =
          await ApiAuthHelper.googleSignIn(accessToken: auth.accessToken!);
      if (res == 'true') {
        ProgressDialogUtils.hideProgressDialog();
        onTapLogin(context);
        ProgressDialogUtils.showSnackBar(
          context: context,
          message: 'You have successfully logged in',
          duration: 2,
        );
      } else if (res == 'false') {
        ProgressDialogUtils.hideProgressDialog();
        var googleId = PrefUtils.sharedPreferences!.getString('googleId') ?? '';
        var email = PrefUtils.sharedPreferences!.getString('email') ?? '';
        var username = PrefUtils.sharedPreferences!.getString('username') ?? '';
        var picture = PrefUtils.sharedPreferences!.getString('picture') ?? '';
        var password = '';
        onTapContinueButton(
          context: context,
          googleId: googleId,
          userName: username,
          phoneNumber: '',
          email: email,
          password: password,
          image: picture,
        );
      } else {
        ProgressDialogUtils.hideProgressDialog();
      }
    } catch (error, stackTrace) {
      ProgressDialogUtils.hideProgressDialog();
      debugPrint('Error: $error\nStackTrace: $stackTrace');
      ProgressDialogUtils.showSnackBar(
        context: context,
        message: "An error occurred while signing in. Please try again later.",
        duration: 2,
      );
    }
  }

  onTapGoogle(BuildContext context) async {
    await GoogleAuthHelper().googleSignInProcess().then((googleUser) {
      if (googleUser != null) {
        ProgressDialogUtils.showSnackBar(
          context: context,
          message: "This is your Email => ${googleUser.email}",
          duration: 2,
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('user data is empty')));
      }
    }).catchError((onError) {
      debugPrint('Error => ${onError.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(onError.toString()),
        ),
      );
    });
  }
}
