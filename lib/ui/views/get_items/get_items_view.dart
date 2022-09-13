import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/ui/components/headings.dart';
import 'package:pro1/ui/components/popUpInfo.dart';
import 'package:pro1/ui/components/walk_through/walkThrough.dart';
import 'package:pro1/ui/components/walk_through/walkthrough_image.dart';
import 'package:pro1/ui/views/get_items/get_item_viewmodel.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'components/inc_dic_buttom.dart';

// ignore: must_be_immutable
class GetItemsView extends StatelessWidget {
  GetItemsView({Key key}) : super(key: key);

  double top = 150.0;

  final GlobalKey flashKey = GlobalKey();

  final GlobalKey scannerKey = GlobalKey();

  final GlobalKey bottomDrawerKey = GlobalKey();

  final GlobalKey deleteKey = GlobalKey();

  final GlobalKey itemsScannedKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ////////// Variables Local Scope /////
    final themeManager = getThemeManager(context);
    final maxwidth = MediaQuery.of(context).size.width;
    final maxheight = MediaQuery.of(context).size.height;
    ////////////// Main build return /////////
    return SafeArea(
        child: ViewModelBuilder.reactive(
      viewModelBuilder: () => GetItemViewModel(),
      onModelReady: (model) async {
        await model.handleReadyLogic();
      },
      builder: (context, GetItemViewModel model, child) => Scaffold(
          backgroundColor: Colors.black,
          body: WalkThrough(
            startWalkthrough: model.showWalkThrough,
            onComplete: () => model.setWalkThrough(),
            data: [
              WalkThroughData(
                pinchHoleRadius: BorderRadius.circular(10),
                infoType: InfoType.Image,
                image: WalkthroughImage(
                    imageSize: 280,
                    showText: true,
                    text: "Lets walk you through this scrren",
                    assetImage: "assets/lottie/get-started.json"),
              ),
              WalkThroughData(
                key: bottomDrawerKey,
                pinchHoleRadius: BorderRadius.circular(10),
                infoType: InfoType.Image,
                image: WalkthroughImage(
                    allowPinchHole: true,
                    imageSize: 200,
                    text: "Swipe up to open list drawer",
                    assetImage: "assets/lottie/swipe-up.json"),
              ),
              WalkThroughData(
                  key: flashKey,
                  shouldCutChildHole: false,
                  hintText: "Press to turn on/off flash ",
                  location: HintTextLocation.Right),
              WalkThroughData(
                key: scannerKey,
                shouldCutChildHole: false,
                infoType: InfoType.Image,
                image: WalkthroughImage(
                    imageType: ImageType.image,
                    alignment: Alignment.bottomCenter,
                    textLocation: TextLocation.Top,
                    text: "Swipe right to delete an item",
                    assetImage: "assets/images/delete-product.png"),
              ),
              WalkThroughData(
                  key: deleteKey,
                  hintText: "Press this to delete all items at once",
                  location: HintTextLocation.Top),
              WalkThroughData(
                  key: itemsScannedKey,
                  hintText: "This shows total number of items scanned",
                  location: HintTextLocation.Top),
            ],
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              physics: PageScrollPhysics(),
              clipBehavior: Clip.hardEdge,
              shrinkWrap: true,
              slivers: [
                ///////////////////////////////////////////////////////////////////
                ////////////////////////// Camera Container //////////////////////
                /////////////////////////////////////////////////////////////////
                Camera(
                    flashKey: flashKey,
                    maxheight: maxheight,
                    top: top,
                    maxwidth: maxwidth,
                    model: model,
                    themeManager: themeManager),
                //////////////////////////////////////////////////////////////////////////
                ////////////////////////////// For product List /////////////////////////
                /////////////////////////// Widget Defined Below ///////////////////////
                //////////////////////////////////////////// //////////////////////////
                SliverList(
                  key: bottomDrawerKey,
                  delegate: SliverChildBuilderDelegate(
                    // ignore: missing_return
                    (context, index) {
                      ///////////////// For Dismising single product

                      ////////////// WHen product length is 0 to display "no item scanned" msg
                      if (index == 0 && model.productList.length == 0) {
                        return Container(
                          color: Colors.black,
                          child: StyledContainer(
                              themeManager: themeManager,
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 15, bottom: 15),
                              topRounded: true,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ItemHeadingWithNumberOfProducts(
                                        deleteButtonKey: deleteKey,
                                        itemScannedKey: itemsScannedKey,
                                        themeManager: themeManager,
                                        model: model),
                                  ),
                                  Center(
                                      child: Text(
                                    "No products scanned yet!",
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ],
                              )),
                        );
                        ////////////// WHen product length is 1 to display the product info and calculate bill button
                      } else if (index == 0 && model.productList.length == 1)
                        return Container(
                          color: Colors.black,
                          child: StyledContainer(
                            themeManager: themeManager,
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 15),
                            topRounded: true,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ItemHeadingWithNumberOfProducts(
                                    deleteButtonKey: deleteKey,
                                    itemScannedKey: itemsScannedKey,
                                    themeManager: themeManager,
                                    model: model),
                              ),
                              model.productList.length == 0
                                  ? Container()
                                  : dismissibleProduct(
                                      model, index, maxwidth, themeManager),
                              CalculateBillButton(
                                model: model,
                                maxwidth: maxwidth,
                              )
                            ]),
                          ),
                        );
                      ////////////// WHen product length is greater than 1 to display the product info and calculate bill button
                      else {
                        if (index == 0)
                          return Container(
                            color: Colors.black,
                            child: StyledContainer(
                              themeManager: themeManager,
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 15),
                              topRounded: true,
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ItemHeadingWithNumberOfProducts(
                                      itemScannedKey: itemsScannedKey,
                                      deleteButtonKey: deleteKey,
                                      themeManager: themeManager,
                                      model: model),
                                ),
                                model.productList.length == 0
                                    ? Container()
                                    : dismissibleProduct(
                                        model, index, maxwidth, themeManager)
                              ]),
                            ),
                          );
                        else if (index < (model.productList.length - 1))
                          return StyledContainer(
                            themeManager: themeManager,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: dismissibleProduct(
                                model, index, maxwidth, themeManager),
                          );
                        else if (index < (model.productList.length))
                          return StyledContainer(
                            themeManager: themeManager,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(children: [
                              model.productList.length == 0
                                  ? Container()
                                  : dismissibleProduct(
                                      model, index, maxwidth, themeManager),
                              CalculateBillButton(
                                  maxwidth: maxwidth, model: model)
                            ]),
                          );
                      }
                    },
                    childCount: model.productList.length + 1,
                  ),
                ),
              ],
            ),
          )),
    ));
  }

  Widget dismissibleProduct(GetItemViewModel model, int index, double maxwidth,
      ThemeManager themeManager) {
    return Dismissible(
      onDismissed: (direction) {
        model.removeProduct(index);
      },
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          ////// Function Defined Below Type: Dilogue
          final res = await model.removeProduct(index);
          return res;
        } else {
          return null;
        }
      },
      background: OnSwipeRight(),
      key: UniqueKey(),
      child: productCard(maxwidth, themeManager, model, index),
    );
  }

  Container productCard(
      double maxwidth, ThemeManager themeManager, model, int index) {
    return Container(
      height: 76,
      width: maxwidth,
      margin: EdgeInsets.only(
        bottom: 13,
      ),
      padding: EdgeInsets.only(left: 24, right: 22, top: 12, bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: themeManager.isDarkMode ? Colors.white24 : Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(8.0, 8.0))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 57,
                width: 57,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("assets/images/fire.png"))),
              ),
              SizedBox(
                width: 13,
              ),
              Container(
                width: maxwidth * 0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Headings(
                        text: (model.productList[index].selfProduct.salePrice *
                                    model.productList[index].counter)
                                .toString() +
                            "\$"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        model.productList[index].selfProduct.productName,
                        overflow: TextOverflow.clip,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: themeManager.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              /////////// From local component folder
              IncDicButton(
                icon: Icon(Icons.remove),
                ontap: () {
                  model.decrementCounter(index);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Headings(
                  text: model.productList[index].counter.toString(),
                ),
              ),
              /////////// From local component folder
              IncDicButton(
                icon: Icon(Icons.add),
                ontap: () {
                  model.incrementCounter(index);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Container floatingButton(ThemeManager themeManager, model) {
    return Container(
      height: 50,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton.extended(
                icon: Icon(
                  Icons.save,
                ),
                backgroundColor:
                    themeManager.isDarkMode ? Colors.white10 : Colors.blue,
                label: Text("Get Bill"),
                onPressed: () async {
                  model.showRecipt(model);
                }),
          ),
          model.productList.length != null && model.productList.length > 0
              ? Positioned(
                  top: -7,
                  right: 0,
                  child: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeManager.isDarkMode
                            ? Colors.white24
                            : Colors.black45),
                    child: Center(
                        child: Text(model.productList.length.toString(),
                            style: TextStyle(color: Colors.white))),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class CalculateBillButton extends StatelessWidget {
  const CalculateBillButton({
    Key key,
    @required this.maxwidth,
    @required this.model,
  }) : super(key: key);

  final double maxwidth;
  final model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        height: 50,
        width: maxwidth,
        decoration: BoxDecoration(
            color: Colors.tealAccent[700],
            borderRadius: BorderRadius.circular(7)),
        child: TextButton(
          child: Text("Calculate Bill", style: TextStyle(color: Colors.white)),
          onPressed: () => model.showRecipt(model),
        ),
      ),
    );
  }
}

class StyledContainer extends StatelessWidget {
  const StyledContainer(
      {Key key,
      @required this.themeManager,
      @required this.child,
      this.topRounded = false,
      this.padding = EdgeInsets.zero})
      : super(key: key);

  final ThemeManager themeManager;
  final Widget child;
  final bool topRounded;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              tileMode: TileMode.clamp,
              colors: themeManager.isDarkMode
                  ? <Color>[Colors.grey[850], Colors.grey[850]]
                  : <Color>[Colors.indigo, Colors.blue]),
          borderRadius: !topRounded ?? false
              ? BorderRadius.zero
              : BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14))),
      child: child,
    );
  }
}

class ItemHeadingWithNumberOfProducts extends StatelessWidget {
  const ItemHeadingWithNumberOfProducts(
      {Key key,
      @required this.themeManager,
      @required this.itemScannedKey,
      @required this.deleteButtonKey,
      this.model})
      : super(key: key);

  final Key deleteButtonKey;
  final Key itemScannedKey;
  final ThemeManager themeManager;
  final model;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 35,
          child: GestureDetector(
              onTap: () {
                if (model.productList.length > 0) {
                  return model.removeAllProducts();
                }
              },
              child: Container(
                key: deleteButtonKey,
                height: 35,
                child: Icon(Icons.delete,
                    color: model.productList.length > 0
                        ? Colors.red
                        : Colors.white38),
              )),
        ),
        Text(
          "Scanned Items",
          style: GoogleFonts.openSans(color: Colors.white, fontSize: 20),
        ),
        Container(
          key: itemScannedKey,
          height: 35,
          width: 35,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: themeManager.isDarkMode ? Colors.white24 : Colors.black45),
          child: Center(
              child: Text(model.productList.length.toString(),
                  style: GoogleFonts.openSans(
                      color: model.productList.length == 0
                          ? Colors.white
                          : Colors.green,
                      fontWeight: FontWeight.w700))),
        ),
      ],
    );
  }
}

class OnSwipeRight extends StatelessWidget {
  const OnSwipeRight({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 13,
      ),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(20)),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}

/////////////////////////////////////////////////////////
////////// Camera For Qr Code scanner //////////////////
///////////////////////////////////////////////////////

// ignore: must_be_immutable
class Camera extends StatefulWidget {
  Camera(
      {Key key,
      @required this.maxheight,
      @required this.top,
      @required this.maxwidth,
      @required this.themeManager,
      @required this.flashKey,
      this.model})
      : super(key: key);

  final Key flashKey;
  final double maxheight;
  double top;
  final double maxwidth;
  final ThemeManager themeManager;
  final model;

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController qrController;
  Function qrHandler;

  @override
  void initState() {
    super.initState();
    void _onQRViewCreated(controller) {
      qrController = controller;
      qrController.scannedDataStream.listen((scanData) async {
        var isProductFound =
            await widget.model.addProduct(productId: scanData.code);
        // if (!isProductFound) {
        //   var result = await addProductNow(
        //       context: context, model: widget.model, productId: scanData);
        //   if (result is SelfProduct) {
        //     await widget.model.addProduct(selfProduct: result);
        //   }
        // }
        print("Scanned Data= " + scanData.code);
      });
      setState(() {});
    }

    qrHandler = _onQRViewCreated;
  }

  @override
  void didChangeDependencies() async {
    await Future.delayed(Duration(seconds: 5));
    qrController.pauseCamera();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        expandedHeight: widget.maxheight - 60,
        flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          widget.top = constraints.biggest.height;
          return Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                      height: widget.maxheight - 60,
                      color: widget.themeManager.isDarkMode
                          ? Colors.black
                          : Colors.white,
                      width: widget.maxwidth,
                      child: VisibilityDetector(
                        key: Key("QrScannerKey"),
                        onVisibilityChanged: (VisibilityInfo info) async {
                          // debugPrint("${info.visibleFraction} of my widget is visible");
                          if (info.visibleFraction <= 0.25) {
                            qrController.pauseCamera();
                            await Future.delayed(Duration(seconds: 3));
                            setState(() {});
                          } else {
                            qrController.resumeCamera();
                          }
                          // if (widget.controller.toString() == "null" ? false : true)
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: QRView(
                            key: qrKey,
                            // formatsAllowed: [
                            //   BarcodeFormat.upcA,
                            //   BarcodeFormat.upcE,
                            //   BarcodeFormat.ean13,
                            //   BarcodeFormat.ean8
                            // ],
                            overlay: QrScannerOverlayShape(
                              borderColor: Colors.red,
                              borderRadius: 10,
                              borderLength: 30,
                              borderWidth: 10,
                              cutOutSize: 150,
                            ),
                            onQRViewCreated: qrHandler,
                          ),
                        ),
                      ))),
              ////  Flash Button
              Positioned(
                top: 10,
                left: 20,
                child: Container(
                  padding: EdgeInsets.only(right: 35),
                  width: widget.maxwidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlashButton(
                          key: widget.flashKey, controller: qrController),
                      PopUpInfo(
                          iconColor: Colors.grey,
                          heroTag: "Scanner_info",
                          text:
                              "Note! \n\nThe scanner is not proefficient as the regular scanner. Its performance can be increased by using it with the flash on. Try turning on the flash and see the result."),
                    ],
                  ),
                ),
              ),
              widget.model.isSearching
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.red),
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
        }));
  }
}

////////////////////////////////////////////////////////////////////
////////// For Turing on/off Camera ///////////////////////////////
//////////////////////////////////////////////////////////////////

class PauseCamera extends StatefulWidget {
  PauseCamera({
    Key key,
    @required this.themeManager,
    this.isCameraOn,
    this.controller,
    this.setisCameraOn,
  }) : super(key: key);

  final ThemeManager themeManager;
  bool isCameraOn;
  final Function setisCameraOn;
  final QRViewController controller;

  @override
  _PauseCameraState createState() => _PauseCameraState();
}

class _PauseCameraState extends State<PauseCamera>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  GlobalService globalService = locator<GlobalService>();
  @override
  void initState() {
    _controller = new AnimationController(
        duration: Duration(milliseconds: 600), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCameraOn) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    return Container(
      height: 51,
      width: 55,
      child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          color: Colors.white12,
          onPressed: () {
            if (widget.isCameraOn) {
              widget.controller.pauseCamera();
              widget.setisCameraOn(false);
            } else if (!widget.isCameraOn) {
              widget.controller.resumeCamera();
              widget.setisCameraOn(true);
            }
            setState(() {
              widget.isCameraOn ? _controller.forward() : _controller.reverse();
            });
          },
          child: AnimatedIcon(
            progress: _controller,
            icon: AnimatedIcons.play_pause,
            color: Colors.white,
          )),
    );
  }
}

///////////////////////////////////////////////
///       For Turing on/off Flash         ////
/////////////////////////////////////////////

// ignore: must_be_immutable
class FlashButton extends StatefulWidget {
  FlashButton({
    Key key,
    this.controller,
  }) : super(key: key);
  var controller;

  @override
  _FlashButtonState createState() => _FlashButtonState();
}

class _FlashButtonState extends State<FlashButton> {
  final GlobalService globalService = locator<GlobalService>();
  var isOnFlash = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      width: 55,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: Colors.white12),
      child: IconButton(
        color: Colors.white,
        icon: Icon(Icons.lightbulb,
            color: isOnFlash ? Colors.white : Colors.white30, size: 40),
        onPressed: () {
          setState(() {
            isOnFlash = !isOnFlash;
          });
          widget.controller.toggleFlash();
        },
      ),
    );
  }
}
