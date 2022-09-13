import 'package:flutter/material.dart';
import 'package:pro1/models/transaction.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChart extends StatefulWidget {
  BarChart({Key key, @required this.data}) : super(key: key);
  final List<Transaction> data;

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    // print(maxWidth);
    return Scaffold(
        body: Container(
      height: 400,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
                child: Graph(
              data: widget.data,
            )),
          ),
        ],
      ),
    ));
  }
}

class Graph extends StatelessWidget {
  const Graph({
    Key key,
    @required this.data,
  }) : super(key: key);
  final List<Transaction> data;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        // title: ChartTitle(text: "samosa"),
        plotAreaBorderColor: Colors.white,
        primaryYAxis: NumericAxis(
            decimalPlaces: 0,
            desiredIntervals: 2,
            axisLine: AxisLine(
                color: Colors.white, width: 2, dashArray: <double>[5, 5])),
        zoomPanBehavior:
            ZoomPanBehavior(enablePanning: true, zoomMode: ZoomMode.x),
        primaryXAxis: DateTimeAxis(
            interval: 1,
            visibleMinimum: data[0].date,
            visibleMaximum: data[data.length > 6 ? 6 : data.length - 1].date),
        // axisLabelFormatter: (axisLabelRenderArgs) => ChartAxisLabel(
        //     axisLabelRenderArgs.text, TextStyle(color: Colors.black54)),
        tooltipBehavior: TooltipBehavior(
            enable: true,
            color: Colors.white,
            canShowMarker: false,
            elevation: 5,
            tooltipPosition: TooltipPosition.auto,
            textStyle: TextStyle(color: Colors.black38)),
        series: <ChartSeries>[
          StackedColumnSeries<Transaction, DateTime>(
            dataSource: data,
            groupName: 'Group A',
            name: "Activity",
            dataLabelSettings: DataLabelSettings(
                isVisible: false, showCumulativeValues: false),
            spacing: 1.3,
            markerSettings: MarkerSettings(width: 10),
            xValueMapper: (Transaction sales, _) => sales.date,
            yValueMapper: (Transaction sales, _) => sales.amount,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.lightBlue,
                  Colors.blue,
                ]),
          ),
        ]);
  }
}
