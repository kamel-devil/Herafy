import 'package:flutter/material.dart';

import '../utils/AppWidget.dart';
import '../utils/DTWidgets.dart';
import 'DTDrawerWidget.dart';

class DTMaintenanceScreen extends StatefulWidget {
  @override
  _DTMaintenanceScreenState createState() => _DTMaintenanceScreenState();
}

class _DTMaintenanceScreenState extends State<DTMaintenanceScreen> {
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
      appBar: appBar(context, 'Maintenance'),
      drawer: DTDrawerWidget(),
      body: errorWidget(
        context,
        'images/defaultTheme/maintenance.png',
        'Maintenance Mode',
        'This app is currently under going maintenance and will be back online shortly, Thank you for your patience.',
      ),
    );
  }
}
