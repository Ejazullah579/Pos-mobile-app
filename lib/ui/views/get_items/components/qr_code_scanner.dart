import 'package:flutter/material.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/services/global_service.dart';

import 'package:pro1/ui/views/get_items/get_item_viewmodel.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stacked/stacked.dart';
import 'package:visibility_detector/visibility_detector.dart';

class QrCodeScanner extends StatefulWidget {
  QrCodeScanner({Key key, this.controller, this.setQrController, this.model})
      : super(key: key);
  final QRViewController controller;
  final Function setQrController;
  final GetItemViewModel model;

  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final GlobalService globalService = locator<GlobalService>();

  @override
  Widget build(BuildContext context) {
    void _onQRViewCreated(QRViewController controller) {
      // globalService.controller = controller;
      widget.setQrController(controller);
      controller.scannedDataStream.listen((scanData) {
        widget.model.addProduct(productId: scanData.code);
        print("Scanned Data= " + scanData.code);
      });
    }

    return VisibilityDetector(
      key: Key("QrScannerKey"),
      onVisibilityChanged: (VisibilityInfo info) {
        // debugPrint("${info.visibleFraction} of my widget is visible");
        if (info.visibleFraction == 0) {
          widget.controller.pauseCamera();
        } else
          widget.controller.resumeCamera();
        // if (widget.controller.toString() == "null" ? false : true)
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: QRView(
          key: qrKey,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 150,
          ),
          onQRViewCreated: _onQRViewCreated,
        ),
      ),
    );
  }
}
