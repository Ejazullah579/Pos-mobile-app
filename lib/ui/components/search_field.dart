import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pro1/app/locator.dart';
import 'package:pro1/services/global_service.dart';
import 'package:pro1/services/search_searvice.dart';
import 'package:stacked_themes/stacked_themes.dart';

class SearchField extends StatelessWidget {
  final SearchService searchService = locator<SearchService>();
  final GlobalService globalService = locator<GlobalService>();
  final formkey = GlobalKey<FormState>();
  final FocusNode focusNode;

  SearchField({Key key, this.focusNode}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context);
    globalService.searchNode = new FocusNode();
    return Container(
      margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 20),
      decoration: BoxDecoration(
        border: themeManager.isDarkMode
            ? null
            : Border.all(color: Colors.grey[200]),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(35),
      ),
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
                  controller: searchService.textController,
                  focusNode: focusNode,
                  style: TextStyle(
                      color: themeManager.isDarkMode
                          ? Colors.white
                          : Colors.black),
                  onFieldSubmitted: (value) {
                    searchService.setSearchValue = value;
                    searchService.drawData(value);
                  },
                  onChanged: (value) {
                    if (globalService.currentPage != 2) {
                      globalService.goToSearchItemView();
                    }
                    searchService.setSearchValue = value;
                    searchService.drawData(value);
                  },
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
          ],
        ),
      ),
    );
  }
}
