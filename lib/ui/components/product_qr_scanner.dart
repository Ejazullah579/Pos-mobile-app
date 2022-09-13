import 'package:flutter/material.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/services/global_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ProductQrCodeScanner extends StatelessWidget {
  ProductQrCodeScanner({Key key, this.model, this.callback}) : super(key: key);
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final model;
  final callback;
  bool isfirstTime = true;
  final GlobalService globalService = locator<GlobalService>();
  @override
  Widget build(BuildContext context) {
    void _onQRViewCreated(QRViewController controller) {
      controller.scannedDataStream.listen((scanData) {
        if (isfirstTime) {
          callback(scanData.code);
          print("Scanned Data= " + scanData.code);
          isfirstTime = false;
          Navigator.pop(context);
        }
      });
    }

    return Container(
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
    );
  }
}
