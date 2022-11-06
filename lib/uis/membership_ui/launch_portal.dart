import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/uis/membership_ui/subscription_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchPortal extends StatefulWidget {
  final Person person;
  final String sessionURL;
  final String appBarTitle;
  final SubscriptionBloc subscriptionBloc;
  const LaunchPortal({
    Key? key,
    required this.appBarTitle,
    required this.subscriptionBloc,
    required this.person,
    required this.sessionURL,
  }) : super(key: key);
  @override
  State<LaunchPortal> createState() => _LaunchPortalState();
}

class _LaunchPortalState extends State<LaunchPortal> {
  @override
  void dispose() {
    // TODO: implement dispose
    widget.subscriptionBloc.update(customerId: widget.person.customerId!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.sessionURL)),
        onDownloadStartRequest: (controller, downloadStartRequest) async {
          await launchUrl(downloadStartRequest.url);
        },
      ),
    );
  }
}
