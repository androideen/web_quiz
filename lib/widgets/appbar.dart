import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:quiz/constants/app.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double barHeight = 0;

  MainAppBar({Key key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + barHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          //IconButton(icon: Icon(Icons.dehaze), onPressed: () { },),
          FlatButton(
            onPressed: () {
              Get.offAllNamed('/');
            },
            splashColor: null,
            highlightColor: null,
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: AppConfig.APP_NAME,
                  style: TextStyle(fontSize: 24, color: Colors.white)),
            ])),
          ),
        ],
      ),
      elevation: 0,
    );
  }
}
