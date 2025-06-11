// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delalochu/domain/apiauthhelpers/apiauth.dart';
import 'package:delalochu/presentation/signupscreen_screen/models/signupscreen_model.dart';
import 'package:flutter/material.dart';

import 'package:delalochu/core/app_export.dart';
import 'package:delalochu/widgets/custom_elevated_button.dart';
import 'package:delalochu/widgets/custom_text_form_field.dart';

import '../../core/utils/progress_dialog_utils.dart';
import '../../data/models/servicesModel/getServicesList.dart';
import '../forgotPassword/forgotpassword_screen.dart';
import '../forgotPassword/provider/forgotpassword_provider.dart';
import 'provider/categoryscreenone_provider.dart';

class CategoryscreenoneScreen extends StatefulWidget {
  const CategoryscreenoneScreen({
    Key? key,
  }) : super(key: key);

  @override
  CategoryscreenoneScreenState createState() => CategoryscreenoneScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CategoryscreenoneProvider(),
        child: CategoryscreenoneScreen());
  }

  static SignupscreenModel getArguments(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route != null) {
      return route.settings.arguments as SignupscreenModel;
    }
    throw Exception("Arguments not found");
  }
}

class CategoryscreenoneScreenState extends State<CategoryscreenoneScreen> {
  bool iscarsaleclick = false;
  bool iscarrentclick = false;
  bool isHousesaleclick = false;
  bool isHouserentclick = false;
  bool isRealestateclick = false;
  bool ishousemaidclick = false;
  bool isSkilledWorkerclick = false;
  bool isUsedItemsclick = false;
  List<Service>? serviceList;
  List<dynamic> selectedservice = [];
  List<dynamic> listotherservice = [];
  TextEditingController typeAnythingController = TextEditingController();

  String searchtext = '';
  String? phoneNumber;

  bool ihaveACar = false;
// Use the serviceList as needed

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((value) async {
      serviceList = await ApiAuthHelper.getservice();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final SignupscreenModel signupModel =
        CategoryscreenoneScreen.getArguments(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.only(left: 10),
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_outlined,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Select your Services",
          style: TextStyle(
            color: appTheme.black900,
            fontSize: 24.fSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: 5.v),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 12.v),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 36.h, right: 36.h, bottom: 5.v),
                  child: Column(
                    children: [
                      // SizedBox(height: 14.v),
                      _buildSearchWidget(context),
                      SizedBox(height: 14.v),
                      if (serviceList != [] &&
                          serviceList != null &&
                          serviceList!.isNotEmpty &&
                          serviceList!.length > 0) ...[
                        GridView.builder(
                          itemCount: serviceList!
                              .where(
                                (item) =>
                                    searchtext.isEmpty ||
                                    item.name
                                        .toString()
                                        .trim()
                                        .toLowerCase()
                                        .contains(searchtext.toLowerCase()),
                              )
                              .length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 80,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            final filteredItems = serviceList!.where(
                              (item) =>
                                  searchtext.isEmpty ||
                                  item.name
                                      .toString()
                                      .trim()
                                      .toLowerCase()
                                      .contains(searchtext.toLowerCase()),
                            );
                            final item = filteredItems.elementAt(index);
                            return CustomElevatedButton(
                              text: item.name ?? '',
                              buttonStyle:
                                  selectedservice.contains('${item.id!}') ==
                                          true
                                      ? CustomButtonStyles.outlineBlackTL5
                                      : CustomButtonStyles.none,
                              onPressed: () {
                                setState(() {
                                  if (!selectedservice
                                      .contains('${item.id!}')) {
                                    selectedservice.add('${item.id!}');
                                  } else {
                                    selectedservice.remove('${item.id!}');
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ] else ...[
                        Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      ],
                      if (signupModel.isFromGoogle) ...[
                        SizedBox(height: 14.v),
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
                        ForgotPasswordScreenState()
                            .buildPhoneNumberWithCountry(context),
                      ],
                      SizedBox(height: 15.v),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Do you have a car ?',
                                style: TextStyle(
                                  color: appTheme.black900,
                                  fontSize: 15.fSize,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(width: 10),
                              CustomImageView(
                                imagePath: ImageConstant.car,
                                height: 14.adaptSize,
                                width: 19.adaptSize,
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 20,
                                child: Checkbox(
                                  value: ihaveACar,
                                  activeColor: Color(0xFFFFA05B),
                                  onChanged: (value) {
                                    setState(() {
                                      ihaveACar = value!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 15),
                              Text(
                                'Yes, I have.',
                                style: TextStyle(
                                  color: appTheme.black900,
                                  fontSize: 15.fSize,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildContinueButton(context),
            SizedBox(height: 14.v),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildSearchWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: EdgeInsets.only(left: 10.h),
        //   child: Text(
        //     "Search",
        //     style: TextStyle(
        //       color: appTheme.black900,
        //       fontSize: 15.fSize,
        //       fontFamily: 'Poppins',
        //       fontWeight: FontWeight.w300,
        //     ),
        //   ),
        // ),
        // if (listotherservice.isNotEmpty && otherService != '') ...[
        //   _buildOtherService(context),
        // ],
        SizedBox(height: 14.v),
        Selector<CategoryscreenoneProvider, TextEditingController?>(
          selector: (context, provider) => provider.typeAnythingController,
          builder: (context, typeAnythingController, child) {
            this.typeAnythingController = typeAnythingController!;
            return CustomTextFormField(
              controller: this.typeAnythingController,
              hintText: "Search".tr,
              onChanged: (p0) {
                setState(() {
                  searchtext = p0;
                });
              },
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
            );
          },
        ),
        SizedBox(height: 14.v),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: ElevatedButton(
        //     onPressed: () {
        //       if (otherService != '') {
        //         setState(() {
        //           listotherservice.add(otherService);
        //           this.typeAnythingController.clear();
        //         });
        //       }
        //     },
        //     child: Container(
        //         width: 53,
        //         height: 50,
        //         clipBehavior: Clip.antiAlias,
        //         decoration: ShapeDecoration(
        //           gradient: LinearGradient(
        //             begin: Alignment(0.79, 0.61),
        //             end: Alignment(-0.79, -0.61),
        //             colors: [Color(0xFFF06400), Color(0xFFFFA05B)],
        //           ),
        //           shape: RoundedRectangleBorder(
        //             side: BorderSide(width: 0.50, color: Colors.white),
        //             borderRadius: BorderRadius.circular(8),
        //           ),
        //         ),
        //         child: Icon(
        //           Icons.add,
        //           color: Colors.white,
        //         )),
        //   ),
        // ),
      ],
    );
  }

  /// Section Widget
  Widget _buildContinueButton(BuildContext context) {
    final SignupscreenModel signupModel =
        CategoryscreenoneScreen.getArguments(context);
    return Padding(
      padding: EdgeInsets.only(left: 1.h, right: 1.h, top: 22.v, bottom: 22.v),
      child:
          Consumer<ForgotPasswordProvider>(builder: (context, provider, child) {
        return ElevatedButton(
          onPressed: () async {
            if (selectedservice.isNotEmpty) {
              if (signupModel.isFromGoogle == true) {
                setState(() {
                  if (listotherservice != []) {
                    for (var i = 0; i < listotherservice.length; i++) {
                      selectedservice.add(listotherservice[i]);
                    }
                  }
                });
                NavigatorService.pushNamed(
                  AppRoutes.addAddressScreen,
                  arguments: SignupscreenModel(
                      imageFile: signupModel.imageFile,
                      password: signupModel.password,
                      userName: signupModel.userName,
                      phoneNumber: signupModel.phoneNumber,
                      email: '',
                      googleId: '',
                      isFromGoogle: false,
                      hasAcar: ihaveACar,
                      selectedservice: selectedservice),
                );
              } else {
                setState(() {
                  if (listotherservice != []) {
                    for (var i = 0; i < listotherservice.length; i++) {
                      selectedservice.add(listotherservice[i]);
                    }
                  }
                });
                NavigatorService.pushNamed(
                  AppRoutes.addAddressScreen,
                  arguments: SignupscreenModel(
                    imageFile: signupModel.imageFile,
                    password: signupModel.password,
                    userName: signupModel.userName,
                    phoneNumber: signupModel.phoneNumber,
                    email: '',
                    googleId: '',
                    isFromGoogle: false,
                    hasAcar: ihaveACar,
                    selectedservice: selectedservice,
                  ),
                );
              }
            } else {
              ProgressDialogUtils.showSnackBar(
                context: context,
                message: 'Please select at least one service!',
                duration: 2,
              );
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
    );
  }

  /// Navigates to the homescreenScreen when the action is triggered.
  onTapContinueButton(BuildContext context) {
    NavigatorService.pushNamedAndRemoveUntil(
      AppRoutes.homescreenScreens,
      arguments: {},
    );
  }
}
