import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:herafy/screen/main/screens/AppSplashScreen.dart';
import 'package:herafy/screen/main/utils/AppConstant.dart';
import 'package:herafy/screen/main/utils/AppTheme.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'screen/DTDashboardScreen.dart';
import 'store/AppStore.dart';


AppStore appStore = AppStore();

void main() async {
  //region Entry Point
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initialize();

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));


  runApp(MyApp());
  //endregion
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: '$mainAppName${!isMobile ? ' ${platformName()}' : ''}',
        home: AppSplashScreen(),
        theme: !appStore.isDarkModeOn ? AppThemeData.lightTheme : AppThemeData.darkTheme,
        scrollBehavior: SBehavior(),
      ),
    );
  }
}
