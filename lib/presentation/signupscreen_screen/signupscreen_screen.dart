import 'dart:io';

import 'package:delalochu/core/app_export.dart';
import 'package:delalochu/core/utils/image_tools.dart';
import 'package:delalochu/presentation/signupscreen_screen/models/signupscreen_model.dart';
import 'package:image/image.dart' as img;
import 'package:delalochu/widgets/custom_text_form_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:universal_platform/universal_platform.dart';
import '../../core/utils/progress_dialog_utils.dart';
import 'provider/signupscreen_provider.dart';

class SignupscreenScreen extends StatefulWidget {
  const SignupscreenScreen({Key? key}) : super(key: key);

  @override
  SignupscreenScreenState createState() => SignupscreenScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SignupscreenProvider(),
        child: SignupscreenScreen());
  }
}

// ignore_for_file: must_be_immutable
class SignupscreenScreenState extends State<SignupscreenScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? fileImages;
  String? userName;
  String? phoneNumber;
  String? password;
  String? confirmPassword;
  bool isContinueClicked = false;
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
            children: [
              SizedBox(height: 105.v),
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
                          // height: 90.v,
                          width: 258.h,
                          alignment: Alignment.center,
                        ),
                        SizedBox(height: 17.v),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "msg_create_new_account".tr,
                            style: TextStyle(
                              color: appTheme.blueGray400,
                              fontSize: 24.fSize,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 36.v),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showOption(context);
                                if (fileImages != null) {
                                  setState(() {
                                    isContinueClicked = false;
                                  });
                                }
                              },
                              child: DottedBorder(
                                color: appTheme.blueGray400,
                                padding: EdgeInsets.only(
                                    left: 1.h,
                                    top: 1.v,
                                    right: 1.h,
                                    bottom: 1.v),
                                strokeWidth: 1.h,
                                radius: Radius.circular(35),
                                borderType: BorderType.RRect,
                                dashPattern: [2, 2],
                                child: fileImages == null
                                    ? Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 19.h, vertical: 3.v),
                                        decoration: AppDecoration
                                            .outlineBlueGray
                                            .copyWith(
                                                borderRadius: BorderRadiusStyle
                                                    .circleBorder35),
                                        child: Text(
                                          "lbl".tr,
                                          style: TextStyle(
                                            color: appTheme.blueGray400,
                                            fontSize: 40.fSize,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 70.v,
                                        width: 70.h,
                                        decoration: AppDecoration
                                            .outlineBlueGray
                                            .copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.circleBorder35,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(fileImages!),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.h, top: 15.v, bottom: 13.v),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("lbl_upload".tr,
                                      style: TextStyle(
                                          color: appTheme.blueGray400,
                                          fontSize: 14.fSize,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400)),
                                  Text(
                                    "lbl_profile_photo".tr,
                                    style: TextStyle(
                                      color: appTheme.gray40001,
                                      fontSize: 14.fSize,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        if (fileImages == null && isContinueClicked) ...[
                          SizedBox(height: 18.v),
                          Padding(
                            padding: EdgeInsets.only(left: 3.h),
                            child: Text(
                              'Please upload your profile picture',
                              style: TextStyle(
                                color: appTheme.redA400,
                                fontSize: 14.fSize,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 18.v),
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: Text(
                            "lbl_username".tr,
                            style: TextStyle(
                              color: appTheme.blueGray400,
                              fontSize: 14.fSize,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.v),
                        _buildUserName(context),
                        SizedBox(height: 11.v),
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: Text(
                            "lbl_phone_number2".tr,
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
                        _buildPhoneNumberWithCountry(context),
                        SizedBox(height: 11.v),
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: Text(
                            "lbl_password".tr,
                            style: TextStyle(
                                color: appTheme.blueGray400,
                                fontSize: 14.fSize,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(height: 4.v),
                        _buildPassword(context),
                        SizedBox(height: 12.v),
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: Text(
                            "msg_confirm_password".tr,
                            style: TextStyle(
                              color: appTheme.blueGray400,
                              fontSize: 14.fSize,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.v),
                        _buildConfirmPassword(context),
                        SizedBox(height: 63.v),
                        _buildContinueButton(context)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// show the image picker options
  void _showOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              const EdgeInsets.only(bottom: 150, left: 100, right: 1, top: 20),
          child: Wrap(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _getImageFromGallery();
                },
                child: const Column(
                  children: <Widget>[
                    Icon(
                      Icons.image,
                      size: 60,
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _getImageFromCamera();
                },
                child: const Column(
                  children: <Widget>[
                    Icon(
                      Icons.camera_alt,
                      size: 60,
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// from camera
  Future _getImageFromCamera() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 70,
    );
    if (pickedFile == null) {
      return;
    }

    var image = File(pickedFile.path);

    var path = image.path;
    var imageDecode = img.decodeImage(image.readAsBytesSync());

    path = '${path.substring(0, path.lastIndexOf('.'))}.png';
    await image.rename(path).then((onValue) {
      onValue.writeAsBytesSync(img.encodePng(imageDecode!));
      setState(() {
        fileImages = onValue;
      });
    });
  }

// from gallery
  Future _getImageFromGallery() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 70,
    );
    if (pickedFile == null) {
      return;
    }

    var image = File(pickedFile.path);

    if (UniversalPlatform.isIOS) {
      var path = image.path;
      var imageDecode = img.decodeImage(image.readAsBytesSync());

      path = '${path.substring(0, path.lastIndexOf('.'))}.png';
      await image.rename(path).then((onValue) {
        onValue.writeAsBytesSync(img.encodePng(imageDecode!));
        setState(() {
          fileImages = onValue;
        });
      });
    } else {
      setState(() {
        fileImages = image;
      });
    }
  }

  /// Section Widget
  Widget _buildUserName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.h),
      child: Selector<SignupscreenProvider, TextEditingController?>(
        selector: (context, provider) => provider.userNameController,
        builder: (context, userNameController, child) {
          return CustomTextFormField(
            controller: userNameController,
            hintText: "lbl_e_g_johntheone".tr,
            hintStyle: TextStyle(color: appTheme.blueGray400),
            textStyle: TextStyle(color: appTheme.black900),
            onChanged: (p0) => userName = p0,
            validator: (value) {
              if (value == '') {
                return "please enter your user name";
              }
              return null;
            },
            prefix: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.h, vertical: 13.v),
                child: CustomImageView(
                    imagePath: ImageConstant.imgFissuser,
                    color: appTheme.blueGray400,
                    height: 16.adaptSize,
                    width: 16.adaptSize)),
            prefixConstraints: BoxConstraints(maxHeight: 42.v),
            contentPadding: EdgeInsets.only(
              top: 10.v,
              right: 30.h,
              bottom: 10.v,
            ),
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildPhoneNumberWithCountry(BuildContext context) {
    const _initialCountryCode = 'ET';
    var _country =
        countries.firstWhere((element) => element.code == _initialCountryCode);
    return Consumer<SignupscreenProvider>(
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
    return Padding(
      padding: EdgeInsets.only(left: 3.h),
      child: Consumer<SignupscreenProvider>(
        builder: (context, provider, child) {
          return CustomTextFormField(
            controller: provider.passwordController,
            hintText: "msg_enter_a_password".tr,
            hintStyle: TextStyle(color: appTheme.blueGray400),
            textStyle: TextStyle(color: appTheme.black900),
            textInputType: TextInputType.visiblePassword,
            onChanged: (p0) => password = p0,
            prefix: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.h, vertical: 13.v),
                child: CustomImageView(
                    imagePath: ImageConstant.imgFisslock,
                    color: appTheme.blueGray400,
                    height: 16.adaptSize,
                    width: 16.adaptSize)),
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
              if (value == null) {
                return "err_msg_please_enter_valid_password".tr;
              } else if (value.length < 8) {
                return "Passwords must be at least 8 characters";
              }
              return null;
            },
            obscureText: provider.isShowPassword,
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildConfirmPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.h),
      child: Consumer<SignupscreenProvider>(
        builder: (context, provider, child) {
          return CustomTextFormField(
              controller: provider.confirmPasswordController,
              hintText: "msg_confirm_password".tr,
              hintStyle: TextStyle(color: appTheme.blueGray400),
              textStyle: TextStyle(color: appTheme.black900),
              textInputType: TextInputType.visiblePassword,
              onChanged: (p0) => confirmPassword = p0,
              prefix: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.h, vertical: 13.v),
                  child: CustomImageView(
                      imagePath: ImageConstant.imgFisslock,
                      color: appTheme.blueGray400,
                      height: 16.adaptSize,
                      width: 16.adaptSize)),
              prefixConstraints: BoxConstraints(maxHeight: 42.v),
              suffix: InkWell(
                onTap: () {
                  provider.changeconfirmPasswordVisibility();
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(30.h, 13.v, 8.h, 13.v),
                  child: provider.isShowconfirmPassword
                      ? Icon(Icons.visibility_off_rounded,
                          color: appTheme.blueGray400)
                      : Icon(Icons.visibility, color: appTheme.blueGray400),
                ),
              ),
              suffixConstraints: BoxConstraints(maxHeight: 42.v),
              validator: (value) {
                if (value == null) {
                  return "err_msg_please_enter_valid_password".tr;
                } else if (value.length < 8) {
                  return "Passwords must be at least 8 characters";
                } else if (confirmPassword != password) {
                  return "Password doesn't match";
                }
                return null;
              },
              obscureText: provider.isShowconfirmPassword);
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildContinueButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate() && fileImages != null) {
          if (isPhoneValidated) {
            setState(() {
              isContinueClicked = false;
            });
            onTapContinueButton(
              context,
              userName!,
              phoneNumber!,
              password!,
              fileImages!,
            );
          } else {
            ProgressDialogUtils.showSnackBar(
              context: context,
              message: 'Please enter your phone number',
              duration: 2,
            );
            return null;
          }
        } else {
          setState(() {
            isContinueClicked = true;
          });
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
              "lbl_continue".tr,
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
  onTapContinueButton(
    BuildContext context,
    String userName,
    String phoneNumber,
    String password,
    File image,
  ) {
    print(phoneNumber);
    final convertedbase64Encode = ImageTools.convertImagesToBase64(image);
    NavigatorService.pushNamed(
      AppRoutes.categoryscreenoneScreen,
      arguments: SignupscreenModel(
        imageFile: convertedbase64Encode,
        password: password,
        userName: userName,
        phoneNumber: phoneNumber,
        email: '',
        googleId: '',
        isFromGoogle: false,
        selectedservice: [],
        hasAcar: false,
      ),
    );
  }
}
