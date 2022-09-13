import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pro1/models/self_product.dart';
import 'package:pro1/ui/components/MainButtons.dart';
import 'package:pro1/ui/components/TextField2.dart';
import 'package:pro1/ui/components/info_box.dart';
import 'package:pro1/ui/components/popUpInfo.dart';
import 'package:pro1/ui/components/product_qr_scanner.dart';
import 'package:pro1/ui/views/services/add_product/add_product_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';

// ignore: must_be_immutable
class AddProductView extends StatelessWidget {
  SelfProduct productRecieved;
  AddProductView({Key key, this.productRecieved}) : super(key: key);
  final node1 = FocusNode();
  final node2 = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var productIdController = TextEditingController();
  var productNameController = TextEditingController();
  var productPurchasePriceController = TextEditingController();
  var productSalePriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context);
    final maxheight = MediaQuery.of(context).size.height;
    final maxwidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => AddProductViewModel(),
      onModelReady: (model) {
        if (productRecieved != null) {
          model.productId = productRecieved.productId;
          model.productName = productRecieved.productName;
          model.orignalProductName = productRecieved.productName;
          model.purchasePrice = productRecieved.purchasePrice;
          model.salePrice = productRecieved.salePrice;
          productNameController.text = productRecieved.productName;
          productPurchasePriceController.text =
              productRecieved.purchasePrice.toString();
          productSalePriceController.text =
              productRecieved.salePrice.toString();
        } else
          productIdController.text = model.productId;
      },
      builder: (context, AddProductViewModel model, child) => Scaffold(
          backgroundColor:
              themeManager.isDarkMode ? Colors.black : Colors.white,
          body: GestureDetector(
            onTap: () {
              if (!FocusScope.of(context).hasPrimaryFocus) {
                FocusScope.of(context).unfocus();
              }
            },
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: productRecieved != null ? 250 : maxheight * 0.6,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    children: [
                      productRecieved != null
                          ? Container()
                          : Container(
                              height: 250,
                              child: FittedBox(
                                child: Container(
                                  width: 300,
                                  height: 250,
                                  child: Lottie.asset(
                                    "assets/lottie/scan-qr-code.json",
                                    reverse: true,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text(
                              productRecieved != null
                                  ? "Update Product"
                                  : "Add Product",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                fontSize: 35,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 3.5,
                                color: !themeManager.isDarkMode
                                    ? Colors.black
                                    : Colors.white,
                              )),
                        ),
                      ),
                      productRecieved == null &&
                              model.currrntUser.userType == "admin"
                          ? Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: themeManager.isDarkMode
                                          ? Colors.white24
                                          : Colors.black12,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Local",
                                        style: TextStyle(
                                            color: themeManager.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                      Switch(
                                          value: model.isGlobalProduct,
                                          inactiveTrackColor:
                                              themeManager.isDarkMode
                                                  ? Colors.white24
                                                  : Colors.black26,
                                          onChanged: (value) {
                                            model.setIsGlobalProduct(value);
                                            productIdController.text =
                                                "Product ID";
                                          }),
                                      Text(
                                        "Global",
                                        style: TextStyle(
                                            color: themeManager.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: -20,
                                    right: 2,
                                    child: PopUpInfo(
                                      heroTag: "add_product_info",
                                      iconColor: Colors.grey,
                                      text: <String>[
                                        "Please select carefully where you add products",
                                        "Global Products are added to global catagory which are accessible to anyone",
                                        "Local Products are those which are only accessible by the user itself"
                                      ],
                                    ))
                              ],
                            )
                          : Container(),
                      productRecieved != null
                          ? Container()
                          : Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: AnimatedContainer(
                                      // width: maxwidth * 0.47,
                                      duration: Duration(milliseconds: 300),
                                      margin: EdgeInsets.only(right: 5),
                                      child: TextField2(
                                        textFieldIcon: Icon(Icons.code),
                                        enableField: false,
                                        hinttext: "Product ID",
                                        con: productIdController,
                                      ),
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    width: !model.isGlobalProduct
                                        ? maxwidth * 0.2
                                        : 0,
                                    height: 50,
                                    margin: EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 5,
                                              offset: Offset(0, 5))
                                        ]),
                                    child: model.isBusyGettingId
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: TextButton(
                                                onPressed: () async {
                                                  productIdController.text =
                                                      await model
                                                          .generateUniqueId();
                                                },
                                                child: Text(
                                                  "get",
                                                  style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: maxwidth * 0.05,
                                                      color: Colors.white),
                                                )),
                                          ),
                                  ),
                                  Container(
                                    width: maxwidth * 0.2,
                                    height: 50,
                                    margin: EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.orange[800],
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 5,
                                              offset: Offset(0, 5))
                                        ]),
                                    child: TextButton(
                                        onPressed: () async {
                                          function(scanData) {
                                            productIdController.text = scanData;
                                            model.setProductId(scanData);
                                          }

                                          await showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => AlertDialog(
                                                  insetPadding:
                                                      EdgeInsets.all(0),
                                                  contentPadding:
                                                      EdgeInsets.all(2),
                                                  actions: [
                                                    GestureDetector(
                                                      onTap: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 3,
                                                                horizontal: 7),
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)),
                                                        child: Text("cancel",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                      ),
                                                    ),
                                                  ],
                                                  content: Container(
                                                    width: maxwidth * 0.8,
                                                    height: maxheight * 0.4,
                                                    child: ProductQrCodeScanner(
                                                      model: model,
                                                      callback: function,
                                                    ),
                                                  )));
                                        },
                                        child: Text(
                                          "scan",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w800,
                                              fontSize: maxwidth * 0.045,
                                              color: Colors.white),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextField2(
                                textFieldIcon: Icon(Icons.perm_identity),
                                hinttext: "Product Name",
                                con: productNameController ?? null,
                                textInputAction: TextInputAction.next,
                                focusnode: () {
                                  FocusScope.of(context).requestFocus(node1);
                                },
                                onSaved: (value) => model.productName = value,
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Product Name is required"),
                                  MinLengthValidator(4,
                                      errorText: "Minium character length is 4")
                                ]),
                              ),
                              TextField2(
                                textFieldIcon: Icon(Icons.money),
                                hinttext: "Purchase Price",
                                focusNode: node1,
                                con: productPurchasePriceController ?? null,
                                textInputAction: TextInputAction.next,
                                onSaved: (value) =>
                                    model.purchasePrice = double.parse(value),
                                focusnode: () {
                                  FocusScope.of(context).requestFocus(node2);
                                },
                                textInputType: TextInputType.number,
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Purchase price is required"),
                                  PatternValidator(r'(^[0-9]*\.?[0-9]+$)',
                                      errorText:
                                          "Only numbers are allowed in this field")
                                ]),
                              ),
                              TextField2(
                                textFieldIcon: Icon(Icons.monetization_on),
                                hinttext: "Sales Price",
                                con: productSalePriceController ?? null,
                                focusNode: node2,
                                textInputAction: TextInputAction.done,
                                onSaved: (value) =>
                                    model.salePrice = double.parse(value),
                                textInputType: TextInputType.number,
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Sales Price is required"),
                                  PatternValidator(r'(^[0-9]*\.?[0-9]+$)',
                                      errorText:
                                          "Only numbers are allowed in this field")
                                ]),
                              ),
                              model.isBusy
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 21),
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            themeManager.isDarkMode
                                                ? Colors.white
                                                : Colors.blue),
                                      )),
                                    )
                                  : MainButtons(
                                      buttontext: productRecieved != null
                                          ? "Update"
                                          : "Add Product",
                                      borderRadius: 50,
                                      btnIcon: Icon(
                                        productRecieved != null
                                            ? Icons.update
                                            : Icons.add_circle,
                                        color: Colors.white,
                                      ),
                                      buttonColor: Colors.blue,
                                      textColor: Colors.white,
                                      onpress: () async {
                                        var result;
                                        if (!_formKey.currentState.validate()) {
                                        } else {
                                          _formKey.currentState.save();
                                          if (productRecieved == null) {
                                            model.addProduct();
                                          } else {
                                            result =
                                                await model.updateProduct();
                                            Navigator.pop(context, result);
                                          }
                                        }
                                      },
                                    )
                            ],
                          ))
                    ],
                  ),
                ),
                productRecieved != null
                    ? Container()
                    : Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
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
                                  ),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    child: PopupMenuButton(
                                      padding: EdgeInsets.zero,
                                      color: themeManager.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                      tooltip: "Options",
                                      icon: Icon(
                                        Icons.adaptive.more,
                                        color: Colors.white,
                                      ),
                                      onSelected: (value) async {
                                        if (value == "checkBox") {
                                          model.globalService
                                              .setshouldGenerateQrImage();
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: "checkBox",
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Generate Qr-Images",
                                                style: TextStyle(
                                                    color:
                                                        !themeManager.isDarkMode
                                                            ? Colors.black
                                                            : Colors.white),
                                              ),
                                              SizedBox(width: 5),
                                              IgnorePointer(
                                                child: Checkbox(
                                                    value: model.globalService
                                                        .shouldGenerateQrImage,
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    onChanged: (value) {}),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))),
              ],
            ),
          )),
    );
  }
}
