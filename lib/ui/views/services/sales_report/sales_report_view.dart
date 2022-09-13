import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/ui/views/services/sales_report/components/bar_chart.dart';
import 'package:pro1/ui/views/services/sales_report/components/wave_chart.dart';
import 'package:pro1/ui/views/services/sales_report/sales_report_model.dart';
import 'package:stacked/stacked.dart';

import 'package:stacked_themes/stacked_themes.dart';

// ignore: must_be_immutable
class SalesReportView extends StatelessWidget {
  SalesReportView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context);
    final maxheight = MediaQuery.of(context).size.height;
    final maxwidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => SalesReportModel(),
        onModelReady: (SalesReportModel model) async =>
            await model.getListsData(),
        builder: (context, SalesReportModel model, child) => Scaffold(
            backgroundColor:
                themeManager.isDarkMode ? Colors.black : Colors.white,
            body: model.isBusy
                ? Container(
                    child: Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          themeManager.isDarkMode ? Colors.white : Colors.blue),
                    )),
                  )
                : ListView(
                    children: [
                      Container(
                        height: 130,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AchievmentWidget(
                              icon: Icon(Icons.add_chart),
                              text: model.getAchievment(type: "totalSales"),
                              toolTipMessage: "Total Sales",
                            ),
                            AchievmentWidget(
                              icon: Icon(Icons.inventory),
                              text: model.getAchievment(
                                  type: "totalProductsSoled"),
                              toolTipMessage: "Total Products Soled",
                            ),
                            AchievmentWidget(
                              icon: Icon(Icons.money),
                              text: model.getAchievment(
                                  number: model.achievments.totalSales /
                                      model.achievments.totalDaysAppUsed),
                              toolTipMessage: "Average Sales",
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: 200,
                          child: WaveChart(data: model.dailyTransactionList)),
                      Container(
                          height: 200,
                          child: BarChart(data: model.dailyTransactionList)),
                    ],
                  )));
  }
}

class AchievmentWidget extends StatelessWidget {
  const AchievmentWidget({
    Key key,
    this.icon,
    this.text,
    this.toolTipMessage,
  }) : super(key: key);

  final Icon icon;
  final String text;
  final String toolTipMessage;

  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context).isDarkMode;
    return Tooltip(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration:
          BoxDecoration(color: themeManager ? Colors.white10 : Colors.black12),
      waitDuration: Duration(milliseconds: 100),
      textStyle: TextStyle(color: themeManager ? Colors.white : Colors.black),
      message: toolTipMessage,
      child: Container(
          width: 100,
          height: 80,
          decoration: BoxDecoration(
              color: themeManager ? Colors.white12 : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(8.0, 8.0))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon.icon,
                color: Colors.orange,
                size: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                      color: !themeManager ? Colors.black : Colors.white),
                ),
              )
            ],
          )),
    );
  }
}
