import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebViewPage extends StatefulWidget {
  const InAppWebViewPage(
      {super.key, required this.pageUrl, required this.pageTitle});
  final String pageUrl;
  final String pageTitle;

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  late final WebViewController controller;
  var loadingPercentage = 0;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(widget.pageUrl),
      );
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.pageTitle),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
