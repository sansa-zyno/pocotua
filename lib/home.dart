import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:news_app/custom_webview.page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /* bg() async {
    await Future.delayed(Duration(seconds: 30), () async {
      await AppbackgroundService().startBg();
    });
  }*/

  bool? result;
  hasConnection() async {
    result = await InternetConnectionChecker().hasConnection;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //bg();
    hasConnection();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: RefreshIndicator(
        child: result == null
            ? Center(child: CircularProgressIndicator())
            : result!
                ? CustomWebviewPage(selectedUrl: "https://pocotua.com")
                : Center(
                    child: Text("No Internet Connection"),
                  ),
        onRefresh: () async {
          await hasConnection();
        },
      )),
    );
  }
}
