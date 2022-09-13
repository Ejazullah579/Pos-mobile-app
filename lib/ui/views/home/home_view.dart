import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/ui/components/headings.dart';
import 'package:pro1/ui/components/transaction_tile.dart';
import 'package:pro1/ui/components/walk_through/walkthrough_image.dart';
import 'package:pro1/ui/components/walk_through/walkThrough.dart';
import 'package:pro1/ui/views/home/components/cards/product_card.dart';
import 'package:pro1/ui/views/home/components/cards/youtube_card.dart';
import 'package:pro1/ui/views/services/custom_search/custom_search.dart';
import 'package:pro1/ui/views/services/add_product/add_product_view.dart';
import 'package:pro1/ui/views/services/edit_product/edit_product_view.dart';
import 'package:pro1/ui/views/services/sales_report/sales_report_view.dart';
import 'package:pro1/ui/views/user_profile/user_profile_view.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:stacked/stacked.dart';
import 'home_viewmodel.dart';
import 'package:pro1/services/test_data.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  /// for operations...
  var current = 1;
  int currentSponsorIndex = 0;
  // bool isMenuOpened = true;
  Function refresh;
  GlobalKey futureBuilderKey = new GlobalKey();
  GlobalKey profilePicKey = GlobalKey();
  GlobalKey sponsorAddKey = GlobalKey();
  GlobalKey servicesKey = GlobalKey();
  GlobalKey drawerKey = GlobalKey();
  GlobalKey transactionHistoryKey = GlobalKey();
  //// operations dots... infront of services text
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  AnimationController _controller;
  ScrollController _sponsorListScrollController;

  Future<void> _onRefresh() async {
    await refresh();
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 2000), vsync: this)
          ..addListener(() {
            if (_controller.isCompleted) {
              _controller.reverse();
            } else if (_controller.isDismissed) {
              _controller.forward();
            }
            setState(() {});
          })
          ..forward();
    _sponsorListScrollController = ScrollController();
    _sponsorListScrollController.addListener(() {
      setState(() {
        currentSponsorIndex = (_sponsorListScrollController.offset ~/ 320);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _sponsorListScrollController.dispose();
    // _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context);
    final maxwidth = MediaQuery.of(context).size.width;
    final maxheight = MediaQuery.of(context).size.height;

    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) {
        refresh = model.refresh;
        model.handleReadyLogic();
      },
      builder: (context, model, child) => Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black,
          // appBar: AppBar(
          //   leading: GestureDetector(
          //       onTap: () {
          //         model.globalService.drawerController.toggle();
          //         print('pressed');
          //       },
          //       child: Icon(Icons.menu)),
          // ),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: WalkThrough(
              startWalkthrough: model.showWalkThrough,
              data: [
                WalkThroughData(
                  pinchHoleRadius: BorderRadius.circular(10),
                  infoType: InfoType.Image,
                  image: WalkthroughImage(
                      imageSize: 280,
                      text:
                          "Welcome to Shopify App. Lets walk through the app for your easability",
                      assetImage: "assets/lottie/get-started.json"),
                ),
                WalkThroughData(
                    key: profilePicKey,
                    hintText: "Access your profile from here",
                    location: HintTextLocation.Left),
                WalkThroughData(
                    key: sponsorAddKey,
                    hintText: "This section will show Sponsor adds",
                    pinchHoleRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                    location: HintTextLocation.Bottom),
                WalkThroughData(
                    key: servicesKey,
                    hintText: "These are the services at your disposal",
                    pinchHoleRadius: BorderRadius.circular(15),
                    location: HintTextLocation.Top),
                WalkThroughData(
                    key: transactionHistoryKey,
                    pinchHoleRadius: BorderRadius.circular(15),
                    hintText:
                        "This section will show your recent transactions.",
                    location: HintTextLocation.Top),
                WalkThroughData(
                  key: profilePicKey,
                  hintText: "Swipe right to open drawer",
                  shouldCutChildHole: false,
                  infoType: InfoType.Image,
                  image: WalkthroughImage(
                      text: "Swipe right to open drawer",
                      assetImage: "assets/lottie/swipe-right.json"),
                ),
              ],
              onComplete: () => model.setWalkThrough(),
              child: Container(
                  width: maxwidth,
                  height: maxheight,
                  key: drawerKey,
                  decoration: BoxDecoration(
                    color:
                        themeManager.isDarkMode ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                  ),
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 15),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 16, bottom: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: maxwidth * 0.6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GreetingText(),
                                    Text(model.currentUser.firstName,
                                        style: GoogleFonts.inter(
                                            fontSize: 30,
                                            color: themeManager.isDarkMode
                                                ? Colors.white
                                                : Color(0xFF3A3A3A),
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  NavigationService().navigateWithTransition(
                                    UserProfileView(),
                                    duration: Duration(milliseconds: 700),
                                    transition: NavigationTransition
                                        .LeftToRighttWithFade,
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Hero(
                                      tag: "profile_pic",
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        key: profilePicKey,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius:
                                                    _controller.value * 8,
                                                spreadRadius:
                                                    _controller.value * 3,
                                                color: Colors.blue)
                                          ],
                                        ),
                                        child: model.currentUser.imageUrl ==
                                                    null ||
                                                model.currentUser.imageUrl ==
                                                    "" ||
                                                model.currentUser.imageUrl ==
                                                    "null"
                                            ? Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Icons.person),
                                              )
                                            : model.isCurrentUserBusy
                                                ? Container(
                                                    padding: EdgeInsets.all(3),
                                                    alignment: Alignment.center,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              Colors.white),
                                                    ),
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: model
                                                        .currentUser.imageUrl,
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      height: 50,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 5,
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  imageProvider)),
                                                    ),
                                                  ),
                                      ),
                                    ),
                                    // Positioned(
                                    //   top: 0,
                                    //   right: 0,
                                    //   child: Container(
                                    //     height: 13,
                                    //     width: 13,
                                    //     decoration: BoxDecoration(
                                    //       shape: BoxShape.circle,
                                    //       color: Colors.redAccent,
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            height: 184,
                            width: maxwidth,
                            padding: EdgeInsets.only(left: 16),
                            child: model.isBusyGettingSponsorAdds
                                ? Center(
                                    child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        themeManager.isDarkMode
                                            ? Colors.white
                                            : Colors.blue),
                                  ))
                                : model.sponsorAddList == null
                                    ? Container()
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        controller:
                                            _sponsorListScrollController,
                                        clipBehavior: Clip.none,
                                        itemCount: model.sponsorAddList.length,
                                        // ignore: missing_return
                                        itemBuilder: (context, index) {
                                          if (model
                                                  .sponsorAddList[index].type ==
                                              "video")
                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                YoutubeCard(
                                                  key: index == 0
                                                      ? sponsorAddKey
                                                      : Key("SponsorAdd$index"),
                                                  videoLink: model
                                                      .sponsorAddList[index]
                                                      .videoUrl,
                                                  index: index,
                                                ),
                                                SizedBox(width: 10),
                                              ],
                                            );
                                          else if (model
                                                  .sponsorAddList[index].type ==
                                              "product")
                                            return ProductCard(
                                              maxheight: maxheight,
                                              index: 1,
                                            );
                                        }

                                        // WebsiteCard(),
                                        )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, bottom: 13, top: 29, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Headings(
                                    text: "Services",
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  model.freeServices
                                      ? Container()
                                      : !model.isBusyGettingTime
                                          ? model.isSubscriptionExpired
                                              ? Tooltip(
                                                  message: "7 days Trial",
                                                  preferBelow: false,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: themeManager
                                                              .isDarkMode
                                                          ? Colors.white30
                                                          : Colors.black38),
                                                  child: model.isBusyGettingTime
                                                      ? ProgressBar()
                                                      : SubscriptionTimeLeftText(
                                                          futureBuilderKey:
                                                              futureBuilderKey,
                                                          themeManager:
                                                              themeManager))
                                              : Container()
                                          : ProgressBar()
                                ],
                              ),
                              Row(
                                children: map<Widget>(model.sponsorAddList ?? 0,
                                    (index, selected) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    height: 9,
                                    width: 9,
                                    margin: EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: !themeManager.isDarkMode
                                            ? (currentSponsorIndex == index
                                                ? Colors.blue[700]
                                                : Colors.blue[200])
                                            : (currentSponsorIndex == index
                                                ? Colors.white
                                                : Colors.white38)),
                                  );
                                }),
                              )
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 130,
                              width: maxwidth,
                              alignment: Alignment.center,
                              child: Container(
                                height: 123,
                                padding: EdgeInsets.only(left: 16),
                                child: ListView.builder(
                                  itemCount: 5,
                                  clipBehavior: Clip.none,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          current = index;
                                        });

                                        if (index == 0) {
                                          NavigationService()
                                              .navigateWithTransition(
                                            CustomSearch(),
                                            duration:
                                                Duration(milliseconds: 600),
                                            transition: NavigationTransition
                                                .LeftToRighttWithFade,
                                          );
                                        } else if (index == 1) {
                                          NavigationService()
                                              .navigateWithTransition(
                                            AddProductView(),
                                            duration:
                                                Duration(milliseconds: 600),
                                            transition: NavigationTransition
                                                .LeftToRight,
                                          );
                                        } else if (index == 2) {
                                          NavigationService()
                                              .navigateWithTransition(
                                            EditProductView(),
                                            duration:
                                                Duration(milliseconds: 600),
                                            transition: NavigationTransition
                                                .LeftToRighttWithFade,
                                          );
                                        } else if (index == 3) {
                                          NavigationService()
                                              .navigateWithTransition(
                                            SalesReportView(),
                                            duration:
                                                Duration(milliseconds: 600),
                                            transition: NavigationTransition
                                                .LeftToRighttWithFade,
                                          );
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          OperationCard(
                                              key: index == 1
                                                  ? servicesKey
                                                  : Key("OperationCard$index"),
                                              operation: cool[index],
                                              selectedIcon: icons[index],
                                              isSelected: current == index,
                                              context: this),
                                          SizedBox(width: 16),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            /////// Locked Section incase pro version is not bought
                            model.freeServices
                                ? Container()
                                : !model.isBusyGettingTime
                                    ? !model.isSubscriptionExpired
                                        ? ServiceLocked(
                                            maxwidth: maxwidth,
                                            model: model,
                                            themeManager: themeManager)
                                        : Container()
                                    : ServiceLocked(
                                        maxwidth: maxwidth,
                                        themeManager: themeManager,
                                        isUsingProgressBar: true,
                                        text: "Please Wait",
                                      ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            key: transactionHistoryKey,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 16, bottom: 13),
                                    child:
                                        Headings(text: "Transaction History"),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      var data = await model
                                          .showAllDailyTransactions();
                                      if (data != null && data.length != 0)
                                        NavigationService()
                                            .navigateToView(CustomSearch(
                                          recievedData: data,
                                          headingText: "Daily Transactions",
                                        ));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 0, bottom: 13, right: 20),
                                      child: Headings(
                                        text: "View all",
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (model.isBusy)
                                Container(
                                  height: 150,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          themeManager.isDarkMode
                                              ? Colors.white
                                              : Colors.blue),
                                    ),
                                  ),
                                )
                              else if (model.lastTenTransactionList == null ||
                                  model.lastTenTransactionList.length == 0)
                                Container(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 30),
                                    child: Center(
                                        child: Text(
                                      "No transaction performed yet. Go to the Scanner page and perform any transaction to view transaction history.",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          color: themeManager.isDarkMode
                                              ? Colors.white54
                                              : Colors.black54),
                                    )))
                              else if (model.lastTenTransactionList.isNotEmpty)
                                ListView.builder(
                                  // key: transactionHistoryKey,
                                  itemCount:
                                      model.lastTenTransactionList.length,
                                  reverse: true,
                                  physics: ClampingScrollPhysics(),
                                  padding: EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                  ),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    //// From Global component Folder
                                    return TransactionTile(
                                        themeManager: themeManager,
                                        data:
                                            model.lastTenTransactionList[index],
                                        maxwidth: maxwidth);
                                  },
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          )),
    );
  }
}

class SubscriptionTimeLeftText extends ViewModelWidget<HomeViewModel> {
  const SubscriptionTimeLeftText({
    Key key,
    @required this.themeManager,
    this.futureBuilderKey,
  }) : super(key: key);
  final GlobalKey futureBuilderKey;
  final ThemeManager themeManager;
  ///// if render issue arises then there is an issue with subString calculation

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return FutureBuilder<DateTime>(
        key: futureBuilderKey,
        future: model.getCurrentTime(),
        initialData: model.currentTime,
        // ignore: missing_return
        builder: (context, snapshot) {
          print(snapshot.data);
          // if (snapshot.connectionState != ConnectionState.done) {
          //   print('project snapshot data is: ${snapshot.data}');
          //   return Text(
          //     "loading",
          //     style: TextStyle(color: Colors.white),
          //   );
          // } else
          if (snapshot.hasData ||
              snapshot.connectionState == ConnectionState.done) {
            /* below text needs to be updated every 10 seconds or so */

            return Text(
              model.daysLeft.inDays < 0
                  ? (model.daysLeft.inDays < -9
                      ? model.daysLeft.inDays.toString().substring(1) +
                          " days " +
                          (model.daysLeft.inHours.remainder(24) < -9
                              ? (model.daysLeft.inHours.remainder(24))
                                      .toString()
                                      .substring(1) +
                                  " hours"
                              : (model.daysLeft.inHours.remainder(24))
                                      .toString()
                                      .substring(
                                          model.daysLeft.inHours.remainder(24) < 0
                                              ? 1
                                              : 0) +
                                  " hour")
                      : model.daysLeft.inDays.toString().substring(1) +
                          " day " +
                          (model.daysLeft.inHours.remainder(24) < -9
                              ? (model.daysLeft.inHours.remainder(24))
                                      .toString()
                                      .substring(1) +
                                  " hours"
                              : (model.daysLeft.inHours.remainder(24))
                                      .toString()
                                      .substring(
                                          model.daysLeft.inHours.remainder(24) < 0 ? 1 : 0) +
                                  " hour"))
                  : model.daysLeft.inHours < -9
                      ? model.daysLeft.toString().substring(1, 3) +
                          " hours " +
                          (model.daysLeft.inMinutes <= -60
                              ? model.daysLeft.inMinutes.remainder(60).toString().substring(1, 3) + " min"
                              : model.daysLeft.inMinutes < -9
                                  ? model.daysLeft.inMinutes.remainder(60).toString().substring(1, 3) + " mins"
                                  : model.daysLeft.inMinutes.remainder(60).toString().substring(1, 2) + " min")
                      : model.daysLeft.toString().substring(1, 2) +
                          " hour " +
                          (model.daysLeft.inMinutes <= -60
                              ? (model.daysLeft.inMinutes.remainder(60) < -9
                                  ? model.daysLeft.inMinutes.remainder(60).toString().substring(1, 3) + " mins"
                                  : model.daysLeft.inMinutes >= -9 && model.daysLeft.inMinutes <= -0
                                      ? model.daysLeft.inMinutes.toString().substring(1) + " min"
                                      : "0 min")
                              : model.daysLeft.inMinutes < -9
                                  ? model.daysLeft.inMinutes.toString().substring(1, 3) + " mins"
                                  : model.daysLeft.inMinutes >= -9 && model.daysLeft.inMinutes < 0
                                      ? model.daysLeft.inMinutes.toString().substring(1) + " min"
                                      : "0 min"),
              style: TextStyle(
                  color:
                      themeManager.isDarkMode ? Colors.white54 : Colors.black54,
                  fontWeight: FontWeight.w500),
            );
          } else if (snapshot.hasError) {
            print("samosas" + snapshot.error.toString());
            return ProgressBar();
          } else {
            print("state " + snapshot.connectionState.toString());
            return ProgressBar();
          }
        });
  }
}

class ServiceLocked extends StatelessWidget {
  const ServiceLocked(
      {Key key,
      @required this.maxwidth,
      @required this.themeManager,
      this.isUsingProgressBar,
      this.text,
      this.model})
      : super(key: key);

  final double maxwidth;
  final ThemeManager themeManager;
  final bool isUsingProgressBar;
  final String text;
  final model;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 130,
          width: maxwidth,
          alignment: Alignment.center,
          color: themeManager.isDarkMode ? Colors.black54 : Colors.white60,
          child: GestureDetector(
            onTap: () async {
              if (!(isUsingProgressBar ?? false))
                model.showPurchaseSubscriptionBottomSheet();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isUsingProgressBar ?? false
                    ? ProgressBar()
                    : Icon(
                        Icons.lock,
                        size: 40,
                        color: themeManager.isDarkMode
                            ? Colors.white70
                            : Colors.black87,
                      ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  text ?? "Pro version required",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: themeManager.isDarkMode
                          ? Colors.white60
                          : Colors.black54),
                ),
                Text(
                  isUsingProgressBar == null ? "Tap here to buy" : "",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.blue),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 20,
        width: 20,
        child: Center(child: CircularProgressIndicator()));
  }
}

class GreetingText extends StatelessWidget {
  const GreetingText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentHour = DateTime.now().hour;
    return Headings(
        text: currentHour >= 5 && currentHour <= 12
            ? "Good Morning"
            : currentHour >= 12 && currentHour <= 18
                ? "Good Afternoon"
                : "Good Evening");
  }
}

class ProfileMenuText extends StatelessWidget {
  const ProfileMenuText({
    Key key,
    @required this.isMenuOpened,
    @required this.themeManager,
    @required this.text,
    @required this.enableBottomBorder,
    this.icons,
  }) : super(key: key);
  final Icon icons;
  final bool enableBottomBorder;
  final String text;
  final bool isMenuOpened;
  final ThemeManager themeManager;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5, top: 5, left: 10),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: enableBottomBorder
                      ? (themeManager.isDarkMode
                          ? Colors.black12
                          : Colors.white10)
                      : Colors.transparent))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icons.icon,
              size: !isMenuOpened ? 20 : 0,
              color: themeManager.isDarkMode ? Colors.black54 : Colors.white),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            overflow: TextOverflow.clip,
            style: GoogleFonts.inter(
                fontSize: !isMenuOpened ? 20 : 0,
                color:
                    themeManager.isDarkMode ? Colors.black54 : Colors.white54,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class OperationCard extends StatefulWidget {
  final String operation;
  final Icon selectedIcon;
  final _HomeViewState context;
  final bool isSelected;
  OperationCard(
      {Key key,
      this.operation,
      this.selectedIcon,
      this.isSelected,
      this.context})
      : super(key: key);

  @override
  _OperationCardState createState() => _OperationCardState();
}

class _OperationCardState extends State<OperationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: 123,
        height: 123,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 5,
                offset: Offset(8.0, 8.0))
          ],
          gradient: LinearGradient(tileMode: TileMode.clamp, colors: <Color>[
            !widget.isSelected
                ? (getThemeManager(context).isDarkMode
                    ? Colors.white12
                    : Colors.white)
                : Colors.indigo,
            !widget.isSelected
                ? (getThemeManager(context).isDarkMode
                    ? Colors.white12
                    : Colors.white)
                : Colors.blue
          ]),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.selectedIcon.icon,
              color: getThemeManager(context).isDarkMode
                  ? Colors.white
                  : (widget.isSelected ? Colors.white : Colors.blue),
              size: 40,
            ),
            SizedBox(
              height: 9,
            ),
            Text(
              widget.operation,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: getThemeManager(context).isDarkMode
                      ? Colors.white
                      : (widget.isSelected ? Colors.white : Colors.blue)),
            )
          ],
        ),
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  double radius = 20, tw = 20, th = 10; //tw & th = triangle width & height

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, th + radius);
    path.arcToPoint(Offset(size.width - radius, th),
        radius: Radius.circular(radius), clockwise: false);
    path.lineTo(radius + 90 + tw, th);
    path.lineTo(radius + 90 + tw / 2,
        0); //in these lines, the 10 is to have a space of 10 between the top-left corner curve and the triangle
    path.lineTo(radius + 90, th);
    path.lineTo(radius, th);
    path.arcToPoint(Offset(0, th + radius),
        radius: Radius.circular(radius), clockwise: false);
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

// FutureBuilder(
//                                                   future:
//                                                       model.getCurrentTime(),
//                                                   builder: (context, snapshot) {
//                                                     // print(snapshot.data);

//                                                     if (snapshot.hasData) {
//                                                       /* below text needs to be updated every 5 mins or so */
//                                                       return Text(
//                                                         model.daysLeft
//                                                             .toString()
//                                                             .substring(1, 6),
//                                                         style: TextStyle(
//                                                             color: themeManager
//                                                                     .isDarkMode
//                                                                 ? Colors.white54
//                                                                 : Colors
//                                                                     .black54,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w500),
//                                                       );
//                                                     } else
//                                                       return Container(
//                                                           height: 20,
//                                                           width: 20,
//                                                           child: Center(
//                                                               child:
//                                                                   CircularProgressIndicator()));
//                                                   }))
