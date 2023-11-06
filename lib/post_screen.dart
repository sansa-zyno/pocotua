import 'package:flutter/material.dart';
import 'package:news_app/custom_webview.page.dart';
import 'package:news_app/service/appbackground.service.dart';

class PostScreen extends StatefulWidget {
  String link;
  PostScreen(this.link);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: CustomWebviewPage(selectedUrl: widget.link)),
    );
  }
}
