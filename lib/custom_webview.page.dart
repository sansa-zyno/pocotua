import 'dart:io';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:news_app/service/appbackground.service.dart';
import 'package:news_app/service/fg_bg_service.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:news_app/service/local_storage.dart' as local;

class CustomWebviewPage extends StatefulWidget {
  //
  CustomWebviewPage({
    Key? key,
    required this.selectedUrl,
  }) : super(key: key);

  final String selectedUrl;

  @override
  _CustomWebviewPageState createState() => _CustomWebviewPageState();
}

class _CustomWebviewPageState extends State<CustomWebviewPage> {
  bool? result;
  hasConnection() async {
    result = await InternetConnectionChecker().hasConnection;
    setState(() {});
  }

  //
  String pageTitle = "";
  String selectedUrl = "";
  bool isLoading = false;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  //final urlController = TextEditingController();

  /*final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };*/

  @override
  void initState() {
    super.initState();
    //
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        await hasConnection();
        if (result!) {
          if (Platform.isAndroid) {
            webViewController?.reload();
          } else if (Platform.isIOS) {
            webViewController?.loadUrl(
                urlRequest: URLRequest(url: await webViewController?.getUrl()));
          }
        } else {
          webViewController!.stopLoading();
          pullToRefreshController!.endRefreshing();
          await Get.defaultDialog(
              title: "Unable to refresh page",
              middleText: "Please turn on your data connection");
        }
      },
    );

    ///
    setState(() {
      selectedUrl = widget.selectedUrl.replaceFirst("http://", "https://");
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    return Stack(
      children: [
        //page
        InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: Uri.parse(selectedUrl)),
          initialOptions: options,
          pullToRefreshController: pullToRefreshController,
          //gestureRecognizers: gestureRecognizers,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStart: (controller, url) async {
            await hasConnection();
            if (!result!) {
              webViewController!.stopLoading();
              await Get.defaultDialog(
                  title: "No network",
                  middleText: "Please turn on your data connection");
            }
            setState(() {
              this.url = url.toString();
              // urlController.text = this.url;
            });
          },
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT,
            );
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url;
            await hasConnection();
            if (result!) {
              if (![
                "http",
                "https",
                "file",
                "chrome",
                "data",
                "javascript",
                "about"
              ].contains(uri!.scheme)) {
                if (await canLaunchUrlString(url)) {
                  // Launch the App
                  await launchUrlString(
                    url,
                  );
                  // and cancel the request
                  return NavigationActionPolicy.CANCEL;
                }
              }
              return NavigationActionPolicy.ALLOW;
            } else {
              webViewController!.stopLoading();
              await Get.defaultDialog(
                  title: "Cant navigate to this link",
                  middleText: "Please turn on your data connection");
            }
          },
          onLoadStop: (controller, url) async {
            pullToRefreshController?.endRefreshing();
            setState(() {
              this.url = url.toString();
              //urlController.text = this.url;
            });
          },
          onLoadError: (controller, url, code, message) {
            pullToRefreshController?.endRefreshing();
          },
          onProgressChanged: (controller, progress) async {
            await hasConnection();
            if (result!) {
              if (progress == 100) {
                pullToRefreshController!.endRefreshing();
              }
              setState(() {
                this.progress = progress / 100;
                //urlController.text = this.url;
                isLoading = this.progress != 1;
              });
            } else {
              /*controller.stopLoading();
              print("oya");

              await Get.defaultDialog(
                title: "No network from Progress block",
                middleText: "Please turn on your data connection",
                /*onWillPop: () async {
                    webViewController!.goBack();
                    return await Future.value(true);
                  }*/
              );*/
              setState(() {
                //this.progress = progress / 100;
                //urlController.text = this.url;
                isLoading = 1 != 1;
              });
            }
          },
          onUpdateVisitedHistory: (controller, url, androidIsReload) {
            setState(() {
              this.url = url.toString();
              // urlController.text = this.url;
            });
          },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
        ),
        //loading
        Center(
          child: Visibility(
              visible: isLoading,
              child: SpinKitFadingCircle(
                color: Color(0xFF072A6C),
              )),
        ),
      ],
    );
  }

/*
    openWebpageLink(String url, {bool external = false}) async {
    if (Platform.isIOS || external) {
      await launchUrlString(url);
      return;
    }
    await viewContext.push(
      (context) => CustomWebviewPage(
        selectedUrl: url,
      ),
    );
  }
  */
}
