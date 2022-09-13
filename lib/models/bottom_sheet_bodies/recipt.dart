import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pro1/utils/pdf.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'package:stacked_themes/stacked_themes.dart';

class FloatingBoxBottomSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  FloatingBoxBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  _FloatingBoxBottomSheetState createState() => _FloatingBoxBottomSheetState();
}

class _FloatingBoxBottomSheetState extends State<FloatingBoxBottomSheet>
    with SingleTickerProviderStateMixin {
  final DateTime now = new DateTime.now();
  DateTime date;
  ScrollController _scrollController = ScrollController();
  AnimationController _controller;
  double offset = 0;
  @override
  void initState() {
    date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    _controller = AnimationController(
        vsync: this,
        upperBound: 90,
        lowerBound: 0,
        duration: Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      })
      ..forward();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset > offset) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
        setState(() {
          offset = _scrollController.offset;
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    // final maxheight = MediaQuery.of(context).size.height;
    final model = widget.request.customData;
    return Container(
        width: maxWidth,
        height: 125 + model.productList.length >= 1 &&
                model.productList.length <= 10
            ? model.productList.length * 35.0 + 190
            : 10.0 * 35.0 + 130,
        decoration: BoxDecoration(
            color: getThemeManager(context).isDarkMode
                ? Colors.black87
                : Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Stack(
              children: [
                NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                    return;
                  },
                  child: ListView(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: 10, left: 15, right: 15, bottom: 10),
                          decoration: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Center(
                            child: Column(
                              children: [
                                Text(model.currentUser.shopName.toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poly(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                                Text(
                                    DateFormat('hh:mm a- yyyy-MM-dd')
                                        .format(now),
                                    style: GoogleFonts.inter(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
//////////////////////////////////////////////////////////////////
//////////////////////// List of Scanned Products ///////////////
////////////////////////////////////////////////////////////////
                        Container(
                            height: 30 + model.productList.length >= 1 &&
                                    model.productList.length <= 10
                                ? model.productList.length * 35.0
                                : 10.0 * 30.0 + 70,
                            // margin: EdgeInsets.only(bottom: 10),
                            child: ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.only(
                                    bottom: model.productList.length >= 1 &&
                                            model.productList.length <= 7
                                        ? 0
                                        : model.productList.length >= 8 &&
                                                model.productList.length <= 10
                                            ? 20
                                            : 40,
                                    left: 15,
                                    right: 15),
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: model.productList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      height: 30,
                                      width: maxWidth,
                                      color: getThemeManager(context).isDarkMode
                                          ? (index % 2 == 0
                                              ? Colors.black26
                                              : Colors.transparent)
                                          : (index % 2 == 0
                                              ? Colors.black12
                                              : Colors.white),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: maxWidth * 0.65,
                                              child: Text(
                                                  "${index + 1}: " +
                                                      model
                                                          .productList[index]
                                                          .selfProduct
                                                          .productName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.inter(
                                                      color: getThemeManager(
                                                                  context)
                                                              .isDarkMode
                                                          ? Colors.white
                                                          : Colors.black)),
                                            ),
                                            Text(
                                                (model
                                                            .productList[index]
                                                            .selfProduct
                                                            .salePrice *
                                                        model.productList[index]
                                                            .counter)
                                                    .toString(),
                                                style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.blue))
                                          ]));
                                })),
/////////////////////////////////////////////////////////////
/////////////////////// Total Value ////////////////////////
///////////////////////////////////////////////////////////
                      ]),
                ),
                Positioned(
                  bottom: 0,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: AnimatedContainer(
                        curve: Curves.bounceOut,
                        duration: Duration(milliseconds: 300),
                        width: maxWidth,
                        height: _controller.value,
                        padding: EdgeInsets.only(right: 20, top: 5, bottom: 13),
                        decoration: BoxDecoration(
                            color: getThemeManager(context).isDarkMode
                                ? Colors.black38
                                : Colors.white24,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        child: ListView(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 6),
                                    child: Text(
                                      "Total :\t\t",
                                      style: GoogleFonts.inter(
                                          fontSize: 15,
                                          color: getThemeManager(context)
                                                  .isDarkMode
                                              ? Colors.white70
                                              : Colors.black54,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      model.globalService.applyDiscount &&
                                              model.globalService
                                                      .discountPercentage !=
                                                  0 &&
                                              model.globalService
                                                      .discountValue !=
                                                  0 &&
                                              model.globalService
                                                      .discountValue <
                                                  model.calculateTotal()
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5, bottom: 3),
                                              child: Text(
                                                "${model.calculateTotal()}",
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  color:
                                                      getThemeManager(context)
                                                              .isDarkMode
                                                          ? Colors.white70
                                                          : Colors.black54,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      Text(
                                          "${model.calculateDiscountedTotal()}",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 25,
                                              color: getThemeManager(context)
                                                      .isDarkMode
                                                  ? Colors.white
                                                  : Colors.black)),
                                    ],
                                  )
                                ])),
                            SizedBox(
                              height: 10,
                            ),
                            ////////////////// Actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Text(
                                          "Cancel",
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        writeOnPdf(model);
                                        await savePdf();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Text(
                                          "Save",
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => model.updateValues(date,
                                          model.calculateDiscountedTotal()),
                                      child: Container(
                                        alignment: Alignment.topRight,
                                        margin: EdgeInsets.only(left: 10),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Print",
                                              style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
