import 'package:flutter/material.dart';
import 'package:herafy/screen/login/login.dart';
import 'package:herafy/screen/main/utils/AppColors.dart';
import 'package:herafy/screen/main/utils/Lipsum.dart' as lipsum;
import 'package:nb_utils/nb_utils.dart';

import '../../utils/AppWidget.dart';
import '../DTDrawerWidget.dart';

class DTWalkThoughScreen extends StatefulWidget {
  static String tag = '/DTWalkThoughScreen';

  @override
  DTWalkThoughScreenState createState() => DTWalkThoughScreenState();
}

class DTWalkThoughScreenState extends State<DTWalkThoughScreen> {
  var pageController = PageController();

  List<Widget>  pages = [];
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  init() async {
    pages = [
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/defaultTheme/walkthrough1.png', height: context.height() * 0.45),
            Text('Title', style: boldTextStyle(size: 20)),
            Text(lipsum.createSentence(), textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(8),
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/defaultTheme/walkthrough1.png', height: context.height() * 0.45),
            Text('Title', style: boldTextStyle(size: 20)),
            Text(lipsum.createSentence(), textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(8),
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/defaultTheme/walkthrough1.png', height: context.height() * 0.45),
            Text('Title', style: boldTextStyle(size: 20)),
            Text(lipsum.createSentence(), textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(8),
          ],
        ),
      )
    ];
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    init();

    return Scaffold(
      appBar: appBar(context, 'WalkThrough'),
      drawer: DTDrawerWidget(),
      body: Container(
        child: Stack(
          children: [
            PageView(
              controller: pageController,
              children: pages,
              onPageChanged: (index) {
                selectedIndex = index;
                setState(() {});
              },
            ),
            AnimatedPositioned(
              duration: const Duration(seconds: 1),
              bottom: 20,
              left: 0,
              right: 0,
              child: DotIndicator(pageController: pageController, pages: pages, indicatorColor: appColorPrimary),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: AnimatedCrossFade(
                firstChild: Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.circular(8)),
                  child: Text('Get Started', style: boldTextStyle(color: white)),
                ).onTap(() {
                  LoginPage().launch(context);
                }),
                secondChild: const SizedBox(),
                duration: const Duration(milliseconds: 300),
                firstCurve: Curves.easeIn,
                secondCurve: Curves.easeOut,
                crossFadeState: selectedIndex == (pages.length - 1) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              ),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.circular(8)),
                child: Text('Skip', style: boldTextStyle(color: white)),
              ).onTap(() {
                finish(context);
                LoginPage().launch(context);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
