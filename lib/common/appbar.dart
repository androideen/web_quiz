import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:quiz/common/app.dart';
import 'package:url_launcher/url_launcher.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double barHeight = 0;

  MainAppBar({Key key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + barHeight);

  void _openUrl(String url) async {
    // flutter web
    if (kIsWeb) {
      html.document.window.location.href = url;
    }
    // android or ios
    else if (Platform.isAndroid || Platform.isIOS) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    // unknown platform
    else {
      throw new Exception('Unsupported platform');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          TextButton(
            child: Icon(Icons.home, color: AppConfig.textColorInContainer,),
            onPressed: () {
              _openUrl(AppConfig.WEBSITE);
            },
          ),
          TextButton(
            onPressed: () {},
            child: Text(AppConfig.APP_NAME,
                style: TextStyle(fontSize: 18, color: AppConfig.textColorInContainer)),
          ),
        ],
      ),
      elevation: 0,
    );
  }
}
