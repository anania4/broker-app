import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:delalochu/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../core/utils/progress_dialog_utils.dart';

class PaymentWebPage extends StatefulWidget {
  final String url;
  final String fallBackNamedUrl;
  final String transactionReference;
  final String amountPaid;

  //ttx
  //amount
  //description
  //

  const PaymentWebPage(
      {Key? key,
      required this.url,
      required this.fallBackNamedUrl,
      required this.transactionReference,
      required this.amountPaid})
      : super(key: key);

  @override
  State<PaymentWebPage> createState() => _PaymentWebPageState();
}

class _PaymentWebPageState extends State<PaymentWebPage> {
  late InAppWebViewController webViewController;
  String url = "";
  double progress = 0;
  StreamSubscription? connection;
  bool isOffline = false;

  @override
  void initState() {
    checkConnectivity();
    debugPrint('widget.url ${widget.url}');
    super.initState();
  }

  void checkConnectivity() {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isOffline = true;
        });
        ProgressDialogUtils.showSnackBar(
          context: context,
          message: ConstantStrings.connectionError,
          duration: 2,
        );

        exitPaymentPage(ConstantStrings.connectionError);
      } else if (result == ConnectivityResult.mobile) {
        setState(() {
          isOffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          isOffline = false;
        });
      } else if (result == ConnectivityResult.ethernet) {
        setState(() {
          isOffline = false;
        });
      } else if (result == ConnectivityResult.bluetooth) {
        setState(() {
          isOffline = false;
        });
        exitPaymentPage(ConstantStrings.connectionError);
      }
    } as void Function(List<ConnectivityResult> event)?);
  }

  void exitPaymentPage(String message) {
    Navigator.pushNamed(
      context,
      widget.fallBackNamedUrl,
      arguments: {
        'message': message,
        'transactionReference': widget.transactionReference,
        'paidAmount': widget.amountPaid
      },
    );
    ProgressDialogUtils.showSnackBar(
      context: context,
      message: message,
      duration: 4,
    );
  }

  @override
  void dispose() {
    super.dispose();
    connection!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFFFE9A3C),
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(widget.url) as WebUri),
                onWebViewCreated: (controller) {
                  setState(() {
                    webViewController = controller;
                  });
                  controller.addJavaScriptHandler(
                    handlerName: "buttonState",
                    callback: (args) async {
                      webViewController = controller;
                      if (args[2][1] == 'CancelbuttonClicked') {
                        exitPaymentPage('Transactions cancelled');
                      }
                      return args.reduce((curr, next) => curr + next);
                    },
                  );
                },
                onUpdateVisitedHistory: (InAppWebViewController controller,
                    Uri? uri, androidIsReload) async {
                  if (uri.toString() == 'https://delalaye.com/success') {
                    exitPaymentPage('Payment Successful');
                  }
                  if (uri.toString() == 'https://delalaye.com/fail') {
                    exitPaymentPage('Payment Failed');
                  }
                  if (uri.toString() == 'https://delalaye.com/cancel') {
                    exitPaymentPage('Transactions cancelled');
                  }
                  if (uri
                      .toString()
                      .contains('checkout/test-payment-receipt/')) {
                    await ProgressDialogUtils.delay();
                    exitPaymentPage('Payment Successful');
                  }
                  controller.addJavaScriptHandler(
                    handlerName: "handlerFooWithArgs",
                    callback: (args) async {
                      webViewController = controller;
                      if (args[2][1] == 'failed') {
                        await ProgressDialogUtils.delay();
                        exitPaymentPage('Payment Failed');
                      }
                      if (args[2][1] == 'success') {
                        await ProgressDialogUtils.delay();
                        exitPaymentPage('Payment Successful');
                      }
                      return args.reduce((curr, next) => curr + next);
                    },
                  );
                  controller.addJavaScriptHandler(
                    handlerName: "buttonState",
                    callback: (args) async {
                      webViewController = controller;
                      if (args[2][1] == 'CancelbuttonClicked') {
                        exitPaymentPage('Transactions cancelled');
                      }
                      return args.reduce((curr, next) => curr + next);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
