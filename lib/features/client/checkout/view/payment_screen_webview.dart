import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/base/view/welcome/base_screen.dart';
import 'package:embone/features/client/checkout/data/model/payment_url_response_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final PaymentUrlResponseModel response;

  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.response,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(widget.paymentUrl))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            PrintUtil.debug("==============> async $url");

            if (url.contains('success=true')) {
              PrintUtil.debug("==============> if $url");

              // CustomSnackbar.show(context, 'تم الدفع بنجاح'.tr, icon: Icons.check);
              navigateTo(context, const BaseScreen());
            } else if (url.contains('success=false')) {
              PrintUtil.debug("==============> else $url");
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
        ),
      );
    // _initializeWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
            child: Column(
          children: [
            AppHeader(
              title: 'pay'.tr(context),
              centerTitle: true,
              showBackButton: true,
              onBackPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(child: WebViewWidget(controller: _controller)),
          ],
        )));
  }

  // Future<void> _initializeWebView() async {
  //   // Create platform-specific WebViewController
  //   late final PlatformWebViewControllerCreationParams params;
  //   if (WebViewPlatform.instance is WebKitWebViewPlatform) {
  //     params = WebKitWebViewControllerCreationParams(
  //       allowsInlineMediaPlayback: true,
  //       mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
  //     );
  //   } else {
  //     params = const PlatformWebViewControllerCreationParams();
  //   }

  //   final WebViewController controller =
  //       WebViewController.fromPlatformCreationParams(params);

  //   // Platform-specific setup
  //   if (controller.platform is AndroidWebViewController) {
  //     AndroidWebViewController.enableDebugging(true);
  //     (controller.platform as AndroidWebViewController)
  //         .setMediaPlaybackRequiresUserGesture(false);
  //   }

  //   await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
  //   await controller.setNavigationDelegate(
  //     NavigationDelegate(
  //       onProgress: (int progress) {
  //         // Update loading bar
  //       },
  //       onPageStarted: (String url) {},
  //       onPageFinished: (String url) {},
  //       onWebResourceError: (WebResourceError error) {},
  //       onNavigationRequest: (NavigationRequest request) {
  //         // Handle payment success URL
  //         if (request.url.contains('success') ||
  //             request.url.contains('payment-success') ||
  //             request.url.contains('success=true')) {
  //           Navigator.of(context).pushReplacement(
  //             MaterialPageRoute(
  //               builder: (context) => const SuccessOrderScreen(),
  //             ),
  //           );
  //           return NavigationDecision.prevent;
  //         }
  //         return NavigationDecision.prevent;
  //       },
  //     ),
  //   );

  //   await controller.loadRequest(Uri.parse(widget.paymentUrl));

  //   setState(() {
  //     _controller = controller;
  //     _webViewInitialized = true;
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: !_webViewInitialized
  //         ? const Center(child: CircularProgressIndicator())
  //         : SafeArea(
  //             child: Column(
  //               children: [
  //                 AppHeader(
  //                   title: 'pay'.tr(context),
  //                   centerTitle: true,
  //                   showBackButton: true,
  //                   onBackPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //                 Expanded(
  //                   child: Stack(
  //                     children: [
  //                       WebViewWidget(controller: _controller),
  //                       if (_isLoading)
  //                         const Center(child: CircularProgressIndicator()),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //   );
  // }
}
