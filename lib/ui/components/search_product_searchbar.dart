import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stacked_themes/stacked_themes.dart';

class SearchProductSearchField extends StatelessWidget {
  final formkey = GlobalKey<FormState>();
  final onFieldSubmission;
  final model;
  String searchData;
  final TextEditingController controller;

  SearchProductSearchField(
      {Key key, this.onFieldSubmission, this.model, this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context);
    return Container(
      margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 15),
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: Material(
        elevation: 2,
        color: themeManager.isDarkMode ? Colors.black54 : Colors.white,
        shadowColor: Colors.white,
        borderRadius: BorderRadius.circular(35),
        textStyle: TextStyle(),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.search,
                    color:
                        themeManager.isDarkMode ? Colors.white : Colors.black54,
                  )),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: 20,
                ),
                child: TextFormField(
                  autofocus: false,
                  controller: controller,
                  style: TextStyle(
                      color: themeManager.isDarkMode
                          ? Colors.white
                          : Colors.black),
                  onFieldSubmitted: (value) =>
                      model.getAllSelfProducts(value.toLowerCase()),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      hintText: "Search here",
                      hintStyle: TextStyle(
                          color: themeManager.isDarkMode
                              ? Colors.white
                              : Colors.black87)),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => model.getAllSelfProducts(controller.text),
              child: Center(
                child: Container(
                  height: 46,
                  width: 80,
                  margin: EdgeInsets.only(top: 3, right: 1),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                    child: Text(
                      "Search",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
