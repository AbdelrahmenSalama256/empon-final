import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/checkout/data/model/payment_url_response_model.dart';
import 'package:embone/features/client/order/view/success_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

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
  bool _isLoading = true;
  bool _webViewInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    // Create platform-specific WebViewController
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    // Platform-specific setup
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar
        },
        onPageStarted: (String url) {
          setState(() => _isLoading = true);
        },
        onPageFinished: (String url) {
          setState(() => _isLoading = false);
        },
        onWebResourceError: (WebResourceError error) {
          setState(() => _isLoading = false);
        },
        onNavigationRequest: (NavigationRequest request) {
          // Handle payment success URL
          if (request.url.contains('success') ||
              request.url.contains('payment-success')) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const SuccessOrderScreen(),
              ),
            );
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );

    await controller.loadRequest(Uri.parse(widget.paymentUrl));

    setState(() {
      _controller = controller;
      _webViewInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: !_webViewInitialized
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
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
                  Expanded(
                    child: Stack(
                      children: [
                        WebViewWidget(controller: _controller),
                        if (_isLoading)
                          const Center(child: CircularProgressIndicator()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
