import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pro1/services/test_data.dart';
import 'package:pro1/ui/components/TextField2.dart';
import 'package:stacked_themes/stacked_themes.dart';

// ignore: must_be_immutable
class Page2 extends StatelessWidget {
  Page2({
    Key key,
    @required this.formKey,
    this.focusNode,
    this.focusNode1,
    this.focusNode2,
    this.focusNode3,
    this.focusNode4,
    this.pageSize,
    this.model,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final FocusScopeNode focusNode;
  double pageSize;

  final FocusNode focusNode1;
  final FocusNode focusNode2;
  final FocusNode focusNode3;
  final FocusNode focusNode4;
  final model;

  @override
  Widget build(BuildContext context) {
    final currentFocus1 = FocusScope.of(context);
    final themeManager = getThemeManager(context);
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownField(
            themeManager: themeManager,
            model: model,
            hintText: "Select your city",
            list: citiesList,
            fieldType: "city",
          ),
          SizedBox(
            height: 10,
          ),
          DropdownField(
            themeManager: themeManager,
            model: model,
            hintText: "Select shop type",
            list: shopTypeList,
            fieldType: "shopType",
          ),
          // TextField2(
          //   textInputAction: TextInputAction.next,
          //   hinttext: "City",
          //   onSave: "city",
          //   textFieldIcon: Icon(Icons.location_city),
          //   autoValidate: true,
          //   onSaved: (String val) {
          //     model.city = val;
          //   },
          //   focusnode: () {
          //     currentFocus1.requestFocus(focusNode4);
          //   },
          //   validator: MultiValidator([
          //     RequiredValidator(errorText: "Field Required"),
          //   ]),
          // ),
          TextField2(
            textInputAction: TextInputAction.next,
            hinttext: "Shop Name",
            focusNode: focusNode4,
            onSave: "shop_name",
            textFieldIcon: Icon(Icons.shop),
            autoValidate: true,
            onSaved: (String val) {
              model.shopName = val;
            },
            focusnode: () {
              currentFocus1.requestFocus(focusNode1);
            },
            validator: MultiValidator([
              RequiredValidator(errorText: "Field Required"),
            ]),
          ),
          TextField2(
            textInputAction: TextInputAction.next,
            focusNode: focusNode1,
            onSaved: (val) {
              model.homeAddress = val;
            },
            hinttext: "Home Address",
            autoValidate: true,
            textFieldIcon: Icon(Icons.home),
            focusnode: () {
              currentFocus1.requestFocus(focusNode2);
            },
            onSave: "homeaddress",
            validator: MultiValidator([
              RequiredValidator(errorText: "Field Required"),
            ]),
          ),
          TextField2(
              textInputAction: TextInputAction.next,
              hinttext: "Shop Address",
              focusNode: focusNode2,
              autoValidate: true,
              textFieldIcon: Icon(Icons.location_pin),
              onSaved: (val) {
                model.shopAddress = val;
              },
              onSave: "shopaddress",
              focusnode: () {
                currentFocus1.requestFocus(focusNode3);
              },
              validator: RequiredValidator(errorText: "Field Required")),
          // TextField2(
          //   textInputAction: TextInputAction.done,
          //   hinttext: "Zip Code",
          //   autoValidate: true,
          //   onSave: "zipcode",
          //   focusNode: focusNode3,
          //   textInputType: TextInputType.number,
          //   textFieldIcon: Icon(Icons.code),
          //   onSaved: (val) {
          //     model.zipCode = val;
          //   },
          //   validator: MultiValidator([
          //     RequiredValidator(
          //       errorText: "Zip Code Required",
          //     ),
          //     LengthRangeValidator(
          //         min: 4, max: 10, errorText: "Enter a Valid Zip Code 6-10")
          //   ]),
          // ),
        ],
      ),
    );
  }
}

class DropdownField extends StatelessWidget {
  const DropdownField({
    Key key,
    @required this.themeManager,
    @required this.model,
    this.hintText,
    this.list,
    this.fieldType,
  }) : super(key: key);

  final ThemeManager themeManager;
  final String fieldType;
  final model;
  final hintText;
  final List<String> list;

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(15),
        textStyle: TextStyle(),
        color: themeManager.isDarkMode ? Colors.white10 : Colors.white,
        child: Row(children: [
          SizedBox(
            width: 20,
            child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.location_city,
                  color:
                      themeManager.isDarkMode ? Colors.white60 : Colors.black45,
                )),
          ),
          Expanded(
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    padding: EdgeInsets.only(
                      left: 25,
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                      left: BorderSide(color: Colors.black26, width: 2),
                    )),
                    child: DropdownButton(
                      hint: Text(hintText),
                      isExpanded: true,
                      iconSize: 0,
                      dropdownColor:
                          themeManager.isDarkMode ? Colors.black : Colors.white,
                      underline: Container(),
                      elevation: 0,
                      style: TextStyle(),
                      items: list.map((String value) {
                        return new DropdownMenuItem<String>(
                          child: new Text(
                            value,
                            style: TextStyle(
                                color: themeManager.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                          value: value,
                        );
                      }).toList(),
                      value: fieldType == "city"
                          ? model.city
                          : fieldType == "shopType"
                              ? model.shopType
                              : "Other",
                      onChanged: (value) => fieldType == "city"
                          ? model.setCity(value)
                          : fieldType == "shopType"
                              ? model.setShopType(value)
                              : "Other",
                    )),
                Align(
                  alignment: Alignment.centerRight,
                  child: IgnorePointer(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 30,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ]));
  }
}
