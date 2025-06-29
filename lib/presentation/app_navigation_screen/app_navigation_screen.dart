import 'package:delalochu/core/app_export.dart';
import 'package:flutter/material.dart';
import 'provider/app_navigation_provider.dart';

class AppNavigationScreen extends StatefulWidget {
  const AppNavigationScreen({Key? key})
      : super(
          key: key,
        );

  @override
  AppNavigationScreenState createState() => AppNavigationScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppNavigationProvider(),
      child: AppNavigationScreen(),
    );
  }
}

class AppNavigationScreenState extends State<AppNavigationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFFFFFFF),
        body: SizedBox(
          width: 375.h,
          child: Column(
            children: [
              _buildAppNavigation(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFFFFFFF),
                    ),
                    child: Column(
                      children: [
                        _buildScreenTitle(
                          context,
                          screenTitle: "splashScreen".tr,
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.splashscreenScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "categoryScreenTwo".tr,
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.categoryscreentwoScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "loginScreen".tr,
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.loginscreenScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "signupScreen".tr,
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.signupscreenScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "categoryScreenOne".tr,
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.categoryscreenoneScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "homeScreen".tr,
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.homescreenScreens),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "homeScreenWithBottomShitOne".tr,
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.homescreenwithbottomshitoneScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "homeScreenWithBottomShitTwo".tr,
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.homescreenwithbottomshittwoScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "categoryScreen".tr,
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.categoryscreenScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "profileScreen".tr,
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.profilescreenScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "historyScreen".tr,
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.historyscreenScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "selectCategoryScreen".tr,
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.selectcategoryscreenScreen),
                        ),
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

  /// Section Widget
  Widget _buildAppNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFFFFFFF),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                "App Navigation".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF000000),
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                "Check your app's UI from the below demo screens of your app."
                    .tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF888888),
                  fontSize: 16.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.v),
          Divider(
            height: 1.v,
            thickness: 1.v,
            color: Color(0XFF000000),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle!.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF),
        ),
        child: Column(
          children: [
            SizedBox(height: 10.v),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Text(
                  screenTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0XFF000000),
                    fontSize: 20.fSize,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.v),
            SizedBox(height: 5.v),
            Divider(
              height: 1.v,
              thickness: 1.v,
              color: Color(0XFF888888),
            ),
          ],
        ),
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(String routeName) {
    NavigatorService.pushNamed(routeName);
  }
}
