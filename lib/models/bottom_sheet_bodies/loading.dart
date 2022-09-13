import 'package:flutter/material.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/enums/connectivity_status.dart';
import 'package:pro1/services/connectivity_service.dart';
import 'package:stacked_services/stacked_services.dart';

class Loading extends StatefulWidget {
  Loading({Key key, this.request, this.completer}) : super(key: key);
  final SheetRequest request;
  final Function(SheetResponse) completer;

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String connectivityStatus;
  ConnectivityStatus status;

  @override
  void initState() {
    super.initState();
    var status = locator<ConnectivityService>().current.toString().split(".");
    connectivityStatus = status[1];
    _startTimer();
  }

  // void _startTimer() async {
  //   await Future.delayed(Duration(seconds: 5), () => Navigator.pop(context));
  // }
  void _startTimer() async {
    await Future.delayed(Duration(seconds: 1));
    status = locator<ConnectivityService>().current;
    if (status == ConnectivityStatus.Offline)
      _startTimer();
    else if (status == ConnectivityStatus.Cellular ||
        widget.request.customData == ConnectivityStatus.Wifi) {
      connectivityStatus = "Online";
      setState(() {});
      await Future.delayed(Duration(milliseconds: 1500));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => null,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: connectivityStatus == "Offline" ? Colors.red : Colors.green,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(8), topLeft: Radius.circular(8))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            connectivityStatus == "Offline"
                ? Container(
                    height: 20,
                    width: 20,
                    child: Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )),
                  )
                : Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
            SizedBox(width: 10),
            Text(
              connectivityStatus,
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
