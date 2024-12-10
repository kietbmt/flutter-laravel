// ignore: file_names
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:shopping/constants/size_config.dart';
import 'package:shopping/constants/color_data.dart';
import 'package:shopping/ui/home/home_screen.dart';
import 'package:shopping/ui/profile/card_list_screen.dart';
import 'package:shopping/ui/profile/my_order_screen.dart';
import 'package:shopping/ui/profile/profile_screen.dart';
import 'package:shopping/ui/profile/setting_screen.dart';
import 'package:shopping/ui/profile/shipping_sddress_screen.dart';

import '../../../constants/constant.dart';
import '../../../constants/pref_data.dart';
import '../../../constants/widget_utils.dart';


class TabProfile extends StatefulWidget {
  const TabProfile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TabProfile();
  }
}

class _TabProfile extends State<TabProfile> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    double appBarPadding = getAppBarPadding();
    double imgHeight = Constant.getPercentSize(screenHeight, 16);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor,
      child: Column(
        children: [
          getDefaultHeader(context, "Profile", () {}, (value) {},
              withFilter: false, isShowBack: false, isShowSearch: false),
          getSpace(appBarPadding),
          Container(
              width: imgHeight,
              height: imgHeight,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image:
                          AssetImage(Constant.assetImagePath + "Profile.png"),
                      fit: BoxFit.cover))

              // image: DecorationImage(image: AssetImage(Constant.assetImagePath+"Profile.png"))),
              // child: ClipRRect(
              //   borderRadius: BorderRadius.all(Radius.circular(imgRadius)),
              //   child: getSvgImage("Profile.svg", double.infinity),
              // ),
              ),
          getSpace(appBarPadding),
          // getSpace(Constant.getPercentSize(screenHeight,1)),
          getCustomText("Jerome Bell", fontBlack, 1, TextAlign.center,
              FontWeight.bold, Constant.getPercentSize(screenHeight, 2.7)),
          getSpace(Constant.getPercentSize(appBarPadding, 50)),
          getCustomText("jeromebell@gmail.com", greyFont, 1, TextAlign.center,
              FontWeight.w400, Constant.getPercentSize(screenHeight, 2.2)),
          getSpace(appBarPadding),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(getAppBarPadding()),
              padding: EdgeInsets.only(
                  left: appBarPadding,
                  right: appBarPadding),
              decoration: ShapeDecoration(
                  color: cardColor,
                  shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius:
                              Constant.getPercentSize(screenHeight, 2),
                          cornerSmoothing: 0.5)),
                  shadows: [
                    BoxShadow(
                        color: shadowColor.withOpacity(0.02),
                        blurRadius: 3,
                        spreadRadius: 4)
                  ]),
              child: ListView(
                padding: EdgeInsets.zero,
                primary: true,
                shrinkWrap: true,
                children: [
                  getSpace(appBarPadding),
                  getSettingRow("User.svg","My Profile",(){
                    Constant.sendToScreen(const ProfileScreen(), context);
                  }),
                  getSeparatorWidget(),
                  getSettingRow("Bag.svg","My Orders",(){
                    Constant.sendToScreen(const MyOrderScreen(), context);

                  }),
                  getSeparatorWidget(),
                  getSettingRow("heart.svg","My Favourites",(){
                    Constant.sendToScreen(HomeScreen(selectedTab: 1), context);

                  }),
                  getSeparatorWidget(),
                  getSettingRow("shipping_location.svg","Shipping Address",(){
                    Constant.sendToScreen(const ShippingAddressScreen(), context);

                  }),
                  getSeparatorWidget(),
                  getSettingRow("Card.svg","My Cards",(){
                    Constant.sendToScreen(const CardListScreen(), context);

                  }),
                  getSeparatorWidget(),
                  getSettingRow("Setting.svg","Settings",(){
                    Constant.sendToScreen(const SettingScreen(), context);

                  }),
                  getSpace(appBarPadding),

                ],
              ),
              
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  Widget getSeparatorWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getAppBarPadding()),
      child: Divider(
        height: 1,
        color: Colors.grey.shade200,
      ),
    );
  }

}
