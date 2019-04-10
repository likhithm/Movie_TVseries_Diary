import 'dart:io';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';

class WebView extends StatefulWidget {
  final String url;
  final String title;

  WebView(this.url,this.title);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WebViewState();
  }
}

class  WebViewState extends State<WebView> {

  final webView = FlutterWebviewPlugin();
  String url;

  @override
  void initState() {
    super.initState();
    url = widget.url;
    webView.close();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title),

      ),
      withJavascript: true,
      withLocalStorage: true,
      withZoom: true,
      withLocalUrl: true,
      allowFileURLs: true,
    );
  }
}