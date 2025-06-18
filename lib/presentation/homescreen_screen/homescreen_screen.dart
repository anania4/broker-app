import 'dart:convert';

import 'package:delalochu/core/app_export.dart';
import 'package:delalochu/data/models/userModel/userModel.dart';
import 'package:delalochu/domain/apiauthhelpers/apiauth.dart';
import 'package:delalochu/localization/lang_provider.dart';
import 'package:delalochu/widgets/app_bar/appbar_leading_image.dart';
import 'package:delalochu/widgets/app_bar/appbar_subtitle.dart';
import 'package:delalochu/widgets/app_bar/appbar_trailing_switch.dart';
import 'package:delalochu/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/progress_dialog_utils.dart';
import '../../widgets/custom_dialog.dart';
import 'models/requestcheckModel.dart';
import 'provider/homescreen_provider.dart';
// import 'package:location/location.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

enum PermissionGroup {
  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - Always
  locationAlways,

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - WhenInUse
  locationWhenInUse
}

class HomescreenScreen extends StatefulWidget {
  const HomescreenScreen({Key? key}) : super(key: key);

  @override
  HomescreenScreenState createState() => HomescreenScreenState();

  static Widget builder(BuildContext context) {
    return HomescreenScreen();
  }

  static Map<String, dynamic> getArguments(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route != null) {
      return route.settings.arguments as Map<String, dynamic>;
    } else {
      return {};
    }
  }
}

class HomescreenScreenState extends State<HomescreenScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String isRequested = '0';
  bool isloading = false;
  Broker brokerData = Broker();
  HomescreenProvider? homeProvider;

  // bool isApproved = false;
  // bool isonline = false;
  DateTime expiredatebroker = DateTime.now();
  late StreamController<CheckForCustomerRequestModel> _requestStreamController;
  late StreamController<CheckForCustomerRequestModel>
      _checkrequestStreamController;
  late Timer _timer;
  late Timer _locationTracktimer;
  late Timer _checkrequesttimer;
  int daysDifference = 0;

  bool isAccepted = false;
  int? connectionId;

  CheckForCustomerRequestModel firstItem = CheckForCustomerRequestModel();
  // Future<LocationData> getCurrentLocation() async {
  //   Location location = Location();
  //   return await location.getLocation();
  // }

  getBrokerData() async {
    await homeProvider!.loadingData(true);
    await homeProvider!.getBroker();
    // isonline = homeProvider!.brokerData.broker!.avilableForWork ?? false;
    // isApproved = homeProvider!.brokerData.broker!.approved ?? false;
    expiredatebroker =
        homeProvider!.brokerData.broker!.serviceExprireDate ?? DateTime.now();
    DateTime today = DateTime.now();
    DateTime specificDate = expiredatebroker;
    Duration difference = specificDate.difference(today);
    setState(() {
      daysDifference = difference.inDays;
      if (daysDifference == 0) {
        daysDifference = 1;
      }
    });
  }

  Future<void> requestLocationPermission() async {
    // startLocationTracking();
  }

  callUpdateStatus() async {
    if (await NetworkInfo().isConnected()) {
      if (homeProvider!.isOnline) {
        await homeProvider!.changeSwitchBox1(true);
      }
    }
  }

  Future<void> _fetchUserRequests() async {
    try {
      debugPrint('=======> waiting for user requests');
      var token = PrefUtils.sharedPreferences!.getString('token') ?? '';
      var headers = {'x-auth-token': token};
      var request = http.Request(
          'GET', Uri.parse('${ApiAuthHelper.domain}/api/broker/request'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        if (jsonResponse['connectionRequests'] != null) {
          CheckForCustomerRequestModel res =
              CheckForCustomerRequestModel.fromJson(jsonResponse);
          _requestStreamController.add(res);
        } else {
          _requestStreamController.addError('');
        }
      } else {
        _requestStreamController.addError('');
      }
    } catch (e, s) {
      debugPrint(' _fetchUserRequests Error: $e StackTres => $s');
      return;
    }
  }

  Future<void> _checkUserRequests() async {
    try {
      debugPrint(
          '=================================> _checkUserRequests() checking for customer');
      var token = PrefUtils.sharedPreferences!.getString('token') ?? '';
      var headers = {'x-auth-token': token};
      var request = http.Request(
          'GET',
          Uri.parse(
              '${ApiAuthHelper.domain}/api/broker/request/$connectionId'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        if (jsonResponse['connectionRequests'] != null) {
          CheckForCustomerRequestModel res =
              CheckForCustomerRequestModel.fromJson(jsonResponse);
          _checkrequestStreamController.add(res);
        } else {
          _checkrequestStreamController.addError('');
        }
      } else {
        _checkrequestStreamController.addError('');
      }
    } catch (e, s) {
      debugPrint(' _fetchUserRequests Error: $e StackTres => $s');
      return;
    }
  }

  // void startLocationTracking() async {
  //   if (await Permission.location.isGranted == true) {
  //     if (context.read<HomescreenProvider>().isOnline) {
  //       getCurrentLocation().then((locationData) async {
  //         if ((homeProvider!.brokerData.broker != null
  //             ? (homeProvider!.brokerData.broker!.avilableForWork != null &&
  //                 homeProvider!.brokerData.broker!.avilableForWork!)
  //             : false)) {
  //           // ProgressDialogUtils.showSnackBar(
  //           //   context: context,
  //           //   message:
  //           //       'My current location => ${locationData.latitude.toString()}, ${locationData.longitude.toString()}',
  //           //   duration: 2,
  //           // );
  //           debugPrint(
  //               '================================================================================================');
  //           debugPrint(
  //               'My current location => ${locationData.latitude.toString()}, ${locationData.longitude.toString()}');
  //           debugPrint(
  //               '================================================================================================');
  //           await homeProvider!.updateLocation(
  //             latitude: locationData.latitude.toString(),
  //             longtude: locationData.longitude.toString(),
  //           );
  //         }
  //       }).catchError((e) {
  //         debugPrint('Error getting location: $e');
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _requestStreamController =
        StreamController<CheckForCustomerRequestModel>.broadcast();
    _checkrequestStreamController =
        StreamController<CheckForCustomerRequestModel>.broadcast();
    homeProvider = Provider.of<HomescreenProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getBrokerData();
      callUpdateStatus();
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (await NetworkInfo().isConnected()) {
        _fetchUserRequests();
      }
    });
    _locationTracktimer = Timer.periodic(Duration(minutes: 30), (timer) async {
      if (await NetworkInfo().isConnected()) {
        requestLocationPermission();
      }
    });
  }

  @override
  void dispose() {
    _requestStreamController.close();
    _checkrequestStreamController.close();
    _timer.cancel();
    _locationTracktimer.cancel();
    _checkrequesttimer.cancel();
    super.dispose();
  }

  Future<void> onRefresh() async {
    await getBrokerData();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context),
      drawer: drawer(),
      body: UpgradeAlert(
        upgrader: Upgrader(dialogStyle: UpgradeDialogStyle.cupertino),
        child: Consumer<HomescreenProvider>(
          builder: (_, model, __) => SmartRefresher(
            controller: _refreshController,
            onRefresh: _checkApprovalStatus,
            child: Container(
              width: SizeUtils.width,
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  _buildBody(context, model),
                  if (model.brokerData.broker != null
                      ? (model.brokerData.broker!.approved != null &&
                          !model.brokerData.broker!.approved!)
                      : false) ...[
                    SizedBox(height: 40),
                    Text(
                      "lbl_waiting_for_approval".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: isAccepted
          ? StreamBuilder<CheckForCustomerRequestModel>(
              stream: _checkrequestStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.connectionRequests != null &&
                    snapshot.data!.connectionRequests!.status == "ACCEPTED" &&
                    snapshot.data!.connectionRequests!.userHasCalled == true) {
                  firstItem = snapshot.data!;
                  return SizedBox();
                } else if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.connectionRequests != null &&
                    snapshot.data!.connectionRequests!.status == "ACCEPTED" &&
                    snapshot.data!.connectionRequests!.userHasCalled == false) {
                  firstItem = snapshot.data!;
                  return _buildBrokerResponse(context, firstItem);
                } else if (snapshot.hasError) {
                  return SizedBox();
                } else {
                  return SizedBox();
                }
              },
            )
          : StreamBuilder<CheckForCustomerRequestModel>(
              stream: _requestStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.connectionRequests != null &&
                    snapshot.data!.connectionRequests!.status == "REQUESTED") {
                  firstItem = snapshot.data!;
                  return _buildCustomerRequest(context, firstItem);
                } else if (snapshot.hasError) {
                  return SizedBox();
                } else {
                  return SizedBox();
                }
              },
            ),
    );
  }

  var titleList = [
    'lbl_home'.tr,
    'lbl_profile'.tr,
    'lbl_history'.tr,
    'lbl_rate_app'.tr,
    'lbl_language'.tr,
    'lbl_logout'.tr,
  ];

  var iconList = [
    Icons.home,
    Icons.person,
    Icons.history,
    Icons.star,
    Icons.language,
    Icons.logout,
  ];
  Future<void> _checkApprovalStatus() async {
    var homePageProvider =
        Provider.of<HomescreenProvider>(context, listen: false);
    // Call API to check approval status
    await homePageProvider.getBroker();
    if (homePageProvider.loading) {
    } else {
      _refreshController.refreshCompleted();
    }
  }

  /// drawer widget
  Drawer drawer() {
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 42.h, vertical: 73.v),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 1.v,
                    ),
                    child: Text(
                      "lbl_menu".tr,
                      style: TextStyle(
                        color: appTheme.gray500,
                        fontSize: 20.fSize,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgFiSsArrowSmallLeft,
                    height: 32.adaptSize,
                    width: 32.adaptSize,
                    margin: EdgeInsets.only(
                      right: 10.h,
                    ),
                    onTap: _closeDrawer,
                  )
                ],
              ),
              const SizedBox(height: 46),
              for (int i = 0; i < 6; i++) ...[
                GestureDetector(
                  onTap: () {
                    switch (i) {
                      case 0:
                        Navigator.of(context).pop();
                        break;
                      case 1:
                        NavigatorService.pushNamed(
                            AppRoutes.profilescreenScreen);
                        break;
                      case 2:
                        NavigatorService.pushNamed(
                            AppRoutes.historyscreenScreen);
                        break;
                      case 3:
                        _rateApp();
                        break;
                      case 4:
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                  title: Text('lbl_select_language'.tr),
                                  children: <Widget>[
                                    SimpleDialogOption(
                                      onPressed: () {
                                        setState(() {
                                          Locale newLocale = Locale("en", '');
                                          languageProvider
                                              .changeLanguage(newLocale);
                                          Navigator.pop(context);
                                        });

                                        NavigatorService
                                            .pushNamedAndRemoveUntil(
                                                AppRoutes.splashscreenScreen);
                                      },
                                      child: Text('English'),
                                    ),
                                    SimpleDialogOption(
                                      onPressed: () {
                                        setState(() {
                                          Locale newLocale = Locale("am", '');
                                          languageProvider
                                              .changeLanguage(newLocale);
                                          Navigator.pop(context);
                                        });
                                        // Perform action when Amharic is selected
                                        //  Navigator.pop(context, 'Amharic');
                                        // Navigator.pop(context);
                                        NavigatorService
                                            .pushNamedAndRemoveUntil(
                                                AppRoutes.splashscreenScreen);
                                      },
                                      child: Text('አማርኛ'),
                                    ),
                                    SimpleDialogOption(
                                      onPressed: () {
                                        setState(() {
                                          Locale newLocale = Locale("da", '');
                                          languageProvider
                                              .changeLanguage(newLocale);
                                          Navigator.pop(context);
                                        });
                                        // Perform action when Afaan Oromo is selected
                                        // Navigator.pop(context, 'Afaan Oromoo');
                                        //  Navigator.pop(context);
                                        NavigatorService
                                            .pushNamedAndRemoveUntil(
                                                AppRoutes.splashscreenScreen);
                                      },
                                      child: Text('Afaan Oromoo'),
                                    ),
                                  ]);
                            });
                        break;
                      case 5:
                        PrefUtils.sharedPreferences!
                            .setBool('isLoggedIn', false);
                        NavigatorService.pushNamedAndRemoveUntil(
                            AppRoutes.loginscreenScreen);
                        break;
                      default:
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        iconList[i],
                        color: i == 5 ? Colors.red : Color(0xFFFFA05B),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Flex(direction: Axis.horizontal, children: [
                          Text(
                            titleList[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: i == 5 ? Colors.red : Colors.black,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  width: 307,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0x66505862),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _rateApp() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.delalayebrokers.app';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawer() {
    Navigator.pop(context); // Close the drawer
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 58.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgCharmMenuHamburger,
        margin: EdgeInsets.only(left: 25.h, top: 11.v, bottom: 11.v),
        onTap: _openDrawer,
      ),
      title: Text(
        "lbl_delalaye".tr,
        style: TextStyle(
          color: appTheme.orangeA200,
          fontSize: 25.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      actions: [
        Consumer<HomescreenProvider>(
          builder: (context, value, child) => AppbarSubtitle(
            text: value.isOnline ? "lbl_online".tr : "Offline",
            margin: EdgeInsets.only(
              left: 19.h,
              top: 20.v,
              right: 13.h,
            ),
          ),
        ),
        Consumer<HomescreenProvider>(
          builder: (context, value, child) => AppbarTrailingSwitch(
            value: value.isOnline,
            margin: EdgeInsets.only(
              right: 25.h,
            ),
            onTap: (value) async {
              if (await NetworkInfo().isConnected()) {
                await homeProvider!.changeSwitchBox1(value);
              }
            },
          ),
        )
      ],
    );
  }

  /// Section Widget
  Widget _buildBody(BuildContext context, HomescreenProvider model) {
    return Container(
      margin: EdgeInsets.only(left: 25.h, right: 25.h, bottom: 5.v),
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 18.v),
      decoration: (model.brokerData.broker != null
              ? (model.brokerData.broker!.approved != null &&
                  !model.brokerData.broker!.approved!)
              : false)
          ? AppDecoration.grey500
              .copyWith(borderRadius: BorderRadiusStyle.roundedBorder15)
          : int.parse(daysDifference.toString()) < 0
              ? AppDecoration.grey500
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder15)
              : AppDecoration.fillOrangeA
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.brokerData.broker != null
                          ? model.brokerData.broker!.topup!.isNotEmpty
                              ? "lbl_remaining_days".tr
                              : "lbl_you_have_trial_days".tr
                          : "lbl_remaining_days".tr,
                      style: TextStyle(
                        color: appTheme.whiteA700,
                        fontSize: 20.fSize,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4.v),
                    Text(
                      '${int.parse(daysDifference.toString()) < 0 ? '0' : daysDifference.toString()}',
                      style: TextStyle(
                        color: appTheme.whiteA700,
                        fontSize: 32.fSize,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: (model.brokerData.broker != null
                          ? (model.brokerData.broker!.approved != null &&
                              !(model.brokerData.broker!.approved)!)
                          : false)
                      ? () {
                          print('here is clicked 2');
                        }
                      : () {
                          Navigator.push(
                            context,
                            CupertinoDialogRoute(
                              context: context,
                              builder: (context) => CustomDialog(
                                amount: '',
                                color: appTheme.orangeA200,
                                buttonLable: 'lbl_continue'.tr,
                                icon: Icons.done_all_rounded,
                                message: '',
                                onClick: () async {
                                  Navigator.pop(context);
                                },
                                title: 'lbl_please_select_package'.tr,
                              ),
                            ),
                          );
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 0, top: 4, bottom: 4),
                        child: Icon(
                          Icons.add,
                          size: 25,
                          color: (model.brokerData.broker != null
                                  ? (model.brokerData.broker!.approved !=
                                          null &&
                                      !model.brokerData.broker!.approved!)
                                  : false)
                              ? appTheme.gray500
                              : appTheme.orangeA200,
                          opticalSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 2,
                          right: 8,
                          top: 4,
                          bottom: 4,
                        ),
                        child: Text(
                          'lbl_top_up'.tr,
                          style: TextStyle(
                            color: (model.brokerData.broker != null
                                    ? (model.brokerData.broker!.approved !=
                                            null &&
                                        !model.brokerData.broker!.approved!)
                                    : false)
                                ? appTheme.gray500
                                : appTheme.orangeA200,
                            fontSize: 14.fSize,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.v),
          Divider(indent: 12.h),
          SizedBox(height: 15.v),
          Padding(
            padding: EdgeInsets.only(left: 11.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4.v),
                  child: Column(
                    children: [
                      (model.brokerData.broker != null
                              ? (model.brokerData.broker!.approved != null &&
                                  !model.brokerData.broker!.approved!)
                              : false)
                          ? Text(
                              "lbl_recently_topup".tr,
                              style: TextStyle(
                                color: appTheme.whiteA700,
                                fontSize: 14.fSize,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Text(
                              'lbl_recently_topup'.tr,
                              style: TextStyle(
                                color: appTheme.whiteA700,
                                fontSize: 14.fSize,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      SizedBox(height: 10.v),
                      (model.brokerData.broker != null
                              ? (model.brokerData.broker!.approved != null &&
                                  !model.brokerData.broker!.approved!)
                              : false)
                          ? SizedBox()
                          : Text(
                              '${model.brokerData.broker != null ? model.brokerData.broker!.topup!.length >= 1 && model.brokerData.broker!.topup != [] && model.brokerData.broker!.topup![0].package != null ? model.brokerData.broker!.topup![0].package!.name : '' : ''}',
                              style: TextStyle(
                                color: appTheme.whiteA700,
                                fontSize: 16.fSize,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 4.v),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "lbl_created_date".tr,
                          style: TextStyle(
                            color: appTheme.whiteA700,
                            fontSize: 14.fSize,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.v),
                      (model.brokerData.broker != null
                              ? (model.brokerData.broker!.approved != null &&
                                  !model.brokerData.broker!.approved!)
                              : false)
                          ? SizedBox()
                          : Text(
                              '${model.brokerData.broker != null ? model.brokerData.broker!.topup!.length >= 1 && model.brokerData.broker!.topup != [] ? "${model.brokerData.broker!.topup![0].createdAt!.year}- ${model.brokerData.broker!.topup![0].createdAt!.month}- ${model.brokerData.broker!.topup![0].createdAt!.day}" : '' : ''}',
                              style: TextStyle(
                                color: appTheme.whiteA700,
                                fontSize: 16.fSize,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 2.v)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCustomerRequest(
      BuildContext context, CheckForCustomerRequestModel firstItem) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 25.v),
      decoration: AppDecoration.outlineOrangeA
          .copyWith(borderRadius: BorderRadiusStyle.customBorderTL25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 3.h),
            child: Text(
              "lbl_customer_name".tr,
              style: TextStyle(
                color: appTheme.whiteA700,
                fontSize: 16.fSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 11.v),
          Padding(
            padding: EdgeInsets.only(left: 3.h),
            child: Text(
              firstItem.connectionRequests != null &&
                      firstItem.connectionRequests!.user != null
                  ? firstItem.connectionRequests!.user!.fullName ?? ''
                  : '',
              style: TextStyle(
                color: appTheme.whiteA700,
                fontSize: 24.fSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 20.v),
          Text("lbl_looking_for".tr,
              style: TextStyle(
                  color: appTheme.whiteA700,
                  fontSize: 16.fSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 4.v),
          Text(
              firstItem.connectionRequests != null &&
                      firstItem.connectionRequests!.service != null
                  ? firstItem.connectionRequests!.service!.name ?? ''
                  : '',
              style: TextStyle(
                  color: appTheme.whiteA700,
                  fontSize: 24.fSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400)),
          SizedBox(height: 20.v),
          Text(
            "lbl_location".tr,
            style: TextStyle(
              color: appTheme.whiteA700,
              fontSize: 16.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.v),
          Text(
            firstItem.connectionRequests != null &&
                    firstItem.connectionRequests!.locationName != null
                ? firstItem.connectionRequests!.locationName ?? ''
                : '',
            style: TextStyle(
              color: appTheme.whiteA700,
              fontSize: 24.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 31.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // here you need to set the accepted api
                    if (firstItem.connectionRequests != null) {
                      ProgressDialogUtils.showProgressDialog(
                        context: context,
                        isCancellable: false,
                      );
                      var respo = await ApiAuthHelper.acceptORpassuserRequest(
                        cennectionId: firstItem.connectionRequests!.id,
                        status: 'accepted',
                      );
                      if (respo) {
                        ProgressDialogUtils.hideProgressDialog();
                        setState(() {
                          isAccepted = true;
                          connectionId = firstItem.connectionRequests!.id;
                        });
                        if (connectionId != null) {
                          _checkrequesttimer =
                              Timer.periodic(Duration(seconds: 3), (timer) {
                            _checkUserRequests();
                          });
                        } else {
                          debugPrint('Connection is no value for connection');
                        }
                      } else {
                        ProgressDialogUtils.hideProgressDialog();
                        ProgressDialogUtils.showSnackBar(
                          context: context,
                          message: 'msg_something_went_wrong'.tr,
                          duration: 3,
                        );
                      }
                    }
                  },
                  child: Container(
                    height: 50.v,
                    padding: const EdgeInsets.only(
                        // top: 13,
                        // left: 58.50,
                        // right: 57.50,
                        // bottom: 13,
                        ),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'lbl_accept'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFE9A3C),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 24.h,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if (firstItem.connectionRequests != null) {
                      ProgressDialogUtils.showProgressDialog(
                        context: context,
                        isCancellable: false,
                      );
                      var respo = await ApiAuthHelper.acceptORpassuserRequest(
                        cennectionId: firstItem.connectionRequests!.id,
                        status: 'pass',
                      );
                      if (respo) {
                        ProgressDialogUtils.hideProgressDialog();
                        // getBrokerData();
                      } else {
                        ProgressDialogUtils.hideProgressDialog();
                        ProgressDialogUtils.showSnackBar(
                          context: context,
                          message: 'msg_something_went_wrong'.tr,
                          duration: 3,
                        );
                      }
                    }
                  },
                  child: Container(
                    height: 50.v,
                    padding: const EdgeInsets.only(),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Color(0xFF7B3D02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'lbl_pass'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 27.v)
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildBrokerResponse(
      BuildContext context, CheckForCustomerRequestModel firstItem) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 25.v),
      decoration: AppDecoration.outlineOrangeA
          .copyWith(borderRadius: BorderRadiusStyle.customBorderTL25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 3.h),
            child: Text(
              "lbl_customer_name".tr,
              style: TextStyle(
                color: appTheme.whiteA700,
                fontSize: 16.fSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 11.v),
          Padding(
            padding: EdgeInsets.only(left: 3.h),
            child: Text(
              firstItem.connectionRequests != null &&
                      firstItem.connectionRequests!.user != null
                  ? firstItem.connectionRequests!.user!.fullName ?? ''
                  : '',
              style: TextStyle(
                color: appTheme.whiteA700,
                fontSize: 24.fSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 20.v),
          Text("lbl_looking_for".tr,
              style: TextStyle(
                  color: appTheme.whiteA700,
                  fontSize: 16.fSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 4.v),
          Text(
              firstItem.connectionRequests != null &&
                      firstItem.connectionRequests!.service != null
                  ? firstItem.connectionRequests!.service!.name ?? ''
                  : '',
              style: TextStyle(
                  color: appTheme.whiteA700,
                  fontSize: 24.fSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400)),
          SizedBox(height: 20.v),
          Text(
            "lbl_location".tr,
            style: TextStyle(
              color: appTheme.whiteA700,
              fontSize: 16.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.v),
          Text(
            firstItem.connectionRequests != null &&
                    firstItem.connectionRequests!.locationName != null
                ? firstItem.connectionRequests!.locationName ?? ''
                : '',
            style: TextStyle(
              color: appTheme.whiteA700,
              fontSize: 24.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 31.v),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 25.76,
                child: Text(
                  'msg_customer_will_call'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: 17.v),
              GestureDetector(
                onTap: () async {
                  if (firstItem.connectionRequests != null) {
                    ProgressDialogUtils.showProgressDialog(
                      context: context,
                      isCancellable: false,
                    );
                    var respo = await ApiAuthHelper.canceluserRequest(
                      cennectionId: firstItem.connectionRequests!.id,
                      status: 'pass',
                    );
                    if (respo) {
                      ProgressDialogUtils.hideProgressDialog();
                      setState(() {
                        isAccepted = false;
                        _checkrequesttimer.cancel();
                      });
                      ProgressDialogUtils.showSnackBar(
                        context: context,
                        message: 'You have Cancelled the customer request!',
                        duration: 3,
                      );
                    } else {
                      ProgressDialogUtils.hideProgressDialog();
                      ProgressDialogUtils.showSnackBar(
                        context: context,
                        message: 'msg_something_went_wrong'.tr,
                        duration: 3,
                      );
                    }
                  }
                },
                child: Container(
                  height: 50.v,
                  padding: const EdgeInsets.only(
                    left: 58.50,
                    right: 57.50,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'lbl_cancel'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFE9A3C),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.v)
        ],
      ),
    );
  }

  /// Navigates to the homescreenwithbottomshitoneScreen when the action is triggered.
  onTapScrollView(BuildContext context) {
    setState(() {
      isRequested = '1';
    });
  }
}

class Showdialog extends StatefulWidget {
  @override
  State<Showdialog> createState() => _ShowdialogState();
}

class _ShowdialogState extends State<Showdialog> {
  @override
  Widget build(BuildContext context) {
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return SimpleDialog(
        title: Text('lbl_select_language'.tr),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              setState(() {
                Locale newLocale = Locale("en", '');
                languageProvider.changeLanguage(newLocale);
              });
              // Perform action when English is selected
              Navigator.pop(context, 'English');
              Navigator.pop(context);
            },
            child: Text('English'),
          ),
          SimpleDialogOption(
            onPressed: () {
              setState(() {
                Locale newLocale = Locale("am", '');
                languageProvider.changeLanguage(newLocale);
                Navigator.pop(context);
              });
              // Perform action when Amharic is selected
              Navigator.pop(context, 'Amharic');
              Navigator.pop(context);
            },
            child: Text('አማርኛ'),
          ),
          SimpleDialogOption(
            onPressed: () {
              setState(() {
                Locale newLocale = Locale("da", '');
                languageProvider.changeLanguage(newLocale);
              });
              // Perform action when Afaan Oromo is selected
              Navigator.pop(context, 'Afaan Oromoo');
              Navigator.pop(context);
            },
            child: Text('Afaan Oromoo'),
          ),
        ]);
  }
}
