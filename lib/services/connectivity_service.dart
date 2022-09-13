import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:pro1/enums/connectivity_status.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/app/router.gr.dart' as routers;
import 'package:stacked_services/stacked_services.dart';
import '../enums/bottom_sheet_type.dart';

class ConnectivityService {
  ConnectivityStatus previous;
  ConnectivityStatus current;
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();
  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((result) async {
      current = _getConnectivityStatus(result);

      if (current == ConnectivityStatus.Offline) {
        await _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.loading,
          barrierDismissible: false,
          customData: current,
        );
        // await Future.delayed(Duration(seconds: 5));
        // if (current == ConnectivityStatus.Offline)
        //   _navigationService.navigateTo(routers.Routes.offlineView);
      } else if (previous == ConnectivityStatus.Offline &&
          (current == ConnectivityStatus.Cellular ||
              current == ConnectivityStatus.Wifi)) {
        _navigationService.back();
      }

      previous = current;
      connectionStatusController.add(current);
    });
  }

  checkConnectionStatus() async {
    var result = await Connectivity().checkConnectivity();
    current = _getConnectivityStatus(result);
    // print("here " + _navigationService.currentRoute);

    if (current == ConnectivityStatus.Offline) {
      await Future.delayed(Duration(seconds: 3));
      var result;
      await _bottomSheetService
          .showBottomSheet(
              title: "No Connection!!",
              description:
                  "Please connect to the internet inorder to use the app",
              confirmButtonTitle: "Ok",
              cancelButtonTitle: "exit")
          .then((value) {
        if (value != null) {
          if (value.confirmed) {
            return result = true;
          } else {
            return result = false;
          }
        } else
          return result = true;
      });

      return result;
    }
  }

  Stream<ConnectivityStatus> get onConnectivityChanged {
    var connectivityStatus;
    Connectivity().onConnectivityChanged.listen((result) {
      connectivityStatus = _getConnectivityStatus(result);
    });
    var current = connectivityStatus;
  }

  ConnectivityStatus _getConnectivityStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.Wifi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}

// class ConnectivityData {
//   ConnectivityStatus status;
// }
