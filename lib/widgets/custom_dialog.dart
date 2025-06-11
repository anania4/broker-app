import 'package:delalochu/core/app_export.dart';
import 'package:delalochu/data/models/packageModel/packageModel.dart';
import 'package:delalochu/domain/apiauthhelpers/apiauth.dart';
import 'package:flutter/material.dart';

import '../core/utils/progress_dialog_utils.dart';
import '../presentation/chapaPyment/chapaWebView.dart';
import '../presentation/forgotPassword/forgotpassword_screen.dart';
import '../presentation/forgotPassword/provider/forgotpassword_provider.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog(
      {Key? key,
      required this.color,
      required this.title,
      required this.buttonLable,
      required this.message,
      required this.amount,
      required this.onClick,
      required this.icon})
      : super(key: key);

  final Color color;
  final String title, message, buttonLable, amount;
  final IconData icon;
  final void Function() onClick;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  bool isLoading = false;
  List<Package> package = [];

  int selectedIndex = 0;

  bool useMyPhone = true;
  bool useAnotherMyPhone = false;

  getPackage() async {
    isLoading = true;
    package = await ApiAuthHelper.getPackage();
    setState(() {});
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    getPackage();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(
        context: context,
        color: widget.color,
        title: widget.title,
        amount: widget.amount,
        message: widget.message,
        buttonLable: widget.buttonLable,
        onClick: widget.onClick,
        icon: widget.icon,
      ),
    );
  }

  StatefulBuilder _buildChild(
      {required BuildContext context,
      required Color color,
      required String title,
      required String message,
      required String amount,
      required String buttonLable,
      required IconData icon,
      required void Function() onClick}) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    // ignore: unused_local_variable
    final amountController = TextEditingController();
    List<dynamic> selectedservice = [];
    return StatefulBuilder(
      builder: (context, setState) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 40.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 16.h, top: 14.v),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgX,
                        color: Color(0xFFFFA05B),
                        height: 26.adaptSize,
                        width: 26.adaptSize,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'poppins',
                    color: Colors.black,
                    fontSize: 18),
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 142.v,
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.h,
                        crossAxisSpacing: 4.h,
                      ),
                      itemCount: package.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            setState(() {
                              selectedservice.clear();
                              selectedservice.add('${package[index].id!}');
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            decoration: selectedservice
                                        .contains('${package[index].id!}') ==
                                    true
                                ? AppDecoration.selectedColor.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder5,
                                  )
                                : AppDecoration.outlineBlack.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder5,
                                  ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    package[index].name ?? '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 5),
                                    Text(
                                      "ETB ${package[index].price ?? ''}",
                                      style: TextStyle(
                                        color: selectedservice.contains(
                                                    '${package[index].id ?? ''}') ==
                                                true
                                            ? Colors.black
                                            : Color(0xFFFFA05B),
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      package[index].discount.toString() == '0'
                                          ? ""
                                          : '${package[index].discount.toString()}% OFF'
                                              .toLowerCase(),
                                      style: TextStyle(
                                        color: selectedservice.contains(
                                                    '${package[index].id!}') ==
                                                true
                                            ? Colors.black
                                            : Color(0xFFFFA05B),
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              const SizedBox(
                height: 5.0,
              ),
              GestureDetector(
                onTap: () async {
                  if (selectedservice.isNotEmpty) {
                    if (await NetworkInfo().isConnected()) {
                      Navigator.pop(context);
                      _showOption(context, amount);
                    } else {
                      ProgressDialogUtils.showSnackBar(
                        context: context,
                        message: 'Internet connection is not available!',
                        duration: 2,
                      );
                      return;
                    }
                  } else {
                    ProgressDialogUtils.showSnackBar(
                      context: context,
                      message: 'Please select one of the available packages',
                      duration: 2,
                    );
                    return;
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0)),
                  ),
                  child: Center(
                    child: Text(
                      buttonLable,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'poppins',
                          color: Colors.white,
                          fontSize: 17),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  void _showOption(BuildContext context, String amount) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              child: Container(
                height: useMyPhone ? 250 : 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 23.0),
                        child: Text(
                          PrefUtils.sharedPreferences!
                                      .getString('phoneNumber') ==
                                  '+251929336352'
                              ? "Verifiy a phone number"
                              : "Enter your phone number to make payments",
                          style: TextStyle(
                            color: appTheme.black900,
                            fontSize: 20.fSize,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  PrefUtils.sharedPreferences!
                                              .getString('phoneNumber') ==
                                          '+251929336352'
                                      ? 'Your phone number is this ${PrefUtils.sharedPreferences!.getString('phoneNumber') ?? ''}'
                                      : 'Use ${PrefUtils.sharedPreferences!.getString('phoneNumber') ?? ''} phone number to make the payments',
                                  style: TextStyle(
                                    color: appTheme.black900,
                                    fontSize: 15.fSize,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              child: Checkbox(
                                shape: CircleBorder(),
                                value: useMyPhone,
                                activeColor: Color(0xFFFFA05B),
                                onChanged: PrefUtils.sharedPreferences!
                                            .getString('phoneNumber') ==
                                        '+251929336352'
                                    ? (val) {}
                                    : (value) {
                                        setState(() {
                                          useAnotherMyPhone = !value!;
                                          useMyPhone = value;
                                        });
                                      },
                              ),
                            ),
                          ],
                        ),
                      ),
                      PrefUtils.sharedPreferences!.getString('phoneNumber') ==
                              '+251929336352'
                          ? SizedBox.shrink()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        'Use another phone number to make the payments',
                                        style: TextStyle(
                                          color: appTheme.black900,
                                          fontSize: 15.fSize,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: Checkbox(
                                      shape: CircleBorder(),
                                      value: useAnotherMyPhone,
                                      activeColor: Color(0xFFFFA05B),
                                      onChanged: (value) {
                                        setState(() {
                                          useMyPhone = !value!;
                                          useAnotherMyPhone = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      if (useAnotherMyPhone) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              'Change phone number',
                              style: TextStyle(
                                color: appTheme.black900,
                                fontSize: 15.fSize,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: ForgotPasswordScreenState()
                              .buildPhoneNumberWithCountry(context),
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Consumer<ForgotPasswordProvider>(
                            builder: (context, providervalue, child) {
                          return GestureDetector(
                            onTap: () async {
                              if ((useAnotherMyPhone &&
                                      providervalue
                                              .phonenumberController.text !=
                                          "") ||
                                  useMyPhone) {
                                if (await NetworkInfo().isConnected()) {
                                  ProgressDialogUtils.showProgressDialog(
                                    context: context,
                                    isCancellable: false,
                                  );
                                  var res = await ApiAuthHelper.topupURl(
                                    packageId: package[selectedIndex].id ?? 0,
                                    phoneNUmber: useMyPhone
                                        ? "${PrefUtils.sharedPreferences!.getString('phoneNumber') ?? ''}"
                                        : "+251${providervalue.phonenumberController.text}",
                                  );
                                  if (res == 'bypass') {
                                    ProgressDialogUtils.hideProgressDialog();
                                    Navigator.of(context).pop();
                                    NavigatorService.pushNamedAndRemoveUntil(
                                      AppRoutes.homescreenScreens,
                                    );
                                    ProgressDialogUtils.showSnackBar(
                                      context: context,
                                      message: 'You have successfully charged!',
                                      duration: 2,
                                    );
                                  } else if (res != 'bypass' &&
                                      res != 'error') {
                                    ProgressDialogUtils.hideProgressDialog();
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentWebPage(
                                          amountPaid: amount,
                                          fallBackNamedUrl:
                                              AppRoutes.homescreenScreens,
                                          transactionReference: 'sdskjad',
                                          url: res,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ProgressDialogUtils.hideProgressDialog();
                                    Navigator.of(context).pop();
                                    ProgressDialogUtils.showSnackBar(
                                      context: context,
                                      message: 'Something went wrong!',
                                      duration: 2,
                                    );
                                    return;
                                  }
                                } else {
                                  ProgressDialogUtils.showSnackBar(
                                    context: context,
                                    message:
                                        'Internet connection is not available!',
                                    duration: 2,
                                  );
                                  return;
                                }
                              } else {
                                ProgressDialogUtils.showSnackBar(
                                  context: context,
                                  message:
                                      'Please select a checkbox to use the phone number or enter a new phone number',
                                  duration: 2,
                                );
                                return;
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: appTheme.orangeA200,
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                              child: Center(
                                child: Text(
                                  'continue',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'poppins',
                                      color: Colors.white,
                                      fontSize: 17),
                                ),
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
