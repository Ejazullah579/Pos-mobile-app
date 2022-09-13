import 'dart:io';
import 'dart:ui';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

Future<void> toQrImageData(String text, String fileName) async {
  if (await Permission.storage.isDenied ||
      await Permission.storage.isPermanentlyDenied ||
      await Permission.storage.isUndetermined ||
      await Permission.storage.isRestricted) {
    await Permission.storage.request();
  }
  try {
    final image = await QrPainter(
      data: text,
      version: QrVersions.auto,
      gapless: false,
      color: Colors.black,
      emptyColor: Colors.white,
    ).toImage(300);
    final finalImage = await image.toByteData(format: ImageByteFormat.png);
    // finalImage.buffer.asUint8List();

    // getting a directory path for saving
    Directory d = Directory("/storage/emulated/0/Shopify/qr_images");
    if (await d.exists()) {
    } else
      await d.create(recursive: true);
    String path = d.path;
    print("here" + path);

// copy the file to a new path
    File file = File("$path/$fileName.png");
    file.writeAsBytesSync(finalImage.buffer.asUint8List());
    SnackbarService()
        .showSnackbar(title: "Image Saved", message: "${file.path}");
    // showSimpleToast(text: "${file.path}");
  } catch (e) {
    throw e;
  }
}
