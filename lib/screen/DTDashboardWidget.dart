import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:herafy/screen/login/DTSignUpScreen.dart';
import 'package:herafy/screen/login/login.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../model/DTProductModel.dart';
import '../utils/AppColors.dart';
import '../utils/AppWidget.dart';
import '../utils/DTDataProvider.dart';
import '../utils/DTWidgets.dart';
import '../utils/rating_bar.dart';

import 'DTCategoryDetailScreen.dart';
import 'DTProductDetailScreen.dart';
import 'DTSearchScreen.dart';

class DTDashboardWidget extends StatefulWidget {
  static String tag = '/DTDashboardWidget';

  @override
  DTDashboardWidgetState createState() => DTDashboardWidgetState();
}

class DTDashboardWidgetState extends State<DTDashboardWidget> {
  PageController pageController = PageController();

  List<Widget> pages = [];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget searchTxt() {
      return Container(
        width: dynamicWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: viewLineColor),
          color: appStore.scaffoldBackground,
        ),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(AntDesign.search1, color: appStore.textSecondaryColor),
            10.width,
            Text('Search',
                style: boldTextStyle(color: appStore.textSecondaryColor)),
          ],
        ),
      ).onTap(() {
        DTSearchScreen().launch(context);
      });
    }

    void addFavServices(data) async {
      FirebaseFirestore.instance.collection('favServices').add({
        'image': data['image'],
        "name": data['name'],
        "des": data['des'],
        'type': data['type'],
        'price': data['price'],
        "time": data['time'],
        "craftsman": data['craftsman'],
        "id": data['id'],
      });
    }

    Widget horizontalList() {
      return FutureBuilder(
        future: getCategory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List cat = snapshot.data as List;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 8, top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: cat.map((e) {
                  return Container(
                    width: isMobile ? 100 : 300,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                          ),
                          child: Image.network(e['image'],
                              height: 200, width: 300, fit: BoxFit.fill),
                        ),
                        4.height,
                        Text(e['name'],
                            style: primaryTextStyle(
                                size: 18, weight: FontWeight.w900),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ).onTap(() {
                    DTCategoryDetailScreen(
                      idCat: e['name'],
                    ).launch(context);
                  });
                }).toList(),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }

    Widget horizontalProductListView(bool isv) {
      return StreamBuilder(
        stream: isv
            ? FirebaseFirestore.instance.collection('favServices').snapshots()
            : FirebaseFirestore.instance
                .collection('allService')
                .where('isAccept', isEqualTo: true)
                .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            List ser = snapshot.data?.docs as List;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (_, index1) {
                return Container(
                  decoration: boxDecorationRoundedWithShadow(8,
                      backgroundColor: appStore.appBarColor!),
                  width: 220,
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      10.height,
                      Stack(
                        children: [
                          Image.network(
                            ser[index1]['image'],
                            fit: BoxFit.fitHeight,
                            height: 180,
                            width: context.width(),
                          ).cornerRadiusWithClipRRect(8),
                        ],
                      ).expand(),
                      8.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(ser[index1]['name'],
                                  style: primaryTextStyle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              !isv
                                  ? ElevatedButton.icon(
                                      onPressed: () {
                                        addFavServices(ser[index1]);
                                      },
                                      icon: const Icon(Icons.add),
                                      label: const Text('Fav'),
                                    )
                                  : Container(),
                            ],
                          ),
                          4.height,
                          Row(
                            children: [
                              IgnorePointer(
                                child: RatingBar(
                                  onRatingChanged: (r) {},
                                  filledIcon: Icons.star,
                                  emptyIcon: Icons.star_border,
                                  initialRating: 3.5,
                                  maxRating: 5,
                                  filledColor: Colors.yellow,
                                  size: 14,
                                ),
                              ),
                              5.width,
                              Text('3.5', style: secondaryTextStyle(size: 12)),
                            ],
                          ),
                          4.height,
                          Row(
                            children: [
                              8.width,
                              priceWidget(
                                  int.parse(ser[index1]['price'].toString()),
                                  applyStrike: true),
                            ],
                          ),
                        ],
                      ).paddingAll(8),
                      10.height,
                    ],
                  ),
                ).onTap(() async {
                  int? index =
                      await DTProductDetailScreen(productModel: ser[index1], isFav: true,)
                          .launch(context);
                  if (index != null) appStore.setDrawerItemIndex(index);
                });
              },
              /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.width() > 1550
                            ? 4
                            : context.width() > 1080
                                ? 3
                                : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: cardWidth / cardHeight,
                      ),*/
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: ser.length,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }

    // Widget bannerWidget() {
    //   return Container(
    //     margin: const EdgeInsets.only(left: 8),
    //     child: Row(
    //       children: [
    //         Image.asset('images/defaultTheme/banner/dt_advertise1.jpg', fit: BoxFit.cover).cornerRadiusWithClipRRect(8).expand(),
    //         8.width,
    //         Image.asset('images/defaultTheme/banner/dt_advertise2.jpg', fit: BoxFit.cover).cornerRadiusWithClipRRect(8).expand(),
    //         8.width,
    //         Image.asset('images/defaultTheme/banner/dt_advertise4.jpg', fit: BoxFit.cover).cornerRadiusWithClipRRect(8).expand(),
    //         8.width,
    //         Image.asset('images/defaultTheme/banner/dt_advertise3.jpg', fit: BoxFit.cover).cornerRadiusWithClipRRect(8).expand(),
    //       ],
    //     ),
    //   );
    // }

    Widget mobileWidget() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  decoration: const BoxDecoration(
                    color: appColorPrimary,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                  ),
                ).visible(false),
                Column(
                  children: [
                    10.height,
                    searchTxt(),
                    Container(
                      margin: const EdgeInsets.all(8),
                      height: 230,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          PageView(
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            children: pages,
                            onPageChanged: (index) {
                              selectedIndex = index;
                              setState(() {});
                            },
                          ).cornerRadiusWithClipRRect(8),
                          DotIndicator(
                            pages: pages,
                            indicatorColor: appColorPrimary,
                            pageController: pageController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            10.height,
            Text('Category', style: boldTextStyle()).paddingAll(8),
            Center(child: horizontalList()),
            20.height,
            Text('ListView', style: boldTextStyle()).paddingAll(8),
            ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (_, index) {
                DTProductModel data = getProducts()[index];

                return Container(
                  decoration: boxDecorationRoundedWithShadow(8,
                      backgroundColor: appStore.appBarColor!),
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 110,
                        width: 126,
                        child: Stack(
                          children: [
                            Image.network(
                              data.image!,
                              fit: BoxFit.cover,
                              height: 110,
                              width: 126,
                            ).cornerRadiusWithClipRRect(8),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: data.isLiked.validate()
                                  ? const Icon(Icons.favorite,
                                      color: Colors.red, size: 16)
                                  : const Icon(Icons.favorite_border, size: 16),
                            ),
                          ],
                        ),
                      ),
                      8.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(data.name!,
                              style: primaryTextStyle(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          4.height,
                          Row(
                            children: [
                              IgnorePointer(
                                child: RatingBar(
                                  onRatingChanged: (r) {},
                                  filledIcon: Icons.star,
                                  emptyIcon: Icons.star_border,
                                  initialRating: data.rating!,
                                  maxRating: 5,
                                  filledColor: Colors.yellow,
                                  size: 14,
                                ),
                              ),
                              5.width,
                              Text('${data.rating}',
                                  style: secondaryTextStyle(size: 12)),
                            ],
                          ),
                          4.height,
                          Row(
                            children: [
                              priceWidget(data.discountPrice),
                              8.width,
                              priceWidget(data.price, applyStrike: true),
                            ],
                          ),
                        ],
                      ).paddingAll(8).expand(),
                    ],
                  ),
                ).onTap(() async {
                  // int? index = await DTProductDetailScreen(productModel: data)
                  //     .launch(context);
                  // if (index != null) appStore.setDrawerItemIndex(index);
                });
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: getProducts().length,
            ),
          ],
        ),
      );
    }

    Widget webWidget() {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 60,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "images/logo.png",
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
                searchTxt().expand(),
                25.width,
                FirebaseAuth.instance.currentUser == null
                    ? Container(
                        padding: const EdgeInsets.only(
                            top: 8, left: 16, right: 16, bottom: 8),
                        decoration: BoxDecoration(
                            color: appColorPrimary,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('Sign In',
                            style: boldTextStyle(color: white, size: 18)),
                      ).onTap(() {
                        LoginPage().launch(context);
                      })
                    : Container(),
                16.width,
                FirebaseAuth.instance.currentUser == null
                    ? Container(
                        padding: const EdgeInsets.only(
                            top: 8, left: 16, right: 16, bottom: 8),
                        decoration: BoxDecoration(
                            color: appColorPrimary,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('Register',
                            style: boldTextStyle(color: white, size: 18)),
                      ).onTap(() {
                        DTSignUpScreen().launch(context);
                      })
                    : Container(),
                16.width,
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.shopping_cart,
                      size: 30, color: appStore.iconColor),
                ).onTap(() {
                  // DTCartScreen().launch(context);
                }),
                16.width
              ],
            ),
            Text('Category ', style: boldTextStyle()).paddingAll(8),
            8.height,
            horizontalList(),
            8.height,
            Text('Service For you', style: boldTextStyle()).paddingAll(8),
            8.height,
            SizedBox(height: 300, child: horizontalProductListView(false)),
            8.height,
            // Text('Latest Offers For You', style: boldTextStyle()).paddingAll(8),
            // 8.height,
            // // bannerWidget(),
            8.height,
            Text('Recommended For You', style: boldTextStyle()).paddingAll(8),
            8.height,
            SizedBox(height: 300, child: horizontalProductListView(true)),
            // Text('Recommended Offers For You', style: boldTextStyle()).paddingAll(8),
            // 8.height,
            // bannerWidget(),
          ],
        ),
      );
    }

    return Scaffold(
      body: ContainerX(
        mobile: mobileWidget(),
        web: webWidget(),
      ),
    );
  }

  Future getCategory() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("category").get();

    return qn.docs;
  }

  getAllServices() async {
    var firestore = FirebaseFirestore.instance;
    var qn = await firestore
        .collection("allService")
        .where('isAccept', isEqualTo: true)
        .snapshots();

    return qn;
  }

  getFavServices() async {
    var firestore = FirebaseFirestore.instance;
    return firestore.collection("favServices").snapshots();
  }
}
