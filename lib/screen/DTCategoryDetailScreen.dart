import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/AppWidget.dart';
import '../utils/DTDataProvider.dart';
import '../utils/DTWidgets.dart';
import '../utils/rating_bar.dart';
import 'DTDrawerWidget.dart';
import 'DTProductDetailScreen.dart';

class DTCategoryDetailScreen extends StatefulWidget {
  static String tag = '/DTCategoryDetailScreen';

  @override
  DTCategoryDetailScreenState createState() => DTCategoryDetailScreenState();
}

class DTCategoryDetailScreenState extends State<DTCategoryDetailScreen> {
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
      appBar: appBar(context, 'Grid View'),
      drawer: DTDrawerWidget(),
      body: SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.end,
          runAlignment: WrapAlignment.center,
          children: getProducts().map((data) {
            return Container(
              decoration: boxDecorationRoundedWithShadow(8, backgroundColor: appStore.appBarColor!),
              margin: const EdgeInsets.all(8),
              //height: 200,
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 110,
                    child: Stack(
                      children: [
                        Image.network(
                          data.image!,
                          fit: BoxFit.fitHeight,
                          height: isMobile ? 110 : 180,
                          width: context.width(),
                        ).cornerRadiusWithClipRRect(8),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: data.isLiked.validate() ? const Icon(Icons.favorite, color: Colors.red, size: 16) : const Icon(Icons.favorite_border, size: 16),
                        ),
                      ],
                    ),
                  ),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(data.name!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      4.height,
                      Row(
                        children: [
                          RatingBar(
                            onRatingChanged: (r) {},
                            filledIcon: Icons.star,
                            emptyIcon: Icons.star_border,
                            initialRating: data.rating!,
                            maxRating: 5,
                            filledColor: Colors.yellow,
                            size: 14,
                          ),
                          5.width,
                          Text('${data.rating}', style: secondaryTextStyle(size: 12)),
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
                  ).paddingAll(8),
                ],
              ),
            ).onTap(() async {
              int? index = await DTProductDetailScreen(productModel: data).launch(context);
              if (index != null) appStore.setDrawerItemIndex(index);
            });
          }).toList(),
        ),
      ),
    );
  }
}
