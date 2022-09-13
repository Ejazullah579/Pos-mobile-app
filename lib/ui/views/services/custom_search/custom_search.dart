import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pro1/models/transaction.dart';
import 'package:pro1/ui/components/section_heading.dart';
import 'package:pro1/ui/components/transaction_tile.dart';
import 'package:pro1/ui/views/search_result/search_result_view_model.dart';
import 'package:pro1/ui/views/services/custom_search/custom_search_viewmodel.dart';
import 'package:stacked/stacked.dart';

import 'package:stacked_themes/stacked_themes.dart';

// ignore: must_be_immutable
class CustomSearch extends StatelessWidget {
  List<Transaction> recievedData;
  String headingText;
  String type;
  CustomSearch({Key key, this.recievedData, this.headingText})
      : super(key: key);

  // final SearchService searchService = locator<SearchService>();
  // final GlobalService globalService = locator<GlobalService>();
  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context);
    final maxheight = MediaQuery.of(context).size.height;
    final maxwidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => CustomSearchViewModel(),
        onModelReady: (model) {
          if (recievedData != null) {
            model.findDateIndexes(transactionList: recievedData);
          }
        },
        builder: (context, model, child) => recievedData != null
            ? Scaffold(
                floatingActionButton: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FloatingActionButton(
                    child: Text("Back"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: ListView.builder(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                    itemCount: recievedData.length,
                    itemBuilder: (context, index) {
                      if (index == 0 ||
                          model.dateHeadingsIndexes.contains(index))
                        return Column(
                          children: [
                            index == 0
                                ? SectionHeading(
                                    text: headingText,
                                  )
                                : Container(),
                            SectionHeading(
                              text: recievedData[index]
                                  .date
                                  .toString()
                                  .substring(0, 10),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TransactionTile(
                                themeManager: themeManager,
                                data: recievedData[index],
                                maxwidth: maxwidth)
                          ],
                        );
                      else
                        return TransactionTile(
                            themeManager: themeManager,
                            data: recievedData[index],
                            maxwidth: maxwidth);
                    }),
              )
            : Scaffold(
                backgroundColor:
                    themeManager.isDarkMode ? Colors.black : Colors.white,
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: maxheight * 0.6,
                      pinned: false,
                      floating: false,
                      leading: Container(),
                      flexibleSpace: Container(
                        alignment: Alignment.bottomCenter,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                stops: [0.0, 0.5, 0.7],
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
                          children: [
                            ListView(
                              shrinkWrap: true,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 0),
                                    child: Lottie.asset(
                                      "assets/lottie/transaction-history.json",
                                      height: maxheight * 0.3,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 10, right: 10),
                                  child: Text(
                                    "Inorder to Generate a sales report, please select a date range to get report. You can also view each day sale report by pressing the apply button only",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: themeManager.isDarkMode
                                            ? Colors.white70
                                            : Colors.black87),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      DateSelector(
                                        themeManager: themeManager,
                                        model: model,
                                        heading: "From",
                                      ),
                                      DateSelector(
                                        themeManager: themeManager,
                                        model: model,
                                        heading: "To",
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 43,
                                  width: 200,
                                  margin: EdgeInsets.only(
                                      top: 20, left: 50, right: 50),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: FlatButton(
                                      onPressed: () {
                                        model.showAllDailyTransactions();
                                      },
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      child: Text(
                                        "Apply",
                                        style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      )),
                                )
                              ],
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 70,
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
                        : model.transactionList == null
                            ? SliverToBoxAdapter(
                                child: Container(),
                              )
                            : model.transactionList.length == 0
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
                                          if (model.dateHeadingsIndexes
                                              .contains(index)) {
                                            return Column(
                                              children: [
                                                SectionHeading(
                                                  text: model
                                                      .transactionList[index]
                                                      .date
                                                      .toString()
                                                      .substring(0, 10),
                                                ),
                                                SizedBox(height: 10),
                                                TransactionTile(
                                                  themeManager: themeManager,
                                                  maxwidth: maxwidth,
                                                  data: model
                                                      .transactionList[index],
                                                ),
                                              ],
                                            );
                                          } else {
                                            return TransactionTile(
                                              themeManager: themeManager,
                                              maxwidth: maxwidth,
                                              data:
                                                  model.transactionList[index],
                                            );
                                          }
                                        },
                                        addAutomaticKeepAlives: false,
                                        addRepaintBoundaries: false,
                                        childCount:
                                            model.transactionList.length,
                                      ),
                                    ),
                                  )
                  ],
                ),
              ));
  }
}

class DateSelector extends StatelessWidget {
  const DateSelector({
    Key key,
    @required this.themeManager,
    this.heading,
    this.model,
  }) : super(key: key);

  final ThemeManager themeManager;
  final String heading;
  final model;

  @override
  Widget build(BuildContext context) {
    final maxWidt = MediaQuery.of(context).size.width;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            model.selectDate(context: context, field: heading.toLowerCase());
            // if(heading.toLowerCase()=="from")
            // if(heading.toLowerCase()=="from")
          },
          child: Material(
            borderRadius: BorderRadius.circular(30),
            color: themeManager.isDarkMode ? Colors.white12 : Colors.white,
            elevation: 5,
            child: Container(
                width: maxWidt * 0.4,
                height: 30,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(
                    heading == "From"
                        ? model.fromText ?? "From"
                        : heading == "To"
                            ? model.toText ?? "To"
                            : "Value",
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: themeManager.isDarkMode
                            ? Colors.white
                            : Colors.black54,
                        decoration: TextDecoration.none),
                  ),
                )),
          ),
        )
      ],
    );
  }
}
