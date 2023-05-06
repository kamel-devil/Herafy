import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:herafy/screen/profile_edit/profile_edit.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../utils/AppColors.dart';
import '../../utils/AppConstant.dart';
import '../../utils/AppWidget.dart';
import '../DTDrawerWidget.dart';
import '../DTSecurityScreen.dart';
import '../main/screens/AppSplashScreen.dart';

class DTProfileScreen extends StatefulWidget {
  static String tag = '/DTProfileScreen';

  const DTProfileScreen({super.key});

  @override
  DTProfileScreenState createState() => DTProfileScreenState();
}

class DTProfileScreenState extends State<DTProfileScreen> {
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

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future getData() async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    Widget options() {
      return Column(
        children: [
          // settingItem(context, 'Notifications', onTap: () {
          //   DTNotificationSettingScreen().launch(context);
          // },
          //     leading: const Icon(MaterialIcons.notifications_none),
          //     detail: const SizedBox()),
          settingItem(context, 'Security', onTap: () {
            DTSecurityScreen().launch(context);
          },
              leading: const Icon(MaterialCommunityIcons.shield_check_outline),
              detail: const SizedBox()),
          // settingItem(context, 'Help', onTap: () {
          //   launch('https://www.google.com');
          // },
          //     leading: const Icon(MaterialIcons.help_outline),
          //     detail: const SizedBox()),
          // settingItem(context, 'About', onTap: () {
          //   DTAboutScreen().launch(context);
          // },
          //     leading: const Icon(MaterialIcons.info_outline),
          //     detail: const SizedBox()),
          settingItem(context, 'Edit', onTap: () {
            ProfileEdit().launch(context);
          },
              leading: const Icon(MaterialIcons.settings),
              detail: const SizedBox()),
          settingItem(context, 'Log Out', onTap: () async {
            await FirebaseAuth.instance.signOut().then((value) {
              const AppSplashScreen().launch(context);
            });
          }, detail: const SizedBox(), textColor: appColorPrimary),
        ],
      );
    }

    return Observer(
      builder: (_) => Scaffold(
        appBar: appBar(context, 'Profile'),
        drawer: const DTDrawerWidget(),
        body: ContainerX(
          mobile: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                const Divider(color: appDividerColor, height: 8)
                    .paddingOnly(top: 4, bottom: 4),
                options(),
              ],
            ),
          ),
          web: Column(
            children: [
              FutureBuilder(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              data['image'] == 'null'
                                  ? data['gender'] == 'female'
                                      ? Image.asset('assets/images/img.png',
                                              height: 70,
                                              width: 70,
                                              fit: BoxFit.cover)
                                          .cornerRadiusWithClipRRect(40)
                                      : Image.asset(profileImage,
                                              height: 70,
                                              width: 70,
                                              fit: BoxFit.cover)
                                          .cornerRadiusWithClipRRect(40)
                                  : Image.network(data['image'],
                                          height: 70,
                                          width: 70,
                                          fit: BoxFit.cover)
                                      .cornerRadiusWithClipRRect(40),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['name'], style: primaryTextStyle()),
                                  2.height,
                                  Text(data['email'],
                                      style: primaryTextStyle()),
                                ],
                              )
                            ],
                          ),
                          IconButton(
                            icon: Icon(AntDesign.edit,
                                color: appStore.iconSecondaryColor),
                            onPressed: () {},
                          ).visible(false)
                        ],
                      ).paddingAll(16);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
              const Divider(height: 8).paddingOnly(top: 4, bottom: 4),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: options(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
