import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class ThemeChange extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const ThemeChange({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 16),
        decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Container(
          width: 500,
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //// Dilouge main heading
              Text(
                request.title,
                style: GoogleFonts.inter(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color:
                        themeManager.isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  themeManager.setThemeMode(ThemeMode.light);

                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      //// Dialogue Custom Radio Box
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 3,
                                color: themeManager.isDarkMode
                                    ? Colors.white
                                    : Colors.tealAccent[700])),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeManager.isDarkMode
                                  ? Colors.transparent
                                  : Colors.tealAccent[700]),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      //// Radio Text
                      Expanded(
                        child: Text(
                          request.mainButtonTitle,
                          style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: themeManager.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  themeManager.setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  child: Row(
                    children: [
                      /////////Dilogue Custom Radio button
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 3,
                                color: !themeManager.isDarkMode
                                    ? Colors.black54
                                    : Colors.tealAccent[700])),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: !themeManager.isDarkMode
                                  ? Colors.transparent
                                  : Colors.tealAccent[700]),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      //// Radio Text
                      Expanded(
                        child: Text(
                          request.secondaryButtonTitle,
                          style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: themeManager.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
