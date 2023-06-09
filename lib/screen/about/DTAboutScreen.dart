import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';

import '../../utils/AppWidget.dart';
import '../drawer/DTDrawerWidget.dart';


class DTAboutScreen extends StatefulWidget {
  static String tag = '/DTAboutScreen';

  const DTAboutScreen({super.key});

  @override
  DTAboutScreenState createState() => DTAboutScreenState();
}

class DTAboutScreenState extends State<DTAboutScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'About'),
      drawer: const DTDrawerWidget(),
      body: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: boxDecoration(showShadow: true),
              child: Image.asset('images/logo.png', height: 100),
            ).cornerRadiusWithClipRRect(50),
            20.height,
            FutureBuilder<String>(
              future: PackageInfo.fromPlatform().then((value) => value.version),
              builder: (_, snap) {
                if (snap.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Version:', style: secondaryTextStyle()),
                      5.width,
                      Text(snap.data!, style: primaryTextStyle(size: 18)),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
            10.height,
            Text(
                'Herfay is the place where you can find the craft services you need!',
                style: primaryTextStyle(),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
