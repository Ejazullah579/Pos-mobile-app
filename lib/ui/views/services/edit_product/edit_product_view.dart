import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pro1/ui/components/MainButtons.dart';
import 'package:pro1/ui/components/search_product_searchbar.dart';
import 'package:pro1/ui/views/services/add_product/add_product_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'edit_product_viewmodel.dart';

// ignore: must_be_immutable
class EditProductView extends StatefulWidget {
  EditProductView({Key key}) : super(key: key);

  @override
  _EditProductViewState createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  TextEditingController _textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context);
    final maxheight = MediaQuery.of(context).size.height;
    final maxwidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => EditProductViewModel(),
        // onModelReady: (model) => productIdController.text = model.productId,
        builder: (context, model, child) => Scaffold(
              backgroundColor:
                  themeManager.isDarkMode ? Colors.black : Colors.white,
              floatingActionButton: FloatingMenu(
                  controller: _controller,
                  themeManager: themeManager,
                  maxwidth: maxwidth,
                  model: model,
                  maxheight: maxheight),
              body: GestureDetector(
                  onTap: () {
                    if (!FocusScope.of(context).hasPrimaryFocus) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: CustomScrollView(
                    clipBehavior: Clip.none,
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        expandedHeight: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? maxheight * 0.51
                            : maxheight,
                        leading: Container(),
                        flexibleSpace: Container(
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? maxheight * 0.51
                              : maxheight,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  stops: [0.0, 0.7, 0.8],
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.lightBlue,
                                    !themeManager.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    themeManager.isDarkMode
                                        ? Colors.black
                                        : Colors.white
                                  ])),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  Container(
                                    height: maxheight * 0.25,
                                    child: Container(
                                      child: Lottie.asset(
                                        'assets/lottie/search.json',
                                        height: maxheight * 0.25,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Center(
                                      child: Text("Search Product",
                                          style: GoogleFonts.patuaOne(
                                            fontSize: 35,
                                            letterSpacing: 3.5,
                                            color: !themeManager.isDarkMode
                                                ? Colors.black
                                                : Colors.white,
                                          )),
                                    ),
                                  ),
                                  SearchProductSearchField(
                                    model: model,
                                    controller: _textController,
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 80,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: !themeManager.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          children: [
                                            Icon(Icons.arrow_back,
                                                color: themeManager.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black),
                                            SizedBox(width: 5),
                                            Text(
                                              "back",
                                              style: TextStyle(
                                                  color: themeManager.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      model.isBusy
                          ? SliverToBoxAdapter(
                              child: Container(
                                height: 47,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: FittedBox(
                                    child: CircularProgressIndicator(
                                      backgroundColor: themeManager.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              themeManager.isDarkMode
                                                  ? Colors.white
                                                  : Colors.blue),
                                      strokeWidth: 5,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : model.selfProductList == null
                              ? SliverToBoxAdapter(
                                  child: Container(),
                                )
                              : model.selfProductList.length == 0
                                  ? SliverToBoxAdapter(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Center(
                                          child: Text(
                                            "No Transactions Found",
                                            style: GoogleFonts.inter(
                                                color: themeManager.isDarkMode
                                                    ? Colors.white70
                                                    : Colors.black87),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SliverPadding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      sliver: SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          // ignore: missing_return
                                          (BuildContext context, int index) {
                                            return Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 13),
                                              padding: EdgeInsets.only(
                                                  left: 8,
                                                  right: 8,
                                                  top: 12,
                                                  bottom: 12),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: themeManager.isDarkMode
                                                      ? Colors.white12
                                                      : Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 10,
                                                        spreadRadius: 2,
                                                        offset:
                                                            Offset(8.0, 8.0))
                                                  ]),
                                              width: maxwidth,
                                              child: Column(
                                                children: [
                                                  SelfProductTile(
                                                    title: "Product ID",
                                                    value: model
                                                        .selfProductList[index]
                                                        .productId,
                                                  ),
                                                  SelfProductTile(
                                                    title: "Product Name",
                                                    value: model
                                                        .selfProductList[index]
                                                        .productName,
                                                  ),
                                                  SelfProductTile(
                                                    title: "Purchase Price ",
                                                    value: model
                                                        .selfProductList[index]
                                                        .purchasePrice
                                                        .toString(),
                                                  ),
                                                  SelfProductTile(
                                                    title: "Sales Price ",
                                                    value: model
                                                        .selfProductList[index]
                                                        .salePrice
                                                        .toString(),
                                                  ),
                                                  SelfProductTileActionButtons(
                                                    model: model,
                                                    index: index,
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          childCount:
                                              model.selfProductList.length,
                                        ),
                                      ),
                                    )
                    ],
                  )),
            ));
  }
}

class FloatingMenu extends StatelessWidget {
  const FloatingMenu({
    Key key,
    @required AnimationController controller,
    @required this.themeManager,
    @required this.maxwidth,
    @required this.maxheight,
    this.model,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;
  final ThemeManager themeManager;
  final double maxwidth;
  final double maxheight;
  final model;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Container(
        height: 100 * _controller.value + 60,
        width: 60,
        decoration: BoxDecoration(
            color: themeManager.isDarkMode ? Colors.white10 : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0.5, 0.5),
                  blurRadius: 5,
                  spreadRadius: 0.5),
            ]),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 90 * _controller.value,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.black87,
                              builder: (context) => GenerateAllQrCodes(
                                  model: model, themeManager: themeManager));
                        },
                        child: Tooltip(
                          message: "Generate All products Qr images",
                          preferBelow: false,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.qr_code_rounded,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => model.deleteAllSelfProducts(),
                        child: Tooltip(
                          message: "Delete all of your Products",
                          preferBelow: false,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.red.shade600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_controller.isCompleted) {
                  _controller.reverse();
                } else if (_controller.isDismissed) {
                  _controller.forward();
                }
              },
              child: Tooltip(
                message: "More Options",
                preferBelow: false,
                child: Container(
                  height: 60,
                  width: 60,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: AnimatedIcon(
                      icon: AnimatedIcons.menu_arrow, progress: _controller),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GenerateAllQrCodes extends StatelessWidget {
  const GenerateAllQrCodes({
    Key key,
    @required this.model,
    @required this.themeManager,
  }) : super(key: key);

  final model;
  final ThemeManager themeManager;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => EditProductViewModel(),
        onModelReady: (thisModel) =>
            thisModel.selfProductList = model.selfProductList,
        builder: (context, model, child) {
          return WillPopScope(
            onWillPop: () {},
            child: AlertDialog(
                insetPadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.all(0),
                backgroundColor: Colors.transparent,
                content: Container(
                  width: 300,
                  height: 330,
                  decoration: BoxDecoration(
                      color:
                          themeManager.isDarkMode ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white10,
                            blurRadius: 10,
                            spreadRadius: 5)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      model.isStarted
                          ? Container(
                              margin: EdgeInsets.only(top: 20),
                              height: 150,
                              width: 150,
                              color: Colors.transparent,
                              child: Stack(
                                children: [
                                  model.isComplete
                                      ? Center(
                                          child: Text(
                                          "Complete",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: themeManager.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black),
                                        ))
                                      : model.isInProgress
                                          ? Center(
                                              child: Text(
                                              (model.progress)
                                                  .toString()
                                                  .split(".")
                                                  .first,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: themeManager.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black),
                                            ))
                                          : Container(),
                                  Container(
                                    height: 200,
                                    width: 200,
                                    child: CircularProgressIndicator(
                                      value: model.progress / 100,
                                      strokeWidth: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "By pressing the start button, All the products Qr images that you added in the app will be generated in the internal storage",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    color: themeManager.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                      SizedBox(height: 20),
                      model.isInProgress
                          ? Text("Please Wait")
                          : Container(
                              color: Colors.transparent,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: [
                                  ///// work on buttons
                                  MainButtons(
                                    buttontext: "Start",
                                    borderRadius: 50,
                                    // btnIcon: Icon(
                                    //   Icons.play_circle_fill,
                                    //   color: Colors.white,
                                    // ),
                                    buttonColor: Colors.blue,
                                    textColor: Colors.white,
                                    onpress: () => model.generateAllQrImages(),
                                  ),
                                  MainButtons(
                                    buttontext: "Back",
                                    borderRadius: 50,
                                    // btnIcon: Icon(
                                    //   Icons.play_circle_fill,
                                    //   color: Colors.white,
                                    // ),
                                    buttonColor: Colors.red,
                                    textColor: Colors.white,
                                    borderColor: Colors.red,
                                    onpress: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                )),
          );
        });
  }
}

class SelfProductTileActionButtons extends StatelessWidget {
  const SelfProductTileActionButtons({
    Key key,
    this.model,
    this.index,
  }) : super(key: key);
  final model;
  final int index;
  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context);
    final maxheight = MediaQuery.of(context).size.height;
    final maxwidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Tooltip(
            message: "Generate Qr image",
            preferBelow: false,
            child: Container(
              height: 30,
              width: 80,
              child: model.workingIndex == index
                  ? model.isBusyGeneratingQrcode
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                getThemeManager(context).isDarkMode
                                    ? Colors.white
                                    : Colors.blue),
                          ),
                        )
                      : RaisedButton(
                          onPressed: () {
                            model.generateQrCode(index);
                          },
                          color: Colors.orange,
                          child: Text(
                            "QrCode",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                  : RaisedButton(
                      onPressed: () {
                        model.generateQrCode(index);
                      },
                      color: Colors.orange,
                      child: Text(
                        "QrCode",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Tooltip(
            message: "Delete this Product",
            preferBelow: false,
            child: Container(
              height: 30,
              width: 75,
              child: model.workingIndex == index
                  ? model.isBusyDeletingProduct
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                getThemeManager(context).isDarkMode
                                    ? Colors.white
                                    : Colors.blue),
                          ),
                        )
                      : RaisedButton(
                          onPressed: () {
                            model.deleteSelfProduct(index: index);
                          },
                          color: Colors.red,
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                  : RaisedButton(
                      onPressed: () {
                        model.deleteSelfProduct(index: index);
                      },
                      color: Colors.red,
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Tooltip(
            message: "Edit this Product",
            preferBelow: false,
            child: Container(
              height: 30,
              width: 75,
              child: ElevatedButton(
                onPressed: () async {
                  var result = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierColor: Colors.black87,
                      builder: (context) => AlertDialog(
                          insetPadding: EdgeInsets.all(0),
                          contentPadding: EdgeInsets.all(0),
                          backgroundColor: Colors.transparent,
                          actions: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context, null),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 7),
                                margin: EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text("cancel",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                          content: Container(
                            width: maxwidth * 0.9,
                            height: maxheight * 0.55,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white10,
                                      blurRadius: 10,
                                      spreadRadius: 5),
                                ]),
                            child: AddProductView(
                              productRecieved: model.selfProductList[index],
                            ),
                          ))).then((value) {
                    if (value != null) model.updateCurrentProduct(index, value);
                  });
                },
                child: Text(
                  "Edit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SelfProductTile extends StatelessWidget {
  const SelfProductTile({
    Key key,
    this.title,
    this.value,
    this.index,
  }) : super(key: key);
  final String title;
  final String value;
  final int index;
  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context).isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        // mainAxisAlignment:
        //     MainAxisAlignment
        //         .spaceBetween,
        children: [
          Expanded(
              child: Text(
            title,
            style: TextStyle(color: themeManager ? Colors.white : Colors.black),
          )),
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: Text(
            value,
            style: TextStyle(color: themeManager ? Colors.white : Colors.black),
          )),
        ],
      ),
    );
  }
}
