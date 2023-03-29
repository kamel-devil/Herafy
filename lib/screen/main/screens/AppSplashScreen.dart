import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:herafy/screen/DTDashboardScreen.dart';
import 'package:herafy/screen/main/utils/AppConstant.dart';
import 'package:nb_utils/nb_utils.dart';


class AppSplashScreen extends StatefulWidget {
  static String tag = '/ProkitSplashScreen';

  @override
  _AppSplashScreenState createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    navigationPage();
  }

  void navigationPage() async {
    setValue(appOpenCount, (getIntAsync(appOpenCount)) + 1);

    if (!await isNetworkAvailable()) {
      toastLong(errorInternetNotAvailable);
    }

    await Future.delayed(Duration(seconds: 3));
    if (isWeb) {
      DTDashboardScreen().launch(context, isNewTask: true);
    } else {
      // ProKitLauncher().launch(context, isNewTask: true);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorFromHex('#FFFDF1'),
      body: Container(
        alignment: Alignment.center,
        child: Image.asset('images/app/app_icon.png', height: 200, fit: BoxFit.fitHeight),
      ),
    );
  }
}
