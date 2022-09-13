import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets/document.dart';
import 'package:stacked_services/stacked_services.dart';

Document pdf;

writeOnPdf(model) {
  pdf = pw.Document();
  pdf.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.standard,
    margin: pw.EdgeInsets.all(15),
    build: (pw.Context context) {
      return <pw.Widget>[
        pw.Header(
          level: 1,
          child: pw.Text(model.currentUser.shopName,
              style: pw.TextStyle(
                fontSize: 30,
              )),
        ),
        pw.ListView.builder(
          itemCount: model.productList.length,
          itemBuilder: (context, index) {
            return pw.Padding(
                padding: pw.EdgeInsets.symmetric(vertical: 7),
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "${index + 1}: " +
                            model.productList[index].selfProduct.productName,
                      ),
                      pw.Text(
                          (model.productList[index].selfProduct.salePrice *
                                  model.productList[index].counter)
                              .toString(),
                          style:
                              pw.TextStyle(color: PdfColor.fromRYB(0, 0, 1))),
                    ]));
          },
        ),
        pw.Header(child: pw.Text(" ")),
        pw.Container(
            child:
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Container(
              height: 30,
              padding: pw.EdgeInsets.only(top: 20),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      margin: pw.EdgeInsets.only(top: 6),
                      child: pw.Text(
                        "Total :   ",
                        style: pw.TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    pw.Text("${model.calculateTotal()}",
                        style: pw.TextStyle(
                          fontSize: 25,
                        )),
                  ])),
        ]))
      ];
    },
  ));
}

Future savePdf() async {
  try {
    Directory d = Directory("/storage/emulated/0/Shopify/recipts");
    if (await d.exists()) {
    } else
      await d.create(recursive: true);
    var path = d.path;
    String fileName = "recipt-" + DateTime.now().toString().substring(0, 19);
    File file = File("$path/$fileName.pdf");
    print("donnne $d/$fileName.pdf");
    file.writeAsBytesSync(pdf.save());
    SnackbarService().showSnackbar(title: "Pdf Saved", message: "$d$fileName");
    // showSimpleToast(text: "$d$fileName");
  } catch (e) {
    print("Errrror" + e.toString());
  }
}
